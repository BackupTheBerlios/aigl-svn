
/*
 *
 *  GRL/Value.m
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

#import <GRL/Value.h>
#import <GRL/Functions.h>


@implementation GValue

- (id) init
{
	return [self initWithInt8:0];
}

- (void) dealloc
{
	free (data);
	[super dealloc];
}

+ (id) valueWithInt8:(GInt8)value
{
	return [[[self alloc] initWithInt8:value] autorelease];
}

+ (id) valueWithUInt8:(GUInt8)value
{
	return [[[self alloc] initWithUInt8:value] autorelease];
}

+ (id) valueWithInt16:(GInt16)value
{
	return [[[self alloc] initWithInt16:value] autorelease];
}

+ (id) valueWithUInt16:(GUInt16)value
{
	return [[[self alloc] initWithUInt16:value] autorelease];
}

+ (id) valueWithInt32:(GInt32)value
{
	return [[[self alloc] initWithInt32:value] autorelease];
}

+ (id) valueWithUInt32:(GUInt32)value
{
	return [[[self alloc] initWithUInt32:value] autorelease];
}

+ (id) valueWithFloat:(float)value
{
	return [[[self alloc] initWithFloat:value] autorelease];
}

+ (id) valueWithDouble:(double)value
{
	return [[[self alloc] initWithDouble:value] autorelease];
}

- (id) initWithInt8:(GInt8)value
{
	self = [super init];
	if (self) [self setInt8Value:value];
	return self;
}

- (id) initWithUInt8:(GUInt8)value
{
	self = [super init];
	if (self) [self setUInt8Value:value];
	return self;
}

- (id) initWithInt16:(GInt16)value
{
	self = [super init];
	if (self) [self setInt16Value:value];
	return self;
}

- (id) initWithUInt16:(GUInt16)value
{
	self = [super init];
	if (self) [self setUInt16Value:value];
	return self;
}

- (id) initWithInt32:(GInt32)value
{
	self = [super init];
	if (self) [self setInt32Value:value];
	return self;
}

- (id) initWithUInt32:(GUInt32)value
{
	self = [super init];
	if (self) [self setUInt32Value:value];
	return self;
}

- (id) initWithFloat:(float)value
{
	self = [super init];
	if (self) [self setFloatValue:value];
	return self;
}

- (id) initWithDouble:(double)value
{
	self = [super init];
	if (self) [self setDoubleValue:value];
	return self;
}

- (void) setInt8Value:(GInt8)value
{
	if (data) free (data);
	data = GAllocInt8(value);
	type = GInt8Type;
}

- (void) setUInt8Value:(GUInt8)value
{
	if (data) free (data);
	data = GAllocUInt8(value);
	type = GUInt8Type;
}

- (void) setInt16Value:(GInt16)value
{
	if (data) free (data);
	data = GAllocInt16(value);
	type = GInt16Type;
}

- (void) setUInt16Value:(GUInt16)value
{
	if (data) free (data);
	data = GAllocUInt16(value);
	type = GUInt16Type;
}

- (void) setInt32Value:(GInt32)value
{
	if (data) free (data);
	data = GAllocInt32(value);
	type = GInt32Type;
}

- (void) setUInt32Value:(GUInt32)value
{
	if (data) free (data);
	data = GAllocUInt32(value);
	type = GUInt32Type;
}

- (void) setFloatValue:(float)value
{
	if (data) free (data);
	data = GAllocFloat(value);
	type = GFloatType;
}

- (void) setDoubleValue:(double)value
{
	if (data) free (data);
	data = GAllocDouble(value);
	type = GDoubleType;
}

- (GInt8) int8Value
{
	GInt8 val = 0;
	if (data && type == GInt8Type) val = *(GInt8 *)data;
	return val;
}

- (GUInt8) unsignedInt8Value
{
	GUInt8 val = 0;
	if (data && type == GUInt8Type) val = *(GUInt8 *)data;
	return val;
}

- (GInt16) int16Value
{
	GInt16 val = 0;
	if (data && type == GInt16Type) val = *(GInt16 *)data;
	return val;
}

- (GUInt16) unsignedInt16Value
{
	GUInt16 val = 0;
	if (data && type == GUInt16Type) val = *(GUInt16 *)data;
	return val;
}

- (GInt32) int32Value
{
	GInt32 val = 0;
	if (data && type == GInt32Type) val = *(GInt32 *)data;
	return val;
}

- (GUInt32) unsignedInt32Value
{
	GUInt32 val = 0;
	if (data && type == GUInt32Type) val = *(GUInt32 *)data;
	return val;
}

- (float) floatValue
{
	float val = 0;
	if (data && type == GFloatType) val = *(float *)data;
	return val;
}

- (double) doubleValue
{
	double val = 0;
	if (data && type == GDoubleType) val = *(double *)data;
	return val;
}

- (GType) type
{
	return type;
}


@end

