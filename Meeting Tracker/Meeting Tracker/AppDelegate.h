//
//  AppDelegate.h
//  Meeting Tracker
//
//  Created by Jared Sorge on 11/2/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JMSPreferencesWindowController;

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, retain, readonly)JMSPreferencesWindowController *preferencesWindow;

#pragma mark - IBActions
- (IBAction)showPreferences:(NSMenuItem *)sender;

@end