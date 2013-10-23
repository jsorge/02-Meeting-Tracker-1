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
@property (assign) IBOutlet NSButton *meetingTemplateButton;
@end

#define CAPTAIN_MEETING @"Captains"
#define MARX_MEETING @"Marxes"
#define STOOGE_MEETING @"Stooges"

@implementation MeetingDocument

#pragma mark - Accessors
- (id)init
{
    self = [super init];
    if (self) {
        self.meeting = [[[Meeting alloc] init] autorelease];
    }
    return self;
}

- (Meeting *)meeting
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

- (void)startTimer
{
    [self setTimer:[NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateGUI:) userInfo:nil repeats:YES]];
}

#pragma mark - IBActions
- (IBAction)logMeeting:(id)sender
{
    NSLog(@"%@", [[self meeting] description]);
}

- (IBAction)logParticipants:(id)sender
{
    NSArray *meetingParticipants = [[self meeting] personsPresent];
    for (Person *attendee in meetingParticipants) {
        NSLog(@"%@", [attendee description]);
    }
}

- (IBAction)startMeetingButton:(id)sender
{
    self.meeting.endingTime = nil;
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

- (IBAction)loadTemplateMeeting:(NSButton *)sender
{
    if ( [sender.title isEqualToString:CAPTAIN_MEETING] ) {
        [self setMeeting:[Meeting meetingWithCaptains]];
    } else if ( [sender.title isEqualToString:MARX_MEETING] ) {
        [self setMeeting:[Meeting meetingWithMarxBrothers]];
    } else if ( [sender.title isEqualToString:STOOGE_MEETING] ) {
        [self setMeeting:[Meeting meetingWithStooges]];
    }
}

#pragma mark - Other Public Methods
- (void)updateGUI:(NSTimer *)theTimer
{
    [self.currentTimeLabel setObjectValue:[NSDate date]];
    [self.totalBillingRate_liveComputeField setObjectValue:[self computeTotalBillingRate]];
    if (self.meeting) {
        self.elapsedTimeLabel.stringValue = [self.meeting elapsedTimeDisplayString];
        self.accruedCostLabel.objectValue  = [self.meeting accruedCost];
    }
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSString *meetingButtonTitle = [self drawRandomMeeting];
    [self.meetingTemplateButton.cell setTitle:meetingButtonTitle];
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

- (NSString *)drawRandomMeeting
{
    NSString *meetingTitle = @"";
    NSUInteger random = arc4random_uniform(3);
    switch (random) {
        case 0:
            meetingTitle = CAPTAIN_MEETING;
            break;
        case 1:
            meetingTitle = MARX_MEETING;
            break;
        case 2:
            meetingTitle = STOOGE_MEETING;
            break;
        default:
            NSLog(@"No meeting was started because the random number was %lu", (unsigned long)random);
    }
    return meetingTitle;
}

#pragma mark - NSWindowDelegate
- (void)windowWillClose:(NSNotification *)notification
{
    [self setTimer:nil];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.meeting forKey:@"meeting"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        self.meeting = [aDecoder decodeObjectForKey:@"meting"];
        [self startTimer];
    }
    return self;
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
    return @"MeetingDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    [self startTimer];
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

- (NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError
{
    return [NSKeyedArchiver archivedDataWithRootObject:self.meeting];
}

- (BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError
{
    Meeting *loadSavedMeeting = nil;
    @try {
        loadSavedMeeting = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception = %@", exception);
        if (outError) {
            NSDictionary *errorDictionary = [NSDictionary dictionaryWithObject:@"The data is corrupted" forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain code:unimpErr userInfo:errorDictionary];
        }
        return NO;
    }
    self.meeting = loadSavedMeeting;
    return YES;
}

@end
