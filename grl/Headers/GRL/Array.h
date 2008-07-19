
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

@interface GRawArray : GObject {
	const void **array;
	unsigned length;
}

- (void)appendObjectsFrom:(GRawArray *)list;
- (void)appendObjectsFrom:(GRawArray *)list range:(GRange)range;
- (void)insertObjectsFrom:(GRawArray *)list range:(GRange)range atIndex:(unsigned)index;

- (void)addObjects:(const void **)list;

- (void)add:(const void *)obj;
- (void)add:(const void *)obj ifAbsent:(BOOL)flag;
- (void)insert:(const void *)obj atIndex:(unsigned)idx;

- (void)removeObjectAtIndex:(unsigned)idx;
- (void)remove:(const void *)obj;
- (void)removeObjectsInRange:(GRange)range;
- (void)removeFirst;
- (void)removeLast;
- (void)empty;

- (const void *)first;
- (const void *)last;
- (const void *)objectAtIndex:(unsigned)idx;
- (unsigned)indexOf:(const void *)obj;
- (BOOL)contains:(const void *)obj;

- (unsigned)count;

@end

@interface GArray : GRawArray {

}

//- (void)append:(GArray *)list;
//- (void)append:(GArray *)list from:(unsigned)idx over:(unsigned)range;
//
- (void)add:(id <GObject>)obj;
//- (void)add:(id <GObject>)obj ifAbsent:(BOOL)flag;
//- (void)insert:(id <GObject>)obj atIndex:(unsigned)idx;
//
//- (void)removeObjectAtIndex:(unsigned)idx;
//- (void)remove:(id <GObject>)obj;
//- (void)removeObjectsFrom:(unsigned)idx over:(unsigned)range;
- (void)removeFirst;
//- (void)removeLast;
//- (void)empty;
//
- (id <GObject>)first;
//- (id <GObject>)last;
- (id <GObject>)objectAtIndex:(unsigned)idx;
//- (unsigned)indexOf:(id <GObject>)obj;
//- (BOOL)contains:(id <GObject>)obj;
//
//- (unsigned)count;

@end

#ifdef __cplusplus
}
#endif

