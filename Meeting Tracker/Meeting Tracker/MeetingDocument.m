
//  JMSDocument.m
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/8/13.
//  Copyright (c) 2013 jsorge. All rights reserved.


#import "MeetingDocument.h"
#import "JMSPreferencesWindowController.h"

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
@property (assign) IBOutlet NSTableView *meetingTable;
@end

NSString *const captainMeeting = @"Captains";
NSString *const marxMeeting = @"Marxes";
NSString *const stoogesMeeting = @"Stooges";
NSString *const simpsonsMeeting = @"Simpsons";
NSString *const arrangedObjectsCountKey = @"@count.arrangedObjects";
NSString *const arrangedObjectsHourlyRateKey = @"arrangedObjects.hourlyRate";

@implementation MeetingDocument
static void *documentContext;

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
    [self setTimer:[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateGUI:) userInfo:nil repeats:YES]];
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
    } else if ( [sender.title isEqualToString:simpsonsMeeting]) {
        [self setMeeting:[Meeting meetingWithSimpsons]];
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
    NSUInteger random = arc4random_uniform(4);
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
        case 3:
            meetingTitle = simpsonsMeeting;
            break;
        default:
            NSLog(@"No meeting was started because the random number was %lu", (unsigned long)random);
    }
    return meetingTitle;
}

- (void)changeTableColor:(id)sender
{
    NSColor *newBackgroundColor = [JMSPreferencesWindowController preferencesTableBackgroundColor];
    self.meetingTable.backgroundColor = newBackgroundColor;
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
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
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
    self.meetingTable.backgroundColor = [JMSPreferencesWindowController preferencesTableBackgroundColor];
    [self startTimer];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeTableColor:)
                                                 name:meetingTableColorChangeNotification
                                               object:nil];
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
    LogMethod();
    [object setValue:value forKeyPath:keyPath];
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    LogMethod();
    if (context != documentContext) {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        return;
    }
    
    switch ([change[NSKeyValueChangeKindKey] integerValue]) {
        case NSKeyValueChangeSetting: {
            id oldValue = [change objectForKey:NSKeyValueChangeOldKey];
            if (oldValue == [NSNull null]) {
                oldValue = nil;
            }
            [[self.undoManager prepareWithInvocationTarget:self] changeKeyPath:keyPath ofObject:object toValue:oldValue];
            self.undoManager.actionName = @"Edit";
            break;
        }
        case NSKeyValueChangeInsertion:
            if ([keyPath isEqualToString:meetingPersonsPresentKeypath]) {
                [[self.undoManager prepareWithInvocationTarget:self.meeting] removePersonsPresentAtIndexes:change[NSKeyValueChangeIndexesKey]];
                for (Person *person in change[NSKeyValueChangeNewKey]) {
                    [self startObservingPerson:person];
                }
            }
            break;
        case NSKeyValueChangeRemoval:
            if ([keyPath isEqualToString:meetingPersonsPresentKeypath]) {
                [[self.undoManager prepareWithInvocationTarget:self.meeting] insertPersonsPresent:change[NSKeyValueChangeOldKey] atIndexes:change[NSKeyValueChangeIndexesKey]];
                for (Person *person in change[NSKeyValueChangeOldKey]) {
                    [self stopObservingPerson:person];
                }
            }
            break;
    }
}

- (void)startObservingMeeting:(Meeting *)meeting
{
    LogMethod();
    for (Person *person in meeting.personsPresent) {
        [self startObservingPerson:person];
    }
    [meeting addObserver:self
              forKeyPath:meetingPersonsPresentKeypath
                 options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                 context:documentContext];
    [meeting addObserver:self
              forKeyPath:meetingTimeStartKeypath
                 options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                 context:documentContext];
    [meeting addObserver:self
              forKeyPath:meetingTimeEndKeypath
                 options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                 context:documentContext];
}

- (void)stopObservingMeeting:(Meeting *)meeting
{
    LogMethod();
    for (Person *person in meeting.personsPresent) {
        [self stopObservingPerson:person];
    }
    [meeting removeObserver:self forKeyPath:meetingPersonsPresentKeypath];
    [meeting removeObserver:self forKeyPath:meetingTimeStartKeypath];
    [meeting removeObserver:self forKeyPath:meetingTimeEndKeypath];
}

- (void)startObservingPerson:(Person *)person
{
    LogMethod();
    [person addObserver:self
             forKeyPath:personNameKeyPath
                options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                context:documentContext];
    [person addObserver:self
             forKeyPath:personHourlyRateKeyPath
                options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew
                context:documentContext];
    
}

- (void)stopObservingPerson:(Person *)person
{
    LogMethod();
    [person removeObserver:self forKeyPath:personNameKeyPath];
    [person removeObserver:self forKeyPath:personHourlyRateKeyPath];
}

#pragma mark - Menu Items
- (BOOL)validateUserInterfaceItem:(id<NSValidatedUserInterfaceItem>)anItem
{
    SEL action = [anItem action];
    
    if (action == @selector(startMeetingButton:)) {
        return self.meeting.canStart;
    } else if ((action == @selector(resetWithMarxes:))
               || (action == @selector(resetWithSimpsons:))
               || (action == @selector(resetWithStooges:))
               || (action == @selector(resetWithCaptains:))) {
        return !(self.meeting.canStop);
    } else if (action == @selector(endMeetingButton:)) {
        return self.meeting.canStop;
    }
    
    return [super validateUserInterfaceItem:anItem];
}

- (IBAction)resetWithMarxes:(id)sender
{
    self.meeting = [Meeting meetingWithMarxBrothers];
}

- (IBAction)resetWithStooges:(id)sender
{
    self.meeting = [Meeting meetingWithStooges];
}

- (IBAction)resetWithSimpsons:(id)sender
{
    self.meeting = [Meeting meetingWithSimpsons];
}

- (IBAction)resetWithCaptains:(id)sender
{
    self.meeting = [Meeting meetingWithCaptains];
}


@end
