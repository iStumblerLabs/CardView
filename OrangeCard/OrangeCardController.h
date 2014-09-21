#import <Cocoa/Cocoa.h>
#import <CardView/CardView.h>

@interface OrangeCardController : NSWindowController // <NSPasteboardReading,NSPasteboardWriting>
@property(nonatomic,strong) IBOutlet CardTextView* cardView;
@property(nonatomic,strong) NSPasteboard* pastedItem;

#pragma mark -

- (id) initWithFilePath:(NSString*) aFilePath;
- (id) initWithPasteboard:(NSPasteboard*) aPastedItem;

@end

/* Copyright (c) 2014, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license in license.txt. */
