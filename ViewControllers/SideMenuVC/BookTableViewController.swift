//
//  BookTableViewController.swift
//  TickTok User
//
//  Created by Excelent iMac on 13/12/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit

class BookTableViewController: BaseViewController, UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {

    
    var aryData = [String]()
    var aryDataImages = [String]()
    
    //-------------------------------------------------------------
    // MARK: - Base Methods
    //-------------------------------------------------------------
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        aryData = ["Asia","Italian","Mexican","Seafood","Indian","Japanese","Middle Eastern","Burgers","Pizza","French","Greek","Mediterranean"]
        aryDataImages = ["iconAsian","iconItalian","iconMexican","iconSeafood","iconIndian","iconJapanese","iconEstrern","iconBurgers","iconPizza","iconFrench","iconGreek","iconMediterranean"]
        collectionView.dataSource = self
        collectionView.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    //-------------------------------------------------------------
    // MARK: - Outlets
    //-------------------------------------------------------------
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    //-------------------------------------------------------------
    // MARK: - Collection View Methods
    //-------------------------------------------------------------
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return aryData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BookTableCollectionViewCell", for: indexPath) as! BookTableCollectionViewCell
        
        cell.lblItemNames.text = aryData[indexPath.row]
        cell.imgItems.image = UIImage(named: aryDataImages[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let next = self.storyboard?.instantiateViewController(withIdentifier: "BookTableSelectedDataViewController") as! BookTableSelectedDataViewController
        next.selectedString = aryData[indexPath.row]
        self.navigationController?.pushViewController(next, animated: true)
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: (self.collectionView.frame.size.width / 2) - 1 , height: (self.collectionView.frame.size.height / 3))
    }
    
    
    
    //-------------------------------------------------------------
    // MARK: - Webservice Methods
    //-------------------------------------------------------------
    
    func webserviceOfBookTable(str: String) {
        
        if SingletonClass.sharedInstance.currentLatitude == "" || SingletonClass.sharedInstance.currentLongitude == "" {
           
            UtilityClass.setCustomAlert(title: "Location Not Found", message: "Your Current Location Not Found") { (index, title) in
            }
        }
        else {
            let creentLocation = "\(SingletonClass.sharedInstance.currentLatitude),\(SingletonClass.sharedInstance.currentLongitude)"
            let type = "restaurant"
            
        
            webserviceForBookTable("" as AnyObject, Location: creentLocation, Type: type, ItemType: str, completion: { (result, status) in
                
                if (status) {
                    print(result)
                }
                else {
                    print(result)
                }
            })
        }
   
    }
}
