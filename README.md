# DrawableCanvasKit
A WKWebView-hosted Canvas element, along with some convenience methods for injecting and evaluating .js and .html scripts.

Also includes some useful file-handling methods as Swift extensions for URL, String, and FileManager:
 
```Swift
let relpath = "Application Support/MyCompanyName/MyHybridApp/WebCanvasViews"
let canvasViewsDir = FileManager.default.getURLForUserLibrarySubfolder(at: relpath)

canvasViewsDir?.contents.map {
    print($0.lastPathComponent) ; println()
    $0.contents.filter { $0.isFileType(".js")   }.map { print($0) } ; println()
    $0.contents.filter { $0.isFileType(".html") }.map { print($0) } ; println()
}
```
