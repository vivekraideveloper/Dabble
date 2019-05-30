//
//  TerminalVC.swift
//  Dabble
//
//  Created by Vivek Rai on 27/05/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit
import CoreBluetooth
import MBProgressHUD

class TerminalVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, BluetoothSerialDelegate  {
   
    //    MARK: Variables here
    var scrollOff: Bool = false
    var chatArray: [Terminal] = []
    var stringArray: [String] = []
    var dataType = "ASCII"
    var autoSendText = false
    //    MARK: IBOutlets here
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var assistantButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var connectButton: UIBarButtonItem!
    @IBOutlet weak var scrollButton: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // textView
        textView.delegate = self
        textView.layer.cornerRadius = 8
        textView.text = ""
        
        // tableView
        chatTableView.delegate = self
        chatTableView.dataSource = self
        chatTableView.tableFooterView = UIView(frame: CGRect.zero)
        chatTableView.separatorStyle = .none
        chatTableView.keyboardDismissMode = .onDrag
        chatTableView.rowHeight = UITableView.automaticDimension
        chatTableView.estimatedRowHeight = UITableView.automaticDimension
        
        
        // reloadView
        reloadView()
        NotificationCenter.default.addObserver(self, selector: #selector(TerminalVC.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
        
        // Listen for KeyBoard Events
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillChange(notification:)), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        serial.stopScan()
        // Go back to the previous ViewController
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func reloadView() {
        // in case we're the visible view again
        serial.delegate = self
        
        if serial.isReady {
            //            navItem.title = serial.connectedPeripheral!.name
            connectButton.title = "Disconnect"
            connectButton.image = UIImage(named: "connect")
            connectButton.isEnabled = true
        } else if serial.centralManager.state == .poweredOn {
            //            navItem.title = "Bluetooth Serial"
            connectButton.image = UIImage(named: "disconnect")
            connectButton.tintColor = UIColor.white
            connectButton.isEnabled = true
        } else {
            //            navItem.title = "Bluetooth Serial"
            connectButton.image = UIImage(named: "disconnect")
            connectButton.tintColor = UIColor.white
            connectButton.isEnabled = false
        }
    }
    
    // keyboard methods
    
    deinit {
        // Stop Listening for keyboards
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
    }
    
    @objc func keyBoardWillChange(notification: Notification){
        guard let keyboardRect = (notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {return}
        
        if notification.name == UIResponder.keyboardWillShowNotification || notification.name == UIResponder.keyboardWillChangeFrameNotification{
            view.frame.origin.y = -keyboardRect.height
        }else{
            view.frame.origin.y = 0
        }
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.chatTableView.endEditing(true)
    }
    
    
    // tableView delegates and dataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? TerminalCell{
            cell.phoneLabel.text = chatArray[indexPath.row].phoneText
            cell.phoneTimeStamp.text = chatArray[indexPath.row].phoneTime
            cell.eviveLabel.text = chatArray[indexPath.row].eviveText
            cell.eviveTimeStamp.text = chatArray[indexPath.row].eviveTime
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        textView.resignFirstResponder()
        chatTableView.deselectRow(at: indexPath, animated: false)
    }
    
    // Scroll tableView
    
    func scrollToBottom(){
        if chatArray.count > 0 {
            DispatchQueue.main.async {
                let indexPath = IndexPath(row: self.chatArray.count-1, section: 0)
                self.chatTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
        }
    
    }
    
    //MARK: BluetoothSerialDelegate

    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        reloadView()
//        dismissKeyboard()
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = "Disconnected"
        hud.hide(animated: true, afterDelay: 1.0)
    }
    
    func serialDidChangeState() {
        reloadView()
        if serial.centralManager.state != .poweredOn {
//            dismissKeyboard()
            let hud = MBProgressHUD.showAdded(to: view, animated: true)
            hud.mode = MBProgressHUDMode.text
            hud.label.text = "Bluetooth turned off"
            hud.hide(animated: true, afterDelay: 1.0)
        }
    }
    
    func serialDidReceiveBytes(_ bytes: [UInt8]) {
        print(bytes)
        var str: String = ""
        let length: Int = Int(bytes[4]) + 5
        //        print(bytes[length])
        print(length)
        var i = 5
        while i < length{
            str += String(Character(UnicodeScalar(bytes[i])))
            i += 1
        }
        
        
        if dataType == "ASCII"{
            str += ""
        }
        if dataType == "Binary"{
            let binaryData = Data(str.utf8)
            let stringOf01 = binaryData.reduce("") { (acc, byte) -> String in
                acc + String(byte, radix: 2)
            }
            str = stringOf01
        }
        if dataType == "Decimal"{
            let formatter = NumberFormatter()
            formatter.generatesDecimalNumbers = true
            formatter.numberStyle = NumberFormatter.Style.decimal
            let xa2 : NSNumber? = formatter.number(from: str)
            print(xa2 as Any)
        }
        if dataType == "Hexadecimal"{
            let data = Data(str.utf8)
            let hexString = data.map{ String(format:"%02x", $0) }.joined()
            str = "\(hexString)"
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm:ss a',' MMMM dd, yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let dateString = formatter.string(from: Date())
        let data = Terminal(phoneText: "", eviveText: str, phoneTime: "", eviveTime: dateString)
        chatArray.append(data)
        chatTableView.reloadData()
        if scrollOff == false{
            chatTableView.reloadData()
            scrollToBottom()
        }
    }
    
    // string to byte Array conversion
    func toByteArray( _ hex:String ) -> [UInt8] {
        
        // remove "-" from Hexadecimal
        let hexString = hex.removeWord( "-" )
        
        let size = hexString.count / 2
        var result:[UInt8] = [UInt8]( repeating: 0, count: size ) // array with length = size
        
        // for ( int i = 0; i < hexString.length; i += 2 )
        for i in stride( from: 0, to: hexString.count, by: 2 ) {
            
            let subHexStr = hexString.subString( i, length: 2 )
            
            result[ i / 2 ] = UInt8( subHexStr, radix: 16 )! // ! - because could be null
        }
        
        return result
    }
    
    func string_Bytes(str: String) -> [UInt8] {
        let buf: [UInt8] = Array(str.utf8)
        return buf
    }
    
    func numberOfLines(textView: UITextView) -> Int {
        let layoutManager:NSLayoutManager = textView.layoutManager
        let numberOfGlyphs = layoutManager.numberOfGlyphs
        print(1000+numberOfGlyphs)
        var numberOfLines = 0
        var index = 0
        var lineRange:NSRange = NSRange()
        
        while (index < numberOfGlyphs) {
            layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange)
            index = NSMaxRange(lineRange);
            numberOfLines = numberOfLines + 1
        }
        
        return numberOfLines
    }
    
    @objc func sendMessage(){
        if textView.text.count > 0 && autoSendText{
            sendMessagePhoneToEvive()
        }
        
    }
    
    func textViewDidChange(_ textView: UITextView) {
        Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(TerminalVC.sendMessage), userInfo: nil, repeats: false)
       
    }
   
    func sendMessagePhoneToEvive(){
        if !serial.isReady {
            let alert = UIAlertController(title: "Not connected", message: "Where I am supposed to send this ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { action -> Void in self.dismiss(animated: true, completion: nil) }))
            present(alert, animated: true, completion: nil)
            textView.resignFirstResponder()
            return
        }
        if scrollOff == false{
            chatTableView.reloadData()
            scrollToBottom()
        }
        var stringFormatted = textView.text!
        if dataType == "ASCII"{
            stringFormatted += ""
        }
        if dataType == "Binary"{
            let binaryData = Data(stringFormatted.utf8)
            let stringOf01 = binaryData.reduce("") { (acc, byte) -> String in
                acc + String(byte, radix: 2)
            }
            stringFormatted = stringOf01
        }
        if dataType == "Decimal"{
            //            let formatter = NumberFormatter()
            //            formatter.generatesDecimalNumbers = true
            //            formatter.numberStyle = NumberFormatter.Style.decimal
            //            let xa2 : NSNumber? = formatter.number(from: stringFormatted)
            //            print(xa2 as Any)
            
        }
        if dataType == "Hexadecimal"{
            let data = Data(stringFormatted.utf8)
            let hexString = data.map{ String(format:"%02x", $0) }.joined()
            stringFormatted = "\(hexString)"
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm:ss a',' MMMM dd, yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let dateString = formatter.string(from: Date())
        
        let data = Terminal(phoneText: stringFormatted, eviveText: "", phoneTime: dateString, eviveTime: "")
        chatArray.append(data)
        chatTableView.reloadData()
        var phoneToEviveByteArray: [UInt8] = []
        let phoneToEviveString: String = "FF0201"
        phoneToEviveByteArray.append(contentsOf: toByteArray(phoneToEviveString))
        
        phoneToEviveByteArray.append(contentsOf: toByteArray("0\(numberOfLines(textView: textView))"))
        
        var str: String = ""
        for i in textView.text!{
            if i == "\n"{
                stringArray.append(str)
                str = ""
            }else{
                str += String(i)
            }
        }
        if str.count > 0{
            stringArray.append(str)
            str = ""
        }
        
        print(stringArray)
        for i in stringArray{
            phoneToEviveByteArray.append(contentsOf: toByteArray(String(format:"%02X", i.count)))
            phoneToEviveByteArray.append(contentsOf: string_Bytes(str: i))
        }
        
        
        phoneToEviveByteArray.append(contentsOf: toByteArray("00"))
        print(phoneToEviveByteArray)
        serial.sendBytesToDevice(phoneToEviveByteArray)
        textView.text = ""
        stringArray.removeAll()
        textView.resignFirstResponder()
        return
    }
    
    @IBAction func sendButtonPressed(_ sender: Any) {
        if !serial.isReady {
            let alert = UIAlertController(title: "Not connected", message: "Where I am supposed to send this ?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss", style: UIAlertAction.Style.default, handler: { action -> Void in self.dismiss(animated: true, completion: nil) }))
            present(alert, animated: true, completion: nil)
            textView.resignFirstResponder()
            return
        }
        if scrollOff == false{
            chatTableView.reloadData()
            scrollToBottom()
        }
        var stringFormatted = textView.text!
        if dataType == "ASCII"{
            stringFormatted += ""
        }
        if dataType == "Binary"{
            let binaryData = Data(stringFormatted.utf8)
            let stringOf01 = binaryData.reduce("") { (acc, byte) -> String in
                acc + String(byte, radix: 2)
            }
            stringFormatted = stringOf01
        }
        if dataType == "Decimal"{
//            let formatter = NumberFormatter()
//            formatter.generatesDecimalNumbers = true
//            formatter.numberStyle = NumberFormatter.Style.decimal
//            let xa2 : NSNumber? = formatter.number(from: stringFormatted)
//            print(xa2 as Any)
            
        }
        if dataType == "Hexadecimal"{
            let data = Data(stringFormatted.utf8)
            let hexString = data.map{ String(format:"%02x", $0) }.joined()
            stringFormatted = "\(hexString)"
        }
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "h:mm:ss a',' MMMM dd, yyyy"
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        let dateString = formatter.string(from: Date())
        
        let data = Terminal(phoneText: stringFormatted, eviveText: "", phoneTime: dateString, eviveTime: "")
        chatArray.append(data)
        chatTableView.reloadData()
        var phoneToEviveByteArray: [UInt8] = []
        let phoneToEviveString: String = "FF0201"
        phoneToEviveByteArray.append(contentsOf: toByteArray(phoneToEviveString))

        phoneToEviveByteArray.append(contentsOf: toByteArray("0\(numberOfLines(textView: textView))"))
        
       var str: String = ""
        for i in textView.text!{
            if i == "\n"{
                stringArray.append(str)
                str = ""
            }else{
                str += String(i)
            }
        }
        if str.count > 0{
            stringArray.append(str)
            str = ""
        }
        
        print(stringArray)
        for i in stringArray{
            phoneToEviveByteArray.append(contentsOf: toByteArray(String(format:"%02X", i.count)))
            phoneToEviveByteArray.append(contentsOf: string_Bytes(str: i))
        }
        
     
        phoneToEviveByteArray.append(contentsOf: toByteArray("00"))
        print(phoneToEviveByteArray)
        serial.sendBytesToDevice(phoneToEviveByteArray)
        textView.text = ""
        stringArray.removeAll()
        textView.resignFirstResponder()
        return
    }
    
    
    @IBAction func connectButtonPressed(_ sender: Any) {
        textView.resignFirstResponder()
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action:#selector(TerminalVC.back(sender:)))
        self.navigationItem.backBarButtonItem = newBackButton
        connectButton.tintColor = UIColor.white
        
        if serial.connectedPeripheral == nil {
            performSegue(withIdentifier: "showBluetoothScanner", sender: self)
        } else if serial.connectedPeripheral != nil {
            serial.disconnect()
            reloadView()
        }
    }
    @IBAction func deleteButtonPressed(_ sender: Any) {
        let alertVC = UIAlertController(title: "Delete", message: "Do you really want to clear all chat?", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { action in
            self.chatArray.removeAll()
            self.chatTableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in }
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    @IBAction func menuButtonPressed(_ sender: Any) {
        let menuPopUp = UIAlertController(title: "Choose Options", message: nil, preferredStyle: .actionSheet)
        
        let ascii = UIAlertAction(title: "ASCII", style: .destructive) { (buttonTapped) in
            self.dataType = "ASCII"
        }
        let binary = UIAlertAction(title: "Binary", style: .destructive) { (buttonTapped) in
            self.dataType = "Binary"
        }
        let decimal = UIAlertAction(title: "Decimal", style: .destructive) { (buttonTapped) in
            self.dataType = "Decimal"
        }
        let hex = UIAlertAction(title: "Hexadecimal", style: .destructive) { (buttonTapped) in
            self.dataType = "Hexadecimal"
            
        }
        let autoSend = UIAlertAction(title: "Auto Send (2 sec)", style: .destructive) { (buttonTapped) in
            
            self.autoSendText = true
        }
        let help = UIAlertAction(title: "Help", style: .destructive) { (buttonTapped) in
            let alertVC = UIAlertController(title: "Terminal", message: "This module allows you to both send and receive data from a device with this module.\n\nYou can send both textual and voice commands to the device eg. turning it ON or OFF. The messages are displayed with a timestamp.\n\nYou can publish data sent by the device on the app.\n\nThe data can be displayed in 4 formats: ASCII, Binary, Decimal and Hexadecimal.", preferredStyle: .alert)
            let knowMore = UIAlertAction(title: "More Info", style: .default) { action in
                UIApplication.shared.open(URL(string: "https://thestempedia.com/docs/dabble/terminal-module/")!, options: [:], completionHandler: nil)
            }
            let close = UIAlertAction(title: "Close", style: .default) { action in
            }
            alertVC.addAction(knowMore)
            alertVC.addAction(close)
            self.present(alertVC, animated: true, completion: nil)
            
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        
        menuPopUp.addAction(ascii)
        menuPopUp.addAction(binary)
        menuPopUp.addAction(decimal)
        menuPopUp.addAction(hex)
        menuPopUp.addAction(autoSend)
        menuPopUp.addAction(help)
        menuPopUp.addAction(cancelAction)
        present(menuPopUp, animated: true, completion: nil)
    }
    
    @IBAction func scrollButtonPressed(_ sender: Any) {
        if scrollOff{
            scrollButton.image = UIImage(named: "scroll")
            scrollButton.tintColor = UIColor.white
            chatTableView.reloadData()
            scrollToBottom()
            scrollOff = false
            
        }else{
            scrollButton.image = UIImage(named: "scrollOff")
            scrollButton.tintColor = UIColor.gray
            scrollOff = true
        }
    }
}


