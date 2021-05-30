//
//  ViewController.swift
//  WebView
//
//  Created by deng on 2021/5/28.
//

import UIKit
import WebKit

class ViewController: UIViewController {
    private var webView: WKWebView!
    private let messageName = "native"

    override func viewDidLoad() {
        super.viewDidLoad()
        setupWebview()
        makeUI()
        loadWebview()
    }

    private func setupWebview() {
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = true
        let config = WKWebViewConfiguration()
        config.preferences = preferences
        config.userContentController.add(self, name: messageName)
        webView = WKWebView(frame: .zero, configuration: config)
    }

    private func makeUI() {
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
    }

    private func loadWebview() {
        if let url = Bundle.main.url(forResource: "index", withExtension: "html") {
            webView.load(URLRequest(url: url))
        }
    }
}

extension ViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        if message.name == messageName {
            print("JavaScript is sending a message \(message.body)")
            try? jsCallback()  // 回调 JS 函数
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

