//
//  JMSPreferencesWindowController.h
//  Meeting Tracker
//
//  Created by Jared Sorge on 11/3/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString *defaultTableColor;
extern NSString *meetingTableColorChangeNotification;

@interface JMSPreferencesWindowController : NSWindowController

- (IBAction)changeDefaultBackgroundColor:(id)sender;
- (IBAction)resetToStandardDefaults:(id)sender;

+ (NSColor *)preferencesTableBackgroundColor;
+ (void)setPreferencesTableBackgroundColor:(NSColor *)color;

+ (void)registerStandardDefaults;

@end
