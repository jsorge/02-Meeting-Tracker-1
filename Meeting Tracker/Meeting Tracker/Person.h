//
//  Person.h
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/8/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *defaultNameKey;
extern NSString *defaultHourlyRateKey;

@interface Person : NSObject <NSCoding>
{
    NSString *_name;
    NSNumber *_hourlyRate;
    NSNumberFormatter *_currencyFormatter;
}

#pragma mark - Accessors
- (NSString *)name;
- (void)setName:(NSString *)aParticipantName;
- (NSNumber *)hourlyRate;
- (void)setHourlyRate:(NSNumber *)anHourlyRate;
- (NSNumberFormatter *)currencyFormatter; 

#pragma mark - Constructors
+ (Person *)personWithName:(NSString *)name hourlyRate:(NSNumber *)rate;
- (id)initWithName:(NSString *)name hourlyRate:(NSNumber *)rate;

@end
