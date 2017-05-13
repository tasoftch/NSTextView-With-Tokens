//
//  NSString+Placeholders.m
//  Placeholders
//
//  Created by Thomas Abplanalp on 13.05.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
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
//	Includes Placeholders by Thomas Abplanalp.
//
//	where <Name of Code> would be replaced by the name of the specific source-code
//	package you made use of. When possible, please link the text “Thomas Abplanalp”
//	to the following URL: https://www.tasoft.ch

#import "NSString+Placeholders.h"

NSString * const TAPlaceholderLabelKey = @"TAPlaceholderLabelKey";
NSString * const TAPlaceholderContentKey = @"TAPlaceholderContentKey";
NSString * const TAPlaceholderRangeKey = @"TAPlaceholderRangeKey";


@implementation NSString (Placeholders)
- (BOOL)hasPlaceholders {
	return [self hasPlaceholdersInRange:NSMakeRange(0, self.length)];
}
- (BOOL)hasPlaceholdersInRange:(NSRange)range {
	return [self rangeOfString:@"<#" options:0 range:range].location < NSNotFound ? YES : NO;
}


- (NSArray <NSDictionary *> *)allPlaceholders {
	return [self placeholdersInRange:NSMakeRange(0, self.length)];
}
- (NSArray <NSDictionary *> *)placeholdersInRange:(NSRange)range {
	if([self hasPlaceholdersInRange:range]) {
		NSMutableArray <NSDictionary *>* list = [NSMutableArray array];
		
		NSRegularExpression *regEx = [NSRegularExpression regularExpressionWithPattern:@"<#(.*?)((?:::)(.*?))?#>" options:0 error:NULL];
		NSArray <NSTextCheckingResult *>* result = [regEx matchesInString:self options:0 range:range];
		
		for(NSTextCheckingResult *res in result) {
			NSMutableDictionary *dict = [NSMutableDictionary dictionary];
			dict[TAPlaceholderRangeKey] = [NSValue valueWithRange:res.range];
			
			NSRange labelRange = [res rangeAtIndex:1];
			if(labelRange.location < NSNotFound) {
				NSString *label = [self substringWithRange:labelRange];
				if(label.length)
					dict[TAPlaceholderLabelKey] = label;
			}
			
			NSRange contentRange = [res rangeAtIndex:3];
			if(contentRange.location < NSNotFound) {
				NSString *content = [self substringWithRange:contentRange];
				if(content.length)
					dict[TAPlaceholderContentKey] = content;
			}
			[list addObject:dict];
		}
		
		return list;
	}
	return nil;
}
@end
