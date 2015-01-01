
#import <Cocoa/Cocoa.h>

@class OrangeCardController;

@interface OrangeCardDelegate : NSObject <NSApplicationDelegate>
{
    NSMutableArray* cards;
}

- (void) addCard:(OrangeCardController*) card;
- (NSArray*) cards;

#pragma mark - IBActions

- (IBAction) newEmptyCard:(id)sender;
- (IBAction) pasteboardCard:(id)sender;
- (IBAction) openFileCard:(id)sender;

@end

/* Copyright (c) 2014-2015, Alf Watt (alf@istumbler.net). All rights reserved.
 Redistribution and use permitted under BSD-Style license in license.txt. */
