//
//  WebKit.swift
//  MyTractice
//
//  Created by Ganesh on 31/03/20.
//  Copyright © 2020 Krishan Kumar. All rights reserved.
//

import UIKit
import WebKit
import SVProgressHUD

class WebKit: UIView,WKNavigationDelegate,WKUIDelegate {
    
    var strUrl=""
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.navigationDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false
        return webView
    }()
    
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        
    }
    
    
    
    func setupUI(strUrl:String) {
        self.strUrl =  strUrl
        self.addSubview(webView)
       
        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: self.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor
                .constraint(equalTo: self.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor
                .constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor),
            webView.rightAnchor
                .constraint(equalTo: self.safeAreaLayoutGuide.rightAnchor)
        ])
        
        if let url = URL(string: strUrl) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        
    }
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        Utility.showHud()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        Utility.DismissHud()
        
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        Utility.DismissHud()
    }
    
}
 
