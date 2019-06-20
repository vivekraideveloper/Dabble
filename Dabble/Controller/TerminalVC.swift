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
import Intents
import Speech
import RNPulseButton

class TerminalVC: UIViewController, UITextViewDelegate, UITableViewDelegate, UITableViewDataSource, BluetoothSerialDelegate, SFSpeechRecognizerDelegate  {
    
    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        return view
    }()
    
    let cancelView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 255/255, alpha: 1)
        let button = UIButton()
        button.setTitle("Cancel", for: .normal)
        button.setTitleColor(UIColor(red: 32, green: 104, blue: 253) , for: .normal)
        button.contentHorizontalAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        view.addSubview(button)
        button.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 10, width: 0, height: 0)
        return view
    }()
    let chooseOptions: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = label.font.withSize(14)
        label.textColor = UIColor(red: 179, green: 179, blue: 179)
        label.text = "Choose Options"
        return label
    }()
    
    let separator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        return view
        
    }()
    
    let separator2: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        return view
        
    }()
    let separator3: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        return view
        
    }()
    let separator4: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        return view
        
    }()
    let separator5: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        return view
        
    }()
    let separator6: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 230, green: 230, blue: 230)
        return view
        
    }()
    
    let ascii: UIButton = {
        let button = UIButton()
        button.setTitle("ASCII", for: .normal)
        button.setTitleColor(UIColor(red: 77, green: 77, blue: 77), for: .normal)
        button.contentHorizontalAlignment = .left
        let image = UIImageView()
        image.image = UIImage(named: "untick")
        button.addSubview(image)
        image.anchor(top: button.topAnchor, left: nil, bottom: button.bottomAnchor, right: button.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 20, height: 20)
        return button
    }()
    
    let binary: UIButton = {
        let button = UIButton()
        button.setTitle("Binary", for: .normal)
        button.setTitleColor(UIColor(red: 77, green: 77, blue: 77), for: .normal)
        button.contentHorizontalAlignment = .left
        let image = UIImageView()
        image.image = UIImage(named: "tick")
        button.addSubview(image)
        image.anchor(top: button.topAnchor, left: nil, bottom: button.bottomAnchor, right: button.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 20, height: 20)
        return button
    }()
    
    let decimal: UIButton = {
        let button = UIButton()
        button.setTitle("Decimal", for: .normal)
        button.setTitleColor(UIColor(red: 77, green: 77, blue: 77), for: .normal)
        button.contentHorizontalAlignment = .left
        let image = UIImageView()
        image.image = UIImage(named: "untick")
        button.addSubview(image)
        image.anchor(top: button.topAnchor, left: nil, bottom: button.bottomAnchor, right: button.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 20, height: 20)
        return button
    }()
    
    let hexaDecimal: UIButton = {
        let button = UIButton()
        button.setTitle("Hexadecimal", for: .normal)
        button.setTitleColor(UIColor(red: 77, green: 77, blue: 77), for: .normal)
        button.contentHorizontalAlignment = .left
        let image = UIImageView()
        image.image = UIImage(named: "untick")
        button.addSubview(image)
        image.anchor(top: button.topAnchor, left: nil, bottom: button.bottomAnchor, right: button.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 20, height: 20)
        return button
    }()
   
    let autoSend: UIButton = {
        let button = UIButton()
        button.setTitle("Autosend (2 sec)", for: .normal)
        button.setTitleColor(UIColor(red: 77, green: 77, blue: 77), for: .normal)
        button.contentHorizontalAlignment = .left
        let image = UIImageView()
        image.image = UIImage(named: "tick")
        button.addSubview(image)
        image.anchor(top: button.topAnchor, left: nil, bottom: button.bottomAnchor, right: button.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 20, height: 20)
        return button
    }()
    
    let help: UIButton = {
        let button = UIButton()
        button.setTitle("Help", for: .normal)
        button.setTitleColor(UIColor(red: 77, green: 77, blue: 77), for: .normal)
        button.contentHorizontalAlignment = .center
        return button
    }()
    
    //    MARK: Variables here
    var scrollOff: Bool = false
    var chatArray: [Terminal] = []
    var stringArray: [String] = []
    var dataType = "ASCII"
    var autoSendText = false
    var eviveToPhoneMessage = ""
    var removeUnnecessaryCharcters: Bool = true
    var checkFramesIncomingBool: Bool = false
    
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private let audioEngine = AVAudioEngine()
    let pulseView = RNPulseButton(frame: CGRect(x: 0, y: 0, width: 100, height: 100),
                                  pulseRadius: 100,
                                  pulseCount: 4,
                                  pulseDuration: 3,
                                  intervalTime: 0.4,
                                  scaleFactor: 3,
                                  repeatCount: 100,
                                  pulseColor: UIColor(red: 11/255.0, green: 44/255.0, blue: 96/255.0, alpha: 1.0),
                                  normalImage: nil, selectedImage: nil)
    
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
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = view.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurEffectView)
        
        view.addSubview(containerView)
        view.addSubview(cancelView)
        containerView.anchor(top: nil, left: view.leftAnchor, bottom: cancelView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: 0, height: 410)
        cancelView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 20, paddingRight: 10, width: 0, height: 50)
        
        containerView.addSubview(chooseOptions)
        chooseOptions.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 8, paddingLeft: 0, paddingBottom: 8, paddingRight: 0, width: 0, height: 20)
        
        containerView.addSubview(separator)
        separator.anchor(top: chooseOptions.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 5, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 5)
        
        containerView.addSubview(ascii)
        ascii.anchor(top: separator.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        containerView.addSubview(separator2)
        separator2.anchor(top: ascii.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 2)
        
        containerView.addSubview(binary)
        binary.anchor(top: separator2.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        containerView.addSubview(separator3)
        separator3.anchor(top: binary.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 2)
        
        containerView.addSubview(decimal)
        decimal.anchor(top: separator3.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        containerView.addSubview(separator4)
        separator4.anchor(top: decimal.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 2)
        
        containerView.addSubview(hexaDecimal)
        hexaDecimal.anchor(top: separator4.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        containerView.addSubview(separator5)
        separator5.anchor(top: hexaDecimal.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 5)
        
        containerView.addSubview(autoSend)
        autoSend.anchor(top: separator5.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 0, width: 0, height: 40)
        
        containerView.addSubview(separator6)
        separator6.anchor(top: autoSend.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 5)
        
        containerView.addSubview(help)
        help.anchor(top: separator6.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 10, paddingRight: 0, width: 0, height: 40)

        
        
       
        
        
        
        
        
        
        
        
        pulseView.center = view.convert(view.center, from: view.superview)
        self.view.addSubview(pulseView)
        pulseView.isHidden = true
        
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
        
        // Speech Recognition
        assistantButton.isEnabled = false  //2
        
        speechRecognizer!.delegate = self  //3
        
        SFSpeechRecognizer.requestAuthorization { (authStatus) in  //4
            
            var isButtonEnabled = false
            
            switch authStatus {  //5
            case .authorized:
                isButtonEnabled = true
                
            case .denied:
                isButtonEnabled = false
                print("User denied access to speech recognition")
                
            case .restricted:
                isButtonEnabled = false
                print("Speech recognition restricted on this device")
                
            case .notDetermined:
                isButtonEnabled = false
                print("Speech recognition not yet authorized")
            @unknown default:
                print("Unknown Value detected")
            }
            
            OperationQueue.main.addOperation() {
                self.assistantButton.isEnabled = isButtonEnabled
            }
        }
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
    
    func alertView(){
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.chatTableView.endEditing(true)
    }
    
    // Speech Recognition methods
    func startRecording() {
        
        if recognitionTask != nil {
            recognitionTask?.cancel()
            recognitionTask = nil
        }
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.record)
            try audioSession.setMode(AVAudioSession.Mode.measurement)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            print("audioSession properties weren't set because of an error.")
        }
        
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        
        let inputNode = audioEngine.inputNode
        
        guard let recognitionRequest = recognitionRequest else {
            fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
        }
        
        recognitionRequest.shouldReportPartialResults = true
        
        recognitionTask = speechRecognizer!.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
            
            var isFinal = false
            
            if result != nil {
                
                self.textView.text = result?.bestTranscription.formattedString
                isFinal = (result?.isFinal)!
            }
            
            if error != nil || isFinal {
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                self.assistantButton.isEnabled = true
            }
        })
        
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        
        do {
            try audioEngine.start()
        } catch {
            print("audioEngine couldn't start because of an error.")
        }
        
        textView.text = "Say something, I'm listening!"
        
    }
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            assistantButton.isEnabled = true
        } else {
            assistantButton.isEnabled = false
        }
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
    
    func serialDidReceiveData(_ data: Data) {
        print(data.count)
        
    }
    
    
    func serialDidReceiveBytes(_ bytes: [UInt8]) {
        print(bytes)
        var i = 0
        while i < bytes.count {
            eviveToPhoneMessage += String(Character(UnicodeScalar(bytes[i])))
            if bytes[i] == UInt8("0"){
                print("I succeeded")
                checkFramesIncomingBool = true
            }
            i += 1
        }
//        if removeUnnecessaryCharcters{
//            eviveToPhoneMessage.removeFirst()
//            eviveToPhoneMessage.removeFirst()
//            eviveToPhoneMessage.removeFirst()
//            removeUnnecessaryCharcters = false
//        }
        
        print(eviveToPhoneMessage)
        
        if checkFramesIncomingBool{
            eviveToPhoneMessage.removeFirst()
            if dataType == "ASCII"{
                eviveToPhoneMessage += ""
            }
            if dataType == "Binary"{
                let binaryData = Data(eviveToPhoneMessage.utf8)
                let stringOf01 = binaryData.reduce("") { (acc, byte) -> String in
                    acc + String(byte, radix: 2)
                }
                eviveToPhoneMessage = stringOf01
            }
            if dataType == "Decimal"{
                let binaryData = Data(eviveToPhoneMessage.utf8)
                let stringOf01 = binaryData.reduce("") { (acc, byte) -> String in
                    acc + String(byte, radix: 10)
                }
                print(stringOf01)
                eviveToPhoneMessage = stringOf01
            }
            if dataType == "Hexadecimal"{
                let data = Data(eviveToPhoneMessage.utf8)
                let hexString = data.map{ String(format:"%02x", $0) }.joined()
                eviveToPhoneMessage = "\(hexString)"
            }
            
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "h:mm:ss a',' MMMM dd, yyyy"
            formatter.amSymbol = "AM"
            formatter.pmSymbol = "PM"
            let dateString = formatter.string(from: Date())
            let data = Terminal(phoneText: "", eviveText: eviveToPhoneMessage, phoneTime: "", eviveTime: dateString)
            chatArray.append(data)
            chatTableView.reloadData()
            eviveToPhoneMessage = ""
            checkFramesIncomingBool = false
            if scrollOff == false{
                chatTableView.reloadData()
                scrollToBottom()
            }
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
            alert.addAction(UIAlertAction(title: "Connect", style: UIAlertAction.Style.default, handler: { (action) in
                self.performSegue(withIdentifier: "showBluetoothScanner", sender: self)
            }))
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
            let binaryData = Data(stringFormatted.utf8)
            let stringOf01 = binaryData.reduce("") { (acc, byte) -> String in
                acc + String(byte, radix: 10)
            }
            print(stringOf01)
            stringFormatted = stringOf01
            
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
       sendMessagePhoneToEvive()
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
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.text
            hud.label.text = "ASCII"
            hud.hide(animated: true, afterDelay: 1.0)
        }
        let binary = UIAlertAction(title: "Binary", style: .destructive) { (buttonTapped) in
            self.dataType = "Binary"
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.text
            hud.label.text = "Binary"
            hud.hide(animated: true, afterDelay: 1.0)
        }
        let decimal = UIAlertAction(title: "Decimal", style: .destructive) { (buttonTapped) in
            self.dataType = "Decimal"
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.text
            hud.label.text = "Decimal"
            hud.hide(animated: true, afterDelay: 1.0)
        }
        let hex = UIAlertAction(title: "Hexadecimal", style: .destructive) { (buttonTapped) in
            self.dataType = "Hexadecimal"
            let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
            hud.mode = MBProgressHUDMode.text
            hud.label.text = "Hexadecimal"
            hud.hide(animated: true, afterDelay: 1.0)
            
        }
        let autoSend = UIAlertAction(title: "Auto Send (2 sec)", style: .destructive) { (buttonTapped) in
            if !self.autoSendText{
                self.autoSendText = true
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = MBProgressHUDMode.text
                hud.label.text = "AutoSend Turned On"
                hud.hide(animated: true, afterDelay: 2.0)
            }else{
                self.autoSendText = false
                let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                hud.mode = MBProgressHUDMode.text
                hud.label.text = "AutoSend Turned Off"
                hud.hide(animated: true, afterDelay: 2.0)
            }
            
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
    @IBAction func assistantButtonPressed(_ sender: Any) {
        if audioEngine.isRunning {
            textView.text = ""
            pulseView.isHidden = true
            pulseView.stop()
            audioEngine.stop()
            recognitionRequest?.endAudio()
            assistantButton.isEnabled = false
            assistantButton.setTitle("", for: .normal)
        } else {
            pulseView.isHidden = false
            pulseView.start()
            startRecording()
            assistantButton.setTitle("Stop", for: .normal)
        }
    }
}


