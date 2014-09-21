
#import "OrangeCardDelegate.h"
#import "OrangeCardController.h"
#import "PFMoveApplication.h"

@implementation OrangeCardDelegate

- (void) applicationDidFinishLaunching:(NSNotification *)notification
{
//    [[NSApplication sharedApplication] registerForDraggedTypes:@[@"public.item"]];
    PFMoveToApplicationsFolderIfNecessary();
}

- (void) awakeFromNib
{
    cards = [NSMutableArray array];
    
    // create a new empty cards
    [self newEmptyCard:nil];
}

- (void) addCard:(OrangeCardController*) card
{
    [cards addObject:card];
}

- (void) removeCard:(OrangeCardController*) card
{
    [cards removeObject:card];
}

- (NSArray*) cards
{
    return [NSArray arrayWithArray:cards]; // autoreleased immutable copy
}

#pragma mark - IBActions

- (IBAction) newEmptyCard:(id)sender
{
    OrangeCardController* card = [OrangeCardController new];
    [self addCard:card];
    [card showWindow:sender];
}

- (IBAction) pasteboardCard:(id)sender
{
    OrangeCardController* card = [[OrangeCardController alloc] initWithPasteboard:[NSPasteboard generalPasteboard]];
    [self addCard:card];
    [card showWindow:sender];
}

- (IBAction) openFileCard:(id)sender
{
    // TODO start a file open dialog to get a path name for the card
    NSString* filePath = nil;
    OrangeCardController* card = [[OrangeCardController alloc] initWithFilePath:filePath];
    [self addCard:card];
    [card showWindow:sender];
}

#pragma mark - NSApplicationDelegate Methods

- (BOOL) application:(NSApplication *)sender openFile:(NSString*) filename
{
    OrangeCardController* card = [[OrangeCardController alloc] initWithFilePath:filename];
    [self addCard:card];
    [card showWindow:sender];
    return YES;
}

- (void) application:(NSApplication*)sender openFiles:(NSArray*) filenames
{
    for( NSString* path in filenames)
    {
        [self application:sender openFile:path];
    }
}

- (BOOL)applicationOpenUntitledFile:(NSApplication *)theApplication
{
    NSPasteboard* draggedItem = [NSPasteboard pasteboardWithName:NSDragPboard];
    OrangeCardController* card = [[OrangeCardController alloc] initWithPasteboard:draggedItem];
    [self addCard:card];
    return YES;
}

@end

/* Copyright (c) 2014, Alf Watt (alf@istumbler.net). All rights reserved.
 Redistribution and use permitted under BSD-Style license in license.txt. */
