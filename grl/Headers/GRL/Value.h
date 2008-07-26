
/*
 *
 *  GRL/Value.h
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

#import <GRL/Object.h>
#import <GRL/Config.h>


@interface GValue : GObject {
	void *data;
	GType type;
}

+ (id) valueWithInt8:(GInt8)value;
+ (id) valueWithUInt8:(GUInt8)value;
+ (id) valueWithInt16:(GInt16)value;
+ (id) valueWithUInt16:(GUInt16)value;
+ (id) valueWithInt32:(GInt32)value;
+ (id) valueWithUInt32:(GUInt32)value;
+ (id) valueWithFloat:(float)value;
+ (id) valueWithDouble:(double)value;

- (id) initWithInt8:(GInt8)value;
- (id) initWithUInt8:(GUInt8)value;
- (id) initWithInt16:(GInt16)value;
- (id) initWithUInt16:(GUInt16)value;
- (id) initWithInt32:(GInt32)value;
- (id) initWithUInt32:(GUInt32)value;
- (id) initWithFloat:(float)value;
- (id) initWithDouble:(double)value;

- (void) setInt8Value:(GInt8)value;
- (void) setUInt8Value:(GUInt8)value;
- (void) setInt16Value:(GInt16)value;
- (void) setUInt16Value:(GUInt16)value;
- (void) setInt32Value:(GInt32)value;
- (void) setUInt32Value:(GUInt32)value;
- (void) setFloatValue:(float)value;
- (void) setDoubleValue:(double)value;

- (GInt8) int8Value;
- (GUInt8) unsignedInt8Value;
- (GInt16) int16Value;
- (GUInt16) unsignedInt16Value;
- (GInt32) int32Value;
- (GUInt32) unsignedInt32Value;
- (float) floatValue;
- (double) doubleValue;

- (GType) type;

@end

