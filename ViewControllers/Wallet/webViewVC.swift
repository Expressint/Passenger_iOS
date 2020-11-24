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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        UtilityClass.showACProgressHUD()
        setNavBarWithBack(Title: headerName, IsNeedRightButton: true)
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
    
    
    
    
    @IBOutlet weak var webView: WKWebView!
    
    
    
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UtilityClass.hideACProgressHUD()
    }
    
    
}
