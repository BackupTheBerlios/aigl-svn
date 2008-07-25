
/*
 *
 *  GRL/Functions.h
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


#ifdef __cplusplus
extern "C" {
#endif

#import <GRL/Config.h>
#import <GRL/Exception.h>
#import <GRL/String.h>
#import <stdlib.h>
#import <stdarg.h>
#import <stdio.h>


#pragma mark GAlloc
void *		GAllocate(unsigned length);
void *		GReallocate(void *ptr, unsigned usedLength, unsigned newLength);
id			GAutoreleaseObject(id <GObject> object);
void *		GAutoreleasePointer(void *object);
#define		GFree(obj) free(obj), obj = NULL


#pragma mark GLog

void		GLogStreamSet(FILE *logOutputStream);
void		GLog(GString *format, ...);
void		GLogv(GString *format, va_list args);
void		GLogc(const char *format, ...);
void		GLogcv(const char *format, va_list args);


#pragma mark GMake

GPointi		GMakePointi(int x, int y);
GPointf		GMakePointf(float x, float y);
GSizei		GMakeSizei(int w, int h);
GSizef		GMakeSizef(float w, float h);
GRecti		GMakeRecti(int x, int y, int w, int h);
GRectf		GMakeRectf(float x, float y, float w, float h);
GRange		GMakeRange(unsigned start, unsigned length);


#ifdef __cplusplus
}
#endif

