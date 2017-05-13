//
//  MyTextView.m
//  Placeholders
//
//  Created by Thomas Abplanalp on 12.05.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "TokenTextView.h"
#import <Placeholders/Placeholders.h>

@implementation TokenTextView
- (void)insertText:(id)string replacementRange:(NSRange)replacementRange {
	[super insertText:string replacementRange:replacementRange];
	[self setFont:[NSFont fontWithName:@"Menlo" size:16.0]];
}


#pragma mark == SELECT AND DESELECT PLACEHOLDERS WITH STRING ==
- (void)setSelectedRanges:(NSArray<NSValue *> *)ranges affinity:(NSSelectionAffinity)affinity stillSelecting:(BOOL)stillSelectingFlag {
	[self.textStorage deselectPlaceholdersInRange:NSMakeRange(0, self.textStorage.length)];
	
	for(NSValue *range in ranges) {
		NSRange rng = [range rangeValue];
		[self.textStorage selectPlaceholdersInRange:rng];
	}
	
	[super setSelectedRanges:ranges affinity:affinity stillSelecting:stillSelectingFlag];
}

- (void)mouseDown:(NSEvent *)event {
	[super mouseDown:event];
	
	NSPoint pt = [self convertPoint:event.locationInWindow fromView:nil];
	NSInteger index = [self.layoutManager characterIndexForPoint:pt inTextContainer:self.textContainer fractionOfDistanceBetweenInsertionPoints:NULL];
	TAPlaceholder *placeholder = [self.textStorage placeholderAtCharacterIndex:index];
	
	
	if([placeholder isKindOfClass:[TAPlaceholder class]]) {
		self.selectedRange = NSMakeRange(index, 1);
		if(event.clickCount == 2) {
			dispatch_async(dispatch_get_main_queue(), ^{
				[self insertNewline:nil];
			});
		}
	}
}

- (void)deleteWordBackward:(id)sender {
	NSString *string = nil;
	if(self.selectedRange.location > 0) {
		TAPlaceholder *placeholder = [self.textStorage placeholderAtCharacterIndex:self.selectedRange.location-1];
		if(placeholder) {
			string = [placeholder inlinePlaceholderString];
			string = [string substringToIndex:string.length-1];
		}
	}
	if(string)
		[self insertText:string replacementRange:NSMakeRange(self.selectedRange.location-1, 1)];
	else
		[super deleteWordBackward:sender];
}

#pragma mark == INTERN PLACEHOLDER ACTIONS ==

- (void)insertNewline:(id)sender {
	if(self.selectedRange.length == 1) {
		TAPlaceholder *placeholder = [self.textStorage placeholderAtCharacterIndex:self.selectedRange.location];
		if(placeholder) {
			id content = placeholder.content ? placeholder.content : placeholder.label;
			NSUInteger position = self.selectedRange.location;
			[self insertText:content replacementRange:self.selectedRange];
			
			// For some reasons, the NSTextView does not display the insert point and/or selection well.
			// I solved it by reselecting the range.
			dispatch_async(dispatch_get_main_queue(), ^{
				[self setSelectedRange:NSMakeRange(position, [content length])];
			});
		}
	}
}

- (void)insertTab:(id)sender {
	NSRange line = [self.string lineRangeForRange:self.selectedRange];
	if([self.textStorage hasPlaceholdersInRange:line]) {
		[self selectNextPlaceholderInLine:sender];
	} else {
		[super insertTab:sender];
	}
}

- (void)insertBacktab:(id)sender {
	NSRange line = [self.string lineRangeForRange:self.selectedRange];
	if([self.textStorage hasPlaceholdersInRange:line]) {
		[self selectPreviousPlaceholderInLine:sender];
	} else {
		[super insertBacktab:sender];
	}
}

#pragma mark == PLACEHOLDER ACTIONS ==

- (void)selectPlaceholder:(TAPlaceholder *)placeholder {
	NSRange range = [self.textStorage rangeOfPlaceholder:placeholder inRange:NSMakeRange(0, self.string.length)];
	if(range.location < NSNotFound)
		[self setSelectedRange:range];
	else
		NSBeep();
}

- (IBAction)selectNextPlaceholder:(id)sender {
	TAPlaceholder *placeholder = [self.textStorage nextPlaceholderAtCharacterIndex:NSMaxRange(self.selectedRange) inRange:NSMakeRange(0, self.string.length)];
	if(placeholder)
		[self selectPlaceholder:placeholder];
}

- (IBAction)selectPreviousPlaceholder:(id)sender {
	TAPlaceholder *placeholder = [self.textStorage previousPlaceholderAtCharacterIndex:self.selectedRange.location inRange:NSMakeRange(0, self.string.length)];
	if(placeholder)
		[self selectPlaceholder:placeholder];
}

- (IBAction)selectNextPlaceholderInLine:(id)sender {
	NSRange line = [self.string lineRangeForRange:self.selectedRange];
	TAPlaceholder *placeholder = [self.textStorage nextPlaceholderAtCharacterIndex:NSMaxRange(self.selectedRange) inRange:line];
	if(placeholder == nil)
		[self selectFirstPlaceholderInLine:sender];
	else {
		[self selectPlaceholder:placeholder];
	}
}

- (IBAction)selectPreviousPlaceholderInLine:(id)sender {
	NSRange line = [self.string lineRangeForRange:self.selectedRange];
	TAPlaceholder *placeholder = [self.textStorage previousPlaceholderAtCharacterIndex:self.selectedRange.location inRange:line];
	if(placeholder == nil)
		[self selectLastPlaceholderInLine:sender];
	else {
		[self selectPlaceholder:placeholder];
	}
}

- (IBAction)selectFirstPlaceholderInLine:(id)sender {
	NSRange line = [self.string lineRangeForRange:self.selectedRange];
	TAPlaceholder *placeholder = [self.textStorage nextPlaceholderAtCharacterIndex:line.location inRange:line];
	if(placeholder)
		[self selectPlaceholder:placeholder];
}

- (IBAction)selectLastPlaceholderInLine:(id)sender {
	NSRange line = [self.string lineRangeForRange:self.selectedRange];
	TAPlaceholder *placeholder = [self.textStorage previousPlaceholderAtCharacterIndex:NSMaxRange(line) inRange:line];
	if(placeholder)
		[self selectPlaceholder:placeholder];
}
@end
