//
//  testMeeting.m
//  Meeting Tracker
//
//  Created by CP120 on 10/8/12.
//  Copyright (c) 2012 Hal Mueller. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "Meeting.h"
@interface testMeeting : XCTestCase

@end

@implementation testMeeting

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
    Meeting *meeting = [[[Meeting alloc] init] autorelease];
    XCTAssertNotNil([meeting personsPresent], @"personsPresent is empty");
    
    NSUInteger expectedCount = 0U;
    // I like to use symbolic names for the expected return values, so that I remember
    // why they are what they are
    XCTAssertEqual(expectedCount, [meeting countOfPersonsPresent], @"count wrong %zd",
                   [meeting countOfPersonsPresent]);
    double expectedRate = 0.;
    XCTAssertEqualWithAccuracy(expectedRate, [[meeting totalBillingRate] doubleValue], 0.01,
                               @"rate wrong");
}

- (void)testDates
{
    Meeting *meeting = [[[Meeting alloc] init] autorelease];
    
    NSUInteger threeHours = 60U*60U*3U;
    NSDate *start = [NSDate date];
    // You could use a more complicated construction method for the starting date,
    // if you wanted the starting date to be the same in each run of the tests.
    // That would most easily be done with NSCalendar -dateFromComponents:, or perhaps
    // [NSDate dateWithTimeIntervalSinceReferenceDate:], but is more complicated than
    // I want you to handle right now.
    NSDate *end = [start dateByAddingTimeInterval:threeHours];

    [meeting setStartingTime:start];
    [meeting setEndingTime:end];
    XCTAssertEqualObjects(start, [meeting startingTime], @"assignment failed");
    XCTAssertEqualObjects(end, [meeting endingTime], @"assignment failed");
    XCTAssertEqualWithAccuracy(threeHours, [meeting elapsedSeconds], .001, @"elapsed seconds wrong");
    XCTAssertEqualWithAccuracy(3., [meeting elapsedHours], .001, @"elapsed hours wrong");
    
}

- (void)testInsertionAndComputation
{
    Meeting *meeting;
    meeting = [[[Meeting alloc] init] autorelease];
    
    Person *groucho = [Person personWithName:@"Groucho" hourlyRate:@85.];
    [meeting insertObject:groucho
  inPersonsPresentAtIndex:0];
    [meeting insertObject:[Person personWithName:@"Harpo" hourlyRate:@75.]
  inPersonsPresentAtIndex:0];
    [meeting insertObject:[Person personWithName:@"Chico" hourlyRate:@65.]
  inPersonsPresentAtIndex:0];
    Person *zeppo = [Person personWithName:@"Zeppo" hourlyRate:@55.];
    [meeting insertObject:zeppo
  inPersonsPresentAtIndex:0];
        [meeting insertObject:[Person personWithName:@"Gummo" hourlyRate:@45.]
  inPersonsPresentAtIndex:0];
        [meeting insertObject:[Person personWithName:@"Karl" hourlyRate:@0.]
  inPersonsPresentAtIndex:0];
    NSLog(@"%@ %@", meeting, [meeting personsPresent]);
    NSUInteger expectedCount = 6;
    XCTAssertEqual(expectedCount, [meeting countOfPersonsPresent], @"count wrong %zd",
                   [meeting countOfPersonsPresent]);
    double expectedRate = 325.; // I computed this by hand, just added up the hourlyRate: arguments above
    XCTAssertEqualWithAccuracy(expectedRate, [[meeting totalBillingRate] doubleValue], 0.01,
                               @"rate wrong after insertions");
    
    [meeting removeObjectFromPersonsPresentAtIndex:5];
    expectedRate -= [[groucho hourlyRate] doubleValue];
    XCTAssertEqualWithAccuracy(expectedRate, [[meeting totalBillingRate] doubleValue], 0.01,
                               @"rate wrong after first removal");
    [meeting removeFromPersonsPresent:zeppo];
    expectedRate -= [[zeppo hourlyRate] doubleValue];
}

- (void)testComputation
{
    Meeting *meeting = [[[Meeting alloc] init] autorelease];

    NSUInteger hoursToRun = 3U;
    NSUInteger threeHours = 60U*60U*hoursToRun;
    NSDate *start = [NSDate date];
    NSDate *end = [start dateByAddingTimeInterval:threeHours];

    [meeting setStartingTime:start];
    [meeting setEndingTime:end];

    [meeting insertObject:[Person personWithName:@"Groucho" hourlyRate:@85.]
  inPersonsPresentAtIndex:0];
    [meeting insertObject:[Person personWithName:@"Harpo" hourlyRate:@75.]
  inPersonsPresentAtIndex:0];

    // both of the expected values are hand computed
    double expectedRate = 160.;
    XCTAssertEqualWithAccuracy(expectedRate, [[meeting totalBillingRate] doubleValue], 0.01,
                               @"rate wrong");
    double expectedCost = expectedRate * hoursToRun;
    XCTAssertEqualWithAccuracy(expectedCost, [[meeting accruedCost] doubleValue], 0.01,
                               @"accrued cost wrong");
}

- (void)testFactories
{
    // very simple tests to make sure these methods exist and return non-empty meetings
    Meeting *captains = [Meeting meetingWithCaptains];
    XCTAssertTrue([captains countOfPersonsPresent] > 0, @"captains failed");
    Meeting *marxBrothers = [Meeting meetingWithMarxBrothers];
    XCTAssertTrue([marxBrothers countOfPersonsPresent] > 0, @"marxBrothers failed");
    Meeting *stooges = [Meeting meetingWithStooges];
    XCTAssertTrue([stooges countOfPersonsPresent] > 0, @"stooges failed");
}

@end
