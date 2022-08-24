//
//  WebserviceMainClass.swift
//  TickTok User
//
//  Created by Excellent Webworld on 27/10/17.
//  Copyright © 2017 Excellent Webworld. All rights reserved.
//

import UIKit
import Alamofire



var request : Request!
let header: [String:String] = ["key":"Book$951951"] //"Allout123*"


//-------------------------------------------------------------
// MARK: - Webservice For PostData Method
//-------------------------------------------------------------

func postData(_ dictParams: AnyObject, nsURL: String, completion: @escaping (_ result: AnyObject, _ sucess: Bool) -> Void)
{
    let url = WebserviceURLs.kBaseURL + nsURL

    UtilityClass.showACProgressHUD()
     print("webservice is : \(url) and the params are \(dictParams) and the header key is \(header)")
    Alamofire.request(url, method: .post, parameters: dictParams as? [String : AnyObject], encoding: URLEncoding.default, headers: header)
        .validate()
        .responseJSON
        { (response) in
            if let JSON = response.result.value
            {
                if (JSON as AnyObject).object(forKey:("status")) as! Bool == false
                {
                    completion(JSON as AnyObject, false)
                    UtilityClass.hideACProgressHUD()
                }
                else
                {
                    completion(JSON as AnyObject, true)
                     UtilityClass.hideACProgressHUD()
                }
            }
            else {
                UtilityClass.hideACProgressHUD()
            }
    }
}


//-------------------------------------------------------------
// MARK: - Webservice For GetData Method
//-------------------------------------------------------------

func getData(_ dictParams: AnyObject, nsURL: String,  completion: @escaping (_ result: AnyObject, _ success: Bool) -> Void)
{
    let url = WebserviceURLs.kBaseURL + nsURL
    
    print("webservice is : \(url) and the params are \(dictParams) and the header key is \(header)")
    UtilityClass.showACProgressHUD()
    
    Alamofire.request(url, method: .get, parameters: dictParams as? [String : AnyObject], encoding: URLEncoding.default, headers: header)
        .validate()
        .responseJSON
    { (response) in
        
        if let JSON = response.result.value
        {
            
            if (JSON as AnyObject).object(forKey:("status")) as! Bool == false
            {
                completion(JSON as AnyObject, false)
                //                    HUD.flash(HUDContentType.systemActivity, delay: 0.0)
                UtilityClass.hideACProgressHUD()
            }
            else
            {
                completion(JSON as AnyObject, true)
                UtilityClass.hideACProgressHUD()
                
            }
        }
        else
        {
            print("Data not Found")
            UtilityClass.hideACProgressHUD()
        }
    }
}

//-------------------------------------------------------------
// MARK: - Webservice For Send Image Method
//-------------------------------------------------------------

func sendImage(_ dictParams: [String:AnyObject], image1: UIImage, image2: UIImage = UIImage(), isRegister: Bool = false, nsURL: String, completion: @escaping (_ result: AnyObject, _ success: Bool) -> Void) {
    
    let url = WebserviceURLs.kBaseURL + nsURL
    
    UtilityClass.showACProgressHUD()
    print("webservice is : \(url) and the params are \(dictParams) and the header key is \(header)")

    Alamofire.upload(multipartFormData: { (multipartFormData) in
        
        if let imageData1 = UIImageJPEGRepresentation(image1, 0.6) {
            multipartFormData.append(imageData1, withName: "Image", fileName: "image.png", mimeType: "image/png")
        }
        
        if(isRegister){
            if let imageData2 = UIImageJPEGRepresentation(image2, 0.6) {
               multipartFormData.append(imageData2, withName: "passenger_id", fileName: "image.png", mimeType: "image/png")
            }
        }
        
        for (key, value) in dictParams
        {
            
            print(value)
            multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key )
            
        }
    }, usingThreshold: 10 * 1024 * 1024, to: url, method: .post, headers: header) { (encodingResult) in
        switch encodingResult
        {
        case .success(let upload, _, _):
            request =  upload.responseJSON {
                response in
                
                if let JSON = response.result.value {
                    
                    if ((JSON as AnyObject).object(forKey: "status") as! Bool) == true
                    {
                        completion(JSON as AnyObject, true)
                        print("If JSON")
                        UtilityClass.hideACProgressHUD()
                        
                    }
                    else
                    {
                        completion(JSON as AnyObject, false)
                        print("else JSON")
                        UtilityClass.hideACProgressHUD()
                    }
                }
                else
                {
                    print("ERROR")
                    UtilityClass.hideACProgressHUD()
                }
                
                
            }
        case .failure( _):
            print("failure")
            UtilityClass.hideACProgressHUD()
            
            break
        }
    }
}

//-------------------------------------------------------------
// MARK: - Webservice For Send Image Method
//-------------------------------------------------------------

func postTwoImageMethod(_ dictParams: [String:AnyObject], image1: UIImage, image2: UIImage, nsURL: String, completion: @escaping (_ result: AnyObject, _ success: Bool) -> Void) {
    
    let url = WebserviceURLs.kBaseURL + nsURL
    
    UtilityClass.showACProgressHUD()
    print("webservice is : \(url) and the params are \(dictParams) and the header key is \(header)")

    Alamofire.upload(multipartFormData: { (multipartFormData) in
        
        if let imageData1 = UIImageJPEGRepresentation(image1, 0.6) {
            multipartFormData.append(imageData1, withName: "Image", fileName: "image.png", mimeType: "image/png")
        }
        if let imageData2 = UIImageJPEGRepresentation(image2, 0.6) {
            multipartFormData.append(imageData2, withName: "Passport", fileName: "image.png", mimeType: "image/png")
        }
        
        for (key, value) in dictParams
        {
            
            print(value)
            multipartFormData.append((value as! String).data(using: String.Encoding.utf8)!, withName: key )
            
        }
    }, usingThreshold: 10 * 1024 * 1024, to: url, method: .post, headers: header) { (encodingResult) in
        switch encodingResult
        {
        case .success(let upload, _, _):
            request =  upload.responseJSON {
                response in
                
                if let JSON = response.result.value {
                    
                    if ((JSON as AnyObject).object(forKey: "status") as! Bool) == true
                    {
                        completion(JSON as AnyObject, true)
                        print("If JSON")
                        UtilityClass.hideACProgressHUD()
                        
                    }
                    else
                    {
                        completion(JSON as AnyObject, false)
                        print("else JSON")
                        UtilityClass.hideACProgressHUD()
                    }
                }
                else
                {
                    print("ERROR")
                    UtilityClass.hideACProgressHUD()
                }
                
                
            }
        case .failure( _):
            print("failure")
            UtilityClass.hideACProgressHUD()
            
            break
        }
    }
}

//-------------------------------------------------------------
// MARK: - Webservice For Bar And Clubs
//-------------------------------------------------------------

func BarsAndClubs(_ dictParams: AnyObject, Location: String, Type: String,  completion: @escaping (_ result: NSDictionary, _ success: Bool) -> Void)
{
    let CurrentLocation = Location
    let types = Type
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(CurrentLocation)&radius=5000&type=\(types)&key=AIzaSyCRaduVCKdm1ll3kHPY-ebtvwwPV2VVozo"
    
    UtilityClass.showACProgressHUD()
    
    Alamofire.request(url, method: .get, parameters: dictParams as? [String : AnyObject], encoding: URLEncoding.default, headers: header)
        .validate()
        .responseJSON
        { (response) in
            
            if let JSON = response.result.value
            {
                
                if ((JSON as! NSDictionary).object(forKey:("status"))) as! String == "OK"
                {
                    completion(JSON as! NSDictionary, true)
                    //                    HUD.flash(HUDContentType.systemActivity, delay: 0.0)
                    UtilityClass.hideACProgressHUD()
                }
                else
                {
                    completion(JSON as! NSDictionary, false)
                    UtilityClass.hideACProgressHUD()
                    
                }
            }
            else
            {
                print("Data not Found")
                UtilityClass.hideACProgressHUD()
            }
    }
}

//-------------------------------------------------------------
// MARK: - Webservice For Book Table
//-------------------------------------------------------------

func BookTable(_ dictParams: AnyObject, Location: String, Type: String, Item: String ,completion: @escaping (_ result: NSDictionary, _ success: Bool) -> Void)
{
    let CurrentLocation = Location
    let types = Type
    let url = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(CurrentLocation)&radius=5000&type=\(types)&keyword=\(Item)&key=AIzaSyCRaduVCKdm1ll3kHPY-ebtvwwPV2VVozo"
    
    UtilityClass.showACProgressHUD()
    
    Alamofire.request(url, method: .get, parameters: dictParams as? [String : AnyObject], encoding: URLEncoding.default, headers: header)
        .validate()
        .responseJSON
        { (response) in
            
            if let JSON = response.result.value
            {
                
                if ((JSON as! NSDictionary).object(forKey:("status"))) as! String == "OK"
                {
                    completion(JSON as! NSDictionary, true)
                    //                    HUD.flash(HUDContentType.systemActivity, delay: 0.0)
                    UtilityClass.hideACProgressHUD()
                }
                else
                {
                    completion(JSON as! NSDictionary, false)
                    UtilityClass.hideACProgressHUD()
                    
                }
            }
            else
            {
                print("Data not Found")
                UtilityClass.hideACProgressHUD()
            }
    }
}

//-------------------------------------------------------------
// MARK: - Webservice For Shopping
//-------------------------------------------------------------

func ShoppingListOfGoogle(_ dictParams: AnyObject, Location: String, Type: String ,completion: @escaping (_ result: NSDictionary, _ success: Bool) -> Void)
{
    let CurrentLocation = Location
    let types = Type
    let url = "https://maps.googleapis.com/maps/api/place/textsearch/json?query=\(types)\(CurrentLocation)&key=AIzaSyCRaduVCKdm1ll3kHPY-ebtvwwPV2VVozo"
    
    UtilityClass.showACProgressHUD()
    
    Alamofire.request(url, method: .get, parameters: dictParams as? [String : AnyObject], encoding: URLEncoding.default, headers: header)
        .validate()
        .responseJSON
        { (response) in
            
            if let JSON = response.result.value
            {
                
                if ((JSON as! NSDictionary).object(forKey:("status"))) as! String == "OK"
                {
                    completion(JSON as! NSDictionary, true)
                    //                    HUD.flash(HUDContentType.systemActivity, delay: 0.0)
                    UtilityClass.hideACProgressHUD()
                }
                else
                {
                    completion(JSON as! NSDictionary, false)
                    UtilityClass.hideACProgressHUD()
                }
            }
            else
            {
                print("Data not Found")
                UtilityClass.hideACProgressHUD()
            }
    }
    
    
}


func estimateMethod(_ dictParams: AnyObject, nsURL: String, completion: @escaping (_ result: AnyObject, _ sucess: Bool) -> Void)
{
    let url = WebserviceURLs.kBaseURL + nsURL
    
//    UtilityClass.showACProgressHUD()
    print("webservice is : \(url) and the params are \(dictParams) and the header key is \(header)")

    Alamofire.request(url, method: .post, parameters: dictParams as? [String : AnyObject], encoding: URLEncoding.default, headers: header)
        .validate()
        .responseJSON
        { (response) in
            if let JSON = response.result.value
            {
                if (JSON as AnyObject).object(forKey:("status")) as! Bool == false
                {
                    completion(JSON as AnyObject, false)
//                    UtilityClass.hideACProgressHUD()
                }
                else
                {
                    completion(JSON as AnyObject, true)
//                    UtilityClass.hideACProgressHUD()
                }
            }
            else {
//                UtilityClass.hideACProgressHUD()
                
                //                    let alert = UIAlertController(title: nil, message: res, preferredStyle: .alert)
                //                    let OK = UIAlertAction(title: "OK", style: .default, handler: nil)
                //                    alert.addAction(OK)
                //                    (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController?.present(alert, animated: true, completion: nil)
                
                
            }
    }
}
