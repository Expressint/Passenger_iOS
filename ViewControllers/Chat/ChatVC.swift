//
//  ChatVC.swift
//  KeepusPostd
//
//  Created by Tej P on 20/07/22.
//  Copyright © 2022 Nathan Osume. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import SDWebImage

class ChatVC: BaseViewController {
    
    @IBOutlet weak var tblData: UITableView!
    @IBOutlet weak var constraintBottomOfChatBG: NSLayoutConstraint!
    @IBOutlet weak var btnSend: UIButton!
    @IBOutlet weak var btnSelectImage: UIButton!
    @IBOutlet weak var txtMessage: UITextView!
    
    @IBOutlet weak var imgNav: UIImageView!
    @IBOutlet weak var lblNavName: UILabel!
    @IBOutlet weak var lblNavLocation: UILabel!
    @IBOutlet weak var lblNavBack: UIButton!
    
    var receiverName: String = ""
    var receiverId: String = ""
    var bookingId: String = ""
    var aryData = [[String:AnyObject]]()
    var isDispacherChat: Bool = false
    var isFromPush: Bool = false
    let socket = (UIApplication.shared.delegate as! AppDelegate).socket
    private var imagePicker: ImagePickerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
        self.getAllMessage()
        AppDelegate.current?.currentChatID = receiverId
        NotificationCenter.default.addObserver(self, selector: #selector(self.reloadScreen(_:)), name: NSNotification.Name(rawValue: "ReloadChatScreen"), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.btnSelectImage.isHidden = (isDispacherChat) ? false : true
        AppDelegate.current?.isChatVisible = true
        self.socketMethods()
        self.setupKeyboard(false)
        self.hideKeyboard()
        self.registerForKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        AppDelegate.current?.currentChatID = ""
        AppDelegate.current?.isChatVisible = false
        self.setupKeyboard(true)
        self.deregisterFromKeyboardNotifications()
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().enable = true
    }
    
    @objc func reloadScreen(_ notification: NSNotification) {
        self.bookingId = notification.userInfo?["booking_id"] as? String ?? ""
        self.receiverId = notification.userInfo?["receiver_Id"] as? String ?? ""
        self.isDispacherChat = notification.userInfo?["isDispacherChat"] as? Bool ?? false
        AppDelegate.current?.currentChatID = receiverId
        self.isFromPush = true
        self.getAllMessage()
    }
    
    func setupUI(){
        self.imagePicker = ImagePickerController(presentationController: self, delegate: self)
        self.title = receiverName
        txtMessage.delegate = self
        txtMessage.text = "Enter Message.."
        txtMessage.textColor = UIColor.black
        
        self.tblData.delegate = self
        self.tblData.dataSource = self
        self.tblData.separatorStyle = .none
        self.tblData.showsVerticalScrollIndicator = false
        self.tblData.showsHorizontalScrollIndicator = false
        
        self.registerNib()
        self.tblData.reloadData()
 }
    
    func setupHeader(name: String, receiverID: String) {
        self.title = name
        self.receiverId = receiverID
       // AppDelegate.current?.currentChatID = receiverId
    }
    
    func registerNib(){
        let nib = UINib(nibName: SenderCell.className, bundle: nil)
        self.tblData.register(nib, forCellReuseIdentifier: SenderCell.className)
        let nib2 = UINib(nibName: ReceiverCell.className, bundle: nil)
        self.tblData.register(nib2, forCellReuseIdentifier: ReceiverCell.className)
    }
    
    func socketMethods()
    {
        if(self.socket?.status == .connected) {
            self.socketOnForReceiveMessage()
        }else{
            var isSocketConnected = Bool()
            socket?.on(clientEvent: .disconnect) { (data, ack) in
                print ("socket? is disconnected please reconnect")
            }
            
            socket?.on(clientEvent: .reconnect) { (data, ack) in
                print ("socket? is reconnected")
            }
            
            socket?.on(clientEvent: .connect) { data, ack in
                
                print("socket? BaseURl : \(SocketData.kBaseURL)")
                print("socket? connected")
                
                if self.socket?.status != .connected {
                    print("socket?.status != .connected")
                }
                
                if (isSocketConnected == false) {
                    isSocketConnected = true
                    self.socketOnForReceiveMessage()
                }
            }
            socket?.connect()
        }
    }

    func socketOnForReceiveMessage() {
        self.socket?.on(SocketData.receiveMessage, callback: { (data, ack) in
            print ("Chat response is :  \(data)")
            let dictData = (data as NSArray).object(at: 0) as! [String : AnyObject]
            let senderId = dictData["sender_id"] as? String ?? ""
            if(senderId == self.receiverId || senderId == SingletonClass.sharedInstance.strPassengerID){
               self.aryData.append(dictData)
                self.tblData.reloadData()
                self.scrollToBottom()
            }
        })
    }
    
    func scrollToBottom(){
        DispatchQueue.main.async {
            if self.aryData.count > 1 {
                let indexPath = IndexPath(row: self.aryData.count-1, section: 0)
                self.tblData.scrollToRow(at: indexPath, at: .bottom, animated: false)
            }
        }
    }
    
    func sendMessage() {
        let myJSON = ["sender_id" : SingletonClass.sharedInstance.strPassengerID,
                      "receiver_id": receiverId,
                      "message" : self.txtMessage.text ?? "",
                      "msg_type" : "text",
                      "imageUrl" : "",
                      "sender_type" : "passenger",
                      "receiver_type" : (isDispacherChat) ? "dispatcher" : "driver",
                      "booking_id" : (isDispacherChat) ? "" : bookingId] as [String : Any]
        
        self.socket?.emit(SocketData.sendMessage, with: [myJSON], completion: nil)
        print ("\(SocketData.sendMessage) : \(myJSON)")
        self.txtMessage.text = ""
        self.view.endEditing(true)
    }
    
    func sendImgMessage(strUrl: String) {
        let myJSON = ["sender_id" : SingletonClass.sharedInstance.strPassengerID,
                      "receiver_id": receiverId,
                      "message" : "",
                      "msg_type" : "image",
                      "imageUrl" : strUrl,
                      "sender_type" : "passenger",
                      "receiver_type" : (isDispacherChat) ? "dispatcher" : "driver",
                      "booking_id" : (isDispacherChat) ? "" : bookingId] as [String : Any]
        
        self.socket?.emit(SocketData.sendMessage, with: [myJSON], completion: nil)
        print ("\(SocketData.sendMessage) : \(myJSON)")
        txtMessage.text = "Enter Message.."
        txtMessage.textColor = UIColor.black
    }
    
    func convertDate(strDate: String) -> String{
        let PickDate = Double(strDate)
        guard let unixTimestamp1 = PickDate else { return "" }
        let date1 = Date(timeIntervalSince1970: TimeInterval(unixTimestamp1))
        let dateFormatter1 = DateFormatter()
        dateFormatter1.dateFormat = "yyyy/MM/dd  HH:mm"
        let strDate1 = dateFormatter1.string(from: date1)
        return strDate1
    }
    
    func openImage(strImage: String) {
        let NextPage = mainStoryboard.instantiateViewController(withIdentifier: "ChatImageViewVC") as! ChatImageViewVC
        NextPage.strUrl = strImage
        NextPage.modalPresentationStyle = .formSheet
        self.present(NextPage, animated: true, completion: nil)
    }
    
    @IBAction func btnSendAction(_ sender: Any) {
        if(self.txtMessage.text.trimmingCharacters(in: .whitespaces) != "" && self.txtMessage.text != "Enter Message.."){
            self.sendMessage()
        }else{
          UtilityClass.setCustomAlert(title: "Misssing", message: "Please enter message".localized) { (index, title) in }
        }
    }
    
    @IBAction func btnImageSendAction(_ sender: UIButton) {
        self.imagePicker.present(from: sender)
    }
    
}



extension ChatVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if txtMessage.textColor == UIColor.black {
            txtMessage.text = nil
            txtMessage.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if txtMessage.text.isEmpty {
            txtMessage.text = "Enter Message.."
            txtMessage.textColor = UIColor.black
        }
    }
}

// MARK: - Image Picker Delegate
extension ChatVC: ImagePickerControllerDelegate {
    func imagePicker(didSelectImage image: UIImage?) {
        if let unWappedImage = image {
            print(unWappedImage)
            
            let imageData: Data? = UIImageJPEGRepresentation(unWappedImage, 0.4)
            let imageStr = imageData?.base64EncodedString(options: .lineLength64Characters) ?? ""
            self.sendImgMessage(strUrl: imageStr)
        }
    }
}

extension ChatVC {
    func getAllMessage() {
        
        var dictData = [String:AnyObject]()
        dictData["user_id"] = SingletonClass.sharedInstance.strPassengerID as AnyObject
        dictData["booking_id"] = bookingId as AnyObject
        dictData["receiver_id"] = receiverId as AnyObject
        
        UtilityClass.showACProgressHUD()
        webserviceForChatHistory(dictData as AnyObject) { (result, status) in
            UtilityClass.hideACProgressHUD()
            if (status) {
                self.aryData = (result as! NSDictionary).object(forKey: "message") as! [[String:AnyObject]]
                
                let ReceiverData = (result as! NSDictionary).object(forKey: "receiver_data") as! [String:AnyObject]
                let name = ReceiverData["Fullname"] as? String
                let id = ReceiverData["Id"] as? String
                if self.isFromPush {
                    self.setupHeader(name: name ?? "", receiverID: id ?? "")
                }
                
                print(self.aryData)
                if(self.aryData.count > 0){
                    self.tblData.reloadData()
                    self.scrollToBottom()
                }
                
            } else {
                if let res = result as? String {
                    UtilityClass.setCustomAlert(title: "Error", message: res) { (index, title) in}
                }
                else if let resDict = result as? NSDictionary {
                    UtilityClass.setCustomAlert(title: "Error", message: resDict.object(forKey: "message") as! String) { (index, title) in }
                }
                else if let resAry = result as? NSArray {
                    UtilityClass.setCustomAlert(title: "Error", message: (resAry.object(at: 0) as! NSDictionary).object(forKey: "message") as! String) { (index, title) in }
                }
            }
        }
    }
    
    func sendMessageAPI(image: UIImage? = UIImage()) {
    }
}

//MARK: - tableview datasource and delegate
extension ChatVC: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.aryData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let dictData = aryData[indexPath.row] as [String:AnyObject]
        
        let senderId = dictData["sender_id"] as? String
        if(senderId == SingletonClass.sharedInstance.strPassengerID){
            let cell = tblData.dequeueReusableCell(withIdentifier: SenderCell.className) as! SenderCell
            cell.selectionStyle = .none
            
            cell.vWMessage.isHidden = false
            cell.vwImg.isHidden = false
            let type = dictData["msg_type"] as? String ?? ""
            
            if(type == "image"){
                cell.vWMessage.isHidden = true
                
                let urlLogo = dictData["image"] as? String ?? ""
                cell.imgMsg.sd_addActivityIndicator()
                cell.imgMsg.sd_setImage(with: URL(string: urlLogo), placeholderImage: UIImage(named: "icon_Picture"), options: [.continueInBackground], progress: nil, completed: { (image, error, cache, url) in
                    if (error == nil) {
                        cell.imgMsg.image = image
                    }
                })
                cell.lblImgDate.text = self.convertDate(strDate: dictData["created_at"] as? String ?? "")
                
                cell.btnImgAction = {
                    print("sender called")
                    let url = dictData["image"] as? String ?? ""
                    self.openImage(strImage: url)
                }
                
            }else{
                cell.vwImg.isHidden = true
                cell.lblMsgSender.text = dictData["message"] as? String ?? ""
                cell.lblDate.text = self.convertDate(strDate: dictData["created_at"] as? String ?? "")
            }
            return cell
            
        }else{
            let cell = tblData.dequeueReusableCell(withIdentifier: ReceiverCell.className) as! ReceiverCell
            cell.selectionStyle = .none
            
            cell.vWMessage.isHidden = false
            cell.vwImg.isHidden = false
            let type = dictData["msg_type"] as? String ?? ""
            
            if(type == "image"){
                
                cell.vWMessage.isHidden = true
                
                let urlLogo = dictData["image"] as? String ?? ""
                cell.imgMsg.sd_addActivityIndicator()
                cell.imgMsg.sd_setImage(with: URL(string: urlLogo), placeholderImage: UIImage(named: "icon_Picture"), options: [.continueInBackground], progress: nil, completed: { (image, error, cache, url) in
                    if (error == nil) {
                        cell.imgMsg.image = image
                    }
                })
                cell.lblImgDate.text = self.convertDate(strDate: dictData["created_at"] as? String ?? "")
                cell.lblImgCompanyName.text = dictData["company_name"] as? String ?? ""
                cell.lblImgCompanyName.isHidden = (cell.lblImgCompanyName.text == "") ? true : false
                
                cell.btnImgAction = {
                    print("receiver called")
                    let url = dictData["image"] as? String ?? ""
                    self.openImage(strImage: url)
                }
                
            }else{
                cell.vwImg.isHidden = true
                cell.lblMsgReceiver.text = dictData["message"] as? String ?? ""
                cell.lblCompanyName.text = dictData["company_name"] as? String ?? ""
                cell.lblCompanyName.isHidden = (cell.lblCompanyName.text == "") ? true : false
                cell.lblDate.text = self.convertDate(strDate: dictData["created_at"] as? String ?? "")
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
}

extension ChatVC {
    func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func hideKeyboard(){
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboards))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboards(){
        view.endEditing(true)
    }
    
    func setupKeyboard(_ enable: Bool) {
        IQKeyboardManager.sharedManager().enable = enable
        IQKeyboardManager.sharedManager().enableAutoToolbar = enable
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = !enable
        IQKeyboardManager.sharedManager().previousNextDisplayMode = .alwaysShow
    }
    
    @objc func keyboardWillBeHidden(notification: NSNotification){
        constraintBottomOfChatBG.constant = 10
        self.animateConstraintWithDuration()
    }
    
    @objc func keyboardWasShown(notification: NSNotification){
        lazy var keyboardHeight : CGFloat = 0.0
        
        if let keyboardSize: NSValue = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardSize.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
        
        if #available(iOS 11.0, *) {
            DispatchQueue.main.async {
                if self.aryData.count != 0 {
                    self.tblData.layoutIfNeeded()
                    let indexpath = IndexPath(row: self.aryData.count - 1, section: 0)
                    self.tblData.scrollToRow(at: indexpath , at: .top, animated: false)
                }
            }
            constraintBottomOfChatBG.constant = keyboardHeight - view.safeAreaInsets.bottom
        } else {
            DispatchQueue.main.async {
                if self.aryData.count != 0 {
                    self.tblData.layoutIfNeeded()
                    let indexpath = IndexPath(row: self.aryData.count - 1, section: 0)
                    self.tblData.scrollToRow(at: indexpath , at: .top, animated: false)
                }
            }
            constraintBottomOfChatBG.constant = keyboardHeight - 10
        }
        self.animateConstraintWithDuration()
    }
    
    func deregisterFromKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func animateConstraintWithDuration(duration: TimeInterval = 0.5) {
        UIView.animate(withDuration: duration, animations: { [weak self] in
            self?.loadViewIfNeeded() ?? ()
        })
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
