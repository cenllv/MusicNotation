
# MusicNotation 0.1

<b>MusicNotation</b> is a
Mac/iOS music notation library for rendering musical scores. 
Based on <a href="https://github.com/0xfe/vexflow">vexflow</a>.

## About

#### Features

- Renders common musical notations including the following
	- notes 
	- staffs
	- time signatures 
	- accidentals
	- and many more
- Simple to use object heirarchy for drawing to **NSView**/**UIView**

## Usage

#### Requirements

- OS X 10.11 (application uses **NSCollectionView**)
- XCode 7
- [COCOAPODS](https://cocoapods.org/)

#### Steps to test application:

1. Clone the repo: `git clone git@github.com:slcott/MusicNotation.git`
2. Install pods: `pod install`
3. Open workspace: `open MusicNotation.xcworkspace`
4. Run target `Notation Catalog`
	- There are two targets:
		1. `Notation Catalog`
		2. `Notation Catalog Mobile`
	- Do not use `Notation Catalog Mobile` which currently has build issues (except to fix cross compilation bugs). 
Use `Notation Catalog` which builds for Mac, not iOS.
5. Choose from sidebar a test. 
	- Suggested tests:
		- `Accidental Test Type` 
		- `AutoBeamFormatting Test Type`
		- `Layer Note Test Type` 
		- `Time Signature Test Type`
		- `Staff Note Test Type`

#### How to use in your Application

- Create a new XCode project
- Copy `lib/`, `fonts/`, and `src/` directories to the project and project directory
- Add optional cocoapod dependencies 
  - `pop`
  - `TheAmazingAudioEngine`
- Modify build settings to match example project 
  - `Other Linker Flags`
- Modify build phases
  - Some files not built using **ARC** set `Compiler Flags` to `-fno-objc-arc`
- Modify `Copy Bundle Resources`
  - Add `font/` and `audio/` resource directories
- Add import directive `#import "MNCore.h"`
- Drawing is done using CoreGraphics. Fastest way to begin drawing is:
  - Create an `NSView`
  - Inside method body `- (void)drawRect:(CGRect)dirtyRect` call MusicNotation library
  - See `test/` directory for example usage of music notation library classes

### Tests Status

| Status    | Count   |
|-----------|---------|
| pass      | 18      |
| almost    | 25      |
| fail      | 5       |
| unknown   | 3       |


| Test                  | Status    | Issues | Demonstration |
|-----------------------|-----------|--------|---------------|
| Accidental            | almost    | order of multiple modifiers different from vexflow  | accidentals |
| Animation             | pass      |  | animation of basic notations |
| Annotation            | pass      |  | annotations for tabs, harmonics, fingerpicking |
| Articulation          | pass      |  | articulations like staccato, accent, marcato, fermata, etc |
| AutoBeamFormatting    | almost    | Guessing Default Beam Groups bug & More Simple Tuplet Auto Beaming bug | auto beams for even/odd, breaks, etc |
| Beam                  | almost    | very minor issues | beams for simple, multi, mixed, insane, tabnotes, complex, etc |
| Bend                  | almost    | down arrow missing, text clobbered, static format method bug | bends for double, reverse, phrase, with release |
| BoundingBox           | pass      |  | bounding box object init and merge |
| Chord                 | almost    | bug with number on left side of bar chart |  |
| Clef                  | almost    | keysignote x posn incorrect | clef start, end small, clef change |
| Curve                 | almost    | beams upside down, thick/thin curve not correct | simple, rounded, thick/thin, top curves |
| Dot                   | almost    | multiple dots clobber | basic and multi-voice |
| Font                  | pass      |  |   |
| Formatter             | fail      | notes clobbered | staff notes, tab notes, multi-staffs |
| GraceNote             | fail      | notes clobbered on left, auto beams failing | grace note basic, with slurs, multi-voices |
| KeyClef               | pass      |  | major/minor clef |
| KeyManager            | unknown   | not rendering | valid/select notes |
| KeySignature          | fail      | cancelled key test incorrect, staff helper missing | key parser, major/minor, cancelled key |
| Layer Note            | almost    |  | click/push calayer note for pop animation & aae audio |
| Modifier              | pass      | not rendering | modifier width, management |
| Music                 | unknown   |  | valid notes, keys, notes, intervals, canonical notes, scales |
| NoteHead              | pass      |  | basic head & bounding box render |
| NotationsGrid         | pass      |  | grid of most basic notations |
| Ornament              | pass      |  | vertically shifted, delayed turns, stacked, w/ accidentals |
| PedalMarking          | almost    |  | pedal for simple, release, depress, text, etc |
| Percussion            | fail      | does not render any notes | percussion clef, notes, basic, snare |
| Rests                 | almost    | minor dot errors, rest x posn errors | rests dotted, auto align beamed, tuplets, single & multi voice |
| Rhythm                | almost    | rests out of place, missing one staff glyph not fully rendered | rhythm draw slash, beamed, rests, 16th, 32nd, etc  |
| Staff                 | pass      |  | draw basic, vertical bar, mutli bar, barlines, repeats, tempo, single lines, etc |
| StaffConnector        | almost    | minor formatting bugs | connectors single, double , bold, thin brace, bracket, combined, etc |
| StaffHairpin          | almost    | minor note modifier clobber | simple, horizontal, vertical, height |
| StaffLine             | almost    | minor bug with mismatched lines and colors | simple, staffline arrow |
| StaffModifier         | almost    | may be complete | staff draw, vertical bar |
| StaffNote             | almost    | slash notes clobber, tab notes incomplete, modifiers clobber | tick, stem, auto, staffline, width, boundingbox, etc |
| StaffTie              | pass      |  | simple, chord, stem up, no end, no start |
| StringNumber          | almost    | not rendering string numbers, needs test callback optimizing | string number in notation, fred hand finger, etc |
| Strokes               | almost    | incorrect strokes rendering | brush/arpeggiate/etc, multi, notation/tab, etc |
| Table                 | unknown   | n/a | clef, key, etc number constants and ratios, etc |
| TabNote               | almost    | TabNote Stems with Dots error | tick, tabstaff, tickcontext, tabnote, etc |
| TabSlide              | pass      |  | tabslide simple, up, down  |
| TabStaff              | pass      |  | tabstaff draw, bar |
| TabTie                | pass      |  | tabtie, simple, hammerons, pulloffs, tapping, continuous |
| TextBracket           | almost    |  | textbracket simple, styles |
| TextNote              | fail      | not rendering all notations | textnote formatting, super/sub scripts formatting glyphs, crescendo, etc |
| Text                  | pass      |  | drawing basic attributed string text, ns/ui labels |
| ThreeVoice            | almost    | beam placement issues, rest collisions | three voiecs, auto adjust rest, etc |
| TickContext           | pass      | no output | current and tracking tick |
| TimeSignature         | almost    | last test clobbers notations | parser basic, big time sigs |
| Tuning                | almost    |  | tuning standard, return note for fret |
| Tuplet                | almost    | voices out of sync, tuplet ratios render errors, one tuplet ratio incorrect | simple, beamed, ratioed, bottom, etc |
| Vibrato               | almost    | vibrato clobbering bend | simple vibrato, harsh, with bend |
| Voice                 | pass      |  | strict, ignore, full voice |

- **fail:** the test fails by crashing.
- **incomlete:** not coded.
- **works:** the test rendes something, but there are major bugs.
- **almost:** the test renders readable output, but there are minor bugs.
- **pass:** the test has no identifiable bugs.
- **unknown:** the test may not render, but could be complete.

## Coming Later

- Tab notation
- Documentation
- Notation Language
- CALayer drawing heirarchy (Layer Note Test is a quick demo using FaceBook's [POP](https://github.com/facebook/pop) layer animation library)
- Test application options
- Core Audio support

## We Want You to help out with this library

<img src="img/uncle_sam.jpg" alt="uncle sam" width="30%;"/>

#### Help Requested for the Following:
- Verify and complete test cases ported from **vexflow** 
  - Open in a browser `MusicNotation/vexflow-master/tests/flow.html` for javascript tests corresponding to this library's ported tests. 
- Fix library bugs revealed by tests.
- Complete library classes, for example: **Chords** or **Vibratos** and others.
- Continue implementing **CALayer** heirarchy of notations. Library supports direct drawing, but there is now some support for drawing using **CAShapeLayer**
- Add support for playing audio using sound fonts. Integrate with **TheAmazingAudioEngine**
- Complete method documentation. Current documentation uses **VVDocumenter** templates.
- Fix cross compilation bugs. Library supports both Mac and iOS.

## Copyright

Copyright (c) Scott Riccardelli 2015
slcott <s.riccardelli@gmail.com> https://github.com/slcott

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
