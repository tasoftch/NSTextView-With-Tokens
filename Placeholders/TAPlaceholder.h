//
//  TAPlaceholder.h
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

#import <Cocoa/Cocoa.h>


@interface TAPlaceholder : NSTextAttachment
@property (nonatomic, readonly) NSString *label;
@property (nonatomic, readonly) id content;

@property (nonatomic, assign, getter=isSelected) BOOL selected;



- (id)initWithLabel:(NSString *)label content:(id)content;

// It is also possible to map sequences to label and content using: <#label::content#(>).
- (id)initWithInlinePlaceholder:(NSString *)inlinePlaceholder;

- (void)setFont:(NSFont *)font;
- (NSFont *)font;

- (NSString *)inlinePlaceholderString;
@end



@interface TAPlaceholder (TAPlaceholderConfiguration)

// The default text color to display the placeholder.
+ (void)setLabelTextColor:(NSColor *)color;
+ (NSColor *)labelTextColor;

// The alternative text color if a placeholder is selected.
+ (void)setSelectedLabelTextColor:(NSColor *)color;
+ (NSColor *)selectedLabelTextColor;

// The default background color of a placeholder
+ (void)setBackgroundColor:(NSColor *)color;
+ (NSColor *)backgroundColor;

// The alternative background color if a placeholder is selected
+ (void)setSelectedBackgroundColor:(NSColor *)color;
+ (NSColor *)selectedBackgroundColor;

// The alternative background color of a placeholder is selected but not in key window.
+ (void)setSecondaryBackgroundColor:(NSColor *)color;
+ (NSColor *)secondaryBackgroundColor;
@end


