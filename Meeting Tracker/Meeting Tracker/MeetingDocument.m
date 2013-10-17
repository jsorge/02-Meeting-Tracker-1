//
//  JMSDocument.m
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/8/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import "MeetingDocument.h"

@interface MeetingDocument ()

@property (assign) IBOutlet NSButton *endMeetingButton;
@property (assign) IBOutlet NSButton *startMeetingButton;
@property (assign) IBOutlet NSTextField *elapsedTimeLabel;
@property (assign) IBOutlet NSTextField *accruedCostLabel;
@property (assign) IBOutlet NSTextField *totalBillingRate_liveComputeField;

@end

@implementation MeetingDocument

#pragma mark - Accessors
- (id)init
{
    self = [super init];
    if (self) {
        NSUInteger random = arc4random_uniform(3);
        switch (random) {
            case 0:
                [self setMeeting:[Meeting meetingWithCaptains]];
                break;
            case 1:
                [self setMeeting:[Meeting meetingWithMarxBrothers]];
                break;
            case 2:
                [self setMeeting:[Meeting meetingWithStooges]];
                break;
            default:
                NSLog(@"No meeting was started because the random number was %lu", (unsigned long)random);
        }
    }
    return self;
}

- (Meeting *)meeting;
{
    return _meeting;
}

- (void)setMeeting:(Meeting *)aMeeting;
{
    if (_meeting != aMeeting) {
        [aMeeting retain];
        [_meeting release];
        _meeting = aMeeting;
    }
}

- (NSTimer *)timer;
{
    return _timer;
}

- (void)setTimer:(NSTimer *)aTimer;
{
    if (_timer != aTimer) {
        [aTimer retain];
        [_timer invalidate];
        [_timer release];
        _timer = aTimer;
    }
}

#pragma mark - IBActions
- (IBAction)logMeeting:(id)sender;
{
    NSLog(@"%@", [[self meeting] description]);
}

- (IBAction)logParticipants:(id)sender;
{
    NSArray *meetingParticipants = [[self meeting] personsPresent];
    for (Person *attendee in meetingParticipants) {
        NSLog(@"%@", [attendee description]);
    }
}

- (IBAction)startMeetingButton:(id)sender
{
    [self.meeting setStartingTime:[NSDate date]];
    [self.endMeetingButton setEnabled:YES];
    [self.startMeetingButton setEnabled:NO];
}

- (IBAction)endMeetingButton:(id)sender
{
    [self.meeting setEndingTime:[NSDate date]];
    [self.endMeetingButton setEnabled:NO];
    [self.startMeetingButton setEnabled:YES];
}

#pragma mark - Other Public Methods
- (void)updateGUI:(NSTimer *)theTimer;
{
    [self.currentTimeLabel setObjectValue:[NSDate date]];
    [self.totalBillingRate_liveComputeField setObjectValue:[self computeTotalBillingRate]];
    if (self.meeting) {
        self.elapsedTimeLabel.stringValue = [self.meeting elapsedTimeDisplayString];
        self.accruedCostLabel.objectValue  = [self.meeting accruedCost];
    }
}

#pragma mark - Private Helper Methods
- (NSNumber *)computeTotalBillingRate
{
    NSArray *meetingParticipants = self.meeting.personsPresent;
    __block double billingRate = 0;
    [meetingParticipants enumerateObjectsUsingBlock:^(Person *person, NSUInteger idx, BOOL *stop) {
        billingRate += [person.hourlyRate doubleValue];
    }];
    return @(billingRate);
}

#pragma mark - NSWindowDelegate
- (void)windowWillClose:(NSNotification *)notification;
{
    [self setTimer:nil];
}

#pragma mark - Memory Management
- (void)dealloc
{
    [_timer release];
    _timer = nil;
    
    [_meeting release];
    _meeting = nil;
    
    [super dealloc];
}

#pragma mark - Templated code
- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MeetingDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
    [self setTimer:[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateGUI:) userInfo:nil repeats:YES]];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
    // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
    NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
    @throw exception;
    return nil;
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
