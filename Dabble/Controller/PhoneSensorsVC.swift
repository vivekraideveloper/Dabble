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
    @IBOutlet weak var gyroView: UIView!
    @IBOutlet weak var magnetoView: UIView!
    @IBOutlet weak var soundView: UIView!
    @IBOutlet weak var locationView: UIView!
    @IBOutlet weak var pressureView: UIView!
    @IBOutlet weak var accelLabel: UILabel!
    @IBOutlet weak var gyroLabel: UILabel!
    @IBOutlet weak var magnetoLabel: UILabel!
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    
    
    // AlertViews
    
    
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
        button.addTarget(self, action: #selector(cancelButtonPressed), for: .touchUpInside)
        return view
    }()
    
    let refreshMode: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.textAlignment = NSTextAlignment.left
        label.textColor = UIColor(red: 179, green: 179, blue: 179)
        label.text = "Refresh Rate"
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
    
    let slow: UIButton = {
        let button = UIButton()
        button.setTitle("Refresh Rate - Slow", for: .normal)
        button.setTitleColor(UIColor(red: 77, green: 77, blue: 77), for: .normal)
        button.contentHorizontalAlignment = .left
        let image = UIImageView()
        image.image = UIImage(named: "radioOff")
        button.addSubview(image)
        image.anchor(top: button.topAnchor, left: nil, bottom: button.bottomAnchor, right: button.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 20, height: 20)
        button.addTarget(self, action: #selector(slowButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let normal: UIButton = {
        let button = UIButton()
        button.setTitle("Refresh Rate - Normal", for: .normal)
        button.setTitleColor(UIColor(red: 77, green: 77, blue: 77), for: .normal)
        button.contentHorizontalAlignment = .left
        let image = UIImageView()
        image.image = UIImage(named: "radioOn")
        button.addSubview(image)
        image.anchor(top: button.topAnchor, left: nil, bottom: button.bottomAnchor, right: button.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 20, height: 20)
        button.addTarget(self, action: #selector(normalButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let fast: UIButton = {
        let button = UIButton()
        button.setTitle("Refresh Rate - Fast", for: .normal)
        button.setTitleColor(UIColor(red: 77, green: 77, blue: 77), for: .normal)
        button.contentHorizontalAlignment = .left
        let image = UIImageView()
        image.image = UIImage(named: "radioOff")
        button.addSubview(image)
        image.anchor(top: button.topAnchor, left: nil, bottom: button.bottomAnchor, right: button.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 10, paddingRight: 20, width: 20, height: 20)
        button.addTarget(self, action: #selector(fastButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let help: UIButton = {
        let button = UIButton()
        button.setTitle("Help", for: .normal)
        button.setTitleColor(UIColor(red: 77, green: 77, blue: 77), for: .normal)
        button.contentHorizontalAlignment = .center
        button.addTarget(self, action: #selector(helpButtonPressed), for: .touchUpInside)
        return button
    }()
    
    
    //    MARK: Variables here
     var motionManager: CMMotionManager!
    var locationManager: CLLocationManager!
    var altimeter: CMAltimeter!
    var recorder: AVAudioRecorder!
    var levelTimer = Timer()
    
    var refreshRate: Double = 0.1
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
                timer1 = Timer.scheduledTimer(timeInterval: refreshRate, target: self, selector: #selector(self.sensorTimer), userInfo: nil, repeats: true)
                print(1)
                timer2?.invalidate()
                timer3?.invalidate()
                timer4?.invalidate()
                timer5?.invalidate()
                timer6?.invalidate()
            }
            if self.sensorCount == 2{
                timer2 = Timer.scheduledTimer(timeInterval: refreshRate*2, target: self, selector: #selector(self.sensorTimer), userInfo: nil, repeats: true)
                print(2)
                timer1?.invalidate()
                timer3?.invalidate()
                timer4?.invalidate()
                timer5?.invalidate()
                timer6?.invalidate()
            }
            if self.sensorCount == 3{
                timer3 = Timer.scheduledTimer(timeInterval: refreshRate*3, target: self, selector: #selector(self.sensorTimer), userInfo: nil, repeats: true)
                print(3)
                timer2?.invalidate()
                timer1?.invalidate()
                timer4?.invalidate()
                timer5?.invalidate()
                timer6?.invalidate()
            }
            if self.sensorCount == 4{
                timer4 = Timer.scheduledTimer(timeInterval: refreshRate*4, target: self, selector: #selector(self.sensorTimer), userInfo: nil, repeats: true)
                print(4)
                timer2?.invalidate()
                timer3?.invalidate()
                timer1?.invalidate()
                timer5?.invalidate()
                timer6?.invalidate()
            }
            if self.sensorCount == 5{
                timer5 = Timer.scheduledTimer(timeInterval: refreshRate*5, target: self, selector: #selector(self.sensorTimer), userInfo: nil, repeats: true)
                print(5)
                timer2?.invalidate()
                timer3?.invalidate()
                timer4?.invalidate()
                timer1?.invalidate()
                timer6?.invalidate()
            }
            if self.sensorCount == 6{
                timer6 = Timer.scheduledTimer(timeInterval: refreshRate*6, target: self, selector: #selector(self.sensorTimer), userInfo: nil, repeats: true)
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
        
//        Add shadow and corner radius to Views

        let viewsToRound = [accelLabel, gyroLabel, magnetoLabel, soundLabel, locationLabel, pressureLabel]
        for i in viewsToRound{
            let path = UIBezierPath(roundedRect:i!.bounds, byRoundingCorners:[.topRight, .topLeft], cornerRadii: CGSize(width: 10, height: 10))
            let maskLayer = CAShapeLayer()
            maskLayer.path = path.cgPath
            i!.layer.mask = maskLayer
//            i!.setShadow(color: UIColor.red, opacity: 1, offset: 3, radius: 4)
        }

        let viewToShadow = [accelView, gyroView, magnetoView, soundView, locationView, pressureView]
        for i in viewToShadow{
            i!.dropShadow(color: .gray, opacity: 1, offSet: CGSize(width: -1, height: 1), radius: 10, scale: true)
        }

        
        
        motionManager = CMMotionManager()
//        Accelerometer
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(refreshRate)), execute: {
            self.motionManager.startAccelerometerUpdates(to: .main, withHandler: self.updateAccelerometer)
        })
//        Gyroscope
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(refreshRate)), execute: {
            self.motionManager.startGyroUpdates(to: .main, withHandler: self.updateGyroscope)
        })
//        Magnetometer
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(Int(refreshRate)), execute: {
            self.motionManager.startMagnetometerUpdates(to: .main, withHandler: self.updateMagnetometer)
        })
        
//        Location Manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
//        locationManager.startUpdatingLocation()
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
        
        createAlertView()
    }
    
    func createAlertView(){
        view.addSubview(containerView)
        view.addSubview(cancelView)
        containerView.anchor(top: nil, left: view.leftAnchor, bottom: cancelView.topAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 5, paddingRight: 10, width: 0, height: 280)
        cancelView.anchor(top: nil, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 0, paddingLeft: 10, paddingBottom: 20, paddingRight: 10, width: 0, height: 50)
        containerView.addSubview(refreshMode)
        refreshMode.anchor(top: containerView.topAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 20, paddingLeft: 20, paddingBottom: 8, paddingRight: 20, width: 0, height: 20)
        containerView.addSubview(separator)
        separator.anchor(top: refreshMode.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 20, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 0, height: 3)
        containerView.addSubview(slow)
        slow.anchor(top: separator.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        containerView.addSubview(normal)
        normal.anchor(top: slow.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        containerView.addSubview(fast)
        fast.anchor(top: normal.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 20, paddingBottom: 0, paddingRight: 20, width: 0, height: 40)
        containerView.addSubview(separator2)
        separator2.anchor(top: fast.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 10, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 5)
        containerView.addSubview(help)
        help.anchor(top: separator2.bottomAnchor, left: containerView.leftAnchor, bottom: nil, right: containerView.rightAnchor, paddingTop: 5, paddingLeft: 20, paddingBottom: 8, paddingRight: 20, width: 0, height: 40)
        containerView.isHidden = true
        cancelView.isHidden = true
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
        guard let long = currentLocation?.coordinate.longitude else {return}
        guard let lat = currentLocation?.coordinate.latitude else {return}

        locationLongitude.text = formatter.string(for: long)
        locationLatitude.text = formatter.string(for: lat)
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
    
    @objc func cancelButtonPressed(){
        containerView.animHide()
        cancelView.animHide()
        view.backgroundColor = UIColor.white
//        backButton.backgroundColor = UIColor.white
        print("Cancel")
    }
    @objc func slowButtonPressed(){
        refreshRate = 0.5
        let slowRate = slow.subviews.first(where: { $0 is UIImageView }) as? UIImageView
        let normalRate = normal.subviews.first(where: { $0 is UIImageView }) as? UIImageView
        let fastRate = fast.subviews.first(where: { $0 is UIImageView }) as? UIImageView
        slowRate?.image = UIImage(named: "radioOn")
        normalRate?.image = UIImage(named: "radioOff")
        fastRate?.image = UIImage(named: "radioOff")
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = "Slow Refresh Rate"
        hud.hide(animated: true, afterDelay: 1.0)
        containerView.animHide()
        cancelView.animHide()
        view.backgroundColor = UIColor.white
        print("Slow")
    }
    @objc func normalButtonPressed(){
        refreshRate = 0.1
        let slowRate = slow.subviews.first(where: { $0 is UIImageView }) as? UIImageView
        let normalRate = normal.subviews.first(where: { $0 is UIImageView }) as? UIImageView
        let fastRate = fast.subviews.first(where: { $0 is UIImageView }) as? UIImageView
        slowRate?.image = UIImage(named: "radioOff")
        normalRate?.image = UIImage(named: "radioOn")
        fastRate?.image = UIImage(named: "radioOff")
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = "Normal Refresh Rate"
        hud.hide(animated: true, afterDelay: 1.0)
        containerView.animHide()
        cancelView.animHide()
        view.backgroundColor = UIColor.white
        print("Normal")
        
    }
    @objc func fastButtonPressed(){
        refreshRate = 0.025
        let slowRate = slow.subviews.first(where: { $0 is UIImageView }) as? UIImageView
        let normalRate = normal.subviews.first(where: { $0 is UIImageView }) as? UIImageView
        let fastRate = fast.subviews.first(where: { $0 is UIImageView }) as? UIImageView
        slowRate?.image = UIImage(named: "radioOff")
        normalRate?.image = UIImage(named: "radioOff")
        fastRate?.image = UIImage(named: "radioOn")
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = "Fast Refresh Rate"
        hud.hide(animated: true, afterDelay: 1.0)
        containerView.animHide()
        cancelView.animHide()
        view.backgroundColor = UIColor.white
        print("Fast")
    }
    @objc func helpButtonPressed(){
        let myAlert = UIAlertController(title: "Phone Sensors", message: nil, preferredStyle: .alert)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let messageText = NSMutableAttributedString(
            string: "\nThis module allows you to access the following inbuilt sensors of your Smartphone:\n\nAccelerometer: Senses the acceleration acting on your Smartphone in all three directions in m/s.\n\nGyroscope: Senses the angular velocity in all three directions in rad/s.\n\nMagnetometer: Senses the magnetic field acting in all three directions in µT. It can be used to move robots in a specific direction.\n\nSound meter: Senses the intensity of nearby sound in dB.\n\nGPS: Shows the Longitude and Latitude of your current location.\n\nBarometer: Senses the pressure in KPa.",
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
                NSAttributedString.Key.foregroundColor : UIColor.black
            ]
        )
        
        myAlert.setValue(messageText, forKey: "attributedMessage")
        let knowMore = UIAlertAction(title: "More Info", style: .default) { action in
            UIApplication.shared.open(URL(string: "https://thestempedia.com/docs/dabble/phone-sensors-module/")!, options: [:], completionHandler: nil)
        }
        let close = UIAlertAction(title: "Close", style: .default) { action in
        }
        myAlert.addAction(knowMore)
        myAlert.addAction(close)
        self.present(myAlert, animated: true, completion: nil)
        
        containerView.animHide()
        cancelView.animHide()
        view.backgroundColor = UIColor.white
        
        print("Help")
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
        view.backgroundColor = UIColor.gray
//        backButton.backgroundColor = UIColor.gray
        containerView.animShow()
        cancelView.animShow()
    }
    
}
