
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
| pass      | 47      |
| FAIL      | 3       |
| incomplete| 3       |


| Test                  | Status    | Issues | Demonstration |
|-----------------------|-----------|--------|---------------|
| Accidental            | pass      |  | accidentals |
| Animation             | pass      |  | animation of basic notations |
| Annotation            | pass      |  | annotations for tabs, harmonics, fingerpicking |
| Articulation          | pass      |  | articulations like staccato, accent, marcato, fermata, etc |
| AutoBeamFormatting    | pass      |  | auto beams for even/odd, breaks, etc |
| Beam                  | pass      |  | beams for simple, multi, mixed, insane, tabnotes, complex, etc |
| Bend                  | pass      |  | bends for double, reverse, phrase, with release |
| BoundingBox           | pass      |  | bounding box object init and merge |
| Chord                 | FAIL      | bug with number on left side of bar chart |  |
| Clef                  | pass      |  | clef start, end small, clef change |
| Curve                 | pass      |  | simple, rounded, thick/thin, top curves |
| Dot                   | pass      |  | basic and multi-voice |
| Font                  | pass      |  |   |
| Formatter             | FAIL      | minor issues justification error | staff notes, tab notes, multi-staffs |
| GraceNote             | pass      |  | grace note basic, with slurs, multi-voices |
| KeyClef               | pass      |  | major/minor clef |
| KeyManager            | incomplete| not rendering | valid/select notes |
| KeySignature          | pass      |  | key parser, major/minor, cancelled key |
| Layer Note            | pass      |  | click/push calayer note for pop animation & aae audio |
| Modifier              | pass      |  | modifier width, management |
| Music                 | incomplete|  | valid notes, keys, notes, intervals, canonical notes, scales |
| NoteHead              | pass      |  | basic head & bounding box render |
| NotationsGrid         | pass      |  | grid of most basic notations |
| Ornament              | pass      |  | vertically shifted, delayed turns, stacked, w/ accidentals |
| PedalMarking          | pass      |  | pedal for simple, release, depress, text, etc |
| Percussion            | pass      |  | percussion clef, notes, basic, snare |
| Rests                 | pass      |  | rests dotted, auto align beamed, tuplets, single & multi voice |
| Rhythm                | pass      |  | rhythm draw slash, beamed, rests, 16th, 32nd, etc  |
| Staff                 | pass      |  | draw basic, vertical bar, mutli bar, barlines, repeats, tempo, single lines, etc |
| StaffConnector        | pass      |  | connectors single, double , bold, thin brace, bracket, combined, etc |
| StaffHairpin          | pass      |  | simple, horizontal, vertical, height |
| StaffLine             | pass      |  | simple, staffline arrow |
| StaffModifier         | pass      |  | staff draw, vertical bar |
| StaffNote             | pass      |  | tick, stem, auto, staffline, width, boundingbox, etc |
| StaffTie              | pass      |  | simple, chord, stem up, no end, no start |
| StringNumber          | pass      |  | string number in notation, fred hand finger, etc |
| Strokes               | pass      |  | brush/arpeggiate/etc, multi, notation/tab, etc |
| Table                 | incomplete| n/a | clef, key, etc number constants and ratios, etc |
| TabNote               | pass      |  | tick, tabstaff, tickcontext, tabnote, etc |
| TabSlide              | pass      |  | tabslide simple, up, down  |
| TabStaff              | pass      |  | tabstaff draw, bar |
| TabTie                | pass      |  | tabtie, simple, hammerons, pulloffs, tapping, continuous |
| TextBracket           | pass      |  | textbracket simple, styles |
| TextNote              | pass      |  | textnote formatting, super/sub scripts formatting glyphs, crescendo, etc |
| Text                  | pass      |  | drawing basic attributed string text, ns/ui labels |
| ThreeVoice            | pass      |  | three voiecs, auto adjust rest, etc |
| TickContext           | pass      |  | current and tracking tick |
| TimeSignature         | pass      | passes but needs refactoring | parser basic, big time sigs |
| Tuning                | FAIL      |  | tuning standard, return note for fret |
| Tuplet                | pass      |  | simple, beamed, ratioed, bottom, etc |
| Vibrato               | pass      |  | simple vibrato, harsh, with bend |
| Voice                 | pass      |  | strict, ignore, full voice |


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
