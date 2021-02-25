<p align="center">
<img src="https://raw.githubusercontent.com/KevinPeplinski/BlastText/main/images/logo.png" alt="BlastText" title="BlastText" width="450"/>
</p>

<p align="center">
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-supported-red"></a>
<a href="https://raw.githubusercontent.com/KevinPeplinski/BlastText/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-lightgrey"></a>
<img src="https://img.shields.io/badge/platform-ios%20%7C%C2%A0tvos%20%7C%20osx%20%7C%20watchos-lightgrey">
</p>

BlastText is an SwiftUI View to separates text in order to facilitate typographic manipulation. BlastText is highly inspired by <a href="https://github.com/julianshapiro/blast">Blast.js</a>

## Requirements

- iOS 13.0+ / macOS 10.15+ / tvOS 13.0+ / watchOS 6.0+
- Swift 5.1+

## Installation

### Swift Package Manager
The [Swift Package Manager](https://swift.org/package-manager/) is a tool for managing the distribution of Swift code. It’s integrated with the Swift build system to automate the process of downloading, compiling, and linking dependencies.

#### Add dependency to Package
Once you have your Swift package set up, adding BlastText as a dependency is as easy as adding it to the dependencies value of your Package.swift.

```swift
dependencies: [
    .package(url: "https://github.com/KevinPeplinski/BlastText.git", .upToNextMajor(from: "1.0.0"))
]
```
#### Add dependency via Xcode 
- File > Swift Packages > Add Package Dependency
- Add `https://github.com/KevinPeplinski/BlastText.git`
- Select "Up to Next Major" with "1.0.0"

### Manually 
You can also integrate `BlastText` into your project manually. Simply copy the `Sources/BlastText` folder into your Xcode project.  

## Usage

First, add `import BlastText` on every swift file you would like to use BlastText.

### BlastText View
To blast a text, `BlastText` needs two important pieces of information. One is the text to be blasted and the other is a delimiter which defines which rule should be applied for blasting. 
Five different delimiter are offered: 
- `.all`
- `.character`
- `.word` (default if no specific delimiter is provided)
- `.sentence`
- `custom(regex: String)` 

The difference between `.all` and `.character` is that `.all` treats spaces as individual parts, while `.character` treats trailing spaces as part of the character before it. 

#### Blasts "Hello World!" by word
```swift
BlastText("Hello World!")
```
#### Blasts "Hello World!" by character
```swift
BlastText("Hello World!", delimiter: .character)
```
#### Blasts "Hello World!" by a custom delimiter
You can provide a custom regex to blast the text by whatever ruleset you wish. In this example the regex is a capturing group that matches every single "l". The displayed text would be "lll", because there are exactly three small l within "Hello World". 
```swift
BlastText("Hello World!", delimiter: .custom(regex: "(l)"))
```
The default initializer for `BlastText` tries to mimic `Text` handling of `LocalizedStringKey`. Each text is therefore considered a LocalizedStringKey and is localized accordingly before output. However, if the text is not to be localized, then the verbatim initializer should be used. 
```swift
BlastText(verbatim: "Hello World!") // Displays the string "Hello World!" in any locale
```

### Blast Modifier
There is also the posibility to blast an existing `Text` View via the `.blast()` modifier. All modifiers that have been applied to the `Text` before the `.blast()`  modifier will be ignored. All delimiters are supported (default: `.word`). 
The `.blast()` modifier accesses the underling text value of `Text` via reflection, which then is used to initialize the `BlastText` View. 

I would not recommend this for production!
```swift
Text("Hello World!")
    .blast()
    
Text("Hello World!")
    .blast(.character)
```

### Segment Modifier
`BlastText` blasts the text value into small segments that can then be customized to your liking. Simply apply the `.segmentModifier()` to your `BlastText` and pass the desired modifier to be applied to each segment.   

```swift
BlastText("Hello World!")
    .segmentModifier(...)
```

## Examples 

### BlastText Logo

<img src="https://raw.githubusercontent.com/KevinPeplinski/BlastText/main/images/logo.png" alt="BlastText" title="BlastText" width="330"/>

```swift
import SwiftUI 
import BlastText

struct ContentView: View {
    var body: some View {
        BlastText(verbatim: "BLASTTEXT", delimeter: .character)
            .segmenModifier(CircularBackground())
    }
}

struct CircularBackground: ViewModifier {
    
    let colors: [Color] = [.red, .blue, .green, .orange, .purple, .pink, .yellow]
    
    func body(content: Content) -> some View {
        content
            .foregroundColor(.white)
            .padding()
            .background(colors.randomElement())
            .clipShape(Circle())
    }
}
```
