//
//  TAPlaceholder.m
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

#import "TAPlaceholder.h"


@interface _TAPlaceholderCell : NSTextAttachmentCell
- (void)setFont:(NSFont *)font;
- (NSFont *)font;
@end

@implementation TAPlaceholder
- (id)initWithInlinePlaceholder:(NSString *)inlinePlaceholder {
	NSString *content = inlinePlaceholder;
	NSString *text = inlinePlaceholder;
	
	if([inlinePlaceholder rangeOfString:@"::"].location < NSNotFound) {
		NSArray *p = [inlinePlaceholder componentsSeparatedByString:@"::"];
		content = p[1];
		text = p[0];
	}
	return [self initWithLabel:text content:content];
}

- (id)initWithLabel:(NSString *)label content:(id)content {
	self = [self init];
	if(self) {
		_label = [label stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
		_content = content;
		self.attachmentCell = [[_TAPlaceholderCell alloc] initTextCell:_label];
	}
	return self;
}

- (void)setFont:(NSFont *)font {
	[(_TAPlaceholderCell *)self.attachmentCell setFont:font];
}
- (NSFont *)font {
	return [(_TAPlaceholderCell *)self.attachmentCell font];
}

- (NSString *)description {
	return [NSString stringWithFormat:@"%@ %@ (%@)", [super description], self.label, self.content];
}

- (NSString *)inlinePlaceholderString {
	if(self.content == nil || [self.label isEqualToString:self.content]) {
		return [NSString stringWithFormat:@"<#%@#>", self.label];
	} else {
		return [NSString stringWithFormat:@"<#%@::%@#>", self.label, self.content];
	}
}
@end


static NSColor *labelTextColor;
static NSColor *selectedLabelTextColor;
static NSColor *backgroundColor;
static NSColor *selectedBackgroundColor;
static NSColor *secondaryBackgroundColor;

@implementation TAPlaceholder (TAPlaceholderConfiguration)
+ (void)setLabelTextColor:(NSColor *)color { labelTextColor=color; }
+ (NSColor *)labelTextColor {return labelTextColor;}
+ (void)setSelectedLabelTextColor:(NSColor *)color {selectedLabelTextColor=color;}
+ (NSColor *)selectedLabelTextColor{return selectedLabelTextColor;}
+ (void)setBackgroundColor:(NSColor *)color {backgroundColor=color;}
+ (NSColor *)backgroundColor{return backgroundColor;}
+ (void)setSelectedBackgroundColor:(NSColor *)color {selectedBackgroundColor=color;}
+ (NSColor *)selectedBackgroundColor{return selectedBackgroundColor;}
+ (void)setSecondaryBackgroundColor:(NSColor *)color {secondaryBackgroundColor=color;}
+ (NSColor *)secondaryBackgroundColor{return secondaryBackgroundColor;}
@end





@implementation _TAPlaceholderCell {
	__strong NSFont *_myFont;
}



+ (void)initialize {
	labelTextColor = [NSColor blackColor];
	selectedLabelTextColor = [NSColor whiteColor];
	
	backgroundColor = [NSColor colorWithRed:0.7412277817726135 green:0.7901633739471436 blue:0.8787038326263428 alpha:1.0];
	selectedBackgroundColor = [NSColor colorWithRed:0.5412277817726135 green:0.5901633739471436 blue:0.8787038326263428 alpha:1.0];
	secondaryBackgroundColor = [NSColor secondarySelectedControlColor];
}

- (id)copyWithZone:(NSZone *)zone {
	_TAPlaceholderCell *cell = [super copyWithZone:zone];
	cell->_myFont = _myFont;
	return cell;
}

- (void)setFont:(NSFont *)font {
	_myFont = font;
}

- (NSFont *)font {
	if(!_myFont) {
		if([self.controlView respondsToSelector:@selector(font)])
			_myFont = [(id)self.controlView font];
	}
	return _myFont ? _myFont : [super font];
}

- (NSDictionary *)defaultTextAttributes {
	return @{NSFontAttributeName:self.font, NSForegroundColorAttributeName:labelTextColor};
}
- (NSDictionary *)alternativeTextAttributes {
	return @{NSFontAttributeName:self.font, NSForegroundColorAttributeName:selectedLabelTextColor};
}

- (NSRect)cellFrameForTextContainer:(NSTextContainer *)textContainer proposedLineFragment:(NSRect)lineFrag glyphPosition:(NSPoint)position characterIndex:(NSUInteger)charIndex {
	NSRect rect;
	rect.origin = NSZeroPoint;
	
	NSFont *f = self.font;
	rect.size = [self.stringValue sizeWithAttributes:[self defaultTextAttributes]];
	rect.size.width += rect.size.height;
	rect.size.height = MIN(rect.size.height, lineFrag.size.height);
	
	rect.origin.y = round( f.descender );
	return rect;
}


- (void)drawWithFrame:(NSRect)cellFrame inView:(NSView *)controlView {
	TAPlaceholder *marker = (TAPlaceholder *)[self attachment];
	CGFloat c = cellFrame.size.height * .25;
	
	NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:cellFrame xRadius:c yRadius:c];
	[NSGraphicsContext saveGraphicsState];
	[path addClip];
	
	NSColor *g = nil;
	
	NSDictionary *attrs = [self defaultTextAttributes];
	
	if(marker.selected) {
		if(controlView.window.keyWindow)
			g = selectedBackgroundColor;
		else
			g = secondaryBackgroundColor;
		
		attrs = [self alternativeTextAttributes];
	} else {
		if(controlView.window.keyWindow)
			g = backgroundColor;
		else
			g = secondaryBackgroundColor;
	}
	
	[g set];
	NSRectFill(cellFrame);
	
	NSFont *f = self.font;
	
	
	[NSGraphicsContext restoreGraphicsState];
	cellFrame.origin.x += cellFrame.size.height / 2.0;
	[self.stringValue drawAtPoint:NSMakePoint(cellFrame.origin.x, cellFrame.origin.y + f.descender) withAttributes:attrs];
}
@end








