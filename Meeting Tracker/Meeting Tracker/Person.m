//
//  Person.m
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/8/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import "Person.h"

NSString *defaultNameKey = @"name";
NSString *defaultHourlyRateKey = @"hourlyRate";

@implementation Person

#pragma mark - Accessors
- (NSString *)description
{
    return [NSString stringWithFormat:@"%@ bills at %@", [self name], [[self currencyFormatter] stringFromNumber:[self hourlyRate]]];
}

- (NSString *)name
{
    return _name;
}

- (void)setName:(NSString *)aParticipantName
{
    if (aParticipantName != _name) {
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
    if (anHourlyRate != _hourlyRate) {
        [anHourlyRate retain];
        [_hourlyRate release];
        _hourlyRate = anHourlyRate;
    }
}

- (NSNumberFormatter *)currencyFormatter
{
    if (!_currencyFormatter) {
        _currencyFormatter = [[NSNumberFormatter alloc] init];
        [_currencyFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    }
    return _currencyFormatter;
}

#pragma mark - Constructors
+ (Person *)personWithName:(NSString *)name hourlyRate:(NSNumber *)rate
{
    return [[[Person alloc] initWithName:name hourlyRate:rate] autorelease];
}

- (id)initWithName:(NSString *)name hourlyRate:(NSNumber *)rate;
{
    self = [super init];
    if (self) {
        [self setName:name];
        [self setHourlyRate:rate];
    }
    return self;
}

- (id)init
{
    NSString *defaultName = [[NSUserDefaults standardUserDefaults] stringForKey:defaultNameKey];
    NSNumber *defaultRate = @([[NSUserDefaults standardUserDefaults] floatForKey:defaultHourlyRateKey]);
    return [self initWithName:defaultName hourlyRate:defaultRate];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self name] forKey:defaultNameKey];
    [aCoder encodeObject:[self hourlyRate] forKey:defaultHourlyRateKey];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        [self setName:[aDecoder decodeObjectForKey:defaultNameKey]];
        [self setHourlyRate:[aDecoder decodeObjectForKey:defaultHourlyRateKey]];
    }
    return self;
}

#pragma mark - Memory Management
- (void)dealloc
{
    [_name release];
    _name = nil;
    
    
    [_hourlyRate release];
    _hourlyRate = nil;
    
    [_currencyFormatter release];
    _currencyFormatter = nil;
    
    [super dealloc];
}

@end
