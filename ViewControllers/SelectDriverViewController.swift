//
//  SelectDriverViewController.swift
//  Book A Ride
//
//  Created by baps on 22/03/21.
//  Copyright © 2021 Excellent Webworld. All rights reserved.
//

import UIKit
import CoreLocation
import GoogleMaps

protocol SendBackSelectedDriverDelegate {
    func didSelectDriver(_ dictSelectedDriver: [String: AnyObject])
}
class SelectDriverViewController: BaseViewController {
    var arrCurrentModelSelectedCars = NSMutableArray()
    @IBOutlet weak var tblVw: UITableView!
    var delegate : SendBackSelectedDriverDelegate?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNavBarWithBack(Title: "Driver List".localized, IsNeedRightButton: true)
        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SelectDriverViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrCurrentModelSelectedCars.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverListCell") as! DriverListCell
        /*
         Optional({
             CarType = 2;
             DriverId = 52;
             DriverImage = "images/driver/52/8ea55358119c8f64d1689f662c421130.jpeg";
             DriverName = "rehan hussain";
             DriverPhoneNumber = 9898989898;
             Location =     (
                 "23.07136571502599",
                 "72.51773186966079"
             );
             PlateNo = yayya;
             Rating = "4.75";
         })
         */
        cell.selectionStyle = .none
        if let dict = arrCurrentModelSelectedCars[indexPath.row] as? [String: AnyObject] {
            cell.lblDriverName.text = "Driver Name : " + (dict["DriverName"] as? String ?? "")
            cell.lblPhoneNumber.text = "Phone Number : " + (dict["DriverPhoneNumber"] as? String ?? "")
            cell.lblVehiclePlateTitle.text = "Vehicle Plate Number"
            cell.lblVehiclePlateNumber.text = (dict["PlateNo"] as? String ?? "" )
            cell.lblCurrentAddressTitle.text = "Driver's Current Address"
            cell.lblCurrentAddress.text = (dict["PlateNo"] as? String ?? "" )
            let strURL = "\(WebserviceURLs.kImageBaseURL)\(dict["DriverImage"] as? String ?? "")"
            cell.imgProfile.sd_setImage(with: URL.init(string: strURL), completed: nil)
            cell.rateVw.rating = Float(dict["Rating"] as? Double ?? 0.0)
            cell.btnCall.tag = indexPath.row
            cell.btnBookNow.tag = indexPath.row
            cell.btnBookLater.tag = indexPath.row
            
            cell.btnCall.addTarget(self, action: #selector(callClick(_:)), for: .touchUpInside)
            cell.btnBookNow.addTarget(self, action: #selector(bookNowClick(_:)), for: .touchUpInside)
            cell.btnBookLater.addTarget(self, action: #selector(bookLaterClick(_:)), for: .touchUpInside)
            if let arrLatLong = dict["Location"] as? [Double] {
//                guard let lat = arrLatLong.first, (Double(lat) != nil) else {
//                    return cell
//                }
//                guard let lng = arrLatLong.last, (Double(lng) != nil) else {
//                    return cell
//                }
                
                let location = CLLocation.init(latitude: arrLatLong.first ?? 0.0, longitude: arrLatLong.last ?? 0.0)
                location.fetchCityAndCountry { (address, error) in
                    cell.lblCurrentAddress.text = address
                }
            }
            
//            let location1 = CLLocation(latitude: location?.latitude ?? 0.0, longitude: location?.longitude ?? 0.0)
//            CLLocation.init(latitude: <#T##CLLocationDegrees#>, longitude: <#T##CLLocationDegrees#>)
        }
       
        return cell
    }
    @IBAction func callClick(_ sender: UIButton) {
        if let dict = arrCurrentModelSelectedCars[sender.tag] as? [String: AnyObject] {
            if let driverCallNumber = dict["DriverPhoneNumber"] as? String {
                if let url = URL(string: "tel://\(driverCallNumber)"), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10, *) {
                        UIApplication.shared.open(url)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
            }
        }
    }
    @IBAction func bookNowClick(_ sender: UIButton) {
        if let dict = arrCurrentModelSelectedCars[sender.tag] as? [String: AnyObject] {
            delegate?.didSelectDriver(dict)
            self.navigationController?.popViewController(animated: true)
        }
    }
    @IBAction func bookLaterClick(_ sender: UIButton) {
        if let dict = arrCurrentModelSelectedCars[sender.tag] as? [String: AnyObject] {
            delegate?.didSelectDriver(dict)
            self.navigationController?.popViewController(animated: true)
        }
    }
}
extension CLLocation {
    func fetchCityAndCountry(completion: @escaping ( _ address: String?, _ error: Error?) -> ()) {
        
        GMSGeocoder().reverseGeocodeCoordinate(coordinate) { (response, error) in
            if let address = response?.results() {
                guard error == nil else {
                    completion("",error)
                    return
                }
                if let addressNew = address.first?.lines {
                    completion(self.makeAddressString(inArr: addressNew), nil)
                }
            }
        }
    }
    
    func makeAddressString(inArr:[String]) -> String {
        
        var fVal:String = ""
        for val in inArr {
            fVal = fVal + val + " "
        }
        return fVal
        
    }
}
class DriverListCell : UITableViewCell {
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblVehiclePlateTitle: UILabel!
    @IBOutlet weak var lblVehiclePlateNumber: UILabel!
    @IBOutlet weak var lblDriverRatingTitle: UILabel!
    @IBOutlet weak var rateVw: FloatRatingView!
    
    @IBOutlet weak var lblCurrentAddressTitle: UILabel!
    @IBOutlet weak var lblCurrentAddress: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnBookNow: UIButton!
    @IBOutlet weak var btnBookLater: UIButton!
}
