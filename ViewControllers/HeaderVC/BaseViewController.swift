//
//  BaseViewController.swift
//  TanTaxi User
//
//  Created by EWW-iMac Old on 05/10/18.
//  Copyright © 2018 Excellent Webworld. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // Do any additional setup after loading the view.
    }
    
    func setNavBarWithMenu(Title:String, IsNeedRightButton:Bool, isFavNeeded:Bool=false,isSOSNeeded:Bool=false, isWhatsApp: Bool = false){
        //        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = Title.uppercased()
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.barTintColor = themeYellowColor;
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        } else {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = themeYellowColor
            appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                              .foregroundColor: UIColor.white]
            
            // Customizing our navigation bar
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        
        var arrLleftButtons = [UIBarButtonItem]()
        
        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_BackWhite"), style: .plain, target: self, action:#selector(self.btnBackAction))
        self.navigationItem.leftBarButtonItem = nil
        arrLleftButtons.append(leftNavBarButton)
        
        if(isSOSNeeded)
        {
            let btnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            btnRight.setImage(UIImage.init(named: "iconSOS"), for: .normal)
            btnRight.addTarget(self, action: #selector(HomeViewController.btnSOS(_:)), for: .touchUpInside)
            let viewRight = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            viewRight.addSubview(btnRight)
            let btnRightBar: UIBarButtonItem = UIBarButtonItem.init(customView: viewRight)
            btnRightBar.style = .plain
            
            let viewRightDummy = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            let btnRightBarDummy: UIBarButtonItem = UIBarButtonItem.init(customView: viewRightDummy)
            btnRightBarDummy.style = .plain
            arrLleftButtons.append(btnRightBarDummy)
            
            arrLleftButtons.append(btnRightBar)
        }
        self.navigationItem.leftBarButtonItems = arrLleftButtons
        
        if IsNeedRightButton == true {
            var arrButtons = [UIBarButtonItem]()
            //            let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.btnCallAction))
            
            if(isFavNeeded)
            {
                
                //                let rightFavBarButton = UIBarButtonItem(image: UIImage(named: "iconFavourites"), style: .plain, target: self, action: #selector(HomeViewController.btnFavourite(_:)))
                //                self.navigationItem.rightBarButtonItems = [rightFavBarButton]
                
                let btnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                btnRight.setImage(UIImage.init(named: "iconFavourites"), for: .normal)
                btnRight.addTarget(self, action: #selector(HomeViewController.btnFavourite(_:)), for: .touchUpInside)
                let viewRight = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                viewRight.addSubview(btnRight)
                let btnRightBar: UIBarButtonItem = UIBarButtonItem.init(customView: viewRight)
                btnRightBar.style = .plain
                arrButtons.append(btnRightBar)
                
            }
            //            if(isSOSNeeded)
            //            {
            ////                let rightSOSBarButton = UIBarButtonItem(image: UIImage(named: "iconSOS"), style: .plain, target: self, action: #selector(HomeViewController.btnSOS(_:)))
            ////                self.navigationItem.rightBarButtonItems?.insert(rightSOSBarButton, at: self.navigationItem.rightBarButtonItems?.count ?? 0)
            //
            //                let btnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            //                btnRight.setImage(UIImage.init(named: "iconSOS"), for: .normal)
            //                btnRight.addTarget(self, action: #selector(HomeViewController.btnSOS(_:)), for: .touchUpInside)
            //                let viewRight = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
            //                viewRight.addSubview(btnRight)
            //                let btnRightBar: UIBarButtonItem = UIBarButtonItem.init(customView: viewRight)
            //                btnRightBar.style = .plain
            //                arrButtons.append(btnRightBar)
            //            }
            
            if(isWhatsApp)
            {
                let btnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                btnRight.setImage(UIImage.init(named: (Localize.currentLanguage() == Languages.English.rawValue) ? "ic_whatsApp" : "ic_whatsApp_es"), for: .normal)
                btnRight.addTarget(self, action: #selector(self.openChatForDispatcher), for: .touchUpInside)
                let viewRight = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                viewRight.addSubview(btnRight)
                let btnRightBar: UIBarButtonItem = UIBarButtonItem.init(customView: viewRight)
                btnRightBar.style = .plain
                arrButtons.append(btnRightBar)
            }
            self.navigationItem.rightBarButtonItems = arrButtons
            
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        
    }
    
    func setNavBarWithSideMenu(Title:String, IsNeedRightButton:Bool, isWhatsApp: Bool = false){
        //        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = Title.uppercased()
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.barTintColor = themeYellowColor;
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 13.0, *) {
            navigationController?.navigationBar.standardAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        } else {
            navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        if #available(iOS 15, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.backgroundColor = themeYellowColor
            appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                              .foregroundColor: UIColor.white]
            
            // Customizing our navigation bar
            navigationController?.navigationBar.tintColor = .white
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.scrollEdgeAppearance = appearance
        }
        

        
        var arrLleftButtons = [UIBarButtonItem]()
        
        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_menu"), style: .plain, target: self, action: #selector(self.OpenSideMenuAction))
        self.navigationItem.leftBarButtonItem = nil
        arrLleftButtons.append(leftNavBarButton)
        
        self.navigationItem.leftBarButtonItems = arrLleftButtons
        
        if IsNeedRightButton == true {
            var arrButtons = [UIBarButtonItem]()
            let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.btnCallAction))
            arrButtons.append(rightNavBarButton)
            
            
            if(isWhatsApp)
            {
                let btnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                btnRight.setImage(UIImage.init(named: (Localize.currentLanguage() == Languages.English.rawValue) ? "ic_whatsApp" : "ic_whatsApp_es"), for: .normal)
                btnRight.addTarget(self, action: #selector(self.openChatForDispatcher), for: .touchUpInside)
                let viewRight = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                viewRight.addSubview(btnRight)
                let btnRightBar: UIBarButtonItem = UIBarButtonItem.init(customView: viewRight)
                btnRightBar.style = .plain
                arrButtons.append(btnRightBar)
            }
            
            
            self.navigationItem.rightBarButtonItems = arrButtons
        } else {
            self.navigationItem.rightBarButtonItems = nil
        }
        
    }
    
    func setNavBarWithBack(Title:String, IsNeedRightButton:Bool, IsNeedBackButton:Bool = true, isSOSNeeded:Bool=false) {
        //        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = Title.uppercased().localizedUppercase
        self.navigationController?.navigationBar.barTintColor = themeYellowColor;
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = themeYellowColor
        appearance.titleTextAttributes = [.font: UIFont.boldSystemFont(ofSize: 20.0),
                                          .foregroundColor: UIColor.white]
        
        // Customizing our navigation bar
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
        
        
        if IsNeedBackButton {
            var arrLleftButtons = [UIBarButtonItem]()
            
            let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_BackWhite"), style: .plain, target: self, action: #selector(self.btnBackAction))
            arrLleftButtons.append(leftNavBarButton)
            
            
            if(isSOSNeeded){
                let btnRight = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                btnRight.setImage(UIImage.init(named: "iconSOS"), for: .normal)
                btnRight.addTarget(self, action: #selector(self.CallSOS), for: .touchUpInside)
                let viewRight = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
                viewRight.addSubview(btnRight)
                let btnRightBar: UIBarButtonItem = UIBarButtonItem.init(customView: viewRight)
                btnRightBar.style = .plain
                
//                let viewRightDummy = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
//                let btnRightBarDummy: UIBarButtonItem = UIBarButtonItem.init(customView: viewRightDummy)
//                btnRightBarDummy.style = .plain
//                arrLleftButtons.append(btnRightBarDummy)
                
                arrLleftButtons.append(btnRightBar)
            }
            
            self.navigationItem.leftBarButtonItems = arrLleftButtons
            
        } else {
            self.navigationItem.leftBarButtonItems = nil
            self.navigationItem.hidesBackButton = true
        }
        
        
        
        if IsNeedRightButton == true {
            let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.btnCallAction))
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = rightNavBarButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
    }
    
    @objc func CallSOS() {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "TourSOS"), object: nil)
    }
    
    
    // MARK:- Navigation Bar Button Action Methods
    @objc func openChatForDispatcher(){
        let NextPage = mainStoryboard.instantiateViewController(withIdentifier: "ChatVC") as! ChatVC
        NextPage.receiverName = DispatchName
        NextPage.bookingId = ""
        NextPage.isDispacherChat = true
        NextPage.receiverId = DispatchId
        self.navigationController?.pushViewController(NextPage, animated: true)
    }
    
    @objc func OpenMenuAction() {
        sideMenuController?.toggle()
    }
    
    @objc func OpenSideMenuAction() {
        sideMenuSwiftController?.revealMenu()
    }
    
    @objc func btnBackAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    // MARK:- Navigation Bar Button Action Methods
    
    @objc func btnCallAction() {
        
        let contactNumber = helpLineNumber
        if contactNumber == "" {
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        } else {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    
    func callNumber(phoneNumber:String) {
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    func requestLoading() -> RequestLoadingVC {
        let viewCtr = bookingsStoryboard.instantiateViewController(withIdentifier: "RequestLoadingVC") as! RequestLoadingVC
        viewCtr.modalPresentationStyle = .overCurrentContext
        viewCtr.modalTransitionStyle = .crossDissolve
        return viewCtr
    }
    
    func closeViewController<T: UIViewController>(ofType: T.Type) {
        if let presentedVC = self.presentedViewController as? T {
            presentedVC.dismiss(animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
