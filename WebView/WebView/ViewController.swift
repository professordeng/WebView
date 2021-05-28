//
//  ViewController.swift
//  WebView
//
//  Created by deng on 2021/5/28.
//

import UIKit
import WebKit

class ViewController: UIViewController {

    let webView = WKWebView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            webView.topAnchor.constraint(equalTo: view.topAnchor),
            webView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            webView.leftAnchor.constraint(equalTo: view.leftAnchor),
            webView.rightAnchor.constraint(equalTo: view.rightAnchor)
        ])
        if let url = URL(string: "https://www.baidu.com") {
            webView.load(URLRequest(url: url))
        }
    }
}

