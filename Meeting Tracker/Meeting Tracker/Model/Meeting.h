//
//  Meeting.h
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/8/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject
{
    NSString *_description;
    NSDate *_startingTime;
    NSDate *_endingTime;
    NSMutableArray *_personsPresent;
}

#pragma mark - Accessors
- (NSString *)description;

- (NSDate *)startingTime;
- (void)setStartingTime:(NSDate *)aStartingTime;

- (NSDate *)endingTime;
- (void)setEndingTime:(NSDate *)anEndingTime;

- (NSMutableArray *)personsPresent;
- (void)setPersonsPresent:(NSMutableArray *)aPersonsPresent;

#pragma mark - Constructors
+ (Meeting *)meetingWithStooges;

#pragma mark - Other Public Methods
- (void)addToPersonsPresent:(id)personsPresentObject;
- (void)removeFromPersonsPresent:(id)personsPresentObject;
- (NSUInteger)countOfPersonsPresent;
- (NSUInteger)elapsedSeconds;
- (double)elapsedHours;
- (NSString *)elapsedTimeDisplayString;
- (NSNumber *)accruedCost;
- (NSNumber *)totalBillingRate;

@end
