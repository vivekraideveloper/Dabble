//
//  GamePadVC.swift
//  Dabble
//
//  Created by Vivek Rai on 31/05/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit
import AudioToolbox
import CoreBluetooth
import QuartzCore
import MBProgressHUD

class GamePadVC: UIViewController, BluetoothSerialDelegate {
  
    @IBOutlet weak var triangleButton: UIButton!
    @IBOutlet weak var squareButton: UIButton!
    @IBOutlet weak var crossButton: UIButton!
    @IBOutlet weak var circleButton: UIButton!
    @IBOutlet weak var selectButton: UIButton!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var upButton: UIButton!
    @IBOutlet weak var downButton: UIButton!
    @IBOutlet weak var rightButton: UIButton!
    @IBOutlet weak var leftButton: UIButton!
    @IBOutlet weak var connectButton: UIButton!
    @IBOutlet weak var modeButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GamePadVC.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
        
        gamePadButtonsPressed()
    }
    
    func gamePadButtonsPressed(){
        
        triangleButton.addTarget(self, action: #selector(trianglePressed), for: .touchDown)
        triangleButton.addTarget(self, action: #selector(triangleReleased), for: .touchUpInside)
        
        squareButton.addTarget(self, action: #selector(squarePressed), for: .touchDown)
        squareButton.addTarget(self, action: #selector(squareReleased), for: .touchUpInside)
        
        crossButton.addTarget(self, action: #selector(crossPressed), for: .touchDown)
        crossButton.addTarget(self, action: #selector(crossReleased), for: .touchUpInside)
        
        circleButton.addTarget(self, action: #selector(circlePressed), for: .touchDown)
        circleButton.addTarget(self, action: #selector(circleReleased), for: .touchUpInside)
        
        selectButton.addTarget(self, action: #selector(selectPressed), for: .touchDown)
        selectButton.addTarget(self, action: #selector(selectReleased), for: .touchUpInside)
        
        startButton.addTarget(self, action: #selector(startPressed), for: .touchDown)
        startButton.addTarget(self, action: #selector(startReleased), for: .touchUpInside)
        
        upButton.addTarget(self, action: #selector(upPressed), for: .touchDown)
        upButton.addTarget(self, action: #selector(upReleased), for: .touchUpInside)
        
        downButton.addTarget(self, action: #selector(downPressed), for: .touchDown)
        downButton.addTarget(self, action: #selector(downReleased), for: .touchUpInside)
        
        rightButton.addTarget(self, action: #selector(rightPressed), for: .touchDown)
        rightButton.addTarget(self, action: #selector(rightReleased), for: .touchUpInside)
        
        leftButton.addTarget(self, action: #selector(leftPressed), for: .touchDown)
        leftButton.addTarget(self, action: #selector(leftReleased), for: .touchUpInside)
    }
    
   
    @objc func trianglePressed(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102040000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func triangleReleased(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func squarePressed(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102200000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func squareReleased(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func circlePressed(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102080000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func circleReleased(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func crossPressed(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102100000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func crossReleased(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func startPressed(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000800"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func startReleased(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func selectPressed(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000800"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func selectReleased(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func upPressed(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000100"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func upReleased(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func downPressed(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000200"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func downReleased(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func leftPressed(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000400"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func leftReleased(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func rightPressed(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Pressed")
        let string: String = "FF01010102000800"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func rightReleased(){
        AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        print("Released")
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func reloadView() {
        // in case we're the visible view again
        serial.delegate = self
        
        if serial.isReady {
            connectButton.setImage(UIImage(named: "connect"), for: .normal)
            connectButton.isEnabled = true
        } else if serial.centralManager.state == .poweredOn {
            connectButton.setImage(UIImage(named: "disconnect"), for: .normal)
            connectButton.tintColor = UIColor.white
            connectButton.isEnabled = true
        } else {
            connectButton.setImage(UIImage(named: "disconnect"), for: .normal)
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
    
    //MARK: Rotate device
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeRight.rawValue, forKey: "orientation")
        
    }
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeRight
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeRight
    }
    
    // convert to byteArray
    func toByteArray( _ hex:String ) -> [UInt8] {
        
        // remove "-" from Hexadecimal
        let hexString = hex.removeWord( "-" )
        let size = hexString.count / 2
        var result:[UInt8] = [UInt8]( repeating: 0, count: size ) // array with length = size
        for i in stride( from: 0, to: hexString.count, by: 2 ) {
            let subHexStr = hexString.subString( i, length: 2 )
            result[ i / 2 ] = UInt8( subHexStr, radix: 16 )! // ! - because could be null
        }
        
        return result
    }
    
    //    MARK: Back button pressed
    @IBAction func buttonPressed(_ sender: Any) {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        dismiss(animated: true, completion: nil)
    }
//    @objc func canRotate() -> Void {}
    
    @IBAction func connectButtonPressed(_ sender: Any) {
        if serial.connectedPeripheral == nil {
            performSegue(withIdentifier: "showBluetoothScanner", sender: self)
        } else if serial.connectedPeripheral != nil {
            serial.disconnect()
            reloadView()
        }
    }
    @IBAction func modeButtonPressed(_ sender: Any) {
    }
    
}


