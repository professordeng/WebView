//
//  ViewController.swift
//  WebView
//
//  Created by deng on 2021/5/28.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    private var webView = WKWebView()
    private let jsHelper = JSHelper()
    override func viewDidLoad() {
        super.viewDidLoad()
        makeUI()
        loadWebview()
    }

    private func makeUI() {
        view.addSubview(webView)
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func loadWebview() {
        jsHelper.webView = webView
        jsHelper.addFunction(name: "sendMessage", numberOfParams: 1) { message in
            print(message.body)
        }
        jsHelper.addFunction(name: "sendJSON", numberOfParams: 1) { message in
            print(message.body)
        }
        jsHelper.registerHandlers()
        jsHelper.registerJS()
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView.load(URLRequest(url: url))
        }
    }

    func jsCallback() throws {
        let funcName = "receiveJSON"
        let perameters = ["parameter" : "value"]
        let data = try JSONEncoder().encode(perameters)
        guard let jsonString = String(data: data, encoding: .utf8) else { return }
        let funcString = funcName + "(" + jsonString + ")"
        webView.evaluateJavaScript(funcString) { result, error in
            if let error = error {
                print(error)
            } else if let result = result {
                print(result)
            }
        }
    }
}

extension ViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        defer { decisionHandler(.allow) }
        guard let urlString = navigationAction.request.url?.absoluteString else { return }
        print(urlString)
    }
}
