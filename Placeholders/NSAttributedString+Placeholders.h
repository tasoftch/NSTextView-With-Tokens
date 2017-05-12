//
//  NSAttributedString+Placeholders.h
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

#import <Foundation/Foundation.h>
#import <Placeholders/TAPlaceholder.h>

// Placeholders are positions in your script where the developer can click on it and replace it through some text.
// Placeholders use a \uFFFC character representation in the editors string. They are only one character.
// The plain text of a placeholder is <#placeholder#(>) without parentheses (because Xcode has the same notation for placeholders.)

// Technically, the placeholders are instances of the NSTextAttachment class.

@interface NSAttributedString (TAPlaceholders)
// It is the standard initializer but it will convert every character sequence <#label#(>) without parentheses to placeholders
// It is also possible to map sequences to label and content using: <#label::content#(>).
- (id)initFromStringContainingPlaceholders:(NSString *)str attributes:(NSDictionary<NSString *,id> *)attrs;

// Opposite method to convert the placeholders into the plain representations.
- (NSString *)stringByExpandingPlaceholders;
- (NSString *)substringByExpandingPlaceholdersWithRange:(NSRange)range;

- (NSArray <TAPlaceholder *> *)allPlaceholders;
- (NSArray <TAPlaceholder *> *)placeholdersInRange:(NSRange)range;

- (void)selectPlaceholdersInRange:(NSRange)range;
- (void)deselectPlaceholdersInRange:(NSRange)range;

- (TAPlaceholder *)nextPlaceholderAtCharacterIndex:(NSUInteger)index inRange:(NSRange)range;
- (TAPlaceholder *)previousPlaceholderAtCharacterIndex:(NSInteger)index inRange:(NSRange)range;
- (TAPlaceholder *)placeholderAtCharacterIndex:(NSUInteger)index;

- (NSRange)rangeOfPlaceholder:(TAPlaceholder *)placeholder inRange:(NSRange)range;

- (BOOL)hasPlaceholdersInRange:(NSRange)range;
@end


@interface NSMutableAttributedString (TAPlaceholders)
- (void)replaceCharactersInRange:(NSRange)range withPlaceholder:(TAPlaceholder *)placeholder;
@end



