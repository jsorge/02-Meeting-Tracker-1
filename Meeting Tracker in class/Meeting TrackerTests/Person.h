//
//  Person.h
//  Meeting Tracker
//
//  Created by CP120 on 1/17/13.
//  Copyright (c) 2013 Hal Mueller. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject {
    NSString *_name;
    NSNumber *_hourlyRate;
}

- (NSString *)name;
- (void)setName:(NSString *)aParticipantName;
- (NSNumber *)hourlyRate;
- (void)setHourlyRate:(NSNumber *)anHourlyRate;
+ (Person *)personWithName:(NSString *)name
                hourlyRate:(double)rate;
- (id)initWithName:(NSString*)aParticipantName
              rate:(double)aRate;
@end
