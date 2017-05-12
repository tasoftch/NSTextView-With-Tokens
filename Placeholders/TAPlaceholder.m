//
//  TAPlaceholder.m
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








