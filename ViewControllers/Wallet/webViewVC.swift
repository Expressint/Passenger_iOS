//
//  webViewVC.swift
//  TiCKTOC-Driver
//
//  Created by Excelent iMac on 02/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import WebKit
/*

*/
class webViewVC: BaseViewController, WKNavigationDelegate, WKUIDelegate {
    
    var strURL = String()
    var headerName = String()
    @IBOutlet weak var webView: WKWebView!
    var isFromRegister = false
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UtilityClass.showACProgressHUD()
        setNavBarWithBack(Title: headerName, IsNeedRightButton: true)
        webView.navigationDelegate = self
        
        if(isFromRegister)
        {
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.navigationBar.backgroundColor = themeYellowColor

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // if headerName != "" {
        // headerView?.lblTitle.text = headerName
        // }
        
        let url = strURL
        
        let requestURL = URL(string: url)
        let request = URLRequest(url: requestURL! as URL)
        webView.load(request)
        
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if(isFromRegister)
        {
            self.navigationController?.isNavigationBarHidden = true
        }
    }
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UtilityClass.hideACProgressHUD()
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        UtilityClass.hideACProgressHUD()

    }
    
    
}
