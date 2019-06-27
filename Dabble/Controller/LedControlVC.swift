//
//  LedControlVC.swift
//  Dabbleabble
//
//  Created by Vivek Rai on 14/06/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit
import CoreBluetooth
import MBProgressHUD

class LedControlVC: UIViewController, BluetoothSerialDelegate {
    
    //    MARK: Variables here
    let arrValues: [Int] = [Int](0...100)
    var powerCheckBool: Bool = true
    var powerValue: Int = 0{
        didSet{
            valueButton.setTitle("\(oldValue)%", for: .normal)
        }
    }
    
    //    MARK: IBOutlets here
    @IBOutlet weak var connectButton: UIBarButtonItem!
    @IBOutlet weak var pinButton: UIButton!
    @IBOutlet weak var valueButton: UIButton!
    @IBOutlet weak var circularSliderView: VivekCircularRingSlider!
    @IBOutlet weak var powerImage: UIImageView!
    @IBOutlet weak var textMessageLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reloadView()
        NotificationCenter.default.addObserver(self, selector: #selector(LedControlVC.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
        
        navigationController?.navigationBar.barTintColor = UIColor(red: 6/255.0, green: 201/255.0, blue: 6/255.0, alpha: 1.0)
        pinButton.layer.cornerRadius = 10
        valueButton.layer.cornerRadius = 10
        
        circularSliderView.delegate = self
        circularSliderView.setCircluarRingShadow(shadowColor: UIColor.clear, radius: 5)
        circularSliderView.setArrayValues(labelValues: arrValues, currentIndex: 0)
        circularSliderView.setKnobOfSlider(knobSize: 40, knonbImage: UIImage(named: "knob")!)
        circularSliderView.setCircularRingWidth(innerRingWidth: 18, outerRingWidth: 18)
        circularSliderView.setCircluarRingColor(innerCirlce: UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0), outerCircle: UIColor(red: 230/255.0, green: 230/255.0, blue: 230/255.0, alpha: 1.0))
        circularSliderView.setValueTextFieldDelegate(viewController: self)
        circularSliderView.setBackgroundColorOfAllButtons(startPointColor: UIColor.clear, endPointColor: UIColor.clear, knobColor: UIColor.flatGreen())
        circularSliderView.setProgressLayerColor(colors: [UIColor(red: 6/255.0, green: 201/255.0, blue: 6/255.0, alpha: 1.0).cgColor, UIColor(red: 3/255.0, green: 229/255.0, blue: 3/255.0, alpha: 1.0).cgColor])
        circularSliderView.setTextLabel(labelFont: UIFont.boldSystemFont(ofSize: 50), textColor: UIColor.green)
        
//        Power
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        powerImage.isUserInteractionEnabled = true
        powerImage.addGestureRecognizer(tapGestureRecognizer)
        
        
        pinButton.setTitle(UserDefaults.standard.string(forKey: "pinValue") ?? "Pin : 555", for: .normal)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if serial.isPoweredOn{
            serial.sendBytesToDevice(toByteArray("FF0003000000"))
            print(toByteArray("FF0003000000"))
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 11/255.0, green: 44/255.0, blue: 96/255.0, alpha: 1.0)
    }
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 53/255.0, green: 173/255.0, blue: 74/255.0, alpha: 1.0)
    }
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.barTintColor = UIColor(red: 11/255.0, green: 44/255.0, blue: 96/255.0, alpha: 1.0)
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
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer){
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        if powerCheckBool{
            tappedImage.image = UIImage(named: "brightnessOn")
            circularSliderView.setCurrentIndexAndUpdate(100)
            powerCheckBool = false
            let brightnessString = "FF0A030101"
            var brightnessByteArray = self.toByteArray(brightnessString)
            let brightnessByte = UInt8(bitPattern: Int8(self.circularSliderView.currentIndex))
            brightnessByteArray.append(brightnessByte)
            brightnessByteArray.append(contentsOf: self.toByteArray("00"))
            print(brightnessByteArray)
            serial.sendBytesToDevice(brightnessByteArray)
        }else{
            tappedImage.image = UIImage(named: "brightnessOff")
            circularSliderView.setCurrentIndexAndUpdate(0)
            powerCheckBool = true
            let offString = "FF0A020101"
            var offByteArray = self.toByteArray(offString)
            let brightnessByte = UInt8(bitPattern: Int8(self.circularSliderView.currentIndex))
            offByteArray.append(brightnessByte)
            offByteArray.append(contentsOf: self.toByteArray("00"))
            print(offByteArray)
            serial.sendBytesToDevice(offByteArray)
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
    
    func to_byte_array<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafePointer(to: &value) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<T>.size) {
                Array(UnsafeBufferPointer(start: $0, count: MemoryLayout<T>.size))
            }
        }
    }
    
    @IBAction func connectButtonPressed(_ sender: Any) {
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action:#selector(GamePadVC.back(sender:)))
        self.navigationItem.backBarButtonItem = newBackButton
        connectButton.tintColor = UIColor.white
        
        if serial.connectedPeripheral == nil {
            performSegue(withIdentifier: "showBluetoothScanner", sender: self)
        } else if serial.connectedPeripheral != nil {
            serial.disconnect()
            reloadView()
        }
    }
    @IBAction func menuIconPressed(_ sender: Any) {
        let menuPopUp = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let help = UIAlertAction(title: "Help", style: .default) { (buttonTapped) in
            let myAlert = UIAlertController(title: "LED Brightness Control", message: nil, preferredStyle: .alert)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = NSTextAlignment.left
            let messageText = NSMutableAttributedString(
                string: "\nThis module allows you to control the brightness of devices such as LEDs. You can enter the pin number to which your device is connected and vary the brightness.\n\nIf your device is connected to a digital pin, you can turn it ON or OFF by pressing the power button in the centre of the screen.\n\nIf your device is connected to a PWM pin, you can vary its brightness by sliding the green bar in the clockwise direction.",
                attributes: [
                    NSAttributedString.Key.paragraphStyle: paragraphStyle,
                    NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
                    NSAttributedString.Key.foregroundColor : UIColor.black
                ]
            )
            
            myAlert.setValue(messageText, forKey: "attributedMessage")
            let knowMore = UIAlertAction(title: "More Info", style: .default) { action in
                UIApplication.shared.open(URL(string: "https://thestempedia.com/docs/dabble/led-brightness-control-module/")!, options: [:], completionHandler: nil)
            }
            let close = UIAlertAction(title: "Close", style: .default) { action in
            }
            myAlert.addAction(knowMore)
            myAlert.addAction(close)
            self.present(myAlert, animated: true, completion: nil)
            
            print("Help")
        }
        menuPopUp.addAction(help)
        present(menuPopUp, animated: true, completion: nil)
    }
    @IBAction func pinButtonPressed(_ sender: Any) {
        var message = ""
        if DataService.instance.boardName == "Mega"{
            message = "Brightness value is supported only on pins 2 to 13 and 44 to 46"
        }
        if DataService.instance.boardName == "Uno"{
            message = "Brightness value is supported only on pins 3, 5, 6, 9, 10, 11"
        }
        if DataService.instance.boardName == "Nano"{
            message = "Brightness value is supported only on pins 3, 5, 6, 9, 10, 11"
        }
        if DataService.instance.boardName == "Others"{
            message = "Unknown Pins"
        }
        let alertVC = UIAlertController(title: "Choose Pin", message: message, preferredStyle: .alert)
        
        alertVC.addTextField { textField in
            textField.keyboardType = UIKeyboardType.numberPad
        }
        let okAction = UIAlertAction(title: "Select", style: .default) { action in
            if let textField = alertVC.textFields?.first,
                let pinValue = textField.text {
                if pinValue == ""{
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.mode = MBProgressHUDMode.text
                    hud.label.text = "No Value Entered"
                    hud.hide(animated: true, afterDelay: 1.0)
                }else{
                    UserDefaults.standard.set("Pin : \(pinValue)", forKey: "pinValue")
                    if DataService.instance.pinArray.contains(Int(pinValue)!){
                        self.pinButton.setTitle("Pin : \(pinValue)", for:  .normal)
                        let pinString = "FF0A010101"
                        var pinByteArray = self.toByteArray(pinString)
                        let pinByte = UInt8(bitPattern: Int8(pinValue)!)
                        pinByteArray.append(pinByte)
                        pinByteArray.append(contentsOf: self.toByteArray("00"))
                        print(pinByteArray)
                        serial.sendBytesToDevice(pinByteArray)
                        self.textMessageLabel.text = ""
                    }else{
                        self.textMessageLabel.text = "Brightness value is not supoorted on selected pin"
                        self.pinButton.setTitle("Pin : \(pinValue)", for:  .normal)
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
    
    @IBAction func valueButtonPressed(_ sender: Any) {
        let alertVC = UIAlertController(title: "Enter Brightness Value", message: "0 to 100", preferredStyle: .alert)
        
        alertVC.addTextField { textField in
            textField.keyboardType = UIKeyboardType.numberPad
        }
        
        let okAction = UIAlertAction(title: "Select", style: .default) { action in
            
            if let textField = alertVC.textFields?.first,
                let value = textField.text {
                if value == ""{
                    let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                    hud.mode = MBProgressHUDMode.text
                    hud.label.text = "No Value Entered"
                    hud.hide(animated: true, afterDelay: 1.0)
                }else{
                    if Int(value)! >= 0 && Int(value)! <= 100{
                        self.valueButton.setTitle("Value : \(value)", for: .normal)
                        self.circularSliderView.setCurrentIndexAndUpdate(Int(value)!)
                        let brightnessString = "FF0A030101"
                        var brightnessByteArray = self.toByteArray(brightnessString)
                        let brightnessByte = UInt8(bitPattern: Int8(self.circularSliderView.currentIndex))
                        brightnessByteArray.append(brightnessByte)
                        brightnessByteArray.append(contentsOf: self.toByteArray("00"))
                        print(brightnessByteArray)
                        serial.sendBytesToDevice(brightnessByteArray)
                    }else{
                        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
                        hud.mode = MBProgressHUDMode.text
                        hud.label.text = "Brightness value not supported"
                        hud.hide(animated: true, afterDelay: 1.0)
                    }
                }
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
            
        }
        
        alertVC.addAction(okAction)
        alertVC.addAction(cancelAction)
        
        self.present(alertVC, animated: true, completion: nil)
        
    }
}


extension LedControlVC: VivekCircularRingSliderDelegate{
    
    func controlValueUpdated(value: Int) {
        valueButton.setTitle("Value : \(value)%", for: .normal)
        let brightnessString = "FF0A030101"
        var brightnessByteArray = self.toByteArray(brightnessString)
        let brightnessByte = UInt8(bitPattern: Int8(value))
        brightnessByteArray.append(brightnessByte)
        brightnessByteArray.append(contentsOf: self.toByteArray("00"))
        print(brightnessByteArray)
        serial.sendBytesToDevice(brightnessByteArray)

    }
}
