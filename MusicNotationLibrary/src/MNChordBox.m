//
//  MNChord.m
//  MusicNotation
//
//  Created by Scott on 4/17/15.
//  Copyright (c) Scott Riccardelli 2015
//  slcott <s.riccardelli@gmail.com> https://github.com/slcott
//  Ported from [VexFlow](http://vexflow.com) - Copyright (c) Mohit Muthanna 2010.
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

#import "MNChordBox.h"
#import "MNFont.h"
#import "MNChordBarStruct.h"

@interface MNChordBox ()
{
}

@property (assign, nonatomic) float x;
@property (assign, nonatomic) float y;
@property (assign, nonatomic) float width;
@property (assign, nonatomic) float height;
@property (assign, nonatomic) NSUInteger numStrings;
//@property (assign, nonatomic) NSUInteger numFrets;
@property (assign, nonatomic) float spacing;
@property (assign, nonatomic) float fretSpacing;
@property (assign, nonatomic) float circleRadius;
@property (assign, nonatomic) float textShiftX;
@property (assign, nonatomic) float textShiftY;
@property (assign, nonatomic) float fontSize;
@property (assign, nonatomic) float barShiftX;
@property (assign, nonatomic) float bridgeStrokeWidth;
@property (strong, nonatomic) NSString* chordFill;
//@property (strong, nonatomic) NSMutableArray* chord;

@property (strong, nonatomic) NSArray* tuning;

//@property (strong, nonatomic) NSString* positionText;

@end

@implementation MNChordBox

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)initWithRect:(CGRect)rect
{
    self = [self initWithDictionary:@{}];
    if(self)
    {
        // ChordBox = function(paper, x, y, width, height) {

        self.x = rect.origin.x;
        self.y = rect.origin.y;

        self.width = (rect.size.width < 100) ? 100 : rect.size.width - 50;
        self.height = (rect.size.height < 100) ? 100 : rect.size.height - 50;
        self.tuning = @[ @"E", @"A", @"D", @"G", @"B", @"E" ];
        self.numStrings = 6;
        _numFrets = 5;

        self.spacing = self.width / (self.numStrings);
        self.fretSpacing = (self.height) / (_numFrets + 2);

        // Add room on sides for finger positions on 1. and 6. string
        self.x += self.spacing / 2;
        self.y += self.fretSpacing;

        self.circleRadius = self.width / 14;   // CHANGE: 28 -> 14;
        self.textShiftX = self.width / 29;
        self.textShiftY = self.height / 29;
        self.fontSize = ceilf(self.width / 9);
        self.barShiftX = self.width / 28;
        self.bridgeStrokeWidth = ceilf(self.height / 36);
        self.chordFill = @"#444";

        // Content
        //        _position = 0;
        //        _positionText = @"";
        _chord = [NSMutableArray array];
        self.bars = [NSMutableArray array];
    }
    return self;
}

- (id)setNumFrets:(NSUInteger)numFrets
{
    _numFrets = numFrets;
    self.fretSpacing = (self.height) / (_numFrets + 1);

    return self;
}

- (id)setChord:(NSMutableArray*)chord
      position:(NSUInteger)position
          bars:(NSArray*)bars
        tuning:(NSArray*)tuning
  positionText:(NSString*)positionText
{
    _chord = chord;
    _position = position;
    _positionText = positionText;
    self.bars = (bars) ? [bars mutableCopy] : [NSMutableArray array];
    self.tuning = tuning ? tuning : @[ @"E", @"A", @"D", @"G", @"B", @"E" ];
    if(tuning.count == 0)
    {
        self.fretSpacing = (self.height) / (_numFrets + 1);
    }

    return self;
}

- (id)setPositionText:(NSString*)positionText
{
    _positionText = positionText;
    return self;
}

- (void)draw:(CGContextRef)ctx
{
    float spacing = self.spacing;
    float fretSpacing = self.fretSpacing;

    // Draw guitar bridge
    if(self.position <= 1)
    {
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, self.x, self.y - self.bridgeStrokeWidth / 2);
        CGContextAddLineToPoint(ctx, self.x + (spacing * (self.numStrings - 1)), self.y - self.bridgeStrokeWidth / 2);
        CGContextSetLineWidth(ctx, self.bridgeStrokeWidth);
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
    }
    else
    {
        // Draw position number
        //                self.paper.text(self.x - (self.spacing / 2) - self.textShiftX,
        //                                self.y + (self.fretSpacing / 2) + self.textShiftY + (self.fretSpacing *
        //                                _positionText),
        //                                self.position)
        //            .attr("font-size", self.fontSize);

        // Draw position number
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = kCTTextAlignmentCenter;
        MNFont* font1 = [MNFont fontWithName:@"Verdana" size:12];
        NSAttributedString* title = [[NSAttributedString alloc]
            initWithString:_positionText
                attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1.font}];
        [title drawAtPoint:CGPointMake(
                               self.x - (self.spacing / 2) - self.textShiftX,
                               self.y + (self.fretSpacing / 2) + self.textShiftY + (self.fretSpacing * _position))];
    }

    CGContextSetLineWidth(ctx, 1);

    // Draw strings
    for(NSUInteger i = 0; i < self.numStrings; ++i)
    {
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, self.x + (spacing * i), self.y);
        CGContextAddLineToPoint(ctx, self.x + (spacing * i), self.y + (fretSpacing * (_numFrets)));
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
    }

    // Draw frets
    for(NSUInteger i = 0; i < _numFrets + 1; ++i)
    {
        CGContextBeginPath(ctx);
        CGContextMoveToPoint(ctx, self.x, self.y + (fretSpacing * i));
        CGContextAddLineToPoint(ctx, self.x + (spacing * (self.numStrings - 1)), self.y + (fretSpacing * i));
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);
    }

    // Draw tuning keys
    if(self.tuning && self.tuning.count > 0)
    {
        NSArray* tuning = self.tuning;
        for(NSUInteger i = 0; i < tuning.count; ++i)
        {
            NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            paragraphStyle.alignment = kCTTextAlignmentCenter;
            MNFont* font1 = [MNFont fontWithName:@"Verdana" size:12];
            NSAttributedString* title = [[NSAttributedString alloc]
                initWithString:tuning[i]
                    attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1.font}];
            [title drawAtPoint:CGPointMake(self.x + (self.spacing * i) - title.size.width / 2,
                                           self.y + ((_numFrets) * (self.fretSpacing)))];
        }
    }

    // Draw chord
    for(NSUInteger i = 0; i < _chord.count; ++i)
    {
        //        self.lightUp(self.chord[i][0], self.chord[i][1]);
        [self lightUp:ctx stringNum:[self.chord[i][0] unsignedIntegerValue] fretNum:self.chord[i][1]];
    }

    // Draw bars
    for(NSUInteger i = 0; i < self.bars.count; ++i)
    {
        MNChordBarStruct* bar = (MNChordBarStruct*)self.bars[i];
        [self lightBar:ctx fromString:bar.fromString toString:bar.toString fretNum:bar.fret];
    }
}

- (id)lightUp:(CGContextRef)ctx stringNum:(NSUInteger)stringNum fretNum:(id)fretNum
{
    stringNum = self.numStrings - stringNum;

    float shift_position = 0;
    if(self.position == 1)   // && _positionText == 1)
    {
        shift_position = _position;
    }

    BOOL mute = NO;
    NSUInteger fret_number;

    if([fretNum isKindOfClass:[NSString class]])
    {
        if([[fretNum capitalizedString] isEqualToString:@"X"])
        {
            fret_number = 0;
            mute = YES;
        }
        else
        {
            // error
            abort();
        }
    }
    else   // fretNum is NSNumber
    {
        fret_number = [fretNum unsignedIntegerValue] - shift_position;
    }

    float x = self.x + (self.spacing * stringNum);
    float y = self.y + (self.fretSpacing * fret_number);

    if(fret_number == 0)
    {
        y -= self.bridgeStrokeWidth;
    }

    if(!mute)
    {
        CGContextBeginPath(ctx);
        CGContextAddEllipseInRect(ctx, CGRectMake(x - self.circleRadius / 2, y - floorf(self.fretSpacing / 1.5),
                                                  self.circleRadius, self.circleRadius));
        CGContextClosePath(ctx);
        CGContextStrokePath(ctx);

        if(fret_number > 0)
        {
            CGContextBeginPath(ctx);
            CGContextAddEllipseInRect(ctx, CGRectMake(x - self.circleRadius / 2, y - floorf(self.fretSpacing / 1.5),
                                                      self.circleRadius, self.circleRadius));
            CGContextFillPath(ctx);
            CGContextStrokePath(ctx);
        }
    }
    else
    {
        //        c = self.paper.text(x, y - (self.fret_spacing - self.metrics.font_size), "X")
        //                .attr({"font-size" : self.metrics.font_size});

        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = kCTTextAlignmentCenter;
        MNFont* font1 = [MNFont fontWithName:@"TimesNewRomanPS-BoldMT" size:18];
        NSAttributedString* title = [[NSAttributedString alloc]
            initWithString:@"X"
                attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font1.font}];
        [title drawAtPoint:CGPointMake(x - title.size.width / 2,
                                       y - (self.fretSpacing - 18) - title.size.height / 1.5)];   // self.fontSize))];
    }

    return self;
}

- (id)lightBar:(CGContextRef)ctx
    fromString:(NSUInteger)stringFrom
      toString:(NSUInteger)stringTo
       fretNum:(NSInteger)fretNum
{
    if(self.position == 1 && [_positionText isEqualToString:@"1"])
    {
        fretNum -= _position;
    }

    NSUInteger string_from_num = self.numStrings - stringFrom;
    NSUInteger string_to_num = self.numStrings - stringTo;

    float x = self.x + (self.spacing * string_from_num) - self.barShiftX;
    float x_to = self.x + (self.spacing * string_to_num) + self.barShiftX;

    float y = self.y + (self.fretSpacing * (fretNum - 1)) + (self.fretSpacing / 4);
    float y_to = self.y + (self.fretSpacing * (fretNum - 1)) + ((self.fretSpacing / 4) * 3);

    CGContextBeginPath(ctx);
    CGContextMoveToPoint(ctx, x, y);

    CGPathRef path =
        CGPathCreateWithRoundedRect(CGRectMake(x, y, (x_to - x), (y_to - y)), 5, 5, NULL);   // self.circleRadius,
    //                                                 self.circleRadius, NULL);
    CGContextAddPath(ctx, path);
    CGContextClosePath(ctx);
    //    CGContextStrokePath(ctx);
    CGContextFillPath(ctx);

    return self;
}

@end