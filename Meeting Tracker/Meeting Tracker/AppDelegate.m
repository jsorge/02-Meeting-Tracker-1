//
//  AppDelegate.m
//  Meeting Tracker
//
//  Created by Jared Sorge on 11/2/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import "AppDelegate.h"
#import "JMSPreferencesWindowController.h"
#import "Person.h"

@interface AppDelegate ()

@property (nonatomic, retain, readwrite)JMSPreferencesWindowController *preferencesWindow;

@end

@implementation AppDelegate

- (id)init
{
    self = [super init];
    if (self) {
        [JMSPreferencesWindowController registerStandardDefaults];
    }
    return self;
}

#pragma mark - Properties
- (JMSPreferencesWindowController *)preferencesWindow
{
    if (!_preferencesWindow) {
        _preferencesWindow = [[JMSPreferencesWindowController alloc] init];
    }
    return _preferencesWindow;
}

#pragma mark - IBActions
- (IBAction)showPreferences:(NSMenuItem *)sender
{
    [[self.preferencesWindow window] makeKeyAndOrderFront:nil];
}

#pragma mark - Memory Management
- (void)dealloc
{
    [_preferencesWindow release];
    _preferencesWindow = nil;
    
    [super dealloc];
}

@end