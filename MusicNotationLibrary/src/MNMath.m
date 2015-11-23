//
//  MNMath.m
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

#import "MNMath.h"

float mnmax(float a, float b)
{
    if(a > b)
    {
        return a;
    }
    else
    {
        return b;
    }
}

float mnmin(float a, float b)
{
    if(a < b)
    {
        return a;
    }
    else
    {
        return b;
    }
}

float mnroundN(float x, float n)
{
    return fmodf(x, n) >= roundf(n / 2.) ? roundf(x / ((float)n) * n + n) : roundf(x / ((float)n)) * ((float)n);
}

float mnmidline(float a, float b)
{
    float mid_line = b + (a - b) / 2.f;
    if(((int)floor(mid_line)) % 2 > 0)
    {
        mid_line = mnroundN((mid_line * 10), 5) / 10;
    }
    //    return (int)mid_line;
    return mid_line;
}
