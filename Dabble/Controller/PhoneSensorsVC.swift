//
//  PhoneSensorsVC.swift
//  Dabbleabble
//
//  Created by Vivek Rai on 13/06/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit
import CoreBluetooth
import MBProgressHUD
import QuartzCore
import SCLAlertView
import CoreMotion
import CoreLocation
import AVFoundation
import CoreAudio

class PhoneSensorsVC: UIViewController, BluetoothSerialDelegate, CLLocationManagerDelegate {

    //    MARK: IBOutlets here
    @IBOutlet weak var connectButton: UIBarButtonItem!
    @IBOutlet weak var menuIcon: UIBarButtonItem!
    @IBOutlet weak var accelerometerX: UITextField!
    @IBOutlet weak var accelerometerY: UITextField!
    @IBOutlet weak var accelerometerZ: UITextField!
    @IBOutlet weak var gyroscopeX: UITextField!
    @IBOutlet weak var gyroscopeY: UITextField!
    @IBOutlet weak var gyroscopeZ: UITextField!
    @IBOutlet weak var magnetometerX: UITextField!
    @IBOutlet weak var magnetometerY: UITextField!
    @IBOutlet weak var magnetometerZ: UITextField!
    @IBOutlet weak var soundIntensity: UITextField!
    @IBOutlet weak var locationLongitude: UITextField!
    @IBOutlet weak var locationLatitude: UITextField!
    @IBOutlet weak var pressure: UITextField!
    @IBOutlet weak var accelView: UIView!
    
    //    MARK: Variables here
     var motionManager: CMMotionManager!
    var locationManager: CLLocationManager!
    var altimeter: CMAltimeter!
    var recorder: AVAudioRecorder!
    var levelTimer = Timer()
    
    var accelX: Double = 0
    var accelY: Double = 0
    var accelZ: Double = 0
    var gyroX: Double = 0
    var gyroY: Double = 0
    var gyroZ: Double = 0
    var magnetoX: Double = 0
    var magnetoY: Double = 0
    var magnetoZ: Double = 0
    var audioValue: Float = 0
    var pressureValue: Float = 0
    
    var accelBool = false
    var gyroBool = false
    var magnetoBool = false
    var audioBool = false
    var pressureBool = false
    var locationBool = false
    var timer1: Timer?
    var timer2: Timer?
    var timer3: Timer?
    var timer4: Timer?
    var timer5: Timer?
    var timer6: Timer?

    var sensorCount: Int = 0{
        didSet{
            if self.sensorCount == 1{
                timer1 = Timer.scheduledTimer(timeInterval: 4, target: self, selector: #selector(self.sensorTimer), userInfo: nil, repeats: true)
                print(1)
                timer2?.invalidate()
                timer3?.invalidate()
                timer4?.invalidate()
                timer5?.invalidate()
                timer6?.invalidate()
            }
            if self.sensorCount == 2{
                timer2 = Timer.scheduledTimer(timeInterval: 8, target: self, selector: #selector(self.sensorTimer), userInfo: nil, repeats: true)
                print(2)
                timer1?.invalidate()
                timer3?.invalidate()
                timer4?.invalidate()
                timer5?.invalidate()
                timer6?.invalidate()
            }
            if self.sensorCount == 3{
                timer3 = Timer.scheduledTimer(timeInterval: 12, target: self, selector: #selector(self.sensorTimer), userInfo: nil, repeats: true)
                print(3)
                timer2?.invalidate()
                timer1?.invalidate()
                timer4?.invalidate()
                timer5?.invalidate()
                timer6?.invalidate()
            }
            if self.sensorCount == 4{
                timer4 = Timer.scheduledTimer(timeInterval: 16, target: self, selector: #selector(self.sensorTimer), userInfo: nil, repeats: true)
                print(4)
                timer2?.invalidate()
                timer3?.invalidate()
                timer1?.invalidate()
                timer5?.invalidate()
                timer6?.invalidate()
            }
            if self.sensorCount == 5{
                timer5 = Timer.scheduledTimer(timeInterval: 20, target: self, selector: #selector(self.sensorTimer), userInfo: nil, repeats: true)
                print(5)
                timer2?.invalidate()
                timer3?.invalidate()
                timer4?.invalidate()
                timer1?.invalidate()
                timer6?.invalidate()
            }
            if self.sensorCount == 6{
                timer6 = Timer.scheduledTimer(timeInterval: 24, target: self, selector: #selector(self.sensorTimer), userInfo: nil, repeats: true)
                print(6)
                timer2?.invalidate()
                timer3?.invalidate()
                timer4?.invalidate()
                timer5?.invalidate()
                timer1?.invalidate()
            }
        }
    }
       
       
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        reloadView()
        NotificationCenter.default.addObserver(self, selector: #selector(PhoneSensorsVC.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
        
        
        
        motionManager = CMMotionManager()
//        Accelerometer
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.motionManager.startAccelerometerUpdates(to: .main, withHandler: self.updateAccelerometer)
        })
//        Gyroscope
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.motionManager.startGyroUpdates(to: .main, withHandler: self.updateGyroscope)
        })
//        Magnetometer
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.motionManager.startMagnetometerUpdates(to: .main, withHandler: self.updateMagnetometer)
        })
        
//        Location Manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        locationUpdate()
        
//        Audio Update
        audioUpdate()
        
//        Pressure Update
        altimeter = CMAltimeter()
        if CMAltimeter.isRelativeAltitudeAvailable(){
            altimeter.startRelativeAltitudeUpdates(to: .main) { (data, error) in
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 1
                formatter.maximumFractionDigits = 2
                self.pressure.text = formatter.string(for: Float(data!.pressure))
                self.pressureValue = Float(data!.pressure)
            }
        }
    }
    
    func updateAccelerometer(data: CMAccelerometerData?, error: Error?){
        guard let accelerometerData = data else {return}
        let x = accelerometerData.acceleration.x
        let y = accelerometerData.acceleration.y
        let z = accelerometerData.acceleration.z
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        accelerometerX.text = formatter.string(for: x*9.8)
        accelerometerY.text = formatter.string(for: y*9.8)
        accelerometerZ.text = formatter.string(for: z*9.8)
        accelX = x
        accelY = y
        accelZ = z
    }
    
    func updateGyroscope(data: CMGyroData?, error: Error?){
        guard let gyroData = data else {return}
        let x = gyroData.rotationRate.x
        let y = gyroData.rotationRate.y
        let z = gyroData.rotationRate.z
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        gyroscopeX.text = formatter.string(for: x)
        gyroscopeY.text = formatter.string(for: y)
        gyroscopeZ.text = formatter.string(for: z)
        gyroX = x
        gyroY = y
        gyroZ = z
    }
    
    func updateMagnetometer(data: CMMagnetometerData?, error: Error?){
        guard let magnetoData = data else {return}
        let x = magnetoData.magneticField.x
        let y = magnetoData.magneticField.y
        let z = magnetoData.magneticField.z
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        magnetometerX.text = formatter.string(for: x)
        magnetometerY.text = formatter.string(for: y)
        magnetometerZ.text = formatter.string(for: z)
        magnetoX = x
        magnetoY = y
        magnetoZ = z
    }
    
    func audioUpdate() {
        
        let documents = URL(fileURLWithPath: NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)[0])
        let url = documents.appendingPathComponent("record.caf")
        
        let recordSettings: [String: Any] = [
            AVFormatIDKey:              kAudioFormatAppleIMA4,
            AVSampleRateKey:            44100.0,
            AVNumberOfChannelsKey:      2,
            AVEncoderBitRateKey:        12800,
            AVLinearPCMBitDepthKey:     16,
            AVEncoderAudioQualityKey:   AVAudioQuality.max.rawValue
        ]
        
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSession.Category.playAndRecord)
            try audioSession.setActive(true)
            try recorder = AVAudioRecorder(url:url, settings: recordSettings)
            
        } catch {
            return
        }
        
        recorder.prepareToRecord()
        recorder.isMeteringEnabled = true
        recorder.record()
        
        levelTimer = Timer.scheduledTimer(timeInterval: 0.2, target: self, selector: #selector(levelTimerCallback), userInfo: nil, repeats: true)
    }
    
    func locationUpdate(){
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        
        var currentLocation: CLLocation?
        if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
            CLLocationManager.authorizationStatus() ==  .authorizedAlways){
            
            currentLocation = locationManager.location
            
        }
        locationLongitude.text = formatter.string(for: currentLocation!.coordinate.longitude)
        locationLatitude.text = formatter.string(for: currentLocation!.coordinate.latitude)
    }
    
   
    @objc func levelTimerCallback() {
        recorder.updateMeters()
        
        let level = recorder.peakPower(forChannel: 0)
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        soundIntensity.text = formatter.string(for: level)
        audioValue = level
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
    @objc func sensorTimer(){
        if accelBool{
            let accelerometerString = "FF04010304"
            var accelerometerByteArray = toByteArray(accelerometerString)
            let x_accel = Float(accelX*9.8)
            let y_accel = Float(accelY*9.8)
            let z_accel = Float(accelZ*9.8)
            accelerometerByteArray.append(contentsOf: to_byte_array(x_accel))
            accelerometerByteArray.append(contentsOf: toByteArray("04"))
            accelerometerByteArray.append(contentsOf: to_byte_array(y_accel))
            accelerometerByteArray.append(contentsOf: toByteArray("04"))
            accelerometerByteArray.append(contentsOf: to_byte_array(z_accel))
            accelerometerByteArray.append(contentsOf: toByteArray("00"))
            serial.sendBytesToDevice(accelerometerByteArray)
        }
        
        if gyroBool{
            let gyroscopeString = "FF04020304"
            var gyroscopeByteArray = toByteArray(gyroscopeString)
            let x_gyro = Float(gyroX)
            let y_gyro = Float(gyroY)
            let z_gyro = Float(gyroZ)
            gyroscopeByteArray.append(contentsOf: to_byte_array(x_gyro))
            gyroscopeByteArray.append(contentsOf: toByteArray("04"))
            gyroscopeByteArray.append(contentsOf: to_byte_array(y_gyro))
            gyroscopeByteArray.append(contentsOf: toByteArray("04"))
            gyroscopeByteArray.append(contentsOf: to_byte_array(z_gyro))
            gyroscopeByteArray.append(contentsOf: toByteArray("00"))
            serial.sendBytesToDevice(gyroscopeByteArray)
        }
        if magnetoBool{
            let magnetometerString = "FF04030304"
            var magnetometerByteArray = toByteArray(magnetometerString)
            let x_magneto = Float(magnetoX)
            let y_magneto = Float(magnetoY)
            let z_magneto = Float(magnetoZ)
            magnetometerByteArray.append(contentsOf: to_byte_array(x_magneto))
            magnetometerByteArray.append(contentsOf: toByteArray("04"))
            magnetometerByteArray.append(contentsOf: to_byte_array(y_magneto))
            magnetometerByteArray.append(contentsOf: toByteArray("04"))
            magnetometerByteArray.append(contentsOf: to_byte_array(z_magneto))
            magnetometerByteArray.append(contentsOf: toByteArray("00"))
            serial.sendBytesToDevice(magnetometerByteArray)
        }
        
        if audioBool{
            let audioString = "FF04060104"
            var audioByteArray = toByteArray(audioString)
            audioByteArray.append(contentsOf: to_byte_array(audioValue))
            audioByteArray.append(contentsOf: toByteArray("00"))
            serial.sendBytesToDevice(audioByteArray)
        }
        
        if locationBool{
            var currentLocation: CLLocation?
            if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                currentLocation = locationManager.location
            }
            let lat = Float(currentLocation?.coordinate.latitude ?? 0)
            let lon = Float(currentLocation?.coordinate.longitude ?? 0)
            let locationString = "FF04090204"
            var locationByteArray = toByteArray(locationString)
            locationByteArray.append(contentsOf: to_byte_array(lat))
            locationByteArray.append(contentsOf: toByteArray("04"))
            locationByteArray.append(contentsOf: to_byte_array(lon))
            locationByteArray.append(contentsOf: toByteArray("00"))
            serial.sendBytesToDevice(locationByteArray)
        }
        
        if pressureBool{
            let pressureString = "FF04080104"
            var pressureByteArray = toByteArray(pressureString)
            pressureByteArray.append(contentsOf: to_byte_array(pressureValue))
            pressureByteArray.append(contentsOf: toByteArray("00"))
            serial.sendBytesToDevice(pressureByteArray)
        }
    }
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
    
    @IBAction func accelerometerSwitch(_ sender: UISwitch) {
        if sender.isOn{
            sensorCount += 1
            accelBool = true
        }else{
            sensorCount -= 1
            accelBool = false
        }
    }
    
    @IBAction func gyroscopeSwitch(_ sender: UISwitch) {
        if sender.isOn{
            sensorCount += 1
            gyroBool = true
        }else{
            sensorCount -= 1
            gyroBool = false
        }
    }
    
    @IBAction func magnetometerSwitch(_ sender: UISwitch) {
        if sender.isOn{
            sensorCount += 1
            magnetoBool = true
        }else{
            sensorCount -= 1
            magnetoBool = false
        }
    }
    
    @IBAction func soundSwitch(_ sender: UISwitch) {
        if sender.isOn{
            sensorCount += 1
            audioBool = true
        }else{
            sensorCount -= 1
            audioBool = false
        }
    }
    
    @IBAction func locationSwitch(_ sender: UISwitch) {
        if sender.isOn{
            sensorCount += 1
            locationBool = true
        }else{
            sensorCount -= 1
            locationBool = false
        }
    }
    @IBAction func pressureSwitch(_ sender: UISwitch) {
        if sender.isOn{
            sensorCount += 1
            pressureBool = true
        }else{
            sensorCount -= 1
            pressureBool = false
        }
    }
    
    @IBAction func connectButtonPressed(_ sender: Any) {
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action:#selector(PhoneSensorsVC.back(sender:)))
        self.navigationItem.backBarButtonItem = newBackButton
        connectButton.tintColor = UIColor.white
        
        if serial.connectedPeripheral == nil {
            performSegue(withIdentifier: "showScanner", sender: self)
        } else if serial.connectedPeripheral != nil {
            serial.disconnect()
            reloadView()
        }
    }
    @IBAction func menuButtonPressed(_ sender: Any) {
        let appearance = SCLAlertView.SCLAppearance(
            showCloseButton: false, showCircularIcon: false
        )
        let alertView = SCLAlertView(appearance: appearance)
        
        alertView.addButton("Help"){
            
        }
        alertView.addButton("Refresh Rate - Slow") {
            
        
        }
        alertView.addButton("Refresh Rate - Normal") {
            
        }
        alertView.addButton("Refresh Rate - Fast") {
            
        }
        alertView.showTitle("Dabble", subTitle: "Select options", style: .info)
    }
    
}
