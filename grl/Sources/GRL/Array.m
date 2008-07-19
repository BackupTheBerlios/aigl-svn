
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

@interface GRawArray (Private)
- (const void **)directBufferAccess;
@end

@implementation GRawArray

- (void)dealloc
{
	free (array);
	[super dealloc];
}

- (void)appendObjectsFrom:(GRawArray *)list
{
	if (list) {
		[self appendObjectsFrom:list forRange:GMakeRange(0, [list count])];
	}
}

- (void)appendObjectsFrom:(GRawArray *)list range:(GRange)range
{
	if (list) {
		[self insertObjectsFrom:list forRange:range atIndex:[list count]];
	}
}

- (void)insertObjectsFrom:(GRawArray *)list range:(GRange)range atIndex:(unsigned)idx
{
	if (!list) {
		GErrorSet (GInconsistencyError);
		return;
	}
	
	unsigned outLength = [list count];
	const void **data = [list directBufferAccess];
	
	if (range.start > outLength) {
		GErrorSet (GInconsistencyError);
		return;
	}
	
	if (range.start + range.length > outLength) {
		range.length = outLength - range.start;
	}
	
	if (idx > length)
		idx = length;
	
	if (!array) {
		unsigned alloc = 8;
		while (alloc < range.length)
			alloc <<= 1;
		
		array = GAllocate(alloc * sizeof(void *));
		
		if (!array) {
			GErrorSet (GMemError);
			return;
		}
	} else {
		unsigned oAlloc = 8, nAlloc = 8;
		while (oAlloc < length)
			oAlloc <<= 1;
		while (nAlloc < length + range.length)
			nAlloc <<= 1;
		
		if (oAlloc != nAlloc) {
			void *tmp = GReallocate (array, oAlloc * sizeof(void *), nAlloc * sizeof (void *));
			
			if (!tmp) {
				GErrorSet (GMemError);
				return;
			}
			
			array = tmp;
		}
	}
	
	memmove (array + idx + range.length,
			 array + idx,
			 (length - idx) * sizeof(void *));
	memcpy (array + idx, data + range.start, range.length);
	
	length += range.length;
}

- (void)addObjects:(const void **)list
{
	if (!list) {
		GErrorSet(GInconsistencyError);
		return;
	}
	
	unsigned i;
	for (i = 0;list[i] != NULL;i++) {
		[self add:list[i]];
	}
}

- (void)add:(const void *)obj
{
	[self insert:obj atIndex:length];
}

- (void)add:(const void *)obj ifAbsent:(BOOL)flag
{
	if (!flag && [self contains:obj])
		return;
	
	[self add:obj];
}

- (void)insert:(const void *)obj atIndex:(unsigned)idx
{
	if (!obj) {
		GErrorSet (GInconsistencyError);
		return;
	}
	
	if (idx > length)
		idx = length;
	
	if (!array) {
		unsigned alloc = 8;
		array = GAllocate(alloc * sizeof(void *));
		
		if (!array) {
			GErrorSet (GMemError);
			return;
		}
	} else {
		unsigned oAlloc = 8, nAlloc = 8;
		while (oAlloc < length)
			oAlloc <<= 1;
		while (nAlloc < length + 1)
			nAlloc <<= 1;
		
		if (oAlloc != nAlloc) {
			void *tmp = GReallocate (array,oAlloc * sizeof(void *), nAlloc * sizeof (void *));
			
			if (!tmp) {
				GErrorSet (GMemError);
				return;
			}
			
			array = tmp;
		}
	}
	
	memmove (&array[idx + 1], &array[idx], (length - idx + 1) * sizeof(void *));
	array[idx] = obj;
	length++;
}

- (void)removeObjectAtIndex:(unsigned)idx
{
	if (!array) {
		return;
	}
	
	if (idx >= length) {
		GErrorSet (GInconsistencyError);
		return;
	}
	
	memmove (&array[idx], &array[idx + 1], (length - idx - 1) * sizeof(void *));
	
	unsigned oAlloc = 8, nAlloc = 8;
	while (oAlloc < length)
		oAlloc <<= 1;
	while (nAlloc < length - 1)
		nAlloc <<= 1;
	
	length--;
	
	if (oAlloc != nAlloc) {
		void *tmp = GReallocate (array, oAlloc * sizeof(void *), nAlloc * sizeof(void *));
		
		if (!tmp) {
			GErrorSet (GMemError);
			return;
		}
		
		array = tmp;
	}
}

- (void)remove:(const void *)obj
{
	unsigned idx = [self indexOf:obj];
	
	if (idx !=  GNotFound) {
		[self removeObjectAtIndex:idx];
	}
}

- (void)removeObjectsInRange:(GRange)range
{
	if (!array) {
		return;
	}
	
	if (range.start >= length || range.start + range.length >= length) {
		GErrorSet (GInconsistencyError);
		return;
	}
	
	memmove (&array[range.start],
			 &array[range.start + range.length],
			 (length - range.start - range.length) * sizeof(void *));
	
	unsigned oAlloc = 8, nAlloc = 8;
	while (oAlloc < length)
		oAlloc <<= 1;
	while (nAlloc < length - range.length)
		nAlloc <<= 1;
	
	length -= range.length;
	
	if (oAlloc != nAlloc) {
		void *tmp = GReallocate (array, oAlloc * sizeof(void *), nAlloc * sizeof(void *));
		
		if (!tmp) {
			GErrorSet (GMemError);
			return;
		}
		
		array = tmp;
	}
}

- (void)removeFirst
{
	if (array && length) {
		[self removeObjectAtIndex:0];
	}
}

- (void)removeLast
{
	if (array && length) {
		[self removeObjectAtIndex:length - 1];
	}
}

- (void)empty
{
	length = 0;
	array = GAllocate(8);
	
	if (!array) {
		GErrorSet (GMemError);
	}
}

- (const void *)first
{
	return [self objectAtIndex:0];
}

- (const void *)last
{
	return [self objectAtIndex:length - 1];
}

- (const void *)objectAtIndex:(unsigned)idx
{
	const void *ptr = NULL;
	
	if (array && idx < length) {
		ptr = array[idx];
	}
	
	return ptr;
}

- (unsigned)indexOf:(const void *)obj
{
	unsigned idx = GNotFound;
	
	if (obj) {
		if (array) {
			unsigned i;
			for (i = 0; i < length;i++) {
				if (obj == array[i]) {
					idx = i;
					break;
				}
			}
		}
	} else {
		GErrorSet(GInconsistencyError);
	}
	
	return idx;
}

- (BOOL)contains:(const void *)obj
{
	BOOL res = NO;
	
	if (obj && array) {
		unsigned i;
		for (i = 0; i < length;i++) {
			if (obj == array[i]) {
				res = YES;
				break;
			}
		}
	}
	
	return res;
}

- (unsigned)count
{
	return length;
}

- (const void **)directBufferAccess
{
	return array;
}

@end

@implementation GArray

- (void)add:(id <GObject>)obj
{
	
}

@end
