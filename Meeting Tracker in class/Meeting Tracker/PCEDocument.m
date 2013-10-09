//
//  PCEDocument.m
//  Meeting Tracker
//
//  Created by CP120 on 1/17/13.
//  Copyright (c) 2013 Hal Mueller. All rights reserved.
//

#import "PCEDocument.h"

@interface PCEDocument ()
//- (void)setMeeting:(Meeting *)aMeeting;
- (NSTimer *)timer;
- (void)setTimer:(NSTimer *)aTimer;

- (void)updateGUI:(NSTimer *)theTimer;
@end

@implementation PCEDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Add your subclass-specific initialization here.
    }
    return self;
}

- (NSTimer *)timer
{
    return _timer;
}
- (void)setTimer:(NSTimer *)aTimer
{
    if (_timer != aTimer) {
        [aTimer retain];
        [_timer invalidate];
        [_timer release];
        _timer = aTimer;
    }
}


- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"PCEDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
	[self setTimer:
	 [NSTimer scheduledTimerWithTimeInterval:0.2
									  target:self
									selector:@selector(updateGUI:)
									userInfo:nil
									 repeats:YES]];
}

- (void)updateGUI:(NSTimer *)theTimer
{
    [[self currentTimeLabel] setObjectValue:[NSDate date]];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:
(NSError **)outError
{
    // FIXME: placeholder
    return [NSData data];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to read your document from the given data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning NO.
    // You can also choose to override -readFromFileWrapper:ofType:error: or -readFromURL:ofType:error: instead.
    // If you override either of these, you should also override -isEntireFileLoaded to return NO if the contents are lazily loaded.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return YES;
}

@end
