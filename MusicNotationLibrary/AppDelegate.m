//
//  AppDelegate.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "AppDelegate.h"
#import "MNBrowserWindowController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification*)aNotification
{
    [DDLog addLogger:[DDASLLogger sharedInstance]];
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];

    DDLogInfo(@"Application finished launching");

    MNBrowserWindowController* browserController = [[MNBrowserWindowController alloc] init];
    if(browserWindowControllers == nil)
    {
        browserWindowControllers = [[NSMutableSet alloc] init];
    }
    [browserWindowControllers addObject:browserController];
    self.browserWindowController = browserController;
    if(browserController)
    {
        [browserController showWindow:self];
    }

    NSWindow* browserWindow = [browserController window];
    if(browserWindow)
    {
    }

    // Create an instance of the audio controller, set it up and start it running
    AudioStreamBasicDescription asbd = AEAudioStreamBasicDescriptionNonInterleavedFloatStereo;

    self.audioController = [[AEAudioController alloc] initWithAudioDescription:asbd inputEnabled:YES];
    self.audioController.preferredBufferDuration = 0.005;
    [self.audioController start:NULL];
}

- (void)applicationWillTerminate:(NSNotification*)aNotification
{
    if(![[NSUserDefaults standardUserDefaults] boolForKey:@"hasLaunchedOnce"])
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"hasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }

    MNBrowserWindowController* bwc = [browserWindowControllers anyObject];

    if(bwc.repeatLastTestCheckBox.state == 1)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(bwc.testType) forKey:@"lastTest"];
    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setObject:@(NoneTestType) forKey:@"lastTest"];
    }
}

@end
