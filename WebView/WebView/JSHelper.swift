//
//  JSHelper.swift
//  WebView
//
//  Created by deng on 2021/6/5.
//

import Foundation
import WebKit

class JSHelper: NSObject {
    var functions: [JSFunction] = []
    weak var webView: WKWebView?

    func addFunction(name: String,
                     numberOfParams: Int,
                     handler: ((WKScriptMessage) -> Void)?,
                     evaluateName: String? = nil) {
        functions.append(.init(name: name,
                               numberOfParams: numberOfParams,
                               handler: handler,
                               evaluateName: evaluateName))
    }

    func registerHandlers() {
        for function in functions {
            webView?.configuration.userContentController
                .add(self, name: function.name)
        }
    }

    func deregesterHandlers() {
        for function in functions {
            webView?.configuration.userContentController
                .removeScriptMessageHandler(forName: function.name)
        }
    }

    deinit { deregesterHandlers() }

    func registerJS(handler: ((Any?, Error?) -> Void)? = nil)  {
        guard functions.count > 0 else { return }
        let jsFuncs = functions.map { $0.buildString() }.joined(separator: " ")
        let js = "(function() { \(jsFuncs) })();"
        webView?.evaluateJavaScript(js, completionHandler: handler)
    }

    func evaluateJS(name: String,
                    arguments: [CVarArg]?,
                    handler: ((Any?, Error?) -> Void)? = nil) {
        let argString = (arguments ?? []).map { String(describing: $0) }.joined(separator: ", ")
        webView?.evaluateJavaScript(name + "(\(argString)", completionHandler: handler)
    }

}

extension JSHelper: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        for function in functions
        where message.name == function.name {
            function.handler?(message)
        }
    }
}

// MARK: -

class JSFunction {
    var name: String
    var numberOfParams: Int
    var handler: ((WKScriptMessage) -> Void)?
    var evaluateName: String?

    init(name: String,
         numberOfParams: Int,
         handler: ((WKScriptMessage) -> Void)?,
         evaluateName: String?) {
        self.name = name
        self.numberOfParams = numberOfParams
        self.handler = handler
        self.evaluateName = evaluateName
    }

    func buildString() -> String {
        var signParam = ""
        var callParam = "{}"
        if numberOfParams > 0 {
            var params = [String]()
            for i in 0..<numberOfParams {
                params.append("p\(i)")
            }
            signParam = params.joined(separator: ", ")
            callParam = "[\(signParam)]"
        }
        return """
            window.Object.\(name) = function(\(signParam)) {
                window.webkit.messageHandlers.\(name).postMessage(\(callParam));
            };
        """
    }
}

