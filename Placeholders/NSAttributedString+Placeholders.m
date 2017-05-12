//
//  NSAttributedString+Placeholders.m
//  Placeholders
//
//  Created by Thomas Abplanalp on 12.05.17.
//	  Copyright © 2017 TASoft Applications. All rights reserved.
//
//	Permission is hereby granted, free of charge, to any person obtaining a copy
//	of this software and associated documentation files (the "Software"), to deal
//	in the Software without restriction, including without limitation the rights
//	to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//	copies of the Software, and to permit persons to whom the Software is
//	furnished to do so, subject to the following conditions:
//
//	The above copyright notice and this permission notice shall be included in all
//	copies or substantial portions of the Software.
//
//	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//	IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//	FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//	AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//	LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//	OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//	SOFTWARE.

#import "NSAttributedString+Placeholders.h"

@implementation NSAttributedString (TAPlaceholders)
- (id)initFromStringContainingPlaceholders:(NSString *)string attributes:(NSDictionary<NSString *,id> *)attrs {
	NSMutableAttributedString *str = [[NSMutableAttributedString alloc] init];
	
	NSArray *parts = [string componentsSeparatedByString:@"<#"];
	[str appendAttributedString:[[NSAttributedString alloc] initWithString:[parts firstObject] attributes:attrs]];
	
	NSFont *f = [attrs objectForKey:NSFontAttributeName];
	
	for(NSUInteger e=1;e<parts.count;e++) {
		NSString *part = parts[e];
		NSRange range = [part rangeOfString:@"#>"];
		
		if(range.location < NSNotFound) {
			NSString *text = [part substringToIndex:range.location];
			if(text.length) {
				TAPlaceholder *mark = [[TAPlaceholder alloc] initWithInlinePlaceholder:text];
				if(f)
					[mark setFont:f];
				[str appendAttributedString:[NSAttributedString attributedStringWithAttachment:mark]];
			}
			[str appendAttributedString:[[NSAttributedString alloc] initWithString:[part substringFromIndex:NSMaxRange(range)] attributes:attrs]];
		}
		else
			[str appendAttributedString:[[NSAttributedString alloc] initWithString:part attributes:attrs]];
	}
	
	return str;
}

- (NSString *)substringByExpandingPlaceholdersWithRange:(NSRange)range {
	NSMutableString *string = [NSMutableString string];
	NSString *temp = self.string;
	
	[self enumerateAttribute:NSAttachmentAttributeName inRange:range options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
		if([value isKindOfClass:[TAPlaceholder class]]) {
			TAPlaceholder *plh = value;
			[string appendString:[plh inlinePlaceholderString]];
		}
		else {
			[string appendString:[temp substringWithRange:range]];
		}
	}];
	
	return string;
}

- (NSString *)stringByExpandingPlaceholders {
	return [self substringByExpandingPlaceholdersWithRange:NSMakeRange(0, self.length)];
}

- (NSArray<TAPlaceholder *> *)allPlaceholders {
	return [self placeholdersInRange:NSMakeRange(0, self.length)];
}

- (NSArray<TAPlaceholder *> *)placeholdersInRange:(NSRange)search {
	NSMutableArray <TAPlaceholder*> *array = [NSMutableArray array];
	[self enumerateAttribute:NSAttachmentAttributeName inRange:search options:0 usingBlock:^(id  _Nullable value, NSRange range, BOOL * _Nonnull stop) {
		if(NSLocationInRange(range.location, search) && [value isKindOfClass:[TAPlaceholder class]]) {
			[array addObject:value];
		}
	}];
	return array;
}

- (void)selectPlaceholdersInRange:(NSRange)search {
	[self enumerateAttribute:NSAttachmentAttributeName inRange:search options:0 usingBlock:^(TAPlaceholder * _Nullable value, NSRange range, BOOL * _Nonnull stop) {
		if(NSLocationInRange(range.location, search) && [value isKindOfClass:[TAPlaceholder class]]) {
			value.selected = YES;
		}
	}];
}

-(void)deselectPlaceholdersInRange:(NSRange)search {
	[self enumerateAttribute:NSAttachmentAttributeName inRange:search options:0 usingBlock:^(TAPlaceholder * _Nullable value, NSRange range, BOOL * _Nonnull stop) {
		if(NSLocationInRange(range.location, search) && [value isKindOfClass:[TAPlaceholder class]]) {
			value.selected = NO;
		}
	}];
}

- (TAPlaceholder *)nextPlaceholderAtCharacterIndex:(NSUInteger)index inRange:(NSRange)search {
	__block TAPlaceholder *placeholder = nil;
	[self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(index, MIN(NSMaxRange(search), self.length)-index) options:0 usingBlock:^(TAPlaceholder * _Nullable value, NSRange range, BOOL * _Nonnull stop) {
		if(NSLocationInRange(range.location, search) && [value isKindOfClass:[TAPlaceholder class]]) {
			placeholder = value;
			*stop = YES;
		}
	}];
	return placeholder;
}


- (TAPlaceholder *)previousPlaceholderAtCharacterIndex:(NSInteger)index inRange:(NSRange)search {
	__block TAPlaceholder *placeholder = nil;
	[self enumerateAttribute:NSAttachmentAttributeName inRange:NSMakeRange(search.location, MIN(index, NSMaxRange(search))-search.location) options:NSAttributedStringEnumerationReverse usingBlock:^(TAPlaceholder * _Nullable value, NSRange range, BOOL * _Nonnull stop) {
		if(NSLocationInRange(range.location, search) && [value isKindOfClass:[TAPlaceholder class]]) {
			placeholder = value;
			*stop = YES;
		}
	}];
	return placeholder;
}

- (NSRange)rangeOfPlaceholder:(TAPlaceholder *)placeholder inRange:(NSRange)range {
	__block NSRange search = {NSNotFound, 0};
	[self enumerateAttribute:NSAttachmentAttributeName inRange:range options:0 usingBlock:^(TAPlaceholder * _Nullable value, NSRange rng, BOOL * _Nonnull stop) {
		if(value == placeholder) {
			search = rng;
			*stop = YES;
		}
	}];
	return search;
}

- (BOOL)hasPlaceholdersInRange:(NSRange)range {
	__block BOOL search = NO;
	[self enumerateAttribute:NSAttachmentAttributeName inRange:range options:0 usingBlock:^(TAPlaceholder * _Nullable value, NSRange rng, BOOL * _Nonnull stop) {
		if([value isKindOfClass:[TAPlaceholder class]]) {
			search = YES;
			*stop = YES;
		}
	}];
	return search;
}

- (TAPlaceholder *)placeholderAtCharacterIndex:(NSUInteger)index {
	id obj = [self attribute:NSAttachmentAttributeName atIndex:index effectiveRange:NULL];
	if([obj isKindOfClass:[TAPlaceholder class]])
		return obj;
	return nil;
}
@end



@implementation NSMutableAttributedString (TAPlaceholders)
- (void)replaceCharactersInRange:(NSRange)range withPlaceholder:(TAPlaceholder *)placeholder {
	NSAttributedString *str = [NSAttributedString attributedStringWithAttachment:placeholder];
	[self replaceCharactersInRange:range withAttributedString:str];
}
@end







