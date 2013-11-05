
//  JMSDocument.m
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/8/13.
//  Copyright (c) 2013 jsorge. All rights reserved.


#import "MeetingDocument.h"

NSString *personNameKeyPath = @"name";
NSString *personHourlyRateKeyPath = @"hourlyRate";
NSString *meetingPersonsPresentKeypath = @"personsPresent";
NSString *meetingTimeStartKeypath = @"startingTime";
NSString *meetingTimeEndKeypath = @"endingTime";

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
NSString *const arrangedObjectsCountKey = @"@count.arrangedObjects";
NSString *const arrangedObjectsHourlyRateKey = @"arrangedObjects.hourlyRate";

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
        [self stopObservingMeeting:_meeting];
        [aMeeting retain];
        [_meeting release];
        _meeting = aMeeting;
        [self startObservingMeeting:_meeting];
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
    [self setTimer:[NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(updateGUI:) userInfo:nil repeats:YES]];
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
    [self stopObservingMeeting:self.meeting];
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
    [self stopObservingMeeting:self.meeting];
    
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
    [self startObservingMeeting:self.meeting];
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

#pragma mark - Undo/Redo
- (void)changeKeyPath:(NSString *)keyPath ofObject:(id)object toValue:(id)value
{
    [object setValue:value forKeyPath:keyPath];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    switch ([change[NSKeyValueChangeKindKey] integerValue]) {
        case NSKeyValueChangeSetting: {
            id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
            if (oldValue == [NSNull null]) {
                oldValue = nil;
            }
            [[self.undoManager prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
            self.undoManager.actionName = @"Edit";
            [self.totalBillingRateLabel_KVO setObjectValue:[self.meeting totalBillingRate]];
            break;
        }
        case NSKeyValueChangeInsertion:
            if ([keyPath isEqualToString:meetingPersonsPresentKeypath]) {
                [[self.undoManager prepareWithInvocationTarget:self.meeting] removePersonsPresentAtIndexes:change[NSKeyValueChangeIndexesKey]];
                for (Person *person in change[NSKeyValueChangeNewKey]) {
                    [self startObservingPerson:person];
                }
                [self.totalBillingRateLabel_KVO setObjectValue:[self.meeting totalBillingRate]];
            }
            break;
        case NSKeyValueChangeRemoval:
            if ([keyPath isEqualToString:meetingPersonsPresentKeypath]) {
                [[self.undoManager prepareWithInvocationTarget:self.meeting] insertPersonsPresent:change[NSKeyValueChangeOldKey] atIndexes:change[NSKeyValueChangeIndexesKey]];
                for (Person *person in change[NSKeyValueChangeOldKey]) {
                    [self stopObservingPerson:person];
                }
                [self.totalBillingRateLabel_KVO setObjectValue:[self.meeting totalBillingRate]];
            }
            break;
    }
}

- (void)startObservingMeeting:(Meeting *)meeting
{
    for (Person *person in meeting.personsPresent) {
        [self startObservingPerson:person];
    }
    [meeting addObserver:self
              forKeyPath:meetingPersonsPresentKeypath
                 options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                 context:NULL];
    [meeting addObserver:self
              forKeyPath:meetingTimeStartKeypath
                 options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                 context:NULL];
    [meeting addObserver:self
              forKeyPath:meetingTimeEndKeypath
                 options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                 context:NULL];
}

- (void)stopObservingMeeting:(Meeting *)meeting
{
    for (Person *person in meeting.personsPresent) {
        [self stopObservingPerson:person];
    }
    [meeting removeObserver:self forKeyPath:meetingPersonsPresentKeypath];
    [meeting removeObserver:self forKeyPath:meetingTimeStartKeypath];
    [meeting removeObserver:self forKeyPath:meetingTimeEndKeypath];
}

- (void)startObservingPerson:(Person *)person
{
    [person addObserver:self
             forKeyPath:personNameKeyPath
                options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                context:NULL];
    [person addObserver:self
             forKeyPath:personHourlyRateKeyPath
                options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                context:NULL];
    
}

- (void)stopObservingPerson:(Person *)person
{
    [person removeObserver:self forKeyPath:personNameKeyPath];
    [person removeObserver:self forKeyPath:personHourlyRateKeyPath];
}

#pragma mark - Menu Items
- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    BOOL shouldEnable = YES;
    
    
    
    return shouldEnable;
}

#pragma mark - NSArrayController


@end
