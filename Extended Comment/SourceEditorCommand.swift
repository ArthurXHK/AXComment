//
//  SourceEditorCommand.swift
//  Extended Comment
//
//  Created by Arthur XU on 21/8/16.
//  Copyright © 2016年 Arthur XU. All rights reserved.
//

import Foundation
import XcodeKit

class SourceEditorCommand: NSObject, XCSourceEditorCommand {
    
    // MARK: - Regex
    let regexForHasComment: NSRegularExpression? = {
        do {
            return try NSRegularExpression(pattern: "^[\\s]*[/]{2,}[\\s]*")
        } catch {
            return nil
        }
    }()
    
    let regexForAddComment: NSRegularExpression? = {
        do {
            return try NSRegularExpression(pattern: "[\\s]*")
        } catch {
            return nil
        }
    }()
    
    let regexForRemoveComment: NSRegularExpression? = {
        do {
            return try NSRegularExpression(pattern: "[/]{2,}[\\s]?")
        } catch {
            return nil
        }
    }()
    
    // MARK: - XCSourceEditorCommand
    /** Perform the action associated with the command using the information in \a invocation. Xcode will pass the code a completion handler that it must invoke to finish performing the command, passing nil on success or an error on failure.
     
     A canceled command must still call the completion handler, passing nil.
     
     \note Make no assumptions about the thread or queue on which this method will be invoked.
     */
    func perform(with invocation: XCSourceEditorCommandInvocation, completionHandler: @escaping (Error?) -> Void) {
        guard
            let regexForHasComment    = regexForHasComment,
            let regexForRemoveComment = regexForRemoveComment,
            let regexForAddComment    = regexForAddComment
            else {
                let error = NSError(domain: "AXCommnet Error", code: 001, userInfo: [NSLocalizedDescriptionKey:"Fail to create regex"])
                completionHandler(error)
                return
        }
        let lines = invocation.buffer.lines
        for selection in invocation.buffer.selections {
            var selectedLines = [Int]()
            var hasComment = false
            let range = selection as! XCSourceTextRange
            for index in range.start.line...range.end.line {
                selectedLines.append(index)
                if !hasComment, let lineStr = lines[index] as? String {
                    hasComment = foundRange(regex: regexForHasComment, inText: lineStr) != nil
                }
            }
            if hasComment {
                for lineIndex in selectedLines {
                    if let lineStr = lines[lineIndex] as? String,
                        let range = foundRange(regex: regexForRemoveComment, inText: lineStr) {
                        let nsString = lineStr as NSString
                        lines[lineIndex] = nsString.replacingCharacters(in: range, with: "")
                    }
                }
            } else {
                var locations = [Int]()
                for lineIndex in selectedLines {
                    if let lineStr = lines[lineIndex] as? String,
                        let range = foundRange(regex: regexForAddComment, inText: lineStr) {
                        locations.append(range.length)
                    }
                }
                if let location = locations.min(by: <) {
                    for lineIndex in selectedLines {
                        if let lineStr = lines[lineIndex] as? NSString {
                            lines[lineIndex] = lineStr.replacingCharacters(in: NSRange(location:location, length:0), with: "// ")
                        }
                    }
                }
            }
        }
        completionHandler(nil)
    }
    
    func foundRange(regex: NSRegularExpression, inText text: String) -> NSRange? {
        return regex.firstMatch(in: text, range: NSRange(location: 0, length: text.characters.count))?.range
    }
    
}
