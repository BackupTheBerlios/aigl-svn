
/*
 *
 *  GRL/Pool.m
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

#import <GRL/Pool.h>
#import <GRL/Functions.h>
#import <stdlib.h>

static GPool *currentPool;

@implementation GPool

- (id) init
{
	self = [super init];
	if (self) {
		objcObjects = [GArray new];
		
		if (!objcObjects) {
			[self release];
			return nil;
		}
		
		currentPool = self;
	}
	return self;
}

- (void) dealloc
{
	unsigned cnt = [objcObjects count];
	unsigned i;
	
	for (i = 0;i < cnt;i++) {
		[[objcObjects first] release];
		[objcObjects removeFirst];
	}
	
	[objcObjects release];
	
	
	cnt = [cObjects count];
	for (i = 0;i < cnt;i++) {
		void *ptr = (void *)[cObjects first];
		[cObjects removeFirst];
		GFree (ptr);
	}
	
	[cObjects release];
	
	[super dealloc];
}

+ (GPool *) current
{
	return currentPool;
}

+ (void) addObject:(id <GObject>)obj
{
	if ([self current]) {
		[[self current] addObject:obj];
	} else {
		GErrorSet(GLeakError);
	}
}

- (void) addObject:(id)obj
{
	[objcObjects add:obj];
}

+ (void) addPointer:(void *)cObj
{
	if ([self current]) {
		[[self current] addPointer:cObj];
	} else {
		GErrorSet(GLeakError);
	}
}

- (void) addPointer:(void *)cObj
{
	[cObjects add:cObj];
}

@end
