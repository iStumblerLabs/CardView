#import "OrangeCardController.h"

#import <CardView/CardView.h>
#import <WebKit/WebKit.h>

@implementation OrangeCardController

#pragma mark - initilizers

- (id) init
{
    if( self = [super initWithWindowNibName:@"Card"])
    {
        // setup 'empty card' text in the cardView
        [self.window registerForDraggedTypes:@[@"public.item"]];
        
        [self.cardView setLinkTextAttributes:@{NSForegroundColorAttributeName: [NSColor orangeColor],
                                               NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)}];
        
        NSImage* dropIcon = [NSImage imageNamed:@"drop-Template"];
        [self.cardView appendNoneString:@"\n\n"];
        [self.cardView appendImage:dropIcon];
        
        NSMutableDictionary* centered = [[CardTextView cardViewCenteredAttributesForSize:[NSFont systemFontSize]] mutableCopy];
        [centered setObject:[NSColor disabledControlTextColor] forKey:NSForegroundColorAttributeName];
        NSAS* dropString = [[NSAS alloc] initWithString:@"\n\nDrop Anything Here\n\n" attributes:centered];
        [self.cardView.textStorage appendAttributedString:dropString];
        
        [self.cardView appendHorizontalRuleWithColor:[NSColor orangeColor] width:1];
        
        NSAS* sellString = [[NSAS alloc] initWithString:@"\n\nLike Orange Card?\n\n" attributes:centered];
        [self.cardView.textStorage appendAttributedString:sellString];
        
        NSMutableDictionary* linked = [[CardTextView cardViewCenteredAttributesForSize:[NSFont systemFontSize]] mutableCopy];
        [linked setObject:[NSURL URLWithString:@"https://istumbler.net?ref=oc"] forKey:NSLinkAttributeName];
        NSAS* trystring = [[NSAS alloc] initWithString:@"Try iStumbler!" attributes:linked];
        [self.cardView.textStorage appendAttributedString:trystring];
        
        self.window.title = @"Orange Card";
    }
    
    return self;
}

- (id) initWithFilePath:(NSString*) aFilePath
{
    if( self = [self init])
    {
        NSPasteboard* filePBaord = [NSPasteboard pasteboardWithUniqueName];
        NSURL* fileURL = [NSURL fileURLWithPath:aFilePath];
        [filePBaord declareTypes:@[NSURLPboardType] owner:nil];
        [filePBaord writeObjects:@[fileURL]];
        self.pastedItem = filePBaord;
        [self updateCard];
    }
    
    return self;
}

- (id) initWithPasteboard:(NSPasteboard*) aPastedItem
{
    if( self = [self init])
    {
        self.pastedItem = aPastedItem;
        // build the card from the pasteboard
        [self updateCard];
    }
    
    return self;
}

#pragma mark -

static CGFloat const ICTabStop = 200;
static CGFloat const ICGutter = 10;

- (void) clearCard
{
    [[self.cardView textStorage] setAttributedString:[NSAS attributedString:@"\n"]]; // clear out the card view
}

- (void) updateCard
{
    [self clearCard];
    
    for( NSPasteboardItem* item in [self.pastedItem pasteboardItems])
    {
        for( NSString* itemType in [item types])
        {
            if( ![itemType hasPrefix:@"dyn."]) // ingore unmatched dynamic types
            {
                NSString* itemTypeName = (__bridge NSString *)UTTypeCopyDescription((__bridge CFStringRef)itemType);
                [self.cardView appendLabelString:(itemTypeName?itemTypeName:itemType)];
                if( itemTypeName)
                {
                    [self.cardView appendNoneString:@" : "];
                    [self.cardView appendNoneString:itemType];
                }
                [self.cardView appendHorizontalRule];
            
                NSData* itemData = [item dataForType:itemType];
                if( UTTypeConformsTo((__bridge CFStringRef) itemType, CFSTR("public.file-url")))
                {
                    NSString* filename = [[NSString alloc] initWithData:itemData encoding:NSUTF8StringEncoding];
                    NSURL* fileURL = [NSURL URLWithString:filename];
                    NSFileManager* fm = [NSFileManager defaultManager];
                    NSWorkspace* ws = [NSWorkspace sharedWorkspace];
//                  NSLog(@"filename: %@ info; %@", filename, [fm attributesOfItemAtPath:[fileURL path] error:nil]);
                    NSImage* icon = [ws iconForFile:[fileURL path]];
                    [icon setSize:NSMakeSize(128,128)];

                    // uti type
                    NSString* fileExt = [[[fileURL path] lastPathComponent] pathExtension];
                    NSString* fileType = (__bridge NSString *)UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (__bridge CFStringRef)fileExt, NULL);
                    NSString* typeName = (__bridge NSString *)UTTypeCopyDescription((__bridge CFStringRef)fileType);
                    NSMutableDictionary* centered = [[CardTextView cardViewCenteredAttributesForSize:[NSFont smallSystemFontSize]] mutableCopy];
                    NSMutableDictionary* centeredGray = [centered mutableCopy];
                    [centeredGray setObject:[NSColor disabledControlTextColor] forKey:NSForegroundColorAttributeName];
                    
                    [self.cardView appendValueString:@"\n\n"];
                    [self.cardView appendImage:icon];
                    [self.cardView appendValueString:@"\n"];
                    [self.cardView.textStorage appendAttributedString:[[NSAS alloc] initWithString:[fileURL path] attributes:centered]];
                    [self.cardView appendValueString:@"\n"];
                    if( typeName)
                    {
                        [self.cardView.textStorage appendAttributedString:[[NSAS alloc] initWithString:typeName attributes:centered]];
                        [self.cardView.textStorage appendAttributedString:[[NSAS alloc] initWithString:@" : " attributes:centeredGray]];
                    }
                    [self.cardView.textStorage appendAttributedString:[[NSAS alloc] initWithString:fileType attributes:centeredGray]];

                    BOOL isDirectory = NO;
                    if( [fm fileExistsAtPath:[fileURL path] isDirectory:&isDirectory]) // if the file is reallly there, show it's attributes
                    {
                        NSDictionary* extended = nil;
                        NSDictionary* attrs = [fm attributesOfItemAtPath:[fileURL path] error:nil];
                        [self.cardView appendLabelString:@"\n\nattributes"];
                        [self.cardView appendHorizontalRule];
                        [self.cardView appendLabelString:@"\n"];
                        for( NSString* key in [attrs allKeys])
                        {
                            if( [key isEqualToString:@"NSFileExtendedAttributes"])
                            {
                                extended = [attrs valueForKey:key];
                            }
                            else
                            {
                                [self.cardView appendTabString:[NSString stringWithFormat:@"\n\t%@\t",key] tabStop:ICTabStop gutterWidth:ICGutter];
                                [self.cardView appendValueString:[[attrs valueForKey:key] description]];
                            }
                        }
                        if( extended)
                        {
                            [self.cardView appendLabelString:@"\n\nextended"];
                            [self.cardView appendHorizontalRule];
                            [self.cardView appendLabelString:@"\n"];
                            for( NSString* key in [extended allKeys])
                            {
                                [self.cardView appendTabString:[NSString stringWithFormat:@"\n\t%@\t",key] tabStop:ICTabStop gutterWidth:ICGutter];
                                [self.cardView appendValueString:[[extended valueForKey:key] className]];
                            }
                        }
                        [self.cardView appendLabelString:@"\n"];

                        NSMetadataItem* metadata = [[NSMetadataItem alloc] initWithURL:fileURL];
                        if( metadata)
                        {
                            [self.cardView appendLabelString:@"\n\nmetadata"];
                            [self.cardView appendHorizontalRule];
                            [self.cardView appendLabelString:@"\n"];
                            for( NSString* attribute in [metadata attributes])
                            {
                                [self.cardView appendTabString:[NSString stringWithFormat:@"\n\t%@\t",attribute] tabStop:ICTabStop gutterWidth:ICGutter];
                                id attrributeValue = [metadata valueForAttribute:attribute];
                                if( [attrributeValue isKindOfClass:[NSArray class]])
                                {
                                    NSArray* attributeArray = (NSArray*)attrributeValue;
                                    BOOL first = YES;
                                    for( NSString* valueItem in attributeArray)
                                    {
                                        if( first) first = NO;
                                        else [self.cardView appendTabString:@"\t\t" tabStop:ICTabStop gutterWidth:ICGutter];
                                        [self.cardView appendValueString:[valueItem description]];
                                        if( valueItem != [attributeArray lastObject]) [self.cardView appendValueString:@"\n"];
                                    }
                                }
                                else [self.cardView appendValueString:[attrributeValue description]];
                            }
                            [self.cardView appendLabelString:@"\n"];
                        }
                        
                        if( isDirectory) // show the contents
                        {
                            NSString* filename = [[fileURL path] lastPathComponent];
                            [self.cardView appendLabelString:@"\n\n"];
                            [self.cardView appendLabelString:filename];
                            [self.cardView appendHorizontalRule];
                            NSInteger limit = 100;
                            
                            // read the contents
                            for( NSString* subpath in [fm enumeratorAtPath:[fileURL path]])
                            {
                                [self.cardView appendValueString:[@"@" stringByAppendingPathComponent:subpath]];
                                [self.cardView appendLabelString:@"\n"];
                                if( --limit == 0) break;
                            }
                        }
                    }
                    
                    // show the contents of particular types, like text or image
                    if( UTTypeConformsTo((__bridge CFStringRef) fileType, CFSTR("public.text")))
                    {
                        NSData* fileContents = [fm contentsAtPath:[fileURL path]];
                        NSString* fileString = [[NSString alloc] initWithData:fileContents encoding:NSUTF8StringEncoding];
                        [self.cardView appendLabelString:@"\n\ncontents"];
                        [self.cardView appendHorizontalRule];
                        [self.cardView appendValueString:fileString];
                        [self.cardView appendValueString:@"\n"];
                    }
                    else if( UTTypeConformsTo((__bridge CFStringRef) fileType, CFSTR("public.image")))
                    {
                        NSData* fileContents = [fm contentsAtPath:[fileURL path]];
                        NSImage* fileImage = [[NSImage alloc] initWithData:fileContents];
                        [self.cardView appendLabelString:@"\n\nimage"];
                        [self.cardView appendHorizontalRule];
                        [self.cardView appendImage:fileImage];
                        [self.cardView appendValueString:@"\n"];
                    }
                }
                else if( UTTypeConformsTo((__bridge CFStringRef)itemType, CFSTR("public.utf8-plain-text")))
                {
                    NSString* text = [[NSString alloc] initWithData:itemData encoding:NSUTF8StringEncoding];
                    [self.cardView appendValueString:text];
                    [self.cardView appendValueString:@"\n"];
                }
                else if( UTTypeConformsTo((__bridge CFStringRef)itemType, CFSTR("public.utf16-external-plain-text")))
                {
                    NSString* text = [[NSString alloc] initWithData:itemData encoding:NSUTF16StringEncoding];
                    [self.cardView appendValueString:text];
                    [self.cardView appendValueString:@"\n"];
                }
                else if( UTTypeConformsTo((__bridge CFStringRef)itemType, CFSTR("public.rtf")))
                {
                    NSAttributedString* rtf = [[NSAttributedString alloc] initWithRTF:itemData documentAttributes:nil];
                    [[self.cardView textStorage] appendAttributedString:rtf];
                    [self.cardView appendValueString:@"\n"];
                }
                else if( UTTypeConformsTo((__bridge CFStringRef)itemType, CFSTR("com.apple.flat-rtfd")))
                {
                    NSAttributedString* rtfd = [[NSAttributedString alloc] initWithRTFD:itemData documentAttributes:nil];
                    [[self.cardView textStorage] appendAttributedString:rtfd];
                    [self.cardView appendValueString:@"\n"];
                }
                else if( [itemType isEqualToString:@"com.apple.webarchive"])
                {
                    WebArchive* web = [[WebArchive alloc] initWithData:itemData];
                    NSString* html = [[NSString alloc] initWithData:[[web mainResource] data] encoding:NSUTF8StringEncoding];
                    [self.cardView appendValueString:html];
                }
                else
                {
                    [self.cardView appendValueString:[NSString stringWithFormat:@"%lu Bytes\n", (unsigned long)[itemData length]]];
                }
                
                [self.cardView appendValueString:@"\n"];
            }
        }
    }
}


#pragma mark -

- (void) populateCardFromFile:(NSString*) aFilepath
{
    NSLog(@"file: %@", aFilepath);
}

- (void) populateCardFromPasteboard:(NSPasteboardItem*) aPastedItem
{
    NSLog(@"paste: %@", aPastedItem);
}

#pragma mark - NSWindowDelegate Methods

- (void) windowDidLoad
{
}

#pragma mark - NSMenuValidation

- (BOOL) validateMenuItem:(NSMenuItem *)menuItem
{
    NSLog(@"just validating: %@", menuItem);
    return YES;
}

#pragma mark - NSDragOperations

- (NSDragOperation)draggingEntered:(id <NSDraggingInfo>)sender
{
    return NSDragOperationCopy;
}

- (NSDragOperation)draggingUpdated:(id <NSDraggingInfo>)sender
{
    return NSDragOperationCopy;
}

- (BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender
{
    return YES;
}

- (BOOL)performDragOperation:(id <NSDraggingInfo>)sender
{
    return YES;
}

- (void)concludeDragOperation:(id <NSDraggingInfo>)sender
{
    self.window.title = [NSString stringWithFormat:@"Drop: %@", [NSDate date]];
    self.pastedItem = [sender draggingPasteboard];
    [self updateCard];
}

#pragma mark - CardTextViewDelegate

- (void) card:(CardTextView*) card cut:(id) sender
{
    [self card:card copy:sender];
    [self card:card delete:sender];
}

- (void) card:(CardTextView*) card copy:(id) sender
{
    NSPasteboard* general = [NSPasteboard generalPasteboard];
    [general clearContents];
    [general writeObjects:[self.pastedItem clonedItems]];
}

- (void) card:(CardTextView*) card paste:(id) sender
{
    self.window.title = [NSString stringWithFormat:@"Paste: %@", [NSDate date]];
    self.pastedItem = [[NSPasteboard pasteboardWithName:NSGeneralPboard] clone];
    [self updateCard];
}

- (void) card:(CardTextView*) card pasteSearch:(id) sender
{
    self.window.title = [NSString stringWithFormat:@"Find: %@", [NSDate date]];
    self.pastedItem = [[NSPasteboard pasteboardWithName:NSFindPboard] clone];
    [self updateCard];
}

- (void) card:(CardTextView*) card pasteRuler:(id) sender
{
    self.window.title = [NSString stringWithFormat:@"Ruler: %@", [NSDate date]];
    self.pastedItem = [[NSPasteboard pasteboardWithName:NSRulerPboard] clone];
    [self updateCard];
}

- (void) card:(CardTextView*) card pasteFont:(id) sender
{
    self.window.title = [NSString stringWithFormat:@"Font: %@", [NSDate date]];
    self.pastedItem = [[NSPasteboard pasteboardWithName:NSFontPboard] clone];
    [self updateCard];
}

- (void) card:(CardTextView*) card delete:(id) sender
{
    [self.window close];
}

@end

/* Copyright (c) 2014, Alf Watt (alf@istumbler.net). All rights reserved.
Redistribution and use permitted under BSD-Style license in license.txt. */
