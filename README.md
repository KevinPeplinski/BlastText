<p align="center">
<img src="https://raw.githubusercontent.com/KevinPeplinski/BlastText/main/images/logo.png" alt="BlastText" title="BlastText" width="557"/>
</p>

<p align="center">
<a href="https://swift.org/package-manager/"><img src="https://img.shields.io/badge/SPM-supported-red"></a>
<a href="https://raw.githubusercontent.com/KevinPeplinski/BlastText/main/LICENSE"><img src="https://img.shields.io/badge/license-MIT-lightgrey"></a>
<img src="https://img.shields.io/badge/platform-ios%20%7C%C2%A0tvos%20%7C%20osx%20%7C%20watchos-lightgrey">
</p>

BlastText separates text in order to facilitate typographic manipulation. BlastText is highly inspired by <a href="https://github.com/julianshapiro/blast">Blast.js</a>

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
