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

@interface JMSDocument : NSDocument <NSWindowDelegate>
{
    Meeting *_meeting;
    NSTimer *_timer;
}
@property (assign) IBOutlet NSTextField *timerLabel;

#pragma mark - Accessors
- (Meeting *)meeting;
- (void)setMeeting:(Meeting *)aMeeting;

- (NSTimer *)timer;
- (void)setTimer:(NSTimer *)aTimer;


#pragma mark - Other Public Methods
- (IBAction)logMeeting:(id)sender;
- (IBAction)logParticipants:(id)sender;
- (void)updateGUI:(NSTimer *)theTimer;
- (void)windowWillClose:(NSNotification *)notification;

@end
