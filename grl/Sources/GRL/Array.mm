
/*
 *
 *  GRL/Array.m
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

#import <GRL/Array.h>
#import <GRL/Functions.h>
#import <GRL/Config.h>
#import <stdlib.h>
#import STRING_H
#import <vector>

struct _GRawArrayOpaqueData {
	std::vector <const void *> *vec;
};

@implementation GRawArray


- (void) dealloc
{
	if (mbs) {
		delete mbs->vec;
	}
	
	GFree (mbs);
	[super dealloc];
}

+ (id) arrayWithObjects:(const void **)objList
{
	return [[[self alloc] initWithObjects:objList] autorelease]; 
}

+ (id) arrayWithObjectsFromArray:(GRawArray *)list
{
	return [self arrayWithObjectFromArray:list range:GMakeRange(0, [list count])];
}

+ (id) arrayWithObjectsFromArray:(GRawArray *)list range:(GRange)range
{
	return [[[self alloc] initWithObjectFromArray:list range:range] autorelease];
}

- (id) initWithObjects:(const void **)objList
{
	self = [super init];
	
	if (self) {
		mbs = (_GRawArrayOpaqueData *)GAllocate (sizeof(*mbs));
		
		if(!mbs) {
			GErrorSet (GMemError);
			[self release];
			return nil;
		}
		
		mbs->vec = new std::vector <const void *>;
		
		if (!mbs->vec) {
			GErrorSet (GMemError);
			[self release];
			return nil;
		}
		
		if (!objList) {
			GErrorSet (GInconsistencyError);
			return self;
		}
		
		unsigned i = 0;
		while (objList[i]) {
			mbs->vec->insert(mbs->vec->begin() + mbs->vec->size(), 1, objList[i]);
		}
	}
	
	return self;
}

- (id) initWithObjectsFromArray:(GRawArray *)list
{
	return [self initWithObjectsFromArray:list range:GMakeRange(0, [list count])];
}

- (id) initWithObjectsFromArray:(GRawArray *)list range:(GRange)range
{
	self = [super init];
	
	if (self) {
		mbs = (_GRawArrayOpaqueData *)GAllocate (sizeof(*mbs));
		
		if(!mbs) {
			GErrorSet (GMemError);
			[self release];
			return nil;
		}
		
		mbs->vec = new std::vector <const void *>;
		
		if (!mbs->vec) {
			GErrorSet (GMemError);
			[self release];
			return nil;
		}
		
		if (!list || range.start > [list count] || range.length == 0) {
			GErrorSet (GInconsistencyError);
			return self;
		}
		
		if (range.start + range.length > [list count]) {
			range.length = [list count] - range.start;
		}
		
		for (unsigned i = range.start; i < range.start + range.length;i++) {
			mbs->vec->insert(mbs->vec->begin() + mbs->vec->size(), 1, [list objectAtIndex:i]);
		}
	}
	
	return self;
}

//- (void) addObject:(const void *)obj;
//- (void) addObject:(const void *)obj ifAbsent:(BOOL)flag;
//- (void) insertObject:(const void *)obj atIndex:(unsigned)idx;
//
//- (void) addObjects:(const void **)list;
//- (void) addObjectsFromArray:(GRawArray *)list;
//- (void) addObjectsFromArray:(GRawArray *)list range:(GRange)range;
//- (void) insertObjectsFromArray:(GRawArray *)list range:(GRange)range atIndex:(unsigned)index;
//
//- (void) removeObjectAtIndex:(unsigned)idx;
//- (void) removeObject:(const void *)obj;
//- (void) removeObjectsInRange:(GRange)range;
//- (void) removeFirst;
//- (void) removeLast;
//- (void) empty;
//
//- (const void *) first;
//- (const void *) last;
//- (const void *) objectAtIndex:(unsigned)idx;
//- (unsigned) indexOfObject:(const void *)obj;
//- (BOOL) contains:(const void *)obj;
//
//- (unsigned) count;

@end

@implementation GArray


@end
