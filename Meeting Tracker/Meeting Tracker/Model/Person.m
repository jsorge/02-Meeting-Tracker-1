//
//  Person.m
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/8/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import "Person.h"

@implementation Person

#pragma mark - Accessors
- (NSString *)description;
{
    return _description;
}

- (NSString *)name;
{
    return _name;
}

- (void)setName:(NSString *)aParticipantName;
{
    if (aParticipantName != _name) {
        [aParticipantName retain];
        [_name release];
        _name = aParticipantName;
    }
}

- (NSNumber *)hourlyRate;
{
    return _hourlyRate;
}

- (void)setHourlyRate:(NSNumber *)anHourlyRate;
{
    if (anHourlyRate != _hourlyRate) {
        [anHourlyRate retain];
        [_hourlyRate release];
        _hourlyRate = anHourlyRate;
    }
}

#pragma mark - Constructors
+ (Person *)personWithName:(NSString *)name hourlyRate:(NSNumber *)rate;
{
    return [[[Person alloc] initWithName:name hourlyRate:[rate doubleValue]] autorelease];
}

- (id)initWithName:(NSString *)name hourlyRate:(double)rate;
{
    self = [super init];
    if (self) {
        [self setName:name];
        [self setHourlyRate:@(rate)];
    }
    return self;
}

//- (id)init
//{
//    return [self initWithName:nil hourlyRate:nil];
//}

#pragma mark - Dealloc
- (void)dealloc
{
    [_name release];
    _name = nil;
    
    [_hourlyRate release];
    _hourlyRate = nil;
    
    [super dealloc];
}

@end
