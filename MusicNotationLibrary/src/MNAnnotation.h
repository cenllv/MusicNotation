//
//  MNAnnotation.h
//  MusicNotation
//
//  Created by Scott Riccardelli on 1/1/15
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


#import "MNModifier.h"
#import "MNEnum.h"

@class MNNote, MNFont;

/*! 
 *  The `MNAnnotation` class implements text annotations.
 */
@interface MNAnnotation : MNModifier
{
   @private
    MNJustiticationType _justification;
    MNVerticalJustifyType _verticalJustification;
    NSString* _text;
}

#pragma mark - Properties

// Get and set horizontal justification. `justification` is a value in
//@property (assign, nonatomic) MNJustiticationType justification;

//@property (assign, nonatomic) MNVerticalJustifyType vert_justification;
@property (strong, nonatomic) NSString* text;
//@property (strong, nonatomic) MNFont* font;
//@property (assign, nonatomic) MNJustiticationType justification;
//@property (assign, nonatomic) MNVerticalJustifyType vert_justification;

#pragma mark - Methods
- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;
+ (MNAnnotation*)annotationWithText:(NSString*)text;

//+ (BOOL)format:(NSMutableArray*)modifiers state:(MNModifierState*)state;

- (id)setFontName:(NSString*)fontName withSize:(NSUInteger)size;
- (id)setFontName:(NSString*)fontName withSize:(NSUInteger)size withStyle:(NSString*)style;

- (id)setJustification:(MNJustiticationType)justification;
- (id)setVerticalJustification:(MNVerticalJustifyType)verticalJustification;
- (MNJustiticationType)justification;
- (MNVerticalJustifyType)vert_justification;

@end
