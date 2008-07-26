
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
#import <stdlib.h>
#import STRING_H
#import <syslog.h>
#import <time.h>


struct GPrivateFunctionsStruct{
	BOOL initialized;
	FILE *errStream;
};

static struct GPrivateFunctionsStruct GPrivateFunctionsHandler = {0};

static void GFunctionsPrivateInit(void)
{
	if (!GPrivateFunctionsHandler.initialized) {
		GPrivateFunctionsHandler.errStream = stdout;
		GPrivateFunctionsHandler.initialized = YES;
	}
}

#pragma mark GAlloc
void *		GAllocate(unsigned length)
{
	void *ptr = malloc(length);
	if (ptr) bzero (ptr, length);
	return ptr;
}

void *		GReallocate(void *ptr, unsigned usedLength, unsigned newLength)
{
	char *tmp = realloc(ptr, newLength);
	if (tmp && newLength > usedLength) bzero (ptr + usedLength, newLength - usedLength);
	return (void *)tmp;
}

id			GAutoreleaseObject(id <GObject> object)
{
	// Note: I don't want to autorelease pools
	const char *objName = [object name];
	if (objName && (0 == strcmp("GPool", objName)))
		return [object autorelease];
	
	[GPool addObject:object];
	return object;
}

void *		GAutoreleasePointer(void *object)
{
	[GPool addCObject:object];
	return object;
}

GInt8 *		GAllocInt8(GInt8 value)
{
	GInt8 *ptr = GAllocate(1);
	if (ptr) *ptr = value;
	return ptr;
}

GUInt8 *	GAllocUInt8(GUInt8 value)
{
	GUInt8 *ptr = GAllocate(1);
	if (ptr) *ptr = value;
	return ptr;
}

GInt16 *	GAllocInt16(GInt16 value)
{
	GInt16 *ptr = GAllocate(2);
	if (ptr) *ptr = value;
	return ptr;
}

GUInt16 *	GAllocUInt16(GUInt16 value)
{
	GUInt16 *ptr = GAllocate(2);
	if (ptr) *ptr = value;
	return ptr;
}

GInt32 *	GAllocInt32(GInt32 value)
{
	GInt32 *ptr = GAllocate(4);
	if (ptr) *ptr = value;
	return ptr;
}

GUInt32 *	GAllocUInt32(GUInt32 value)
{
	GUInt32 *ptr = GAllocate(4);
	if (ptr) *ptr = value;
	return ptr;
}

float *		GAllocFloat(float value)
{
	float *ptr = GAllocate(sizeof(float));
	if (ptr) *ptr = value;
	return ptr;
}

double *	GAllocDouble(double value)
{
	double *ptr = GAllocate(sizeof(double));
	if (ptr) *ptr = value;
	return ptr;
}


#pragma mark GLog
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

void		GLogcv(const char *in_format, va_list args)
{
	GFunctionsPrivateInit();
	
	char *format = NULL;
	if (in_format)
		format = strdup (in_format);
	else
		format = strdup("(null)");
	
	char date[] = "YYYY/MM/DD HH:MM:SS";
	time_t t;
	struct tm *tm;
	
	char *string = NULL;
	vasprintf(&string, format, args);
	
	if (!string) {
		[GException raise:GMallocException description:nil];
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
			[GException raise:GMallocException description:nil];
			free (string);
			return;
		}
	}
	
	fprintf(GPrivateFunctionsHandler.errStream, "%s", string);
	
	syslog(LOG_INFO | LOG_USER, "%s", string);
	
	free(string), string = NULL;
	
}

#pragma mark GMake
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

