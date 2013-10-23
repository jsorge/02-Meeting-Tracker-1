//
//  Meeting.m
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/8/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import "Meeting.h"
#import "Person.h"

NSString *const totalBillingRateString = @"totalBillingRate";

@implementation Meeting

#pragma mark - Accessors
- (NSString *)description
{
    return [NSString stringWithFormat:@"This is a meeting that started at %@ with %lu participants billing at %@/hour", [self startingTime], (unsigned long)[self countOfPersonsPresent], [[self currencyFormatter] stringFromNumber:[self totalBillingRate]]];
}

- (NSDate *)startingTime
{
    return _startingTime;
}

- (void)setStartingTime:(NSDate *)aStartingTime
{
    if (aStartingTime != _startingTime) {
        [aStartingTime retain];
        [_startingTime release];
        _startingTime = aStartingTime;
    }
}

- (NSDate *)endingTime
{
    return _endingTime;
}

- (void)setEndingTime:(NSDate *)anEndingTime
{
    if (anEndingTime != _endingTime) {
        [anEndingTime retain];
        [_endingTime release];
        _endingTime = anEndingTime;
    }
}

- (NSMutableArray *)personsPresent
{
    return _personsPresent;
}

- (void)setPersonsPresent:(NSMutableArray *)aPersonsPresent
{
    if (aPersonsPresent != _personsPresent) {
        [aPersonsPresent retain];
        [_personsPresent release];
        _personsPresent = aPersonsPresent;
    }
}

- (NSNumberFormatter *)currencyFormatter
{
    if (!_currencyFormatter) {
        _currencyFormatter = [[[NSNumberFormatter alloc] init] retain];
        [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return _currencyFormatter;
}

#pragma mark - Constructors
+ (Meeting *)meetingWithStooges
{
    Person *larry = [Person personWithName:@"Larry" hourlyRate:@20];
    Person *curly = [Person personWithName:@"Curly" hourlyRate:@25];
    Person *mo = [Person personWithName:@"Mo" hourlyRate:@30];
    NSArray *stooges = @[larry, curly, mo];
    
    Meeting *stoogeMeeting = [[[Meeting alloc] init] autorelease];
    [stoogeMeeting setPersonsPresent:[[stooges mutableCopy] autorelease]];
    
    return stoogeMeeting;
}

+ (Meeting *)meetingWithCaptains
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

+ (Meeting *)meetingWithMarxBrothers
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
    }
    return self;
}

#pragma mark - Other Public Methods
- (void)addToPersonsPresent:(id)personsPresentObject
{
    [_personsPresent addObject:personsPresentObject];
}

- (void)removeFromPersonsPresent:(id)personsPresentObject
{
    [_personsPresent removeObject:personsPresentObject];
}

- (NSUInteger)countOfPersonsPresent
{
    return [_personsPresent count];
}

- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx
{
    [[self personsPresent] removeObjectAtIndex:idx];
}

- (void)insertObject:(id)anObject inPersonsPresentAtIndex:(NSUInteger)idx
{
    [[self personsPresent] insertObject:anObject atIndex:idx];
}

- (NSUInteger)elapsedSeconds
{
    NSDate *startingTime = [self startingTime];
    NSDate *endingTime;
    if (![self endingTime]) {
        endingTime = [NSDate date];
    } else {
        endingTime = [self endingTime];
    }
    NSTimeInterval timeSinceMeetingStarted = [endingTime timeIntervalSinceDate:startingTime];
    return timeSinceMeetingStarted;
}

- (double)elapsedHours
{
    double secondsGoneBy = [self elapsedSeconds];
    double hoursGoneBy = secondsGoneBy / 3600;
    return hoursGoneBy;
}

- (NSString *)elapsedTimeDisplayString
{
    NSUInteger hours = 0;
    NSUInteger minutes = 0;
    NSUInteger seconds = 0;
    
    if ([self startingTime]) {
        NSUInteger elapsedSeconds = [self elapsedSeconds];
        hours = elapsedSeconds / 3600;
        minutes = (elapsedSeconds / 60) % 60;
        seconds = elapsedSeconds % 60;
    }
    
    return [NSString stringWithFormat:@"%02lu:%02lu:%02lu", (unsigned long)hours, (unsigned long)minutes, (unsigned long)
            seconds];
}

- (NSNumber *)accruedCost
{
    double totalBillingRate = 0;
    double elapsedHours = 0;
    
    if ([self startingTime]) {
        totalBillingRate = [[self totalBillingRate] doubleValue];
        elapsedHours = [self elapsedHours];
    }
    
    double totalCost = totalBillingRate * elapsedHours;
    return @(totalCost);
}

- (NSNumber *)totalBillingRate
{
    [self willChangeValueForKey:totalBillingRateString];
    double totalRate = 0;
    
    for (Person *person in [self personsPresent]) {
        double personRate = [[person hourlyRate] doubleValue];
        totalRate += personRate;
    }
    
    return @(totalRate);
    [self didChangeValueForKey:totalBillingRateString];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self startingTime] forKey:@"startingTime"];
    [aCoder encodeObject:[self endingTime] forKey:@"endingTime"];
    [aCoder encodeObject:[self personsPresent] forKey:@"personsPresent"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setStartingTime:[aDecoder decodeObjectForKey:@"startingTime"]];
        [self setEndingTime:[aDecoder decodeObjectForKey:@"endingTime"]];
        [self setPersonsPresent:[aDecoder decodeObjectForKey:@"personsPresent"]];
    }
    return self;
}

#pragma mark - KVO
- (void)addObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options context:(void *)context
{
    
}

- (void)removeObserver:(NSObject *)observer forKeyPath:(NSString *)keyPath
{
    
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    
}

#pragma mark - Memory Management
- (void)dealloc
{
    [_startingTime release];
    _startingTime = nil;
    
    [_endingTime release];
    _endingTime = nil;
    
    [_personsPresent release];
    _personsPresent = nil;
    
    [_currencyFormatter release];
    _currencyFormatter = nil;
    
    [super dealloc];
}

@end
