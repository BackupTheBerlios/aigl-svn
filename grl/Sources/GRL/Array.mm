
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
#import <GRL/Exception.h>
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

- (id) init {
	return [self initWithObjects:nil];
}

+ (GRawArray *) arrayWithObjects:(const void **)objList
{
	return [[(GRawArray *)[self alloc] initWithObjects:objList] autorelease]; 
}

+ (GRawArray *) arrayWithObjectsFromArray:(GRawArray *)list
{
	return [self arrayWithObjectsFromArray:list range:GMakeRange(0, [list count])];
}

+ (GRawArray *) arrayWithObjectsFromArray:(GRawArray *)list range:(GRange)range
{
	return [[(GRawArray *)[self alloc] initWithObjectsFromArray:list range:range] autorelease];
}

- (GRawArray *) initWithObjects:(const void **)objList
{
	self = [super init];
	
	if (self) {
		mbs = (_GRawArrayOpaqueData *)GAllocate (sizeof(*mbs));
		
		if(!mbs) {
			[GException raise:GMallocException description:nil];
			[self release];
			return nil;
		}
		
		mbs->vec = new std::vector <const void *>;
		
		if (!mbs->vec) {
			[GException raise:GMallocException description:nil];
			[self release];
			return nil;
		}
		
		if (!objList) {
			return self;
		}
		
		[self addObjects:objList];
	}
	
	return self;
}

- (GRawArray *) initWithObjectsFromArray:(GRawArray *)list
{
	return [self initWithObjectsFromArray:list range:GMakeRange(0, [list count])];
}

- (GRawArray *) initWithObjectsFromArray:(GRawArray *)list range:(GRange)range
{
	self = [super init];
	
	if (self) {
		mbs = (_GRawArrayOpaqueData *)GAllocate (sizeof(*mbs));
		
		if(!mbs) {
			[GException raise:GMallocException description:nil];
			[self release];
			return nil;
		}
		
		mbs->vec = new std::vector <const void *>;
		
		if (!mbs->vec) {
			[GException raise:GMallocException description:nil];
			[self release];
			return nil;
		}
		
		[self addObjectsFromArray:list range:range];
	}
	
	return self;
}

- (void) addObject:(const void *)obj
{
	if (obj) mbs->vec->insert(mbs->vec->end(), 1, obj);
}

- (void) addObject:(const void *)obj ifAbsent:(BOOL)flag
{
	if (!flag && [self contains:obj]) {
		return;
	}
	
	[self addObject:obj];
}

- (void) insertObject:(const void *)obj atIndex:(unsigned)idx
{
	if (obj) mbs->vec->insert(mbs->vec->begin() + idx, 1, obj);
}


- (void) addObjects:(const void **)list
{
	if (!list) {
		return;
	}
	
	unsigned i = 0;
	while (list[i]) {
		mbs->vec->insert(mbs->vec->end(), 1, list[i]);
	}
}

- (void) addObjectsFromArray:(GRawArray *)list
{
	[self addObjectsFromArray:list range:GMakeRange(0, [list count])];
}

- (void) addObjectsFromArray:(GRawArray *)list range:(GRange)range
{
	[self insertObjectsFromArray:list range:range atIndex:[list count]];
}

- (void) insertObjectsFromArray:(GRawArray *)list range:(GRange)range atIndex:(unsigned)index
{
	if (!list || range.start > [list count] || range.length == 0) {
		return;
	}
	
	if (range.start + range.length > [list count]) {
		range.length = [list count] - range.start;
	}
	
	if (index > [self count])
		index = [self count];
	
	for (unsigned i = range.start; i < range.start + range.length;i++) {
		mbs->vec->insert(mbs->vec->begin() + index + (i - range.start), 1, [list objectAtIndex:i]);
	}
}


- (void) removeObjectAtIndex:(unsigned)idx
{
	mbs->vec->erase(mbs->vec->begin() + idx);
}

- (void) removeObject:(const void *)obj
{
	unsigned idx = [self indexOfObject:obj];
	if (idx != GNotFound) {
		mbs->vec->erase(mbs->vec->begin() + idx);
	}
}

- (void) removeObjectsInRange:(GRange)range
{
	mbs->vec->erase(mbs->vec->begin() + range.start, mbs->vec->begin() + range.start + range.length);
}

- (void) removeFirst
{
	mbs->vec->erase(mbs->vec->begin());
}

- (void) removeLast
{
	mbs->vec->erase(mbs->vec->end());
}

- (void) empty
{
	mbs->vec->clear();
}


- (const void *) first
{
	return mbs->vec->at(0);
}

- (const void *) last
{
	return mbs->vec->at(mbs->vec->size());
}

- (const void *) objectAtIndex:(unsigned)idx
{
	return mbs->vec->at(idx);
}

- (unsigned) indexOfObject:(const void *)obj
{
	unsigned idx = GNotFound;
	
	if (obj) {
		unsigned s = [self count];
		for (unsigned i = 0;i < s;i++) {
			if ([self objectAtIndex:i] == obj) {
				idx = i;
				break;
			}
		}
	}
	
	return idx;
}

- (BOOL) contains:(const void *)obj
{
	if ([self indexOfObject:obj] == GNotFound)
		return NO;
	else
		return YES;
}


- (unsigned) count
{
	return mbs->vec->size();
}

@end

@implementation GArray

- (void) dealloc
{
	[self empty];
	[arr release];
	[super dealloc];
}

- (id) init
{
	return [self initWithObjects:nil];
}

+ (GArray *) arrayWithObjects:(id <GObject> *)objList
{
	return [[(GArray *)[self alloc] initWithObjects:objList] autorelease];
}

+ (GArray *) arrayWithObjectsFromArray:(GArray *)list
{
	return [[(GArray *)[self alloc] initWithObjectsFromArray:list] autorelease];
}

+ (GArray *) arrayWithObjectsFromArray:(GArray *)list range:(GRange)range
{
	return [[(GArray *)[self alloc] initWithObjectsFromArray:list range:range] autorelease];
}


- (GArray *) initWithObjects:(id <GObject> *)objList
{
	self = [super init];
	
	if (self) {
		arr = [GRawArray new];
		
		if (!arr) {
			[GException raise:GMallocException description:nil];
			[self release];
			return nil;
		}
		
		[self addObjects:objList];
	}
	
	return self;
}

- (GArray *) initWithObjectsFromArray:(GArray *)list
{
	self = [super init];
	
	if (self) {
		arr = [GRawArray new];
		
		if (!arr) {
			[GException raise:GMallocException description:nil];
			[self release];
			return nil;
		}
		
		[self addObjectsFromArray:list];
	}
	
	return self;
}

- (GArray *) initWithObjectsFromArray:(GArray *)list range:(GRange)range
{
	self = [super init];
	
	if (self) {
		arr = [GRawArray new];
		
		if (!arr) {
			[GException raise:GMallocException description:nil];
			[self release];
			return nil;
		}
		
		[self addObjectsFromArray:list range:range];
	}
	
	return self;
}

- (void) addObject:(id <GObject>)obj
{
	if (obj) {
		[obj retain];
		[arr addObject:obj];
	}
}

- (void) addObject:(id <GObject>)obj ifAbsent:(BOOL)flag
{
	if (!flag && [self contains:obj]) {
		return;
	}
	
	[self addObject:obj];
}

- (void) insertObject:(id <GObject>)obj atIndex:(unsigned)idx
{
	if (obj) {
		[obj retain];
		[arr insertObject:obj atIndex:idx];
	}
}

- (void) addObjects:(id <GObject> *)list
{
	if (!list)
		return;
	
	for (unsigned i = 0;list[i];i++) {
		[list[i] retain];
		[arr addObject:list[i]];
	}
}

- (void) addObjectsFromArray:(GArray *)list
{
	[self addObjectsFromArray:list range:GMakeRange(0, [list count])];
}

- (void) addObjectsFromArray:(GArray *)list range:(GRange)range
{
	[self insertObjectsFromArray:list range:range atIndex:[list count]];
}

- (void) insertObjectsFromArray:(GArray *)list range:(GRange)range atIndex:(unsigned)index
{
	if (!list || range.start > [list count] || range.length == 0) {
		return;
	}
	
	if (range.start + range.length > [list count]) {
		range.length = [list count] - range.start;
	}
	
	if (index > [self count])
		index = [self count];
	
	for (unsigned i = range.start; i < range.start + range.length;i++) {
		[[list objectAtIndex:i] retain];
		[arr insertObject:[list objectAtIndex:i] atIndex:index + (i - range.start)];
	}
}

- (void) removeObjectAtIndex:(unsigned)idx
{
	[[self objectAtIndex:idx] release];
	[arr removeObjectAtIndex:idx];
}

- (void) removeObject:(id <GObject>)obj
{
	unsigned idx = GNotFound;
	if (GNotFound != (idx = [self indexOfObject:obj])) {
		[self removeObjectAtIndex:idx];
	}
}

- (void) removeObjectsInRange:(GRange)range
{
	if (range.start < [self count] && range.length > 0) {
		if (range.start + range.length > [self count])
			range.length = [self count] - range.start;
		
		for (unsigned i = range.start;i < range.start + range.length;i++) {
			[self removeObjectAtIndex:range.start];
		}
	}
}

- (void) removeFirst
{
	[self removeObjectAtIndex:0];
}

- (void) removeLast
{
	[self removeObjectAtIndex:[self count]];
}

- (void) empty
{
	[self removeObjectsInRange:GMakeRange(0, [self count])];
}

- (id <GObject>) first
{
	return [self objectAtIndex:0];
}

- (id <GObject>) last
{
	return [self objectAtIndex:[self count]];
}

- (id <GObject>) objectAtIndex:(unsigned)idx
{
	return (id <GObject>)[arr objectAtIndex:idx];
}

- (unsigned) indexOfObject:(id <GObject>)obj
{
	return [arr indexOfObject:obj];
}

- (BOOL) contains:(id <GObject>)obj
{
	if (GNotFound != [self indexOfObject:obj])
		return YES;
	else
		return NO;
}

- (unsigned) count
{
	return [arr count];
}

@end
