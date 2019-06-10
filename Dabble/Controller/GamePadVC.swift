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
import SCLAlertView
import CoreMotion
import AVFoundation

class GamePadVC: UIViewController, BluetoothSerialDelegate, JoystickViewDelegate {
    
    @IBOutlet weak var joystickView: KZJoystickView!
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
    @IBOutlet weak var accelOuter: UIImageView!
    @IBOutlet weak var accelInner: UIImageView!
    
    
    
    
//    Variables to check whether frames repeats or not
    var checkAngleFrameRepeat: String = ""
    var checkRadiusFrameRepeat: String = ""
    var motionManager: CMMotionManager!
    var accelInnerX: CGFloat?
    var accelInnerY: CGFloat?
    
//    Var for accelerometer
    var accelInnerLastX: CGFloat = 0.0
    var accelInnerLastY: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(GamePadVC.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
        
        gamePadButtonsPressed()
        joystickView.delegate = self
        joystickView.isHidden = true
        accelOuter.isHidden = true
        accelInner.isHidden = true
        
        accelInnerX = accelInner.frame.origin.x
        accelInnerY = accelInner.frame.origin.y
        
        // Handling Core Motion
        motionManager = CMMotionManager()
        self.motionManager.stopAccelerometerUpdates()
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
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let string: String = "FF01010102040000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func triangleReleased(){
       
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func squarePressed(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let string: String = "FF01010102200000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func squareReleased(){
       
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func circlePressed(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let string: String = "FF01010102080000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func circleReleased(){
        
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func crossPressed(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let string: String = "FF01010102100000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func crossReleased(){
        
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func startPressed(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let string: String = "FF01010102010000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func startReleased(){
       
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func selectPressed(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let string: String = "FF01010102020000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func selectReleased(){
        
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func upPressed(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let string: String = "FF01010102000100"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func upReleased(){
        
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func downPressed(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let string: String = "FF01010102000200"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func downReleased(){
        
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func leftPressed(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let string: String = "FF01010102000400"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func leftReleased(){
        
        let string: String = "FF01010102000000"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func rightPressed(){
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        let string: String = "FF01010102000800"
        serial.sendBytesToDevice(toByteArray(string))
    }
    
    @objc func rightReleased(){
        
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
//            connectButton.setImage(UIImage(named: "disconnect"), for: .normal)
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
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        serial.stopScan()
        // Go back to the previous ViewController
        self.navigationController?.popViewController(animated: true)
    }
    
    //    MARK: JoystickView Delegate
    func joystickViewDidEndMoving(_ joystickView: KZJoystickView) {
        
    }
    
    func joystickView(_ joystickView: KZJoystickView, didMoveto angle: Int, distance: Float) {
        //        label.text = "angle: " + String(angle) + " distance: " + String(distance)
        print(distance)
        print(joystickView.thumbView.frame.origin.x, joystickView.thumbView.frame.origin.y )
        let frame: String = "FF0102010200"
        let finalRadius = Int((distance*7))
        let fangle: Int = 0
        
        if angle<0{
            let fangle = Int((24/360)*Float(-2*angle))
            print(fangle)
        }else{
            let fangle = Int((24/360)*Float(2*angle))
            print(fangle)

        }
        
        
//        print(finalRadius)
        let angleFrame = frame + "0\(fangle)" + "00"
        let radiusFrame = frame + "0\(finalRadius)" + "00"
//        print(angleFrame)
//        print(radiusFrame)
        
        if checkAngleFrameRepeat != angleFrame || checkRadiusFrameRepeat != radiusFrame{
            serial.sendBytesToDevice(toByteArray(angleFrame))
            serial.sendBytesToDevice(toByteArray(radiusFrame))
        }
        
        checkAngleFrameRepeat = angleFrame
        checkRadiusFrameRepeat = radiusFrame
        
    }
    
    // Core Motion functioning
    func updateLabels(data: CMAccelerometerData?, error: Error?){
        guard let accelorometerData = data else { return }

        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        
        let x = accelorometerData.acceleration.x
        let y = accelorometerData.acceleration.y

        var frm: CGRect = accelInner.frame
        
        var pos = frm.origin.y - CGFloat(x*5)
        if pos < 180 && pos != accelInnerLastX && pos > 20{
            frm.origin.y = pos
            accelInnerLastX = pos
        }
        pos = frm.origin.x - CGFloat(y*5)
            if pos < 180 && pos != accelInnerLastY && pos > 20{
            frm.origin.x = pos
            accelInnerLastY = pos
        }
        accelInner.frame = frm
        
//        Send data to Evive
        
        let distance = hypot(frm.origin.x - accelInnerX!, frm.origin.y - accelInnerY!)
        print("Distance---\(distance)")
        
        let v1 = CGVector(dx: accelInnerX!, dy: accelInnerY!)
        let v2 = CGVector(dx: frm.origin.x, dy: frm.origin.y)
        let angle = atan2(v2.dy, v2.dx) - atan2(v1.dy, v1.dx)
        var deg = angle * CGFloat(180.0 / Double.pi)
        if deg < 0 {
            deg += 360.0
            print("Angle---\(deg)")
        }else{
            print("Angle---\(deg)")
        }
        
        let frame: String = "FF0103010200"
        let finalRadius = Int((distance*7))
        
        let fangle = Int((24/360)*Float(deg))
        print(fangle)
        
        
        //        print(finalRadius)
        let angleFrame = frame + "0\(fangle)" + "00"
        let radiusFrame = frame + "0\(finalRadius)" + "00"
        //        print(angleFrame)
        //        print(radiusFrame)
        
//        if checkAngleFrameRepeat != angleFrame || checkRadiusFrameRepeat != radiusFrame{
//            serial.sendBytesToDevice(toByteArray(angleFrame))
//            serial.sendBytesToDevice(toByteArray(radiusFrame))
//        }
        
//        checkAngleFrameRepeat = angleFrame
//        checkRadiusFrameRepeat = radiusFrame
        
    }
    
    //    MARK: Back button pressed
    @IBAction func buttonPressed(_ sender: Any) {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        dismiss(animated: true, completion: nil)
    }
//    @objc func canRotate() -> Void {}
    
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
    @IBAction func modeButtonPressed(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false, showCircularIcon: true
        )
        let alertView = SCLAlertView(appearance: appearance)
       
        alertView.addButton("Digital Mode"){
            self.upButton.isHidden = false
            self.downButton.isHidden = false
            self.leftButton.isHidden = false
            self.rightButton.isHidden = false
            self.joystickView.isHidden = true
            self.accelInner.isHidden = true
            self.accelOuter.isHidden = true
            self.motionManager.stopAccelerometerUpdates()

        }
        alertView.addButton("Joystick Mode") {
            print("Joystick button tapped")
            self.upButton.isHidden = true
            self.downButton.isHidden = true
            self.leftButton.isHidden = true
            self.rightButton.isHidden = true
            self.joystickView.isHidden = false
            self.accelInner.isHidden = true
            self.accelOuter.isHidden = true
            self.joystickView.backgroundView.isHidden = false
            self.joystickView.thumbView.isHidden = false
            self.motionManager.stopAccelerometerUpdates()

        }
        alertView.addButton("Accelerometer Mode") {
            print("Accelerometer button tapped")
            self.upButton.isHidden = true
            self.downButton.isHidden = true
            self.leftButton.isHidden = true
            self.rightButton.isHidden = true
            self.joystickView.isHidden = false
            self.joystickView.backgroundView.isHidden = true
            self.joystickView.thumbView.isHidden = true
            self.accelInner.isHidden = false
            self.accelOuter.isHidden = false
            self.motionManager.startAccelerometerUpdates(to: .main, withHandler: self.updateLabels)
            

        }
         alertView.showTitle("Switch Mode", subTitle: "", style: .info)
        
        
    }
    
}


