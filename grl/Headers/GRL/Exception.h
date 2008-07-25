
/*
 *
 *  GRL/Exception.h
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

#import <GRL/Object.h>
#import <GRL/String.h>

	
#define GMallocException			"GMallocException"
#define GInconsistencyException		"GInconsistencyException"
#define GFileAccessException		"GFileAccessException"
	
@interface GException : GObject {
	GString *_name;
	GString *_description;
}

+ (void)raise:(const char *)name description:(GString *)format;

+ (id) exceptionWithName:(const char *)name description:(GString *)description;
- (id) initWithName:(const char *)name description:(GString *)description;

- (GString *) name;
- (GString *) description;
- (void) raise;

@end

#ifdef __cplusplus
}
#endif

