//
//  PesapalWebViewViewController.swift
//  TanTaxi-Driver
//
//  Created by Apple on 10/04/19.
//  Copyright © 2019 Excellent Webworld. All rights reserved.
//

import UIKit
import WebKit

protocol delegatePesapalWebView {
    func didOrderPesapalStatus(status: Bool)
}


class PesapalWebViewViewController: BaseViewController {
    
    @IBOutlet weak var viewForWebView: UIView!
    
    // ----------------------------------------------------
    // MARK: - Globle Declaration Methods
    // ----------------------------------------------------
    var webView: WKWebView!
    var strUrl = String()
    var delegate: delegatePesapalWebView?
    var isFrompastPayment: Bool = false
    
    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progressTintColor = themeYellowColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    deinit {
        webView?.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    
    let successURL = WebserviceURLs.kBasePaymentURL + "payment/success" //"https://www.bookaridegy.com/payment/success"
    let failURL = WebserviceURLs.kBasePaymentURL + "payment/failed" //"https://www.bookaridegy.com/payment/failed"
    
    // ----------------------------------------------------
    // MARK: - Base Methods
    // ----------------------------------------------------
    override func loadView() {
       
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.view.backgroundColor = UIColor.blue
        let webConfiguration = WKWebViewConfiguration()
        
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.navigationDelegate = self
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        webView.backgroundColor = UIColor.blue
        self.view = webView!
        self.viewForWebView = webView!
        
//        self.viewForWebView = webView!
        
//        let url = URL(string: strUrl)!
        let URLTemp = URL.init(string: strUrl)
        webView.load(URLRequest.init(url: URLTemp!))//load(URLRequest(url: URLTemp))
        webView.allowsBackForwardNavigationGestures = true
        setProgressView()
        self.setNavBarWithBack(Title: "Payment".localized, IsNeedRightButton: false)
//        self.navigationItem.title = Title.uppercased().localizedUppercase
        self.navigationController?.navigationBar.barTintColor = themeYellowColor;
        self.navigationController?.navigationBar.tintColor = UIColor.white;
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float((webView?.estimatedProgress)!)
        }
    }
    
    // ----------------------------------------------------
    // MARK: - Custom Methods
    // ----------------------------------------------------
    func setProgressView() {
        [progressView].forEach { self.view.addSubview($0) }
        progressView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        progressView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        if #available(iOS 11.0, *) {
            progressView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        } else {
            // Fallback on earlier versions
        }
        progressView.heightAnchor.constraint(equalToConstant: 2).isActive = true
    }
    
    func showProgressView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 1
        }, completion: nil)
    }
    
    func hideProgressView() {
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseInOut, animations: {
            self.progressView.alpha = 0
        }, completion: nil)
    }
}

extension PesapalWebViewViewController: WKUIDelegate, WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
     //   UtilityClass.showHUD()
        
       self.showProgressView()
        print("didStartProvisionalNavigation: \(String(describing: webView.url?.absoluteString))")
        if (webView.url?.absoluteString == successURL) {
           
            let alert = UIAlertController(title: appName.localized, message: "Payment Success", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.dismiss(animated: true) {
        //                self.delegate?.PayPalPaymentSuccess(paymentID: "\(self.paymentid)")
                    self.delegate?.didOrderPesapalStatus(status: true)
                }
            }
            alert.addAction(ok)
            if((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.presentedViewController != nil)
            {
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                    //                vc.present(alert, animated: true, completion: nil)
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                })
            }
            else {
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        else if webView.url?.absoluteString == (WebserviceURLs.kBasePaymentURL + "payment/failed") { //"https://www.bookaridegy.com/payment/failed"
            
            let alert = UIAlertController(title: appName.localized, message: "Payment failed", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.delegate?.didOrderPesapalStatus(status: false)
                self.dismiss(animated: true, completion: nil)
            }
            alert.addAction(ok)
            if((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.presentedViewController != nil)
            {
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                    //                vc.present(alert, animated: true, completion: nil)
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                })
            }
            else {
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    public func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width'); document.getElementsByTagName('head')[0].appendChild(meta);"
        webView.evaluateJavaScript(jscript)
    }
    
    
    public func webView(_ webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: Error) {
     //   UtilityClass.hideHUD()
        self.hideProgressView()
        print("didFailProvisionalNavigation: \(String(describing: webView.url?.absoluteString))")
        
        //        self.dismissPayPalWebViewController()
        
        //        let next = self.storyboard?.instantiateViewController(withIdentifier: "AlertViewController") as! AlertViewController
        //        next.delegateOfAlertView = self
        //        next.btnCancelisHidden = true
        //        next.strMessage = error.localizedDescription
        //        self.present(next, animated: true, completion: nil)
        
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
      //  UtilityClass.hideHUD()
        self.hideProgressView()
        print("didFinish: \(String(describing: webView.url?.absoluteString))")
        
        if (webView.url?.absoluteString == successURL) {
            
            let alert = UIAlertController(title: appName.localized, message: "Payment Success", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                alert.dismiss(animated: true) {
                    //                self.delegate?.PayPalPaymentSuccess(paymentID: "\(self.paymentid)")
                    
                   
                    if(self.isModal)
                    {
                        self.dismiss(animated: true) {
                            if(self.isFrompastPayment){
                                self.navigationController?.popViewController(animated: true)
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                    NotificationCenter.default.post(name: Notification.Name("ReloadPastBooking"), object: nil)
                                }
                            }else{
                                self.delegate?.didOrderPesapalStatus(status: true)
                            }
                        }
                    } else {
                        if(self.isFrompastPayment){
                            self.navigationController?.popToRootViewController(animated: true)
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                                NotificationCenter.default.post(name: Notification.Name("ReloadPastBooking"), object: nil)
                            }
                        }else{
                            self.navigationController?.popViewController(animated: false)
                            self.delegate?.didOrderPesapalStatus(status: true)
                        }
                        
                    }
                    

                }
            }
            alert.addAction(ok)
            if((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.presentedViewController != nil)
            {
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                    //                vc.present(alert, animated: true, completion: nil)
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                })
            }
            else {
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
        else if webView.url?.absoluteString == failURL {
           
            let alert = UIAlertController(title: appName.localized, message: "Payment failed", preferredStyle: .alert)
            let ok = UIAlertAction(title: "Ok", style: .default) { (action) in
                self.delegate?.didOrderPesapalStatus(status: false)
                alert.dismiss(animated: true) {
                    self.navigationController?.popViewController(animated: true)
                }
                
            }
            alert.addAction(ok)
            if((UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.presentedViewController != nil)
            {
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.dismiss(animated: true, completion: {
                    //                vc.present(alert, animated: true, completion: nil)
                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                })
            }
            else {
                (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
    //    UtilityClass.hideHUD()
        self.hideProgressView()
        print("didFail: \(String(describing: webView.url?.absoluteString))")
    }
   
}
