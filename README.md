# Word Sleuth

*Word Sleuth* represents the latest generation of word search
games giving you the ability to not only solve the puzzles but also has
an unlimited ability to create new puzzles using either the more than
50 curated word categories, a choice of 10K - 35K built-in common words, 
or create your own categorized word lists.

## Features

* Unlimited puzzles sized from 5x5 to 20x20(iPad/Mac) / 20x12(iPhone) letter grids.
* Created puzzles are randomly generated so no two are ever the same — even from the same word list.
* Puzzle-based timers encourage you to improve your skill level by tracking and reporting on your progress.
* Awards are granted for significant milestones as you progress.
* Points are earned as games are completed — demonstrating your prowess to others.
* Optional hints can get you started more easily or keep you going when stuck.
* Customization of how words are highlighted and the colors that are used.
* More than 50 word categories, each containing at least 50 words or more.
* New puzzle creation using either a single touch or an advanced puzzle-generation interface.
* Puzzles and word lists can be shared with your friends and family.
* Edit existing or create new word lists either by manual entry or text-based word list import.
* Works with iPad, iPhone, or Macs (licensed separately).
* Supports dark mode for late-night puzzle sessions.
* No internet connection required.
* Language support for English, French, German, Italian, Spanish and more.
* No gimmicks, advertisements or solicitation for other games — just pure puzzle fun.

## Examples
Here are screenshots of typical puzzle grids:

```LaTeX
x = \frac{-b \pm \sqrt{b^2-4ac}}{2a}
```

![Quadratic Formula](img/quadratic-light.png#gh-light-mode-only) 
![Quadratic Formula](img/quadratic-dark.png#gh-dark-mode-only) 

## Usage

The library provides a class `MTMathUILabel` which is a `UIView` that
supports rendering math equations. To display an equation simply create
an `MTMathUILabel` as follows:

### Example

The [SwiftMathDemo](https://github.com/mgriebling/SwiftMathDemo) is a SwiftUI version
of the Objective-C demo included in `iosMath` that uses `SwiftMath` as a Swift package dependency.

### Advanced configuration

`MTMathUILabel` supports some advanced configuration options:

##### Math mode

You can change the mode of the `MTMathUILabel` between Display Mode
(equivalent to `$$` or `\[` in LaTeX) and Text Mode (equivalent to `$`
or `\(` in LaTeX). The default style is Display. To switch to Text
simply:

## Future Enhancements

Note this is not a complete implementation of LaTeX math mode. There are

## License

`SwiftMath` is available under the MIT license. See the [LICENSE](./LICENSE)
file for more info.

