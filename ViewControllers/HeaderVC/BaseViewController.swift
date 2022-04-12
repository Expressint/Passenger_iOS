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

    func setNavBarWithMenu(Title:String, IsNeedRightButton:Bool, isFavNeeded:Bool=false,isSOSNeeded:Bool=false){
        //        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = Title.uppercased()
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        self.navigationController?.navigationBar.barTintColor = themeYellowColor;
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        
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
        
        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_menu"), style: .plain, target: self, action: #selector(self.OpenMenuAction))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        if IsNeedRightButton == true {
//            let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.btnCallAction))
            
            if(isFavNeeded)
            {
                
                let rightFavBarButton = UIBarButtonItem(image: UIImage(named: "iconFavourites"), style: .plain, target: self, action: #selector(HomeViewController.btnFavourite(_:)))
                
                self.navigationItem.rightBarButtonItems = [rightFavBarButton]
                
            }
            if(isSOSNeeded)
            {
                let rightSOSBarButton = UIBarButtonItem(image: UIImage(named: "iconSOS"), style: .plain, target: self, action: #selector(HomeViewController.btnSOS(_:)))
                self.navigationItem.rightBarButtonItems?.insert(rightSOSBarButton, at: self.navigationItem.rightBarButtonItems?.count ?? 0)
                
            }
//            else
//            {
//                self.navigationItem.rightBarButtonItem = nil
//                self.navigationItem.rightBarButtonItem = rightNavBarButton
//            }
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        
        
    }
    
    func setNavBarWithBack(Title:String, IsNeedRightButton:Bool) {
//        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = Title.uppercased().localizedUppercase
        self.navigationController?.navigationBar.barTintColor = themeYellowColor;
        self.navigationController?.navigationBar.tintColor = UIColor.white;
        
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor : UIColor.white]
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        let leftNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_BackWhite"), style: .plain, target: self, action: #selector(self.btnBackAction))
        self.navigationItem.leftBarButtonItem = nil
        self.navigationItem.leftBarButtonItem = leftNavBarButton
        
        
        
        
        if IsNeedRightButton == true {
            let rightNavBarButton = UIBarButtonItem(image: UIImage(named: "icon_Call"), style: .plain, target: self, action: #selector(self.btnCallAction))
            self.navigationItem.rightBarButtonItem = nil
            self.navigationItem.rightBarButtonItem = rightNavBarButton
        } else {
            self.navigationItem.rightBarButtonItem = nil
        }
        if UserDefaults.standard.value(forKey: "i18n_language") != nil {
            if let language = UserDefaults.standard.value(forKey: "i18n_language") as? String {
                if language == "sw" {
//                    btnLeft.semanticContentAttribute = .forceLeftToRight
                    
//                    image = UIImage.init(named: "icon_BackWhite")?.imageFlippedForRightToLeftLayoutDirection()
                }
            }
        }
    }
    
    
    // MARK:- Navigation Bar Button Action Methods
    
    @objc func OpenMenuAction(){
         sideMenuController?.toggle()
    }
    
    @objc func btnBackAction()
    {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnCallAction() {
        
        let contactNumber = helpLineNumber
        if contactNumber == "" {
            UtilityClass.setCustomAlert(title: "\(appName)", message: "Contact number is not available") { (index, title) in
            }
        }
        else
        {
            callNumber(phoneNumber: contactNumber)
        }
    }
    
    
    private func callNumber(phoneNumber:String) {
        
        if let phoneCallURL = URL(string: "tel://\(phoneNumber)") {
            
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
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
