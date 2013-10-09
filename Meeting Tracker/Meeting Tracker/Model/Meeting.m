//
//  Meeting.m
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/8/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import "Meeting.h"

@implementation Meeting

#pragma mark - Accessors
- (NSString *)description;
{
    return _description;
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
    Meeting *stoogeMeeting = [[Meeting alloc] init];
    
    //@fix Finish
    
    return stoogeMeeting;
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

- (NSUInteger)elapsedSeconds;
{
    NSUInteger secondsGoneBy = 0;
    
    return secondsGoneBy;
}

- (double)elapsedHours;
{
    double hoursGoneBy = 0.0;
    
    return hoursGoneBy;
}

- (NSString *)elapsedTimeDisplayString;
{
    NSString *timeGoneByString;
    
    
    
    return timeGoneByString;
}

- (NSNumber *)accruedCost;
{
    return @0;
}

- (NSNumber *)totalBillingRate;
{
    return @0;
}

@end
