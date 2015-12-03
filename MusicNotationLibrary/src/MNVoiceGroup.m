//
//  MNVoiceGroup.m
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

#import "MNVoiceGroup.h"

@interface MNVoiceGroup ()

@property (strong, nonatomic) NSMutableArray* voices;
@property (strong, nonatomic) NSMutableArray* modiferContexts;

- (instancetype)initWithDictionary:(NSDictionary*)optionsDict NS_DESIGNATED_INITIALIZER;

@end

@implementation MNVoiceGroup

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
    self = [self initWithDictionary:@{}];
    if(self)
    {
        [self setupVoiceGroup];
    }
    return self;
}

- (void)setupVoiceGroup
{
    _voices = [[NSMutableArray alloc] init];
    _modiferContexts = [[NSMutableArray alloc] init];
}

- (NSMutableDictionary*)propertiesToDictionaryEntriesMapping
{
    NSMutableDictionary* propertiesEntriesMapping = [super propertiesToDictionaryEntriesMapping];
    //        [propertiesEntriesMapping addEntriesFromDictionaryWithoutReplacing:@{@"virtualName" : @"realName"}];
    return propertiesEntriesMapping;
}

/*
Vex.Flow.VoiceGroup.prototype.init = function(time, voiceGroup) {
    self.voices = [];
    self.modifierContexts = [];
}
*/

#pragma mark - Properties

- (NSMutableArray*)voices
{
    if(!_voices)
    {
        _voices = [[NSMutableArray alloc] init];
    }
    return _voices;
}

- (NSMutableArray*)modiferContexts
{
    if(!_modiferContexts)
    {
        _modiferContexts = [[NSMutableArray alloc] init];
    }
    return _modiferContexts;
}

/*
// Every tickable must be associated with a voiceGroup. This allows formatters
// and preformatters to associate them with the right modifierContexts.
Vex.Flow.VoiceGroup.prototype.getVoices = function() {
    return self.voices;
}
 */

#pragma mark - Methods

- (void)addVoices:(NSArray*)objects
{
    [self.voices addObjectsFromArray:objects];
}

- (void)addVoice:(MNVoice*)voice
{
    [self.voices addObject:voice];
}

/*
Vex.Flow.VoiceGroup.prototype.addVoice = function(voice) {
    if (!voice) throw new Vex.RERR("BadArguments", "Voice cannot be null.");
    self.voices.push(voice);
    voice.setVoiceGroup(this);
}
 */

/*
Vex.Flow.VoiceGroup.prototype.getModifierContexts = function() {
    return self.modifierContexts;
}
 */

@end
