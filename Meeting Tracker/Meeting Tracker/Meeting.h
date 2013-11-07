//
//  Meeting.h
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/8/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject <NSCoding>
{
    NSDate *_startingTime;
    NSDate *_endingTime;
    NSMutableArray *_personsPresent;
    NSNumberFormatter *_currencyFormatter;
}

#pragma mark - Accessors
- (NSDate *)startingTime;
- (void)setStartingTime:(NSDate *)aStartingTime;
- (NSDate *)endingTime;
- (void)setEndingTime:(NSDate *)anEndingTime;
- (NSMutableArray *)personsPresent;
- (void)setPersonsPresent:(NSMutableArray *)aPersonsPresent;
- (NSNumberFormatter *)currencyFormatter;

#pragma mark - Constructors
+ (Meeting *)meetingWithStooges;
+ (Meeting *)meetingWithCaptains;
+ (Meeting *)meetingWithMarxBrothers;
+ (Meeting *)meetingWithSimpsons;

#pragma mark - Other Public Methods
- (void)addToPersonsPresent:(id)personsPresentObject;
- (void)removeFromPersonsPresent:(id)personsPresentObject;
- (void)removePersonsPresentAtIndexes:(NSIndexSet *)indexes;
- (void)removeObjectFromPersonsPresentAtIndex:(NSUInteger)idx;
- (void)insertObject:(id)anObject inPersonsPresentAtIndex:(NSUInteger)idx;
- (void)insertPersonsPresent:(NSArray *)personsPresent atIndexes:(NSIndexSet *)indexes;
- (NSUInteger)countOfPersonsPresent;
- (NSUInteger)elapsedSeconds;
- (double)elapsedHours;
- (NSString *)elapsedTimeDisplayString;
- (NSNumber *)accruedCost;
- (NSNumber *)totalBillingRate;
- (BOOL)canStart;
- (BOOL)canStop;

@end
