//
//  Extensions.swift
//  FileHandling
//
//  Created by Thom Jordan on 10/28/17.
//  Copyright © 2017 Thom Jordan. All rights reserved.
//

import Cocoa

/* Example Usage:
 
let relpath = "Application Support/MyCompanyName/MyHybridApp/WebCanvasViews"
let canvasViewsDir = FileManager.default.getURLForUserLibrarySubfolder(at: relpath)

canvasViewsDir?.contents.map {
    print($0.lastPathComponent) ; println()
    $0.contents.filter { $0.isFileType(".js")   }.map { print($0) } ; println()
    $0.contents.filter { $0.isFileType(".html") }.map { print($0) } ; println()
}
*/

public extension URL {
    
    public var isDirectory: Bool? {
    // Using the resourceValues() method you can also easily query other interesting information, like the size of a file or the last modification date.
        do {
            let values = try self.resourceValues(
                forKeys:Set([URLResourceKey.isDirectoryKey])
            )
            return values.isDirectory
        } catch  { return nil }
    }
    
    public func isFileType(_ ext: String) -> Bool {
        guard let isDir = self.isDirectory else { return false }
        let str = ext.without(chars:".")
        return (!isDir) && (self.pathExtension == str)
    }
    
    public var contents: [URL] { // uber-convenient
        guard let results = try? FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: [], options: .skipsHiddenFiles) else {
            return []
        }
        return results
    }
}

public extension String {
    
    public func getPathExtension() -> String {
        return (self as NSString).pathExtension
    }
    
    public func without(chars: String) -> String {
        let okayChars : Set<String.Element> = Set(chars)
        return String(self.filter { !(okayChars.contains($0)) })
    }
}

public extension FileManager {
    
    public var userLibrary: URL? {
        let usrlib = try? self.url(for: .libraryDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
        return usrlib
    }
    
    public func getURLForUserLibrarySubfolder(at subpath: String) -> URL? {
        let result = self.userLibrary?.appendingPathComponent(subpath, isDirectory: true)
        return result
    }
}

