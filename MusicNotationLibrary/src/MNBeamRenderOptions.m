//
//  MNBeamRenderOptions.m
//  MusicNotation
//
//  Created by Scott Riccardelli on 12/2/15.
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

#import "MNBeamRenderOptions.h"

@implementation MNBeamRenderOptions

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict
{
    self = [super initWithDictionary:optionsDict];
    if(self)
    {
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _beam_width = 0;
        _max_slope = 0;
        _min_slope = 0;
        _slope_iterations = 0;
        _slope_cost = 0;
        _show_stemlets = NO;
        _stemlet_extension = 0;
        _partial_beam_length = 0;
    }
    return self;
}

@end