//
//  JMSPreferencesWindowController.m
//  Meeting Tracker
//
//  Created by Jared Sorge on 11/3/13.
//  Copyright (c) 2013 jsorge. All rights reserved.
//

#import "JMSPreferencesWindowController.h"
#import "Person.h"

NSString *defaultTableColor = @"defaultTableColor";
NSString *meetingTableColorChangeNotification = @"meetingTableColorChangeNotification";

@interface JMSPreferencesWindowController ()
@property (assign) IBOutlet NSColorWell *colorWell;
@end

@implementation JMSPreferencesWindowController

- (id)init
{
    return [super initWithWindowNibName:@"PreferencesWindow"];
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    self.colorWell.color = [JMSPreferencesWindowController preferencesTableBackgroundColor];
}

#pragma mark - IBActions
- (IBAction)changeDefaultBackgroundColor:(id)sender
{
    NSColor *color = self.colorWell.color;
    [JMSPreferencesWindowController setPreferencesTableBackgroundColor:color];
}

- (IBAction)resetToStandardDefaults:(id)sender
{
    NSString *appDomain = [[NSBundle mainBundle] bundleIdentifier];
    [[NSUserDefaults standardUserDefaults] removePersistentDomainForName:appDomain];
    
    [JMSPreferencesWindowController registerStandardDefaults];
    
    self.colorWell.color = [JMSPreferencesWindowController preferencesTableBackgroundColor];
}

#pragma mark - Preferences Accessors
+ (NSColor *)preferencesTableBackgroundColor
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSData *colorData = [standardDefaults objectForKey:defaultTableColor];
    return [NSKeyedUnarchiver unarchiveObjectWithData:colorData];
}

+ (void)setPreferencesTableBackgroundColor:(NSColor *)color
{
    NSData *colorData = [NSKeyedArchiver archivedDataWithRootObject:color];
    [[NSUserDefaults standardUserDefaults] setObject:colorData forKey:defaultTableColor];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:meetingTableColorChangeNotification object:self];
}

+ (void)registerStandardDefaults
{
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];

    [defaultValues setObject:@"Person" forKey:defaultNameKey];
    [defaultValues setObject:@100 forKey:defaultHourlyRateKey];
    [JMSPreferencesWindowController setPreferencesTableBackgroundColor:[NSColor whiteColor]];
    
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

@end