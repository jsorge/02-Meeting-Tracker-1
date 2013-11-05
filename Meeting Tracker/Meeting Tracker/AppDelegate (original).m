//
//  AppDelegate.m
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/21/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import "AppDelegate.h"
#import "PreferencesWindowController.h"

NSString *MTGDefaultNameKey = @"name";
NSString *MTGDefaultBillingRateKey = @"hourlyRate";

@interface AppDelegate ()
@property (retain, nonatomic, readwrite)PreferencesWindowController *preferencesWindowController;
@end

@implementation AppDelegate
#pragma mark - Accessors
- (PreferencesWindowController *)preferencesWindowController
{
    if (!_preferencesWindowController) {
        _preferencesWindowController = [[PreferencesWindowController alloc] init];
    }
    return _preferencesWindowController;
}

#pragma mark - NSApplicationDelegate
- (void)applicationDidFinishLaunching:(NSNotification *)notification
{
    [self registerDefaultValues];
}

#pragma mark - IBActions
- (IBAction)showPreferences:(id)sender
{
    [[self.preferencesWindowController window] makeKeyAndOrderFront:nil];
}

#pragma mark - Private Methods
- (void)registerDefaultValues
{
    
}

#pragma mark - Memory Management
- (void)dealloc
{
    [_preferencesWindowController release];
    self.preferencesWindowController = nil;
    
    [super dealloc];
}

@end
