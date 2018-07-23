//
//  LoginViewController.swift
//  kakaogram
//
//  Created by UramMyeongbu on 2018. 7. 21..
//  Copyright © 2018년 myeongbu. All rights reserved.
//

import UIKit
import WebKit
import Alamofire

class LoginViewController: UIViewController {
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView.navigationDelegate = self;
//        removeAllData()
        signInRequest()
        // Do any additional setup after loading the view.
    }
}

extension LoginViewController {
    func removeAllData() {
        WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { (records) in
            for record in records {
                WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {
                })
            }
        }
    }
    
    func signInRequest()
    {
        let urlString = String(format: "%@?client_id=%@&response_type=token&redirect_uri=%@&scope=%@&DEBUG=true", arguments:
            [INSTAGRAM_IOS.AUTHURL,INSTAGRAM_IOS.CLIENTID,INSTAGRAM_IOS.REDIRECTURL,INSTAGRAM_IOS.SCOPE])
        
        if let url = URL.init(string: urlString) {
            var request = URLRequest.init(url: url)
            request.cachePolicy = .reloadIgnoringCacheData
            webView.load(request)
        }
    }
    
    func checkRequestForCallBackUrl(request: URLRequest) -> Void
    {
        guard let URLString = request.url?.absoluteString else { return }
        
        if URLString.hasPrefix(INSTAGRAM_IOS.REDIRECTURL)
        {
            let range : Range<String.Index> = URLString.range(of: "#access_token=")!
            
            INSTAGRAM_IOS.ACCESSTOKEN = String(URLString[range.upperBound...])
            
            let viewController = self.storyboard?.instantiateViewController(withIdentifier: "ViewController")
            self.navigationController?.pushViewController(viewController!, animated: true)
            
        }
    }
}

extension LoginViewController : WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        if (navigationAction.navigationType == .linkActivated){
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
        
        checkRequestForCallBackUrl(request: navigationAction.request)
    }
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        indicator.isHidden = false
        indicator.startAnimating()
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        indicator.isHidden = true
        indicator.stopAnimating()
    }
}
