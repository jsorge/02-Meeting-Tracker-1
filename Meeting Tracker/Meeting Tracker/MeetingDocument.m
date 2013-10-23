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
@property (assign) IBOutlet NSArrayController *meetingArrayController;
@property (assign) IBOutlet NSTextField *totalBillingRateLabel_KVO;
@end

NSString *const captainMeeting = @"Captains";
NSString *const marxMeeting = @"Marxes";
NSString *const stoogesMeeting = @"Stooges";

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
    if ( [sender.title isEqualToString:captainMeeting] ) {
        [self setMeeting:[Meeting meetingWithCaptains]];
    } else if ( [sender.title isEqualToString:marxMeeting] ) {
        [self setMeeting:[Meeting meetingWithMarxBrothers]];
    } else if ( [sender.title isEqualToString:stoogesMeeting] ) {
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
            meetingTitle = captainMeeting;
            break;
        case 1:
            meetingTitle = marxMeeting;
            break;
        case 2:
            meetingTitle = stoogesMeeting;
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
    [self unregisterForChangeNotification];
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
    [self registerForChangeNotification];
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

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    DLog(@"%@", keyPath);
    [self.totalBillingRateLabel_KVO setObjectValue:[self.meeting totalBillingRate]];
}

- (void)registerForChangeNotification
{
    [self.meetingArrayController addObserver:self forKeyPath:@"@count.arrangedObjects" options:NSKeyValueObservingOptionOld context:NULL];
    [self.meetingArrayController addObserver:self forKeyPath:@"arrangedObjects.hourlyRate" options:NSKeyValueObservingOptionOld context:NULL];
}

- (void)unregisterForChangeNotification
{
    [self.meetingArrayController removeObserver:self forKeyPath:@"@count.arrangedObjects"];
    [self.meetingArrayController removeObserver:self forKeyPath:@"arrangedObjects.hourlyRate"];
}

@end
