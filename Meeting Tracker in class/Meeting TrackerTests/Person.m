//
//  Person.m
//  Meeting Tracker
//
//  Created by CP120 on 1/17/13.
//  Copyright (c) 2013 Hal Mueller. All rights reserved.
//

#import "Person.h"

@implementation Person
- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)aParticipantName
{
    if (_name != aParticipantName) {
        [_name release];
        _name = [aParticipantName copy];
    }
}

- (NSNumber *)hourlyRate
{
    return _hourlyRate;
}
- (void)setHourlyRate:(NSNumber *)anHourlyRate
{
    if (_hourlyRate != anHourlyRate) {
        [_hourlyRate release];
        _hourlyRate = [anHourlyRate retain];
    }
}

+ (Person *)personWithName:(NSString *)newName
                hourlyRate:(double)billingRate
{
	Person *result = [Person alloc];
    result = [result initWithName:newName
                             rate:billingRate];
    [result autorelease];
    return result;
}


- (id)initWithName:(NSString*)aParticipantName rate:(double)aRate
{
    if (self = [super init]) {
        _name = [aParticipantName copy];
        _hourlyRate = [[NSNumber numberWithDouble:aRate] retain];
    }
    return self;
}

- (NSString *)description
{
    return [NSString stringWithFormat:@"<Person %@ %@>", [self name], [self hourlyRate]];
}

- (void)dealloc
{
    [_name release];
    _name = nil;
    [_hourlyRate release];
    _hourlyRate = nil;
    
    [super dealloc];
}

- (id)init
{
    return [self initWithName:@"sample"
                         rate:20.];
}
@end
