//
//  Meeting.m
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/8/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import "Meeting.h"
#import "Person.h"

@implementation Meeting

#pragma mark - Accessors
- (NSString *)description;
{
    return [NSString stringWithFormat:@"This is a meeting that started at %@", [self startingTime]];
}

- (NSDate *)startingTime;
{
    return _startingTime;
}

- (void)setStartingTime:(NSDate *)aStartingTime;
{
    if (aStartingTime != _startingTime) {
        [aStartingTime retain];
        [_startingTime release];
        _startingTime = aStartingTime;
    }
}

- (NSDate *)endingTime;
{
    return _endingTime;
}

- (void)setEndingTime:(NSDate *)anEndingTime;
{
    if (anEndingTime != _endingTime) {
        [anEndingTime retain];
        [_endingTime release];
        _endingTime = anEndingTime;
    }
}

- (NSMutableArray *)personsPresent;
{
    return _personsPresent;
}

- (void)setPersonsPresent:(NSMutableArray *)aPersonsPresent;
{
    if (aPersonsPresent != _personsPresent) {
        [aPersonsPresent retain];
        [_personsPresent release];
        _personsPresent = aPersonsPresent;
    }
}

#pragma mark - Constructors
+ (Meeting *)meetingWithStooges;
{
    Person *larry = [Person personWithName:@"Larry" hourlyRate:@20];
    Person *curly = [Person personWithName:@"Curly" hourlyRate:@25];
    Person *mo = [Person personWithName:@"Mo" hourlyRate:@30];
    NSArray *stooges = @[larry, curly, mo];
    
    Meeting *stoogeMeeting = [[[Meeting alloc] init] autorelease];
    [stoogeMeeting setPersonsPresent:[[stooges mutableCopy] autorelease]];
    
    return stoogeMeeting;
}

+ (Meeting *)meetingWithCaptains;
{
    Person *picard = [Person personWithName:@"Picard" hourlyRate:@250];
    Person *kirk = [Person personWithName:@"Kirk" hourlyRate:@400];
    Person *janeway = [Person personWithName:@"Janeway" hourlyRate:@200];
    Person *spock = [Person personWithName:@"Spock" hourlyRate:@300];
    NSArray *captains = @[picard, kirk, janeway, spock];
    
    Meeting *captainsMeeting = [[[Meeting alloc] init] autorelease];
    [captainsMeeting setPersonsPresent:[[captains mutableCopy] autorelease]];
    
    return captainsMeeting;
}

+ (Meeting *)meetingWithMarxBrothers;
{
    Person *harpo = [Person personWithName:@"Harpo" hourlyRate:@20];
    Person *groucho = [Person personWithName:@"Groucho" hourlyRate:@50];
    Person *zeppo = [Person personWithName:@"Zeppo" hourlyRate:@30];
    Person *chico = [Person personWithName:@"Chico" hourlyRate:@35];
    NSArray *marxBrothers = @[harpo, groucho, zeppo, chico];
    
    Meeting *marxBrosMeeting = [[[Meeting alloc] init] autorelease];
    [marxBrosMeeting setPersonsPresent:[[marxBrothers mutableCopy] autorelease]];
    
    return marxBrosMeeting;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setPersonsPresent:[NSMutableArray array]];
        [self setStartingTime:[NSDate date]];
    }
    return self;
}

#pragma mark - Other Public Methods
- (void)addToPersonsPresent:(id)personsPresentObject;
{
    [_personsPresent addObject:personsPresentObject];
}

- (void)removeFromPersonsPresent:(id)personsPresentObject;
{
    [_personsPresent removeObject:personsPresentObject];
}

- (NSUInteger)countOfPersonsPresent;
{
    return [_personsPresent count];
}

- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx;
{
    [[self personsPresent] removeObjectAtIndex:idx];
}

- (void)insertObject:(id)anObject inPersonsPresentAtIndex:(NSUInteger)idx;
{
    [[self personsPresent] insertObject:anObject atIndex:idx];
}

- (NSUInteger)elapsedSeconds;
{
    NSDate *startingTime = [self startingTime];
    NSDate *endingTime = [self endingTime];
    NSTimeInterval timeSinceMeetingStarted = [endingTime timeIntervalSinceDate:startingTime];
    return timeSinceMeetingStarted;
}

- (double)elapsedHours;
{
    double secondsGoneBy = [self elapsedSeconds];
    double hoursGoneBy = secondsGoneBy / 3600;
    return hoursGoneBy;
}

- (NSString *)elapsedTimeDisplayString;
{
    return [NSString stringWithFormat:@"%f", [self elapsedHours]];
}

- (NSNumber *)accruedCost;
{
    double totalBillingRate = [[self totalBillingRate] doubleValue];
    double elapsedHours = [self elapsedHours];
    
    double totalCost = totalBillingRate * elapsedHours;
    return @(totalCost);
}

- (NSNumber *)totalBillingRate;
{
    double totalRate = 0;
    
    for (Person *person in [self personsPresent]) {
        double personRate = [[person hourlyRate] doubleValue];
        totalRate += personRate;
    }
    
    return @(totalRate);
}

@end
