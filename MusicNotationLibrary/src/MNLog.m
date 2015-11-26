//
//  MNLog.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
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

#import "MNLog.h"

#import <objc/runtime.h>


#import "MNColor.h"
#import "OCTotallyLazy.h"
#import "NSString+Ruby.h"
#import "MNEnum.h"
#import "MNUtils.h"
#import "MNMacros.h"

#import "MNBrowserLogger.h"

@interface MNLog ()
{
    BOOL Debug;
}
@end

@implementation MNLog

+ (MNLogLevelType)logLevel
{
    return debug;
}

#pragma mark -
#pragma mark Rendering

+ (void)drawDotWithContext:(CGContextRef)ctx atX:(CGFloat)x atY:(CGFloat)y withColor:(MNColor*)color
{
    /*
     **
     * Draw a tiny marker on the specified canvas. A great debugging aid.
     *
     * @param {!Object} ctx Canvas context.
     * @param {number} x X position for dot.
     * @param {number} y Y position for dot.
     *
     Vex.drawDot = function(ctx, x, y, color) {
     var c = color || "#f55";
     ctx.save();
     ctx.fillStyle = c;

     //draw a circle
     ctx.beginPath();
     ctx.arc(x, y, 3, 0, Math.PI*2, YES);
     ctx.closePath();
     ctx.fill();
     ctx.restore();
     }

     */
    if(!color)
    {
        color = [MNColor colorWithRed:1.0f green:0.3f blue:0.3f alpha:1.0f];
    }
    [color setFill];
    [color setStroke];
    // CGMutablePathRef path = CGPathCreateMutable();
    // CGPathMoveToPoint(path, NULL, x, y);
    // CGContextDrawPath(ctx, kCGPathFill);

    // CGContextAddEllipseInRect(ctx, CGRectMake(x, y, 3.0, 3.0));
    // FillPath();
    CGContextFillEllipseInRect(ctx, CGRectMake(x, y, 3.0, 3.0));
}

static BOOL _initialized = NO;

static MNBrowserLogger* _browserLogger = nil;

+ (void)setup
{
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    [[DDTTYLogger sharedInstance] setForegroundColor:[MNColor redColor]
                                     backgroundColor:[MNColor clearColor]
                                             forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:[MNColor whiteColor]
                                     backgroundColor:[MNColor clearColor]
                                             forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance]
        setForegroundColor:[MNColor colorWithCalibratedRed:(255 / 255.0)green:(150 / 255.0)blue:(159 / 255.0)alpha:1.0]
           backgroundColor:[MNColor clearColor]
                   forFlag:DDLogFlagDebug];
    [[DDTTYLogger sharedInstance] setForegroundColor:[MNColor greenColor]
                                     backgroundColor:[MNColor clearColor]
                                             forFlag:DDLogFlagWarning];
    [[DDTTYLogger sharedInstance] setForegroundColor:[MNColor blueColor]
                                     backgroundColor:[MNColor greenColor]
                                             forFlag:DDLogFlagVerbose];
    
    _browserLogger = [[MNBrowserLogger alloc]init];
    [DDLog addLogger:_browserLogger];
}

#pragma mark - Logging
/*

 **
 * Logs a message to the console.
 *
 * @param {Vex.LogLevels} level A logging level.
 * @param {string|number|!Object} A log message (or object to dump).
 */
+ (void)LogMessage:(NSObject*)messenger withLevel:(NSUInteger)level
{
    //    if ((NSUInteger)level >= (NSUInteger)MNVex.logLevel)  {
    if(!_initialized)
    {
        _initialized = YES;
        [MNLog setup];

    }

    if([messenger isKindOfClass:[NSString class]])
    {
        NSString* log_message = (NSString*)messenger;
        switch(level)
        {
            case DDLogFlagDebug:
                DDLogDebug(@"%@", log_message);
                break;
            case DDLogFlagInfo:
                DDLogInfo(@"%@", log_message);
                break;
            case DDLogFlagWarning:
                DDLogWarn(@"%@", log_message);
                break;
            case DDLogFlagError:
                DDLogError(@"%@", log_message);
                break;
            default:
                DDLogVerbose(@"%@", log_message);
                break;
        }
    }
    //    }
}

+ (NSString*)convertFormat:(NSString*)format, ...
{
    NSCParameterAssert(format != nil);

    va_list args;
    va_start(args, format);

    NSString* str = [[NSString alloc] initWithFormat:format arguments:args];
    va_end(args);

    return str;
}

+ (void)logDebug:(NSString*)format, ...
{
    NSString* msg = [[self class] convertFormat:format];
//     [MNLog LogMessage:msg withLevel:LOG_FLAG_DEBUG];
    NSLog(@"%@", msg);
}

+ (void)logInfo:(NSString*)format, ...
{
    NSString* msg = [[self class] convertFormat:format];
//     [MNLog LogMessage:msg withLevel:LOG_FLAG_INFO];
    NSLog(@"%@", msg);
}

+ (void)logWarn:(NSString*)format, ...
{
    NSString* msg = [[self class] convertFormat:format];
//     [MNLog LogMessage:msg withLevel:LOG_FLAG_WARN];
    NSLog(@"%@", msg);
}

+ (void)logError:(NSString*)format, ...
{
    NSString* msg = [[self class] convertFormat:format];
//     [MNLog LogMessage:msg withLevel:LOG_FLAG_ERROR];
    NSLog(@"%@", msg);
}

+ (void)logFatal:(NSString*)format, ...
{
    NSString* msg = [[self class] convertFormat:format];
    [MNLog LogMessage:msg withLevel:DDLogFlagError];
    NSLog(@"%@", msg);
    [MNLog logVexDump:msg];
}

+ (void)logNotYetImplementedForClass:(id)obj andSelector:(SEL)sel
{
    //    Method method = class_getInstanceMethod([obj class], sel);

    //    const char *cStr = method_copyReturnType(method) == NULL ? "(null)" : method_copyReturnType(method);
    //    NSString *tmp = [NSString stringWithCString:cStr encoding:NSASCIIStringEncoding]; //[NSString
    //    stringWithCString:];
    //    NSString *returnType =  [tmp isEqualToString:@"(null)"] ? @"(void)" : tmp;

    //    NSString *formattedPolymorphicHierachyObj =  [MNVex FormatObject:[NSString stringWithFormat:@"%@",
    //                                                  [obj description]]];
    //    NSString *formattedPolymorphicHierachyObj = [obj prettyPrint];
    //            withLevel:error];
    //    NSString *prefix = [NSString stringWithFormat:@"NotYetImplemented: -%@%s => \n",
    //                        returnType,
    //                        sel_getName(sel)//,
    //                        /*class_getName([obj class]),*/];
    //    ////     [MNLog LogMessage:[prefix concat:formattedPolymorphicHierachyObj] withLevel:error];
#if TARGET_OS_IPHONE
     [MNLog LogMessage:[NSString stringWithFormat:@"not yet implemented:\n  [%@ %s] ", NSStringFromClass([obj class]), sel_getName(sel)]
            withLevel:error];
#elif TARGET_OS_MAC
    [MNLog LogMessage:[NSString stringWithFormat:@"not yet implemented:\n  [%@ %s] ", [obj className], sel_getName(sel)]
            withLevel:error];
#endif

    //     [MNLog LogMessage:prefix withLevel:error];
    abort();
}

+ (void)logVexDump:(NSString*)msg
{
    NSArray* mnSymbols = [NSThread callStackSymbols];
    __block NSMutableString* output = [@"" mutableCopy];
    [mnSymbols foreach:^(NSString* callStackLine, NSUInteger index, BOOL* stop) {
      if([callStackLine rangeOfString:@"VexFlow"].location != NSNotFound)
      {
          if(!([callStackLine includes:@"LogVexDump"] || [callStackLine includes:@"main +"] ||
               [callStackLine includes:@"start +"]))
          {
              NSError* error = NULL;
              NSString* regexString = @"(\\s*\\d+\\s*)(VexFlow)\\s*(0x\\w*)(\\s+)";
              NSRegularExpression* regex =
                  [NSRegularExpression regularExpressionWithPattern:regexString
                                                            options:NSRegularExpressionCaseInsensitive
                                                              error:&error];

              NSString* modifiedString = [regex stringByReplacingMatchesInString:callStackLine
                                                                         options:0
                                                                           range:NSMakeRange(0, [callStackLine length])
                                                                    withTemplate:@""];   //@"$2$1"];
              [output appendString:[NSString stringWithFormat:@"\r\n      %@", modifiedString]];
          }
      }
    }];
    //[MNLog LogError:[aFormat stringByAppendingFormat:@"%@",  output]];
    DDLogError(@"%@", [msg stringByAppendingFormat:@"%@", output]);
}

#pragma mark - Description Formatting

/*
 + (NSString *)FormatObject:(NSString *)objString {
 __block NSUInteger tabStack = 1;
 __block NSString *ret = [@"" mutableCopy];
 [objString lines:^(NSString *line) {
 if ([line includes:@"}"]) --tabStack;
 ret = [ret concat:[NSString stringWithFormat:@"%@ %@\n", [@"\t" multiply:tabStack], line]];
 if ([line includes:@"{"]) tabStack++;
 } separator:@"\n"];

 return [NSString stringWithFormat: @"%@", ret];
 }
 */

+ (NSString*)formatObject:(id)obj
{
    NSString* objString = nil;
    if([obj isKindOfClass:[NSString class]])
    {
        objString = (NSString*)obj;
    }
    else
    {
        objString = [obj prettyPrint];
    }

    __block NSUInteger tabStack = 1;
    __block NSString* ret = [@"" mutableCopy];
    [objString lines:^(NSString* line) {
      if([line includes:@"}"])
          --tabStack;
      ret = [ret concat:[NSString stringWithFormat:@"%@%@\n", [@"\t" multiply:tabStack], line]];
      if([line includes:@"{"])
          tabStack++;
    } separator:@"\n"];

    return [NSString stringWithFormat:@"%@", ret];
}

@end
