
/*
 *
 *  GRL/Array.h
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

#define GNotFound UINT_MAX

typedef struct _GRawArrayOpaqueData _GRawArrayOpaqueData;

	
@interface GRawArray : GObject {
	_GRawArrayOpaqueData *mbs;
//	const void **array;
//	unsigned length;
}

+ (GRawArray *) arrayWithObjects:(const void **)objList;
+ (GRawArray *) arrayWithObjectsFromArray:(GRawArray *)list;
+ (GRawArray *) arrayWithObjectsFromArray:(GRawArray *)list range:(GRange)range;

- (GRawArray *) initWithObjects:(const void **)objList;
- (GRawArray *) initWithObjectsFromArray:(GRawArray *)list;
- (GRawArray *) initWithObjectsFromArray:(GRawArray *)list range:(GRange)range;

- (void) addObject:(const void *)obj;
- (void) addObject:(const void *)obj ifAbsent:(BOOL)flag;
- (void) insertObject:(const void *)obj atIndex:(unsigned)idx;

- (void) addObjects:(const void **)list;
- (void) addObjectsFromArray:(GRawArray *)list;
- (void) addObjectsFromArray:(GRawArray *)list range:(GRange)range;
- (void) insertObjectsFromArray:(GRawArray *)list range:(GRange)range atIndex:(unsigned)index;

- (void) removeObjectAtIndex:(unsigned)idx;
- (void) removeObject:(const void *)obj;
- (void) removeObjectsInRange:(GRange)range;
- (void) removeFirst;
- (void) removeLast;
- (void) empty;

- (const void *) first;
- (const void *) last;
- (const void *) objectAtIndex:(unsigned)idx;
- (unsigned) indexOfObject:(const void *)obj;
- (BOOL) contains:(const void *)obj;

- (unsigned) count;

@end

@interface GArray : GObject {
	GRawArray *arr;
}

+ (GArray *) arrayWithObjects:(id <GObject> *)objList;
+ (GArray *) arrayWithObjectsFromArray:(GArray *)list;
+ (GArray *) arrayWithObjectsFromArray:(GArray *)list range:(GRange)range;

- (GArray *) initWithObjects:(id <GObject> *)objList;
- (GArray *) initWithObjectsFromArray:(GArray *)list;
- (GArray *) initWithObjectsFromArray:(GArray *)list range:(GRange)range;

- (void) addObject:(id <GObject>)obj;
- (void) addObject:(id <GObject>)obj ifAbsent:(BOOL)flag;
- (void) insertObject:(id <GObject>)obj atIndex:(unsigned)idx;

- (void) addObjects:(id <GObject> *)list;
- (void) addObjectsFromArray:(GArray *)list;
- (void) addObjectsFromArray:(GArray *)list range:(GRange)range;
- (void) insertObjectsFromArray:(GArray *)list range:(GRange)range atIndex:(unsigned)index;

- (void) removeObjectAtIndex:(unsigned)idx;
- (void) removeObject:(id <GObject>)obj;
- (void) removeObjectsInRange:(GRange)range;
- (void) removeFirst;
- (void) removeLast;
- (void) empty;

- (id <GObject>) first;
- (id <GObject>) last;
- (id <GObject>) objectAtIndex:(unsigned)idx;
- (unsigned) indexOfObject:(id <GObject>)obj;
- (BOOL) contains:(id <GObject>)obj;

- (unsigned) count;

@end

#ifdef __cplusplus
}
#endif

