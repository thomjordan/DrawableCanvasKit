//
//  DrawableCanvas.swift
//  DrawableCanvasKit
//
//  Created by Thom Jordan on 10/28/17.
//  Copyright © 2017 Thom Jordan. All rights reserved.
//

import Foundation
import WebKit


public protocol MessageHandler {
    var configurer : WKWebViewConfiguration { get }
}

public class DrawableCanvas: NSObject, MessageHandler {
    public let configurer = WKWebViewConfiguration()
    public fileprivate(set) var canvasView : WKWebView!
    public fileprivate(set) var uiFrame    : CGRect!
    
    public var outputRoutines : [Int : (Any) -> Void] = [:]
    
    public init(frame: NSRect) {
        super.init()
        self.uiFrame = frame
        let contentController = WKUserContentController()
        self.configurer.userContentController = contentController
        self.canvasView = WKWebView(frame: self.uiFrame, configuration: self.configurer)
       // addScripts(from: url)
    }
}

extension DrawableCanvas {
    
    public func evaluateJS(_ str: String, completionHandler: ((Any?, Error?) -> Swift.Void)? = nil) {
        canvasView.evaluateJavaScript(str, completionHandler: completionHandler)
    }
    
    public func addJSUserScript(_ url: URL) {
        configurer.userContentController.addJSUserScript(url)
    }
    
    public func addJSUserScript(_ str: String) {
        configurer.userContentController.addJSUserScript(str)
    }
    
    public func addHTMLUserScript(_ url: URL) {
        canvasView.addHTMLUserScript(url)
    }
    public func addHTMLUserScript(_ html: String) {
        canvasView.addHTMLUserScript(html)
    }
}

extension MessageHandler where Self: WKScriptMessageHandler {

    public func addMessageHandler(for msgName: String) {
        configurer.userContentController.add(self, name: msgName)
    }
    
}

extension DrawableCanvas {  /* : CanvasInteractor */
    
    public func processInput(_ innum: Int, _ val: Int) {
        let str : String = "processNextValue(\(innum), \(val))"
        evaluateJS(str) // <-- a 'Command'
        // evaluateJS(str, completionHandler: nil) // <-- a Command with an asynchronous Response
    }
}

extension DrawableCanvas {  /* : CanvasConfigurator */

    public func reifyUserSpecs() {   // add UserSpec parameter?
        //let specsCode = "setNumInputs(\(3));"
        let specsCode = "var numinputs = 3;"
        evaluateJS(specsCode)
    }
    
    public func addScripts(from url: URL) {
        addJSGlobalCode()
        addUserScripts(from: url)
    }
    
    public func setupUI() {
        let runCode = "initCommonSetup(); initCustomSetup();"
        addJSUserScript(runCode)
    }
}


extension DrawableCanvas {
    
    fileprivate func addJSGlobalCode() {
        guard let globalJSCodeURL = Bundle.main.url(forResource: "globalUtils", withExtension: "js") else { return }
        addJSUserScript(globalJSCodeURL)
    }
    
    fileprivate func addUserScripts(from url: URL) {
        let jvsc = url.contents.filter { $0.isFileType(".js")   }
        let html = url.contents.filter { $0.isFileType(".html") }
        for jsURL   in jvsc {   addJSUserScript( jsURL   ) }
        for htmlURL in html { addHTMLUserScript( htmlURL ) }
    }
    
}


//extension DrawableCanvas : WKScriptMessageHandler {
//
//    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
//        let msgname = message.name
//        switch msgname {
//        case "outlet":
//            guard let msgbody = message.body as? [String] else { return }
//            print(msgbody) //outroutine(msgbody)
//        case "defInputs":
//            guard let inputTypes = message.body as? [String] else { return }
//            print(inputTypes) //defInputsCallback(inputTypes.count)
//        case "defOutputs":
//            guard let outputType = message.body as? String else { return }
//            print(outputType) //addOutputCallback?(outputType)
//        default: break  }
//    }
//
//}

