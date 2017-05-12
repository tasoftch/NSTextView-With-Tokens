//
//  MyTextView.h
//  Placeholders
//
//  Created by Thomas Abplanalp on 12.05.17.
//  Copyright © 2017 TASoft Applications. All rights reserved.
//

#import <Cocoa/Cocoa.h>



@interface TokenTextView : NSTextView


- (IBAction)selectNextPlaceholder:(id)sender;
- (IBAction)selectPreviousPlaceholder:(id)sender;

- (IBAction)selectNextPlaceholderInLine:(id)sender;
- (IBAction)selectPreviousPlaceholderInLine:(id)sender;

- (IBAction)selectFirstPlaceholderInLine:(id)sender;
- (IBAction)selectLastPlaceholderInLine:(id)sender;
@end
