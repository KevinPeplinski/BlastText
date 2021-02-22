//
//  BlastText.swift
//
//  Created by Kevin Peplinski on 18.02.21.
//  Copyright © 2021 Kevin Peplinski. All rights reserved.
//

import Foundation
import SwiftUI

// MARK: BlastText
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public struct BlastText: View {
    private let content: String
    private let delimiter: BlastDelimiter

    /// Initializer for `BlastText` that displays the text without localization
    ///
    ///     BlastText("Hello World", delimeter: .word)
    ///     // Displays the string "Hello World" in any locale
    ///
    /// If you want to have localization before blasting the text, use the
    /// ``BlastText/init(:delimeter:)`` initializer instead.
    ///
    /// - Parameters:
    ///   - content: The string to display withput localization
    ///   - delimeter: The delimiter which is responsible for the rule according to which the given content is divided
    public init(verbatim content: String, delimiter: BlastDelimiter = .word) {
        self.content = content
        self.delimiter = delimiter
    }

    public var body: some View {
        HStack(spacing: 0) {
            ForEach(blastSegments) { segment in
                BlastSegmentView(segment: segment)
            }
        }
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension BlastText {

    /// Function that applies a given ViewModifier to each Segment of the `BlastText` View
    func segmenModifier<M: ViewModifier>(_ modifier: M) -> some View {
        HStack(spacing: 0) {
            ForEach(blastSegments) { segment in
                BlastSegmentView(segment: segment, modifier: modifier)
            }
        }
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
internal extension BlastText {
    
    /// Holds the blasted value in a form thats easy to work with in SwiftUI
    struct BlastSegment: Identifiable {
        let id: UUID = UUID()
        let value: String
    }

    /// Simple View to display the content of a given `BlastSegment`
    struct BlastSegmentView<M: ViewModifier>: View {
        let segment: BlastSegment
        let modifier: M

        /// If you dont want to provide an specific `ViewModifier`, use the
        /// ``BlastSegmentView/init(segment:)`` initializer instead.
        ///
        /// - Parameters:
        ///   - segment: An BlastSegment whose data is used to display
        ///   - modifier: an instance of a Type that conforms to ViewModifier, that will be applied to the Text inside the body
        init(segment: BlastSegment, modifier: M) {
            self.segment = segment
            self.modifier = modifier
        }

        /// `BlastSegmentView` has an generic property whose value needs to conform to the`ViewModifier` protocol.
        /// To avoid giving each instance of `BlastSegmentView` a specific `ViewModifier`,
        /// this initializer was implemented which is the default and defines an `EmptyModifier` for the generic property.
        ///
        /// If you want to provide an specific `ViewModifier`, use the
        /// ``BlastSegmentView/init(segment:modifier:)`` initializer instead.
        ///
        /// - Parameter segment: An BlastSegment whose data is used to display
        init(segment: BlastSegment) where M == EmptyModifier {
            self.init(segment: segment, modifier: EmptyModifier())
        }

        var body: some View {
            Text(verbatim: segment.value)
                .modifier(modifier)
        }
    }
}

// MARK: Blasting
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
internal extension String {

    /// Blasts a `String` into pieces for a given `NSRegularExpression`
    /// Only those pieces of the original `String` are returned that match with the regex
    ///
    /// `String` = `"Hallo World"`
    /// `NSRegularExpression` = `#"\s*(\S+)\s*"#`
    ///
    /// `-> ["Hallo", "World"]`
    func blast(for regex: NSRegularExpression) -> [String] {
        let nsrange = NSRange(location: 0, length: self.utf16.count)
        let matches = regex.matches(in: self, options: [], range: nsrange)

        return matches.map {
            self[$0.range]
        }
    }

    /// Get the Substring bases on a given `NSRange`
    subscript(range: NSRange) -> String {

        /// Transform `NSRange` lower and upper Bound to `String.Index`
        let start = index(startIndex, offsetBy: range.lowerBound)
        let end = index(startIndex, offsetBy: range.upperBound)

        return String(self[start..<end])
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
internal extension BlastText {

    /// Computed property that provides the blasted content in a form thats easy to work with in SwiftUI
    var blastSegments: [BlastSegment] {
        content.blast(for: BlastDelimiter.regex(delimiter)).map {
            BlastSegment(value: $0)
        }
    }
}

// MARK: Regular Expressions
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public extension BlastText {

    /// Defines default regex that can be used for blasting the text
    enum BlastDelimiter {
        case all
        case character
        case word
        case sentence
        case custom(regex: String)

        static func regex(_ delimeter: BlastDelimiter) -> NSRegularExpression {
            switch delimeter {
            case .all:

                /// Capturing Group that matches any character
                /// (except for line terminators)
                return NSRegularExpression(#"(.)"#)
            case .character:

                /// Capturing Group that matches any non-whitespace character
                return NSRegularExpression(#"\s*(\S)\s*"#)
            case .word:

                /// Matches strings in between whitespace characters
                return NSRegularExpression(#"\s*(\S+)\s*"#)
            case .sentence:

                /// Matches phrases either ending in Latin alphabet punctuation
                /// or located at the end of the text. (Linebreaks are not considered punctuation.)
                return NSRegularExpression(#"\s*(?=\S)(([.]{2,})?[^!?]+?([.…!?]+|(?=\s+$)|$)(\s*[′’'”″“")»]+)*)\s*"#)
            case .custom(let regex):

                /// Matches a custom regex
                /// The following example would result in only "World" beining displayed:
                ///
                ///     BlastText(
                ///         verbatim: "Hallo World!",
                ///         delimeter: .custom(regex: #"World"#)
                ///     )
                /// - Parameter regex: The regex provided as `String`
                return NSRegularExpression(regex)
            }
        }
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
internal extension NSRegularExpression {

    /// To avoid force unwrapping, heres a conveniecne initializer that either creates a regex correctly or creates an assertion failure
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
}

// MARK: LocalizedStringKey
@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension BlastText {
    
    /// default initializer for `BlastText` that mimics `Text` handling of `LocalizedStringKey`
    ///
    ///     BlastText(LocalizedStringKey(someString), delimeter: .word)
    ///     // Localizes the contents of before beeing blastes by the defined delimeter `someString`
    ///
    /// If you have a string literal that you don't want to localize, use the
    /// ``BlastText/init(verbatim:delimeter:)`` initializer instead.
    ///
    /// - Parameters:
    ///   - content: The key of which the localization is accessed
    ///   - delimeter: The delimiter which is responsible for the rule according to which the given content is divided
    public init(_ content: LocalizedStringKey, delimiter: BlastDelimiter = .word) {
        self.init(verbatim: content.stringValue(), delimiter: delimiter)
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
internal extension LocalizedStringKey {

    /// Computed property that contains the key of the `LocalizedStrinkKey` accessed by the description
    var stringKey: String {
        let description = "\(self)"

        let components = description.components(separatedBy: "key: \"")
            .map { $0.components(separatedBy: "\",") }

        return components[1][0]
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
internal extension String {

    /// Returns Localized String for a given Key/Locale combination if there is a .lproj file in main bundle for the locale
    static func localizedString(for key: String, locale: Locale = .current) -> String? {
        guard let path = Bundle.main.path(forResource: locale.languageCode, ofType: "lproj"),
              let bundle = Bundle(path: path) else {
            return nil
        }

        return NSLocalizedString(key, bundle: bundle, comment: "")
    }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
internal extension LocalizedStringKey {

    /// Returns `String` value of a `LocalizedStringKey` for a given Locale if exists, else returns the Key value of the `LocalizedStringKey`
    func stringValue(locale: Locale = .current) -> String {
        return String.localizedString(for: self.stringKey, locale: locale) ?? self.stringKey
    }
}
