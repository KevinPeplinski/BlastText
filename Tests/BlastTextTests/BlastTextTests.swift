import XCTest
import SwiftUI
@testable import BlastText

final class BlastTextTests: XCTestCase {
    
    let stringToBlast = "Lorem ipsum dolor sit amet, voluptua. At et ea rebum."
    
    func testBlastTextWithAllDelimiter() {
        let blastSegmentsValues = BlastText(verbatim: stringToBlast, delimiter: .all).blastSegments.map {
            $0.value
        }
        
        let expectedResult: [String] = ["L", "o", "r", "e", "m", " ", "i",
                                        "p", "s", "u", "m", " ", "d", "o",
                                        "l", "o", "r", " ", "s", "i", "t",
                                        " ", "a", "m", "e", "t", ",", " ",
                                        "v", "o", "l", "u", "p", "t", "u",
                                        "a", ".", " ", "A", "t", " ", "e",
                                        "t", " ", "e", "a", " ", "r", "e",
                                        "b", "u", "m", "."]
        
        XCTAssertEqual(blastSegmentsValues, expectedResult)
    }
    
    func testBlastTextWithCharacterDelimiter() {
        let blastSegmentsValues = BlastText(verbatim: stringToBlast, delimiter: .character).blastSegments.map {
            $0.value
        }
        
        let expectedResult: [String] = ["L", "o", "r", "e", "m ", "i", "p",
                                        "s", "u", "m ", "d", "o","l", "o",
                                        "r ", "s", "i", "t ", "a", "m", "e",
                                        "t", ", ", "v", "o", "l", "u", "p",
                                        "t", "u", "a", ". ", "A", "t ", "e",
                                        "t ", "e", "a ", "r", "e", "b", "u",
                                        "m", "."]
        
        XCTAssertEqual(blastSegmentsValues, expectedResult)
    }
    
    func testBlastTextWithWordDelimiter() {
        let blastSegmentsValues = BlastText(verbatim: stringToBlast, delimiter: .word).blastSegments.map {
            $0.value
        }
        
        let expectedResult: [String] = ["Lorem ", "ipsum ", "dolor ",
                                        "sit ", "amet, ", "voluptua. ",
                                        "At ", "et ", "ea ", "rebum."]
        
        XCTAssertEqual(blastSegmentsValues, expectedResult)
    }
    
    func testBlastTextWithSentenceDelimiter() {
        let blastSegmentsValues = BlastText(verbatim: stringToBlast, delimiter: .sentence).blastSegments.map {
            $0.value
        }
        
        let expectedResult: [String] = ["Lorem ipsum dolor sit amet, voluptua. ",
                                        "At et ea rebum."]
        
        XCTAssertEqual(blastSegmentsValues, expectedResult)
    }
    
    func testBlastTextWithCustomDelimiter() {
        let blastSegmentsValues = BlastText(verbatim: stringToBlast, delimiter: .custom(regex: "(um)")).blastSegments.map {
            $0.value
        }
        
        let expectedResult: [String] = ["um", "um"]
        
        XCTAssertEqual(blastSegmentsValues, expectedResult)
    }
    
    func testBlastTextWithLocalizedInitializerButNoMatchInLocalizationFileOrNoLocalizationFileProvided() {
        
        let key = LocalizedStringKey("Localized_Key_But_No_Match_In_Localization_File_Or_No_Localization_File_Provided")
        
        let test = BlastText(key, delimiter: .word)
        
        XCTAssertTrue(test.blastSegments[0].value == key.stringValue())
    }

    static var allTests = [
        ("testBlastTextWithAllDelimiter", testBlastTextWithAllDelimiter),
        ("testBlastTextWithCharacterDelimiter", testBlastTextWithCharacterDelimiter),
        ("testBlastTextWithWordDelimiter", testBlastTextWithWordDelimiter),
        ("testBlastTextWithSentenceDelimiter", testBlastTextWithSentenceDelimiter),
        ("testBlastTextWithCustomDelimiter", testBlastTextWithCustomDelimiter),
        ("testBlastTextWithLocalizedInitializerButNoMatchInLocalizationFileOrNoLocalizationFileProvided", testBlastTextWithLocalizedInitializerButNoMatchInLocalizationFileOrNoLocalizationFileProvided)
    ]
}
