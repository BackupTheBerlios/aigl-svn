
/*
 *
 *  GRL/Exception.m
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

#import <GRL/Exception.h>
#import <GRL/Functions.h>


@implementation GException

- (void) dealloc
{
	[_name release];
	[_description release];
	[super dealloc];
}

+ (void)raise:(const char *)name description:(GString *)string
{
	[[self exceptionWithName:name description:string] raise];
}

+ (id) exceptionWithName:(const char *)name description:(GString *)description
{
	return [[[self alloc] initWithName:name description:description] autorelease];
}

- (id) initWithName:(const char *)name description:(GString *)description
{
	self = [super init];
	
	if (self) {
		_name = [[GString stringWithCharacters:name] retain];
		_description = [[GString stringWithString:description] retain];
	}
	
	return self;
}

- (GString *) name
{
	return _name;
}

- (GString *) description
{
	return _description;
}

- (void) raise
{
	@throw self;
}

@end

