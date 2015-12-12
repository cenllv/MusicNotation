//
//  MNText.m
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

#import "MNText.h"
//#import <CoreText/CoreText.h>
#import "MNFont.h"
#import "MNColor.h"
#import "MNUtils.h"
#import "MNBoundingBox.h"

@interface MNText ()
@property (strong, nonatomic) MNFont* font;
//@property (strong, nonatomic, readonly)  MNFont *font;
//@property (strong, nonatomic) MNColor* color;
//@property (strong, nonatomic) NSString *fontName;
//@property (assign, nonatomic) NSUInteger fontSize;
//@property (assign, nonatomic) BOOL fontItalic;
//@property (assign, nonatomic) BOOL fontBold;
@property (assign, nonatomic) MNTextAlignment alignment;
@property (assign, nonatomic) MNTextVerticalAlignment verticalAlignment;
@end

static BOOL _dirty;   // update font prop
static BOOL _showBoundingBox = NO;

@implementation MNText
{
    MNColor* _color;
    NSString* _fontName;
    NSUInteger _fontSize;
    BOOL _fontItalic;
    BOOL _fontBold;
}

+ (MNText*)sharedText
{
    static MNText* _sharedMNText = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
      _sharedMNText = [[self alloc] init];
    });
    return _sharedMNText;
}

- (instancetype)init
{
    if(self = [super init])
    {
        _dirty = YES;
        self.font = [MNFont fontWithName:@"times" size:12];
        self.color = MNColor.blackColor;
        self.verticalAlignment = MNTextAlignmentTop;
    }
    return self;
}

#pragma mark - Properties

+ (void)setAlignment:(MNTextAlignment)alignment
{
    [[MNText sharedText] setAlignment:alignment];
}

- (void)setAlignment:(MNTextAlignment)alignment
{
    _alignment = alignment;
}

+ (void)setVerticalAlignment:(MNTextVerticalAlignment)alignment
{
    [[MNText sharedText] setVerticalAlignment:alignment];
}

- (void)setVerticalAlignment:(MNTextVerticalAlignment)alignment
{
    _verticalAlignment = alignment;
}

- (void)setColor:(MNColor*)color
{
    _dirty = YES;
    _color = color;
}

- (void)setFontName:(NSString*)fontName
{
    _dirty = YES;
    _fontName = fontName;
}

- (void)setFontSize:(NSUInteger)fontSize
{
    _dirty = YES;
    _fontSize = fontSize;
}

- (void)setFontItalic:(BOOL)fontItalic
{
    _dirty = YES;
    _fontItalic = fontItalic;
}

- (void)setFontBold:(BOOL)fontBold
{
    _dirty = YES;
    _fontBold = fontBold;
}

+ (void)setFont:(MNFont*)font
{
    MNLogNotYetImlemented();
    abort();
}

+ (void)setBold:(BOOL)bold
{
    MNLogNotYetImlemented();
    abort();
}

+ (void)setItalic:(BOOL)italic
{
    MNLogNotYetImlemented();
    abort();
}

+ (void)setColor:(MNColor*)color
{
    MNLogNotYetImlemented();
    abort();
}

+ (void)showBoundingBox:(BOOL)showBoundingBox
{
    _showBoundingBox = showBoundingBox;
}

#pragma mark - Methods

+ (void)drawBoundingBox:(CGContextRef)ctx title:(NSAttributedString*)title point:(MNPoint*)point
{
    if(_showBoundingBox)
    {
        MNBoundingBox* bb =
            [MNBoundingBox boundingBoxAtX:point.x atY:point.y withWidth:title.size.width andHeight:title.size.height];
        [bb draw:ctx];
    }
}

+ (void)drawBoundingBox:(CGContextRef)ctx title:(NSAttributedString*)title rect:(CGRect)rect
{
    if(_showBoundingBox)
    {
        MNBoundingBox* bb = [MNBoundingBox boundingBoxWithRect:rect];
        [bb draw:ctx];
    }
}

+ (NSAttributedString*)getAttributedStringWith:(MNFont*)font text:(id)text
{
    NSString* str = @"";
    NSAttributedString* title = nil;
    if([text isKindOfClass:[NSAttributedString class]])
    {
        //        str = ((NSAttributedString*)text).string;
        title = text;
    }
    else if([text isKindOfClass:[NSString class]])
    {
        str = text;
        NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = (NSTextAlignment)[[MNText sharedText] alignment];

        NSMutableDictionary* attributesDictionary = [NSMutableDictionary dictionary];
        [attributesDictionary addEntriesFromDictionary:@{
            NSParagraphStyleAttributeName : paragraphStyle,
            NSFontAttributeName : font.font,
            NSForegroundColorAttributeName : font.fillColor,
        }];
        if(font.backColor)
        {
            [attributesDictionary addEntriesFromDictionary:@{
                NSBackgroundColorAttributeName : font.backColor,
            }];
        }
        if(font.strokeColor)
        {
            [attributesDictionary addEntriesFromDictionary:@{
                NSStrokeColorAttributeName : font.strokeColor,
                NSStrokeWidthAttributeName : [NSNumber numberWithFloat:-4.0],
            }];
        }

        title = [[NSAttributedString alloc] initWithString:str attributes:attributesDictionary];
    }
    else
    {
        MNLogError(@"ExpectedNSStringTypeException, Text must be either a NSString* or NSAttributedString*");
    }
    return title;
}

+ (void)drawText:(CGContextRef)ctx atPoint:(MNPoint*)point withText:(id)text
{
    MNFont* font = [MNFont fontWithName:@"times" size:12];
    [MNText drawText:ctx withFont:font atPoint:point withText:text];
}

+ (void)drawText:(CGContextRef)ctx withFont:(MNFont*)font atPoint:(MNPoint*)point withText:(id)text
{
    //    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    //    paragraphStyle.alignment = (NSTextAlignment)[[MNText sharedText] alignment];
    //
    //    NSAttributedString* title = [[NSAttributedString alloc]
    //        initWithString:text
    //            attributes:@{NSParagraphStyleAttributeName : paragraphStyle, NSFontAttributeName : font.font}];
    NSAttributedString* title = [self getAttributedStringWith:font text:text];

    [title drawAtPoint:point.CGPoint];

    [self drawBoundingBox:ctx title:title point:point];
}

+ (void)drawText:(CGContextRef)ctx withFont:(MNFont*)font atRect:(CGRect)rect withText:(id)text
{
    NSAttributedString* title = [self getAttributedStringWith:font text:text];

    if([[MNText sharedText] verticalAlignment] == MNTextAlignmentTop)
    {
        [title drawInRect:rect];
    }
    else if([[MNText sharedText] verticalAlignment] == MNTextAlignmentMiddle)
    {
        [title drawInRect:CGRectMake(rect.origin.x, CGRectGetMidY(rect) - title.size.height / 2, rect.size.width,
                                     rect.size.height)];
    }
    else
    {
        [title drawInRect:CGRectMake(rect.origin.x, CGRectGetMaxY(rect) - title.size.height, rect.size.width,
                                     rect.size.height)];
    }

    [self drawBoundingBox:ctx title:title rect:rect];
}

+ (CGSize)measureText:(id)text withFont:(MNFont*)font
{
    NSString* str = @"";
    if([text isKindOfClass:[NSAttributedString class]])
    {
        str = ((NSAttributedString*)text).string;
    }
    else if([text isKindOfClass:[NSString class]])
    {
        str = text;
    }
    else
    {
        MNLogError(@"ExpectedNSStringTypeException, Text must be either a NSString* or NSAttributedString*");
    }

    NSAttributedString* title =
        [[NSAttributedString alloc] initWithString:str attributes:@{NSFontAttributeName : font.font}];
    return title.size;
}

@end

@implementation MNLoremIpsum

static NSArray<NSString*>* _words;

+ (NSArray<NSString*>*)words
{
    if(!_words)
    {
        _words = [@"lorem,ipsum,dolor,sit,amet,consectetuer,adipiscing,elit," @"integer,in,mi,a,mauris,"
            @"ornare,sagittis,suspendisse,potenti,suspendisse,dapibus,dignissim," @"dolor,nam,"
            @"sapien,tellus,tempus,et,tempus,ac,tincidunt,in,arcu," @"duis,dictum,proin,magna,"
            @"nulla,pellentesque,non,commodo,et,iaculis,sit,amet,mi,mauris," @"condimentum,massa,"
            @"ut,metus,donec,viverra,sapien,mattis,rutrum," @"tristique,lacus,eros,semper,tellus,"
            @"et,molestie,nisi,sapien,eu,massa,vestibulum,ante,ipsum,primis,in," @"faucibus,orci,"
            @"luctus,et,ultrices,posuere,cubilia,curae;,fusce," @"erat,tortor,mollis,ut,accumsan,"
            @"ut,lacinia,gravida,libero,curabitur,massa,felis,accumsan,feugiat," @"convallis,sit,"
            @"amet,porta,vel,neque,duis,et,ligula,non,elit," @"ultricies,rutrum,suspendisse,"
            @"tempor,quisque,posuere,malesuada,velit,sed,pellentesque,mi,a,purus," @"integer,"
            @"imperdiet,orci,a,eleifend,mollis,velit,nulla,iaculis," @"arcu,eu,rutrum,magna,quam,"
            @"sed,elit,nullam,egestas,integer,interdum,purus,nec,mauris,vestibulum," @"ac,mi,in,"
            @"nunc,suscipit,dapibus,duis,consectetuer,ipsum,et," @"pharetra,sollicitudin,metus,"
            @"turpis,facilisis,magna,vitae,dictum,ligula,nulla,nec,mi,nunc,ante," @"urna,gravida,"
            @"sit,amet,congue,et,accumsan,vitae,magna,praesent," @"luctus,nullam,in,velit,"
            @"praesent,est,curabitur,turpis,class,aptent,taciti,sociosqu,ad,litora," @"torquent,"
            @"per,conubia,nostra,per,inceptos,hymenaeos,cras," @"consectetuer,nibh,in,lacinia,"
            @"ornare,turpis,sem,tempor,massa,sagittis,feugiat,mauris,nibh,non," @"tellus,"
            @"phasellus,mi,fusce,enim,mauris,ultrices,turpis,eu," @"adipiscing,viverra,justo,"
            @"libero,ullamcorper,massa,id,ultrices,velit,est,quis,tortor,quisque," @"condimentum,"
            @"lacus,volutpat,nonummy,accumsan,est,nunc,imperdiet," @"magna,vulputate,aliquet,nisi,"
            @"risus,at,est,aliquam,imperdiet,gravida,tortor,praesent,interdum," @"accumsan,ante,"
            @"vivamus,est,ligula,consequat,sed,pulvinar,eu," @"consequat,vitae,eros,nulla,elit,"
            @"nunc,congue,eget,scelerisque,a,tempor,ac,nisi,morbi,facilisis," @"pellentesque,"
            @"habitant,morbi,tristique,senectus,et,netus,et," @"malesuada,fames,ac,turpis,egestas,"
            @"in,hac,habitasse,platea,dictumst,suspendisse,vel,lorem,ut,ligula," @"tempor,"
            @"consequat,quisque,consectetuer,nisl,eget,elit,proin,quis," @"mauris,ac,orci,"
            @"accumsan,suscipit,sed,ipsum,sed,vel,libero,nec,elit,feugiat,blandit," @"vestibulum,"
            @"purus,nulla,accumsan,et,volutpat,at,pellentesque,vel," @"urna,suspendisse,nonummy,"
            @"aliquam,pulvinar,libero,donec,vulputate,orci,ornare,bibendum," @"condimentum,lorem,"
            @"elit,dignissim,sapien,ut,aliquam,nibh,augue," @"in,turpis,phasellus,ac,eros,"
            @"praesent,luctus,lorem,a,mollis,lacinia,leo,turpis,commodo,sem,in," @"lacinia,mi,"
            @"quam,et,quam,curabitur,a,libero,vel,tellus,mattis," @"imperdiet,in,congue,neque,ut,"
            @"scelerisque,bibendum,libero,lacus,ullamcorper,sapien,quis,aliquet," @"massa,velit,"
            @"vel,orci,fusce,in,nulla,quis,est,cursus,gravida,in," @"nibh,lorem,ipsum,dolor,sit,"
            @"amet,consectetuer,adipiscing,elit,integer,fermentum,pretium,massa," @"morbi,feugiat,"
            @"iaculis,nunc,aenean,aliquam,pretium,orci,cum," @"sociis,natoque,penatibus,et,magnis,"
            @"dis,parturient,montes,nascetur,ridiculus,mus,vivamus,quis,tellus,vel," @"quam,"
            @"varius,bibendum,fusce,est,metus,feugiat,at,porttitor,et," @"cursus,quis,pede,nam,ut,"
            @"augue,nulla,posuere,phasellus,at,dolor,a,enim,cursus,vestibulum,duis," @"id,nisi,"
            @"duis,semper,tellus,ac,nulla,vestibulum,scelerisque," @"lobortis,dolor,aenean,a,"
            @"felis,aliquam,erat,volutpat,donec,a,magna,vitae,pede,sagittis," @"lacinia,cras,"
            @"vestibulum,diam,ut,arcu,mauris,a,nunc,duis," @"sollicitudin,erat,sit,amet,turpis,"
            @"proin,at,libero,eu,diam,lobortis,fermentum,nunc,lorem,turpis," @"imperdiet,id,"
            @"gravida,eget,aliquet,sed,purus,ut,vehicula,laoreet," @"ante,mauris,eu,nunc,sed,sit,"
            @"amet,elit,nec,ipsum,aliquam,egestas,donec,non,nibh,cras,sodales," @"pretium,massa,"
            @"praesent,hendrerit,est,et,risus,vivamus,eget,pede," @"curabitur,tristique,"
            @"scelerisque,dui,nullam,ullamcorper,vivamus,venenatis,velit,eget,enim," @"nunc,eu,"
            @"nunc,eget,felis,malesuada,fermentum,quisque,magna," @"mauris,ligula,felis,luctus,a,"
            @"aliquet,nec,vulputate,eget,magna,quisque,placerat,diam,sed,arcu," @"praesent,"
            @"sollicitudin,aliquam,non,sapien,quisque,id,augue,class," @"aptent,taciti,sociosqu,"
            @"ad,litora,torquent,per,conubia,nostra,per,inceptos,hymenaeos,etiam," @"lacus,lectus,"
            @"mollis,quis,mattis,nec,commodo,facilisis,nibh,sed," @"sodales,sapien,ac,ante,duis,"
            @"eget,lectus,in,nibh,lacinia,auctor,fusce,interdum,lectus,non,dui," @"integer,"
            @"accumsan,quisque,quam,curabitur,scelerisque,imperdiet," @"nisl,suspendisse,potenti,"
            @"nam,massa,leo,iaculis,sed,accumsan,id,ultrices,nec,velit,suspendisse," @"potenti,"
            @"mauris,bibendum,turpis,ac,viverra,sollicitudin,metus," @"massa,interdum,orci,non,"
            @"imperdiet,orci,ante,at,ipsum,etiam,eget,magna,mauris,at,tortor,eu," @"lectus,"
            @"tempor,tincidunt,phasellus,justo,purus,pharetra,ut," @"ultricies,nec,consequat,vel,"
            @"nisi,fusce,vitae,velit,at,libero,sollicitudin,sodales,aenean,mi," @"libero,ultrices,"
            @"id,suscipit,vitae,dapibus,eu,metus,aenean," @"vestibulum,nibh,ac,massa,vivamus,"
            @"vestibulum,libero,vitae,purus,in,hac,habitasse,platea,dictumst," @"curabitur,"
            @"blandit,nunc,non,arcu,ut,nec,nibh,morbi,quis,leo,vel," @"magna,commodo,rhoncus,"
            @"donec,congue,leo,eu,lacus,pellentesque,at,erat,id,mi,consequat," @"congue,praesent,"
            @"a,nisl,ut,diam,interdum,molestie,fusce,suscipit," @"rhoncus,sem,donec,pretium,"
            @"aliquam,molestie,vivamus,et,justo,at,augue,aliquet,dapibus," @"pellentesque,felis,"
            @"morbi,semper,in,venenatis,imperdiet,neque," @"donec,auctor,molestie,augue,nulla,id,"
            @"arcu,sit,amet,dui,lacinia,convallis,proin,tincidunt,proin,a,ante," @"nunc,imperdiet,"
            @"augue,nullam,sit,amet,arcu,quisque,laoreet," @"viverra,felis,lorem,ipsum,dolor,sit,"
            @"amet,consectetuer,adipiscing,elit,in,hac,habitasse,platea,dictumst," @"pellentesque,"
            @"habitant,morbi,tristique,senectus,et,netus,et," @"malesuada,fames,ac,turpis,egestas,"
            @"class,aptent,taciti,sociosqu,ad,litora,torquent,per,conubia,nostra," @"per,inceptos,"
            @"hymenaeos,nullam,nibh,sapien,volutpat,ut,placerat," @"quis,ornare,at,lorem,class,"
            @"aptent,taciti,sociosqu,ad,litora,torquent,per,conubia,nostra,per," @"inceptos,"
            @"hymenaeos,morbi,dictum,massa,id,libero,ut,neque," @"phasellus,tincidunt,nibh,ut,"
            @"tincidunt,lacinia,lacus,nulla,aliquam,mi,a,interdum,dui,augue,non," @"pede,duis,"
            @"nunc,magna,vulputate,a,porta,at,tincidunt,a,nulla,praesent,facilisis,"
            @"suspendisse,sodales,feugiat,purus,cras,et,justo,a,mauris,mollis," @"imperdiet,morbi,"
            @"erat,mi,ultrices,eget,aliquam,elementum,iaculis," @"id,velit,in,scelerisque,enim,"
            @"sit,amet,turpis,sed,aliquam,odio,nonummy,ullamcorper,mollis,lacus," @"nibh,tempor,"
            @"dolor,sit,amet,varius,sem,neque,ac,dui,nunc,et,est," @"eu,massa,eleifend,mollis,"
            @"mauris,aliquet,orci,quis,tellus,ut,mattis,praesent,mollis," @"consectetuer,quam,"
            @"nulla,nulla,nunc,accumsan,nunc,sit,amet," @"scelerisque,porttitor,nibh,pede,lacinia,"
            @"justo,tristique,mattis,purus,eros,non,velit,aenean,sagittis,commodo," @"erat,"
            @"aliquam,id,lacus,morbi,vulputate,vestibulum,elit" componentsSeparatedByString:@","];
    }
    return _words;
}

- (id)init
{
    if((self = [super init]))
    {
    }
    return self;
}

- (NSString*)randomWord
{
    NSUInteger randomIndex = random() % [_words count];
    return [_words objectAtIndex:randomIndex];
}

- (NSString*)words:(NSUInteger)count
{
    if(count == 0)
        return @"";

    NSString* words;
    @autoreleasepool
    {
        NSString* collectedWords = [self randomWord];
        for(NSUInteger i = 0; i < count; i++)
        {
            collectedWords = [collectedWords stringByAppendingString:@" "];
            collectedWords = [collectedWords stringByAppendingString:[self randomWord]];
        }

        words = [collectedWords copy];
    }

    return words;
}

- (NSString*)sentences:(NSUInteger)count
{
    NSMutableString* result = [NSMutableString string];
    for(NSUInteger i = 0; i < count; i++)
    {
        long numberOfWords = random() % 10 + 10;   // range from 10-20 words
        NSMutableString* sentence = [[self words:numberOfWords] mutableCopy];
        NSString* firstChar = [sentence substringWithRange:NSMakeRange(0, 1)];
        firstChar = [firstChar uppercaseString];
        [sentence replaceCharactersInRange:NSMakeRange(0, 1) withString:firstChar];
        [result appendString:sentence];

        if(i + 1 == count)
        {   // last sentence
            [result appendString:@"."];
        }
        else
        {
            [result appendString:@". "];
        }
    }
    return result;
}

@end

@implementation NSString (MNSize)

- (CGSize)attributedSizeWithFont:(MNFont*)font
{
    return [self attributedSizeWithFont:font maxWidth:CGFLOAT_MAX];
}

- (CGSize)attributedSizeWithFont:(MNFont*)font maxWidth:(CGFloat)width
{
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByWordWrapping;
    NSAttributedString* attributedText =
        [[NSAttributedString alloc] initWithString:self
                                        attributes:@{
                                            NSFontAttributeName : font,
                                            NSForegroundColorAttributeName : MNColor.blackColor,
                                            NSParagraphStyleAttributeName : style
                                        }];

#if TARGET_OS_IPHONE
    // TODO: this is unnecessary
    //    CGRect textRect = CGRectZero;   // [attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
    //                                    //               options:(NSStringDrawingUsesLineFragmentOrigin)];
    CGRect textRect = CGRectMake(0, 0, attributedText.size.width, attributedText.size.height);
#elif TARGET_OS_MAC
    CGRect textRect = [attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                                   options:(NSStringDrawingUsesLineFragmentOrigin)];
#endif

    CGSize size = textRect.size;
    size.height = ceilf(size.height);
    size.width = ceilf(size.width);

    return size;
}
@end
