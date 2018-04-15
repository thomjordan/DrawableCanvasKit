//
//  Extensions.swift
//  DrawableCanvasKit
//
//  Created by Thom Jordan on 10/28/17.
//  Copyright © 2017 Thom Jordan. All rights reserved.
//

import Foundation
import WebKit


public extension WKUserContentController {
    
    public func addJSUserScript(_ url: URL) {
        guard let str = try? String(contentsOf: url) else { return }
        self.addUserScript(WKUserScript(source: str, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
    }
    
    public func addJSUserScript(_ str: String) {
        self.addUserScript(WKUserScript(source: str, injectionTime: .atDocumentEnd, forMainFrameOnly: false))
    }
}


public extension WKWebView {
    
    public func addHTMLUserScript(_ url: URL) {
        guard let html = try? String(contentsOf: url) else { return }
        self.loadHTMLString(html, baseURL: nil)
    }
    
    public func addHTMLUserScript(_ html: String) {
        self.loadHTMLString(html, baseURL: nil)
    }
}



