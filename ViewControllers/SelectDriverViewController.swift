//
//  SelectDriverViewController.swift
//  Book A Ride
//
//  Created by baps on 22/03/21.
//  Copyright © 2021 Excellent Webworld. All rights reserved.
//

import UIKit

class SelectDriverViewController: UIViewController {
    var arrCurrentModelSelectedCars = NSMutableArray()
    @IBOutlet weak var tblVw: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DriverListCell") as! DriverListCell
        if let dict = arrCurrentModelSelectedCars[indexPath.row] as? [String: AnyObject] {
//            cell.lblDriverName.text = dict[""]
        }
        
        return cell
    }
    
    
}

class DriverListCell : UITableViewCell {
    @IBOutlet weak var lblDriverName: UILabel!
    @IBOutlet weak var lblPhoneNumber: UILabel!
    @IBOutlet weak var lblVehiclePlateTitle: UILabel!
    @IBOutlet weak var lblVehiclePlateNumber: UILabel!
    @IBOutlet weak var lblDriverRatingTitle: UILabel!
    
    @IBOutlet weak var lblCurrentAddressTitle: UILabel!
    @IBOutlet weak var lblCurrentAddress: UILabel!
    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var btnCall: UIButton!
    @IBOutlet weak var btnBookNow: UIButton!
    @IBOutlet weak var btnBookLater: UIButton!
}
