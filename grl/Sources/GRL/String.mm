
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

/* - (void)dealloc
{
	free(data);
	[super dealloc];
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
	return [self stringWithFormat:format arguments:args];
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
	if (!cString) {
		GErrorSet (GInconsistencyError);
		[self release];
		return nil;
	}
	
	return [self initWithCharacters:cString range:GMakeRange(0, strlen(cString) + 1)];
}

- (id) initWithCharacters:(const char *)cString range:(GRange)range
{
	self = [super init];
	
	if (self) {
		if (!cString) {
			GErrorSet(GInconsistencyError);
			[self release];
			return nil;
		}
		
		[self setCharacters:cString];
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
	return [self initWithFormat:format arguments:args];
}

- (id) initWithFormat:(const char *)format arguments:(va_list)args
{
	self = [super init];
	
	if (self) {
		if (!format) {
			GErrorSet(GInconsistencyError);
			[self release];
			return nil;
		}
		
		vasprintf(&data, format, args);
		
		if (!data) {
			GErrorSet(GMemError);
			[self release];
			return nil;
		}
		
		[self setLength:strlen(data)];
		
		unsigned alloc = 8;
		while (alloc < [self length])
			alloc <<= 1;
		
		if (alloc > [self length]) {
			void *tmp = GReallocate (data, [self length] + 1, alloc);
			
			if (tmp) {
				data = tmp;
			} else {
				GErrorSet(GMemError);
				[self release];
				return nil;
			}
		}
	}
	
	return self;
}

- (id) initWithFile:(const char *)sourceFilename
{
	self = [super init];
	
	if (self) {
		[self readFrom:sourceFilename];
	}
	
	return self;
}

- (void) setCharacters:(const char *)cString
{
	if (!cString) {
		free (data), data = NULL;
		[self setLength:0];
		return;
	}
	
	unsigned len = strlen (cString);
	unsigned alloc = 8;
	while (alloc < len)
		alloc <<= 1;
	
	data = GAllocate (alloc);
	
	if (!data) {
		GErrorSet(GMemError);
		return;
	}
	
	memmove (data, cString, len + 1);
	[self setLength:len];
}

- (void) appendCharacters:(const char *)cString
{
	if (!cString) {
		GErrorSet (GInconsistencyError);
		return;
	}
	
	[self appendCharacters:cString range:GMakeRange(0, strlen(cString))];
}

- (void) appendCharacters:(const char *)cString range:(GRange)range
{
	[self insertCharacters:cString atIndex:[self length] range:range];
}

- (void) appendString:(GString *)string
{
	[self appendString:string range:GMakeRange(0, [string length])];
}

- (void) appendString:(GString *)string range:(GRange)range
{
	[self appendCharacters:[string cString] range:range];
}

- (void) prependCharacters:(const char *)cString
{
	[self insertCharacters:cString atIndex:0];
}

- (void) prependString:(GString *)string
{
	[self insertCharacters:[string cString] atIndex:0];
}

- (void) insertCharacters:(const char *)cString atIndex:(unsigned)idx
{
	if (!cString) {
		GErrorSet (GInconsistencyError);
		return;
	}
	
	[self insertCharacters:cString atIndex:idx range:GMakeRange(0, strlen(cString))];
}

- (void) insertCharacters:(const char *)cString atIndex:(unsigned)idx range:(GRange)srcRange
{
	if (!cString) {
		GErrorSet (GInconsistencyError);
		return;
	}
	
	unsigned len = strlen (cString);
	if (srcRange.length > len + 1)
		srcRange.length = len + 1;
	
	if (!data) {
		unsigned alloc = 8;
		while (alloc < srcRange.length)
			alloc <<= 1;
		
		data = GAllocate(alloc);
		
		if (!data) {
			GErrorSet (GMemError);
			return;
		}
		
		memmove (data, cString + srcRange.start, srcRange.length);
		[self setLength:srcRange.length];
		return;
	}
	
	if (idx > [self length])
		idx = [self length];
	
	unsigned totalLen = srcRange.length + [self length];
	unsigned allocNew = 8, allocCurrent = 8;
	
	while (allocNew < totalLen)
		allocNew <<= 1;
	
	while (allocCurrent < [self length])
		allocCurrent <<= 1;
	
	if (allocNew != allocCurrent) {
		void *tmp = GReallocate(data, allocCurrent, allocNew);
		
		if (!tmp) {
			GErrorSet (GMemError);
			return;
		}
		
		data = tmp;
	}
	
	// move data to have space for characters
	memmove (data + idx + srcRange.length, data + idx, [self length] - idx);
	
	// copy characters from source
	memmove (data + idx, cString + srcRange.start, srcRange.length);
	[self setLength:totalLen];
}

- (void) insertString:(GString *)string atIndex:(unsigned)idx
{
	[self insertCharacters:[string cString] atIndex:idx];
}

- (void) insertString:(GString *)string atIndex:(unsigned)idx range:(GRange)srcRange
{
	[self insertCharacters:[string cString] atIndex:idx range:srcRange];
}

- (void) removeCharactersForRange:(GRange)range
{
	if (range.start >= [self length] || !data) {
		return;
	}
	
	if (range.start + range.length > [self length]) {
		range.length = [self length] - range.start;
	}
	
	memmove (data + range.start, data + range.start + range.length, [self length] - range.length + 1);
	
	unsigned oldAlloc = 8, newAlloc = 8;
	while (oldAlloc < [self length])
		oldAlloc <<= 1;
	while (newAlloc < ([self length] - range.length))
		newAlloc <<= 1;
	
	[self setLength:[self length] - range.length];
	
	if (oldAlloc != newAlloc) {
		void *tmp = GReallocate (data, oldAlloc, newAlloc);
		
		if (tmp) {
			data = tmp;
		} else {
			GErrorSet (GMemError);
		}
	}
}

- (char) characterAtIndex:(unsigned)idx
{
	char chr = 0;
	if (idx <= [self length])
		chr = data[idx];
	return chr;
}

- (const char *) cString
{
	return data;
}


- (unsigned) length
{
	return length;
}

- (BOOL) isEqualTo:(GString *)string
{
	BOOL res = NO;
	
	if (!string && !data) {
		res = YES;
	} else if (string && data) {
		if ([self length] == [string length]) {
			if (0 == memcmp([self cString], [string cString], [self length])) {
				res = YES;
			}
		}
	}
	
	return res;
}
		

- (void) readFrom:(char const *)filename
{
	if (!filename) {
		GErrorSet(GInconsistencyError);
		return;
	}
	
	unsigned fileLen;
	unsigned alloc = 8;
	unsigned readErr = 0;
	FILE *stream = fopen(filename, "r");
	
	if (!stream) {
		GErrorSet(GFileError);
		return;
	}
	
	fseek (stream, 0L, SEEK_END);
	fileLen = ftell (stream);
	fseek (stream, 0L, SEEK_SET);
	
	while (alloc < fileLen)
		alloc <<= 1;
	
	if (data)
		free (data);
	
	data = GAllocate (alloc);
	
	if (!data) {
		GErrorSet (GMemError);
		fclose (stream);
		return;
	}
	
	readErr = fread (data, 1, fileLen, stream);
	fclose (stream);
	
	[self setLength:fileLen];
	
	if (readErr < fileLen) {
		GErrorSet (GFileError);
		free (data), data = NULL;
		[self setLength:0];
		return;
	}	
}

- (void) writeTo:(char const *)filename
{
	if (!filename) {
		GErrorSet(GInconsistencyError);
		return;
	}
	
	if (!data) {
		return;
	}
	
	FILE *stream = fopen (filename, "w");
	unsigned err;
	
	if (!stream) {
		GErrorSet (GFileError);
		return;
	}
	
	err = fwrite (data, 1, [self length], stream);
	fclose (stream);
	
	if (err < [self length]) {
		GErrorSet (GFileError);
		return;
	}
}

- (char *)bufferAccess
{
	return data;
}

- (void)setLength:(unsigned)len
{
	length = len;
} */

- (void) dealloc
{
	if (mbs) {
		delete mbs->cpps;
	}
	free (mbs);
	[super dealloc];
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
		
		if (!cString) {
			GErrorSet (GInconsistencyError);
			[self release];
			return nil;
		}
		
		mbs->cpps->assign (cString + range.start, range.length);
	}
	
	return self;
}

- (id) initWithString:(GString *)string
{
	if (!string || ![string cString]) {
		GErrorSet (GInconsistencyError);
		[self release];
		return nil;
	}
	
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
		
		if (!format) {
			GErrorSet(GInconsistencyError);
			[self release];
			return nil;
		}
		
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
		
		vasprintf(&buffer, format, args);
		
		if (!buffer) {
			GErrorSet(GMemError);
			[self release];
			return nil;
		}
		
		mbs->cpps->assign(buffer);
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
		
		[self readFrom:sourceFilename];
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


- (void) readFrom:(char const *)filename
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
	
	buffer = new char [len];
	
	stream.read (buffer, len);
	stream.close();
	
	mbs->cpps->assign(buffer);
}

- (void) writeTo:(char const *)filename
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
