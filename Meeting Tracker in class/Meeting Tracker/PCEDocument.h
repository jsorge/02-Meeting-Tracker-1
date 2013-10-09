//
//  PCEDocument.h
//  Meeting Tracker
//
//  Created by CP120 on 1/17/13.
//  Copyright (c) 2013 Hal Mueller. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class Meeting;

@interface PCEDocument : NSDocument
{
    NSTimer *_timer;
//    Meeting *_meeting;
}

@property (assign) IBOutlet NSTextField *currentTimeLabel;
//- (Meeting *)meeting;

@end
