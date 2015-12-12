//
//  MNBrowserLogger.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 11/12/15.
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

#import "MNBrowserLogger.h"
#import "AppDelegate.h"
#import "MNBrowserWindowController.h"
#import "NSString+Ruby.h"

@implementation MNBrowserLogger

- (void)logMessage:(DDLogMessage*)logMessage
{
    NSString* logMsg = logMessage.message;
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"\nyyyy-MM-dd HH:mm:ss:SSS"];
    NSString* dateString = [formatter stringFromDate:[NSDate date]];
    NSLog(@"%@", dateString);
    logMsg = [logMsg insert:0 string:dateString];

    if(self->_logFormatter)
        logMsg = [self->_logFormatter formatLogMessage:logMessage];

    if(logMsg)
    {
        NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:logMsg];
        [attributedString addAttribute:NSForegroundColorAttributeName
                                 value:[NSColor whiteColor]
                                 range:NSMakeRange(0, logMsg.length)];
        [((AppDelegate*)[[NSApplication sharedApplication] delegate])
                .browserWindowController appendText:attributedString];
    }
}

@end
