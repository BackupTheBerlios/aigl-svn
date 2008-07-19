
/*
 *
 *  GRL/String.h
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
#import <GRL/Config.h>
	
typedef struct _GStringOpaqueData _GStringOpaqueData;
	
@interface GString : GObject {
	_GStringOpaqueData *mbs;
}

+ (id) stringWithCharacters:(const char *)cString;
+ (id) stringWithCharacters:(const char *)cString range:(GRange)range;
+ (id) stringWithString:(GString *)string;
+ (id) stringWithString:(GString *)string range:(GRange)range;
+ (id) stringWithFormat:(const char *)format, ...;
+ (id) stringWithFormat:(const char *)format arguments:(va_list)args;
+ (id) stringWithFile:(const char *)sourceFilename;

- (id) initWithCharacters:(const char *)cString;
- (id) initWithCharacters:(const char *)cString range:(GRange)range;
- (id) initWithString:(GString *)string;
- (id) initWithString:(GString *)string range:(GRange)range;
- (id) initWithFormat:(const char *)format, ...;
- (id) initWithFormat:(const char *)format arguments:(va_list)args;
- (id) initWithFile:(const char *)sourceFilename;

- (void) setCharacters:(const char *)cString;
- (void) appendCharacters:(const char *)cString;
- (void) appendCharacters:(const char *)cString range:(GRange)range;
- (void) appendString:(GString *)string;
- (void) appendString:(GString *)string range:(GRange)range;
- (void) prependCharacters:(const char *)cString;
- (void) prependString:(GString *)string;
- (void) insertCharacters:(const char *)cString atIndex:(unsigned)idx;
- (void) insertCharacters:(const char *)cString atIndex:(unsigned)idx range:(GRange)srcRange;
- (void) insertString:(GString *)string atIndex:(unsigned)idx;
- (void) insertString:(GString *)string atIndex:(unsigned)idx range:(GRange)srcRange;

- (void) removeCharacterAtIndex:(unsigned)indx;
- (void) removeCharactersForRange:(GRange)range;

- (char) characterAtIndex:(unsigned)idx;
- (const char *) cString;
- (unsigned) length;

- (BOOL) isEqualTo:(GString *)string;

- (void) readFromFile:(char const *)filename;
- (void) writeToFile:(char const *)filename;

@end

#ifdef __cplusplus
}
#endif

