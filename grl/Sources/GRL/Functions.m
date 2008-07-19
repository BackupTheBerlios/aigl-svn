
/*
 *
 *  GRL/Functions.m
 *  Game Rendering Library project
 *  
 *
 *  Copyright (C) 2008 Lucas Soltic - soltic.lucas@wanadoo.fr
 *
 *  This software is provided 'as-is', without any express or implied
 *  warranty.  In no event will the authors be held liable for any damages
 *  arising from the use of this software.
 *
 *  Permission is granted to anyone to use this software for any purpose,
 *  including commercial applications, and to alter it and redistribute it
 *  freely, subject to the following restrictions:
 *
 *  1. The origin of this software must not be misrepresented; you must not
 *  claim that you wrote the original software. If you use this software
 *  in a product, an acknowledgment in the product documentation would be
 *  appreciated but is not required.
 *  2. Altered source versions must be plainly marked as such, and must not be
 *  misrepresented as being the original software.
 *  3. This notice may not be removed or altered from any source distribution
 *
 */


#import <GRL/Functions.h>
#import <GRL/Pool.h>
#import <GRL/Value.h>
#import <stdlib.h>
#import STRING_H
#import <syslog.h>
#import <time.h>


struct GPrivateFunctionsStruct{
	BOOL initialized;
	BOOL errors[GCountFlagError];
	FILE *errStream;
};

struct GPrivateFunctionsStruct GPrivateFunctionsHandler = {0};

static void GFunctionsPrivateInit(void)
{
	if (!GPrivateFunctionsHandler.initialized) {
		bzero (GPrivateFunctionsHandler.errors, sizeof(GPrivateFunctionsHandler.errors));
		GPrivateFunctionsHandler.errStream = stdout;
		GPrivateFunctionsHandler.initialized = YES;
	}
}

#pragma mark Alloc
void *		GAllocate(unsigned length)
{
	void *ptr = malloc(length);
	if (ptr) memset (ptr, 0, length);
	return ptr;
}

void *		GReallocate(void *ptr, unsigned usedLength, unsigned newLength)
{
	char *tmp = realloc(ptr, newLength);
	if (tmp && newLength > usedLength) memset (ptr + usedLength, 0, newLength - usedLength);
	return (void *)tmp;
}

id			GAutoreleaseObject(id <GObject> object)
{
	[GPool addObject:object];
	return object;
}

void *		GAutoreleasePointer(void *object)
{
	[GPool addPointer:object];
	return object;
}


#pragma mark Log
void		GLogStreamSet(FILE *outputStream)
{
	GFunctionsPrivateInit();
	GPrivateFunctionsHandler.errStream = outputStream;
}

void		GLog(GString *format, ...)
{
	va_list ap;
	va_start(ap, format);
	GLogv(format, ap);
	va_end(ap);
}

void		GLogv(GString *format, va_list args)
{
	GLogcv([format cString], args);
}

void		GLogc(const char *format, ...)
{
	va_list ap;
	va_start(ap, format);
	GLogcv(format, ap);
	va_end(ap);
}

void		GLogcv(const char *format, va_list args)
{
	GFunctionsPrivateInit();
	
	if (!format)
		return;
	
	char date[] = "YYYY/MM/DD HH:MM:SS";
	time_t t;
	struct tm *tm;
	
	char *string = NULL;
	vasprintf(&string, format, args);
	
	if (!string) {
		GErrorSet (GMemError);
		return;
	}
	
	size_t len = strlen(string);
	
	if (len < 1) {
		free(string), string = NULL;
		return;
	}
	
	if (string[len - 1] != '\n') {
		void *tmp = GReallocate(string, len, len + 2);
		
		if (tmp != NULL) {
			string = tmp;
			string[len] = '\n';
			string[len + 1] = '\0';
			
			t = time(NULL);
			tm = localtime(&t);
			strftime(date, sizeof(date), "%Y/%m/%d %H:%M:%S", tm);
		} else {
			GErrorSet(GMemError);
			free (string);
			return;
		}
	}
	
	fprintf(GPrivateFunctionsHandler.errStream, "%s", string);
	
	syslog(LOG_INFO | LOG_USER, "%s", string);
	
	free(string), string = NULL;
	
}

#pragma mark Non linear types functions
GPointi	GMakePointi(int x, int y)
{
	return (GPointi){x, y};
}

GPointf	GMakePointf(float x, float y)
{
	return (GPointf){x, y};
}

GSizei		GMakeSizei(int w, int h)
{
	return (GSizei){w, h};
}

GSizef		GMakeSizef(float w, float h)
{
	return (GSizef){w, h};
}

GRecti		GMakeRecti(int x, int y, int w, int h)
{
	return (GRecti){{x, y}, {w, h}};
}

GRectf		GMakeRectf(float x, float y, float w, float h)
{
	return (GRectf){{x, y}, {w, h}};
}

GRange		GMakeRange(unsigned start, unsigned length)
{
	return (GRange){start, length};
}

#pragma mark Error handling

void		GErrorSet(GError error)
{
	GFunctionsPrivateInit();
	GPrivateFunctionsHandler.errors[error] = YES;
}

GError		GErrorGet(void)
{
	GError err = GNoError;
	
	GFunctionsPrivateInit();
	unsigned i;
	for (i = 0;i < GCountFlagError;i++) {
		if (GPrivateFunctionsHandler.errors[i]) {
			GPrivateFunctionsHandler.errors[i] = NO;
			err = i;
			break;
		}
	}
	
	return err;
}

GString *	GErrorGetString(GError error)
{
	GString *desc = nil;
	
	switch (error) {
		case GNoError:
			desc = [GString stringWithFormat:"no error"];
			break;
			
		case GMemError:
			desc = [GString stringWithFormat:"could not allocate memory"];
			break;
			
		case GInconsistencyError:
			desc = [GString stringWithFormat:"an invalid argument has been used or an incorrect value has been found"];
			break;
			
		case GLeakError:
			desc = [GString stringWithFormat:"an object has been autoreleased without any GPool object created"];
			break;
			
		case GFileError:
			desc = [GString stringWithFormat:"could not open file for reading or writing ; or could read or write to a file"];
			break;
			
		default:
			break;
	}
	
	return desc;
}


