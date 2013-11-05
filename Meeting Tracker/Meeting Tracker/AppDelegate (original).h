//
//  AppDelegate.h
//  Meeting Tracker
//
//  Created by Jared Sorge on 10/21/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PreferencesWindowController;

extern NSString *MTGDefaultNameKey;
extern NSString *MTGDefaultBillingRateKey;

@interface AppDelegate : NSObject <NSApplicationDelegate>

#pragma mark - Properties
@property (retain, nonatomic, readonly)PreferencesWindowController *preferencesWindowController;

#pragma mark - IBActions
- (IBAction)showPreferences:(id)sender;

@end