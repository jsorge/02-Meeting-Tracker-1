//
//  testPerson.m
//  Meeting Tracker
//
//  Created by CP120 on 10/8/12.
//  Copyright (c) 2012 Hal Mueller. All rights reserved.
//

#import "testPerson.h"
#import "Person.h"

@implementation testPerson

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testCreation
{
    Person *person = [[[Person alloc] init] autorelease];

    // the STAssertNoThrow macro simply tests that the call runs without throwing an error
    STAssertNoThrow([person name], @"name doesn't work");
    STAssertNoThrow([person hourlyRate], @"hourlyRate doesn't work");
}

- (void)testHourlyRate
{
    double rate = 85.;
    Person *person = [[[Person alloc] init] autorelease];
    [person setHourlyRate:[NSNumber numberWithDouble:rate]];
    // STAsserEqualsWithAccuracy is necessary to allow for rounding error within floating point numbers
    STAssertEqualsWithAccuracy(rate, [[person hourlyRate] doubleValue], .001, @"hourly rate wrong");
}

#define grouchoString @"Groucho Marx"

- (void)testParticipantName
{
    Person *person = [[[Person alloc] init] autorelease];
    NSMutableString *mutableStringWithGroucho = [NSMutableString stringWithString:grouchoString];
    [person setName:mutableStringWithGroucho];
    STAssertTrue([grouchoString isEqualToString:[person name]], @"name wrong");
    NSLog(@"testParticipantName before editing %@", [person name]);

    [mutableStringWithGroucho deleteCharactersInRange:NSMakeRange(0, 5)]; // delete 5 characters starting at index 0
    STAssertTrue([grouchoString isEqualToString:[person name]], @"name wrong");
    NSLog(@"testParticipantName after editing %@", [person name]);
}

- (void)testPersonWithNameRate
{
    Person *groucho = [Person personWithName:grouchoString
                                  hourlyRate:85.];
    STAssertEqualObjects(grouchoString, [groucho name], @"name wrong");
    STAssertEqualsWithAccuracy(85., [[groucho hourlyRate] doubleValue], .001, @"hourly rate wrong");
}

@end
