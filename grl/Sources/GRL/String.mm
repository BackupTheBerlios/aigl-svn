
/*
 *
 *  GRL/String.m
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

#import <GRL/String.h>
#import <GRL/Functions.h>
#import STRING_H
#import <string>
#import <fstream>

struct _GStringOpaqueData {
	std::string *cpps;
};

@implementation GString

- (void) dealloc
{
	if (mbs) {
		delete mbs->cpps;
	}
	GFree (mbs);
	[super dealloc];
}

- (id) init
{
	return [self initWithCharacters:NULL];
}

+ (id) stringWithCharacters:(const char *)cString
{
	return [[[self alloc] initWithCharacters:cString] autorelease];
}

+ (id) stringWithCharacters:(const char *)cString range:(GRange)range
{
	return [[[self alloc] initWithCharacters:cString range:range] autorelease];
}

+ (id) stringWithString:(GString *)string
{
	return [[[self alloc] initWithString:string] autorelease];
}

+ (id) stringWithString:(GString *)string range:(GRange)range
{
	return [[[self alloc] initWithString:string range:range] autorelease];
}

+ (id) stringWithFormat:(const char *)format, ...
{
	va_list args;
	va_start(args, format);
	self = [self stringWithFormat:format arguments:args];
	va_end(args);
	return self;
}

+ (id) stringWithFormat:(const char *)format arguments:(va_list)args
{
	return [[[self alloc] initWithFormat:format arguments:args] autorelease];
}

+ (id) stringWithFile:(const char *)sourceFilename
{
	return [[[self alloc] initWithFile:sourceFilename] autorelease];
}

- (id) initWithCharacters:(const char *)cString
{
	return [self initWithCharacters:cString range:GMakeRange (0, (cString != NULL) ? strlen (cString) : 0)];
}

- (id) initWithCharacters:(const char *)cString range:(GRange)range
{
	self = [super init];
	
	if (self) {
		mbs = (_GStringOpaqueData *)GAllocate (sizeof(*mbs));
		
		if(!mbs) {
			GErrorSet (GMemError);
			[self release];
			return nil;
		}
		
		mbs->cpps = new std::string;
		
		if (!mbs->cpps) {
			GErrorSet (GMemError);
			[self release];
			return nil;
		}
		
		if (cString) mbs->cpps->assign (cString + range.start, range.length);
	}
	
	return self;
}

- (id) initWithString:(GString *)string
{
	return [self initWithString:string range:GMakeRange(0, [string length])];
}

- (id) initWithString:(GString *)string range:(GRange)range
{
	return [self initWithCharacters:[string cString] range:range];
}

- (id) initWithFormat:(const char *)format, ...
{
	va_list args;
	va_start(args, format);
	self = [self initWithFormat:format arguments:args];
	va_end(args);
	return self;
}

- (id) initWithFormat:(const char *)format arguments:(va_list)args
{
	self = [super init];
	
	if (self) {
		char *buffer = NULL;
		
		mbs = (_GStringOpaqueData *)GAllocate (sizeof(*mbs));
		
		if(!mbs) {
			GErrorSet (GMemError);
			[self release];
			return nil;
		}
		
		mbs->cpps = new std::string;
		
		if (!mbs->cpps) {
			GErrorSet (GMemError);
			[self release];
			return nil;
		}
		
		if (!format) {
			GErrorSet(GInconsistencyError);
			return self;
		}
		
		vasprintf(&buffer, format, args);
		
		if (!buffer) {
			GErrorSet(GMemError);
			[self release];
			return nil;
		}
		
		mbs->cpps->assign(buffer);
		
		free (buffer);
	}
	
	return self;	
}

- (id) initWithFile:(const char *)sourceFilename
{
	self = [super init];
	
	if (self) {
		mbs = (_GStringOpaqueData *)GAllocate (sizeof(*mbs));
		
		if(!mbs) {
			GErrorSet (GMemError);
			[self release];
			return nil;
		}
		
		mbs->cpps = new std::string;
		
		if (!mbs->cpps) {
			GErrorSet (GMemError);
			[self release];
			return nil;
		}
		
		[self readFromFile:sourceFilename];
	}
	
	return self;
}


- (void) setCharacters:(const char *)cString
{
	mbs->cpps->assign(cString);
}

- (void) appendCharacters:(const char *)cString
{
	mbs->cpps->append(cString);
}

- (void) appendCharacters:(const char *)cString range:(GRange)range
{
	if (cString) {
		mbs->cpps->append(cString + range.start, range.length);
	}
}

- (void) appendString:(GString *)string
{
	[self appendCharacters:[string cString]];
}

- (void) appendString:(GString *)string range:(GRange)range
{
	[self appendCharacters:[string cString] range:range];
}

- (void) prependCharacters:(const char *)cString
{
	mbs->cpps->insert (0, cString);
}

- (void) prependString:(GString *)string
{
	mbs->cpps->insert (0, [string cString]);
}

- (void) insertCharacters:(const char *)cString atIndex:(unsigned)idx
{
	mbs->cpps->insert (idx, cString);
}

- (void) insertCharacters:(const char *)cString atIndex:(unsigned)idx range:(GRange)srcRange
{
	mbs->cpps->insert(idx, cString + srcRange.start, srcRange.length);
}

- (void) insertString:(GString *)string atIndex:(unsigned)idx
{
	[self insertCharacters:[string cString] atIndex:idx];
}

- (void) insertString:(GString *)string atIndex:(unsigned)idx range:(GRange)srcRange
{
	[self insertCharacters:[string cString] atIndex:idx range:srcRange];
}


- (void) removeCharacterAtIndex:(unsigned)idx
{
	mbs->cpps->erase(idx, 1);
}

- (void) removeCharactersForRange:(GRange)range
{
	mbs->cpps->erase(range.start, range.length);
}


- (char) characterAtIndex:(unsigned)idx
{
	char chr = mbs->cpps->at(idx);
	return chr;
}

- (const char *) cString
{
	return mbs->cpps->c_str();
}

- (unsigned) length
{
	return mbs->cpps->length();
}


- (BOOL) isEqualTo:(GString *)string
{
	BOOL res = NO;
	
	if (!string) {
		res = YES;
	} else if (string) {
		if ([self length] == [string length]) {
			if (0 == mbs->cpps->compare([string cString])) {
				res = YES;
			}
		}
	}
	
	return res;
}


- (void) readFromFile:(char const *)filename
{
	if (!filename) {
		GErrorSet(GInconsistencyError);
		return;
	}
	
	unsigned len;
	char *buffer = NULL;
	std::ifstream stream(filename);
	
	if (!stream.is_open()) {
		GErrorSet (GFileError);
		return;
	}
	
	stream.seekg (0, std::ios::end);
	len = stream.tellg();
	stream.seekg (0, std::ios::beg);
	
	buffer = GAllocate(len);
	
	if (!buffer) {
		GErrorSet (GMemError);
		stream.close();
		return;
	}
	
	stream.read (buffer, len);
	stream.close();
	
	mbs->cpps->assign(buffer);
	GFree (buffer);
}

- (void) writeToFile:(char const *)filename
{
	if (!filename) {
		GErrorSet(GInconsistencyError);
		return;
	}
	
	std::ofstream stream(filename);
	
	if (!stream.is_open()) {
		GErrorSet (GFileError);
		return;
	}
	
	stream.write (mbs->cpps->c_str(), mbs->cpps->length());
	stream.close();
}

@end
