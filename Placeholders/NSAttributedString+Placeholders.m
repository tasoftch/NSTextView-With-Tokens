//
//  NSAttributedString+Placeholders.m
//  Placeholders
//
//  Created by Thomas Abplanalp on 12.05.17.
//	Copyright (c) 2017, TASoft Applications
//	All rights reserved.
//
//	Redistribution and use in source and binary forms, with or without
//	modification, are permitted provided that the following conditions are met:
//
//	* Redistributions of source code must retain the above copyright notice, this
//	list of conditions and the following disclaimer.
//
//	* Redistributions in binary form must reproduce the above copyright notice,
//	this list of conditions and the following disclaimer in the documentation
//	and/or other materials provided with the distribution.
//
//	* Neither the name of the copyright holder nor the names of its
//	contributors may be used to endorse or promote products derived from
//	this software without specific prior written permission.
//
//	THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//	AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//	IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//	DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//	FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//	DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//			 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//	CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//	OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//	OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//
//	Suggested Attribution Format
//	----------------------------
//
//	The license requires that you give credit to Thomas Abplanalp, as the original
//	author of any of our source that you use. The placement and format of the credit
//	is up to you, but we prefer the credit to be in the software’s “About” window.
//	Alternatively, you could put the credit in a list of acknowledgements within the
//	software, in the software’s documentation, or on the web page for the software.
//	The suggested format for the attribution is:
//
//	Includes <Name of Code> by Thomas Abplanalp.
//
//	where <Name of Code> would be replaced by the name of the specific source-code
//	package you made use of. When possible, please link the text “Thomas Abplanalp”
//	to the following URL: https://www.tasoft.ch

#import "NSAttributedString+Placeholders.h"
#import "NSString+Placeholders.h"

@implementation NSAttributedString (TAPlaceholders)
+ (id)attributedStringWithString:(NSString *)string attributes:(NSDictionary<NSString *,id> *)attrs {
	NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string attributes:attrs];
	
	if([string hasPlaceholders]) {
		NSArray <NSDictionary *>* placeholders = [string allPlaceholders];
		NSFont *f = [attrs objectForKey:NSFontAttributeName];
		
		for(NSDictionary *placeholder in placeholders.reverseObjectEnumerator.allObjects) {
			NSString *label = placeholder[TAPlaceholderLabelKey];
			NSString *content = placeholder[TAPlaceholderContentKey];
			NSRange range = [placeholder[TAPlaceholderRangeKey] rangeValue];
			
			if(label) {
				TAPlaceholder *mark = [[TAPlaceholder alloc] initWithLabel:label content:content?content:label];
				if(f)
					[mark setFont:f];
				[str replaceCharactersInRange:range withPlaceholder:mark];
			}
		}
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







