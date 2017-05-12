//
//  AppDelegate.m
//  Test
//
//  Created by Thomas Abplanalp on 12.05.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import "AppDelegate.h"
#import "TokenTextView.h"
#import <Placeholders/Placeholders.h>

@interface AppDelegate ()
@property (weak) IBOutlet TokenTextView *editor;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
	NSString *file = [[NSBundle mainBundle] pathForResource:@"TestScript" ofType:@"txt"];
	NSString *script = [NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:NULL];
	
	NSAttributedString *str = [[NSAttributedString alloc] initFromStringContainingPlaceholders:script attributes:@{NSFontAttributeName:[NSFont fontWithName:@"Menlo" size:16.0]}];
	
	[self.editor.textStorage setAttributedString:str];
	[self.editor.textStorage setFont:[NSFont fontWithName:@"Menlo" size:16.0]];
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}
- (IBAction)printStorage:(id)sender {
	NSLog(@"%@", [self.editor.textStorage previousPlaceholderAtCharacterIndex:self.editor.selectedRange.location inRange:[self.editor.string lineRangeForRange:self.editor.selectedRange]]);
}

- (IBAction)insert:(id)sender {
	TAPlaceholder *plh = [[TAPlaceholder alloc] initWithLabel:self.label content:self.content];
	[plh setFont:[NSFont fontWithName:@"Menlo" size:16.0]];
	
	[self.editor.textStorage replaceCharactersInRange:self.editor.selectedRange withPlaceholder:plh];
}

@end
