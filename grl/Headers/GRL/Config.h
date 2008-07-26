
/*
 *
 *  GRL/Config.h
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

#define STRING_H "/usr/include/string.h"
#include <limits.h>



#pragma mark Target OS

#if defined(linux) || defined(__linux) || defined(__linux__)
#undef GRL_LINUX
#define GRL_LINUX
#warning Port not done for this platform. May result in compilation or execution errors.
#endif

#if defined(__APPLE__)
#undef GRL_MACOS
#define GRL_MACOS
#endif

#if defined(WIN32) || defined(_WIN32)
#undef GRL_WINDOWS
#define GRL_WINDOWS
#warning Port not done for this platform. May result in compilation or execution errors.
#endif

#if !defined(GRL_LINUX) && !defined(GRL_MACOS) && !defined(GRL_WINDOWS)
#error Unknown OS
#endif


#pragma mark Linear types
// 8 bits integer types
#if UCHAR_MAX == 0xFF
typedef char			GInt8;
typedef unsigned char	GUInt8;
#else
#error No 8 bits integer type for this platform
#endif

// 16 bits integer types
#if USHRT_MAX == 0xFFFF
typedef short			GInt16;
typedef unsigned short	GUInt16;
#elif UINT_MAX == 0xFFFF
typedef int				GInt16;
typedef unsigned int	GUInt16;
#elif ULONGRL_MAX == 0xFFFF
typedef long			GInt16;
typedef unsigned long	GUInt16;
#else
#error No 16 bits integer type for this platform
#endif

// 32 bits integer types
#if USHRT_MAX == 0xFFFFFFFF
typedef short			GInt32;
typedef unsigned short	GUInt32;
#elif UINT_MAX == 0xFFFFFFFF
typedef int				GInt32;
typedef unsigned int	GUInt32;
#elif ULONGRL_MAX == 0xFFFFFFFF
typedef long			GInt32;
typedef unsigned long	GUInt32;
#else
#error No 32 bits integer type for this platform
#endif

typedef GUInt8		GByte;
typedef GInt32		GInt;
typedef GUInt32		GUInt;
typedef double		GFloat;

typedef enum {
	GNullType = 0,
	GInt8Type,
	GUInt8Type,
	GInt16Type,
	GUInt16Type,
	GInt32Type,
	GUInt32Type,
	GFloatType,
	GDoubleType,
	GLongDoubleType
} GType;


#pragma mark Non linear types

typedef struct {
	int x, y;
} GPointi;

typedef struct {
	float x, y;
} GPointf;


typedef struct {
	int w, h;
} GSizei;

typedef struct {
	float w, h;
} GSizef;


typedef struct {
	GPointi point;
	GSizei size;
} GRecti;

typedef struct {
	GPointf point;
	GSizef size;
} GRectf;

typedef struct {
	unsigned start;
	unsigned length;
} GRange;


#ifdef __cplusplus
}
#endif

