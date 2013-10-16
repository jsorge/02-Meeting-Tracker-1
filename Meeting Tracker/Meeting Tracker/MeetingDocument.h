//
//  JMSDocument.h
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/8/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Meeting.h"
#import "Person.h"

@interface MeetingDocument : NSDocument <NSWindowDelegate>
{
    Meeting *_meeting;
    NSTimer *_timer;
}

@property (assign) IBOutlet NSTextField *currentTimeLabel;

#pragma mark - Accessors
- (Meeting *)meeting;
- (void)setMeeting:(Meeting *)aMeeting;
- (NSTimer *)timer;
- (void)setTimer:(NSTimer *)aTimer;


#pragma mark - IBActions
- (IBAction)logMeeting:(id)sender;
- (IBAction)logParticipants:(id)sender;
- (IBAction)startMeetingButton:(id)sender;
- (IBAction)endMeetingButton:(id)sender;

#pragma mark - Other Public Methods
- (void)updateGUI:(NSTimer *)theTimer;

@end
