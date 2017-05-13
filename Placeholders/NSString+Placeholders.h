//
//  NSString+Placeholders.h
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

#import <Foundation/Foundation.h>

extern NSString * const TAPlaceholderLabelKey;		// NSString *
extern NSString * const TAPlaceholderContentKey;	// NSString *
extern NSString * const TAPlaceholderRangeKey;		// NSValue *  containing the range of the occurence.


@interface NSString (Placeholders)
// Returns YES if the string contains at least one occurence of <# ... #(>)
- (BOOL)hasPlaceholders;
- (BOOL)hasPlaceholdersInRange:(NSRange)range;

// Returns a list with all found placeholders
- (NSArray <NSDictionary *> *)allPlaceholders;
- (NSArray <NSDictionary *> *)placeholdersInRange:(NSRange)range;
@end
