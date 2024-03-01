//
//  TourDriverInfoVC.swift
//  Book A Ride
//
//  Created by Yagnik on 02/02/23.
//  Copyright © 2023 Excellent Webworld. All rights reserved.
//

import UIKit
import SDWebImage

protocol ChatWithDriverprotocol: AnyObject {
    func gotoChat()
}

class TourDriverInfoVC: BaseViewController {
    
    @IBOutlet weak var vWMain: UIView!
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var btnOutside: UIButton!
    @IBOutlet weak var imgDriver: UIImageView!
    @IBOutlet weak var lblHours: UILabel!
    @IBOutlet weak var lblDriverInfo: UILabel!
    @IBOutlet weak var lblPassengerInfo: UILabel!
    
    @IBOutlet weak var lblTitlePickUpLoc: UILabel!
    @IBOutlet weak var lblPickUpLoc: UILabel!
    @IBOutlet weak var lblTitleDropOffLoc: UILabel!
    @IBOutlet weak var lblDropOffLoc: UILabel!
    
    weak var delegate: ChatWithDriverprotocol?
    var dictCurrentBookingInfoData = NSDictionary()
    var dictCurrentPassengerInfoData = NSDictionary()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.prepareView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = UIColor.black.withAlphaComponent(0)
        UIView.animate(withDuration: 0.3, delay: 0.3) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(changeLanguage), name: Notification.Name(rawValue: LCLLanguageChangeNotification), object: nil)
    }
    
    func prepareView() {
        self.setupUI()
        self.setupData()
        self.setLocalization()
    }
    
    @objc func changeLanguage(){
        self.setLocalization()
    }
    func setLocalization(){
        self.lblDriverInfo.text = "Driver Info".localized
        self.lblPassengerInfo.text = "Package Info".localized + " :"
        self.lblTitlePickUpLoc.text = "Pickup Location".localized
        self.lblTitleDropOffLoc.text = "Dropoff Location".localized
        //self.btnCancelTrip.setTitle("Next".localized, for: .normal)
    }
    
    func setupUI() {
        self.vWMain.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.vWMain.layer.masksToBounds = false
        self.vWMain.layer.shadowRadius = 4
        self.vWMain.layer.borderColor = #colorLiteral(red: 0.1098039216, green: 0.4588235294, blue: 0.7333333333, alpha: 1)
        self.vWMain.layer.cornerRadius = 10
        self.vWMain.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        self.vWMain.layer.shadowOpacity = 0.15
        
        self.imgDriver.layer.cornerRadius = (self.imgDriver.frame.size.width) / 2
        self.imgDriver.clipsToBounds = true
        self.imgDriver.layer.borderWidth = 1.0
        self.imgDriver.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    func setupData() {
        let packageInfo = self.dictCurrentBookingInfoData.object(forKey: "PackageInfo") as? NSDictionary
        
        self.lblPickUpLoc.text =  self.dictCurrentBookingInfoData.object(forKey: "PickupLocation") as? String ?? ""
        self.lblDropOffLoc.text =  self.dictCurrentBookingInfoData.object(forKey: "DropoffLocation") as? String ?? ""
        self.lblDriverName.text = self.dictCurrentPassengerInfoData.object(forKey: "Fullname") as? String ?? ""
        self.lblHours.text = "\(packageInfo?.object(forKey: "MinimumHours") as? String ?? "") hrs/\(packageInfo?.object(forKey: "MinimumKm") as? String ?? "") km $\(packageInfo?.object(forKey: "MinimumAmount") as? String ?? "")"
      
        let urlLogo = "\(NetworkEnvironment.current.imageBaseURL)\(dictCurrentPassengerInfoData.object(forKey: "Image") as? String ?? "")"
        self.imgDriver.sd_setImage(with: URL(string: urlLogo), placeholderImage: UIImage(named: "icon_UserImage"), options: [.continueInBackground], progress: nil, completed: { (image, error, cache, url) in
            if (error == nil) {
                self.imgDriver.image = image
            }
        })
    }
    
    @IBAction func btnPhoneAction(_ sender: Any) {
        let contactNumber = self.dictCurrentPassengerInfoData.object(forKey: "MobileNo") as? String ?? ""
        if let phoneCallURL = URL(string: "tel://\(contactNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func btnOutsideAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func btncloseAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func btncallAction(_ sender: Any) {
        callNumber(phoneNumber: DispatchCall)
    }
    
    @IBAction func btnChatAction(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            self.delegate?.gotoChat()
        })
    }
}

