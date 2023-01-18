//
//  WebKitViewController.swift
//  The News Explorer
//
//  Created by bjit on 18/1/23.
//

import UIKit
import WebKit

class WebKitViewController: UIViewController {
    var newsUrl: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        let webView = WKWebView(frame: view.bounds)
        view.addSubview(webView)
        guard let url = URL(string: newsUrl ?? "") else { return }
        webView.load(URLRequest(url: url))

    }
    

}
