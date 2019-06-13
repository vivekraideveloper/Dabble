//
//  PhoneSensorVC.swift
//  Dabbleabble
//
//  Created by Vivek Rai on 08/06/19.
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

class PhoneSensorVC: UIViewController, UITableViewDelegate, UITableViewDataSource, BluetoothSerialDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var phoneSensorTableView: UITableView!
    @IBOutlet weak var connectButton: UIBarButtonItem!
    @IBOutlet weak var menuIcon: UIBarButtonItem!
    
    
    //    MARK: Variables
    var motionManager: CMMotionManager!
    var locationManager: CLLocationManager!
    var pressure: CMAltimeter!
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
    var switchSate: [Bool] = [false, false, false, false, false, false, false]
    var sensorCount: Int = 0
    private var cellHeights: [IndexPath: CGFloat?] = [:]
    var expandedIndexPaths: [IndexPath] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        phoneSensorTableView.delegate = self
        phoneSensorTableView.dataSource = self
        
        phoneSensorTableView.rowHeight = 300
        phoneSensorTableView.allowsSelection = false
        
        reloadView()
        NotificationCenter.default.addObserver(self, selector: #selector(PhoneSensorVC.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
        
//        Motion manager
        motionManager = CMMotionManager()
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.motionManager.startAccelerometerUpdates(to: .main, withHandler: self.updateAccelerometer)
            self.phoneSensorTableView.reloadData()
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.motionManager.startGyroUpdates(to: .main, withHandler: self.updateGyroscope)
            self.phoneSensorTableView.reloadData()
            
        })
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(100), execute: {
            self.motionManager.startMagnetometerUpdates(to: .main, withHandler: self.updateMagnetometer)
            self.phoneSensorTableView.reloadData()
            
        })
        
//        Location Manager
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.startUpdatingLocation()
        
//        Audio method
        audioUpdate()
       
//        Barometer
        pressure = CMAltimeter()
        if CMAltimeter.isRelativeAltitudeAvailable(){
            pressure.startRelativeAltitudeUpdates(to: .main) { (data, error) in
                self.pressureValue = Float(data!.pressure)
            }
        }
        
//        Reload TableView data
        Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(updateTableView), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(sensorTimer), userInfo: nil, repeats: true)
        
        

        
    }

    
    func updateAccelerometer(data: CMAccelerometerData?, error: Error?){
        guard let accelerometerData = data else {return}
        let x = accelerometerData.acceleration.x
        let y = accelerometerData.acceleration.y
        let z = accelerometerData.acceleration.z
        
        accelX = x
        accelY = y
        accelZ = z
    }
    
    func updateGyroscope(data: CMGyroData?, error: Error?){
        guard let gyroData = data else {return}
        let x = gyroData.rotationRate.x
        let y = gyroData.rotationRate.y
        let z = gyroData.rotationRate.z
        
        gyroX = x
        gyroY = y
        gyroZ = z
    }
    
    func updateMagnetometer(data: CMMagnetometerData?, error: Error?){
        guard let magnetoData = data else {return}
        let x = magnetoData.magneticField.x
        let y = magnetoData.magneticField.y
        let z = magnetoData.magneticField.z
        
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
    
    @objc func updateTableView(){
        phoneSensorTableView.reloadData()
        phoneSensorTableView.setContentOffset(phoneSensorTableView.contentOffset, animated: false)
    }
    
    @objc func levelTimerCallback() {
        recorder.updateMeters()
        
        let level = recorder.peakPower(forChannel: 0)
        audioValue = level
    }
    
    func to_byte_array<T>(_ value: T) -> [UInt8] {
        var value = value
        return withUnsafePointer(to: &value) {
            $0.withMemoryRebound(to: UInt8.self, capacity: MemoryLayout<T>.size) {
                Array(UnsafeBufferPointer(start: $0, count: MemoryLayout<T>.size))
            }
        }
    }
    
    @objc func sensorTimer(){
        let timer: Double = 3
        if sensorCount == 1{
        Timer.scheduledTimer(timeInterval: timer, target: self, selector: #selector(sendDataToEvive), userInfo: nil, repeats: true)
        }
        if sensorCount == 2{
        Timer.scheduledTimer(timeInterval: timer*2, target: self, selector: #selector(sendDataToEvive), userInfo: nil, repeats: true)
        }
        if sensorCount == 3{
        Timer.scheduledTimer(timeInterval: timer*3, target: self, selector: #selector(sendDataToEvive), userInfo: nil, repeats: true)
        }
        if sensorCount == 4{
        Timer.scheduledTimer(timeInterval: timer*4, target: self, selector: #selector(sendDataToEvive), userInfo: nil, repeats: true)
        }
        if sensorCount == 5{
        Timer.scheduledTimer(timeInterval: timer*5, target: self, selector: #selector(sendDataToEvive), userInfo: nil, repeats: true)
        }
        if sensorCount == 6{
        Timer.scheduledTimer(timeInterval: timer*6, target: self, selector: #selector(sendDataToEvive), userInfo: nil, repeats: true)
        }
    }
    @objc func sendDataToEvive(){
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 2
        
        if switchSate[0]{
    //        ACCELEROMETER
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
        
        
        if switchSate[1]{
    //        GYROSCOPE
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
        
        if switchSate[2]{
    //        MAGNETOMETER
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
        
        if switchSate[4]{
    //        PROXIMITY
            let audioString = "FF04060104"
            var audioByteArray = toByteArray(audioString)
            audioByteArray.append(contentsOf: to_byte_array(audioValue))
            audioByteArray.append(contentsOf: toByteArray("00"))
            serial.sendBytesToDevice(audioByteArray)
        }
        
        if switchSate[5]{
    //        LOCATION
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
        
        if switchSate[6]{
    //        PRESSURE
            let pressureString = "FF04080104"
            var pressureByteArray = toByteArray(pressureString)
            pressureByteArray.append(contentsOf: to_byte_array(pressureValue))
            pressureByteArray.append(contentsOf: toByteArray("00"))
            serial.sendBytesToDevice(pressureByteArray)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DataService.instance.getSensorComponents().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? PhoneSensorCell{
            
            let cellComponents = DataService.instance.getSensorComponents()[indexPath.row]
            cell.updateViews(sensorComponents: cellComponents)
            cell.firstValue.allowsEditingTextAttributes = false
            cell.secondValue.allowsEditingTextAttributes = false
            cell.thirdValue.allowsEditingTextAttributes = false
            
    
            
            if indexPath.row == 0{
                cell.sensorToggle.setOn(switchSate[0], animated: false)
                cell.sensorToggle.addTarget(self, action: #selector(toggle0Pressed), for: .valueChanged)
                
                cell.sensorToggle.tag = 0
                cell.firstValue.isHidden = false
                cell.secondValue.isHidden = false
                cell.thirdValue.isHidden = false
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 1
                formatter.maximumFractionDigits = 2
                
                let x = formatter.string(for: accelX*9.8)
                let y = formatter.string(for: accelY*9.8)
                let z = formatter.string(for: accelZ*9.8)
                cell.firstValue.text = x
                cell.secondValue.text = y
                cell.thirdValue.text = z
                
                if cell.sensorToggle.isOn{
                    switchSate[0] = true
                    sensorCount += 1
                }
                if cell.sensorToggle.isOn == false{
                    sensorCount -= 1
                }
                
            }
            
            if indexPath.row == 1{
                cell.sensorToggle.setOn(switchSate[1], animated: false)
                cell.sensorToggle.addTarget(self, action: #selector(toggle1Pressed), for: .valueChanged)
                
                cell.sensorToggle.tag = 1
                cell.firstValue.isHidden = false
                cell.secondValue.isHidden = false
                cell.thirdValue.isHidden = false
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 1
                formatter.maximumFractionDigits = 2
                
                let x = formatter.string(for: gyroX)
                let y = formatter.string(for: gyroY)
                let z = formatter.string(for: gyroZ)
                cell.firstValue.text = x
                cell.secondValue.text = y
                cell.thirdValue.text = z
                
                if cell.sensorToggle.isOn{
                    switchSate[1] = true
                    sensorCount += 1
                }
                if cell.sensorToggle.isOn == false{
                    sensorCount -= 1
                }
            }
            
            if indexPath.row == 2{
                cell.sensorToggle.setOn(switchSate[2], animated: false)
                cell.sensorToggle.addTarget(self, action: #selector(toggle2Pressed), for: .valueChanged)
                
                cell.firstValue.isHidden = false
                cell.secondValue.isHidden = false
                cell.thirdValue.isHidden = false
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 1
                formatter.maximumFractionDigits = 2
                
                let x = formatter.string(for: magnetoX)
                let y = formatter.string(for: magnetoY)
                let z = formatter.string(for: magnetoZ)
                cell.firstValue.text = x
                cell.secondValue.text = y
                cell.thirdValue.text = z
                
                if cell.sensorToggle.isOn{
                    switchSate[2] = true
                    sensorCount += 1
                }
                if cell.sensorToggle.isOn == false{
                    sensorCount -= 1
                }
            }
            
            if indexPath.row == 3{
                cell.sensorToggle.setOn(switchSate[3], animated: false)
                cell.sensorToggle.addTarget(self, action: #selector(toggle3Pressed), for: .valueChanged)
                
                let device = UIDevice.current
//                device.isProximityMonitoringEnabled = true
                if device.isProximityMonitoringEnabled {
                    cell.secondValue.text = "\(0)"

                }else{
                    cell.secondValue.text = "\(1)"

                }
                cell.firstValue.isHidden = true
                cell.thirdValue.isHidden = true
                
                if cell.sensorToggle.isOn{
                    switchSate[3] = true
                    sensorCount += 1
                }
                if cell.sensorToggle.isOn == false{
                    sensorCount -= 1
                }
                
            }
            
            if indexPath.row == 4{
                cell.sensorToggle.setOn(switchSate[4], animated: false)
                cell.sensorToggle.addTarget(self, action: #selector(toggle4Pressed), for: .valueChanged)
                
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 1
                formatter.maximumFractionDigits = 2
                cell.secondValue.text = formatter.string(for: audioValue)
                cell.firstValue.isHidden = true
                cell.thirdValue.isHidden = true
                
                if cell.sensorToggle.isOn{
                    switchSate[4] = true
                    sensorCount += 1
                }
                if cell.sensorToggle.isOn == false{
                    sensorCount -= 1
                }
                
            }
            
            if indexPath.row == 5{
                cell.sensorToggle.setOn(switchSate[5], animated: false)
                cell.sensorToggle.addTarget(self, action: #selector(toggle5Pressed), for: .valueChanged)
                
                cell.firstValue.isHidden = false
                cell.secondValue.isHidden = false
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 1
                formatter.maximumFractionDigits = 2
                
                var currentLocation: CLLocation?
                if( CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
                    CLLocationManager.authorizationStatus() ==  .authorizedAlways){
                    
                    currentLocation = locationManager.location
                    
                }
                cell.firstValue.text = formatter.string(for: currentLocation!.coordinate.longitude)
                cell.secondValue.text = formatter.string(for: currentLocation!.coordinate.latitude)
                cell.thirdValue.isHidden = true
                
                if cell.sensorToggle.isOn{
                    switchSate[5] = true
                    sensorCount += 1
                }
                if cell.sensorToggle.isOn == false{
                    sensorCount -= 1
                }
                
            }
            
            if indexPath.row == 6{
                cell.sensorToggle.setOn(switchSate[6], animated: false)
                cell.sensorToggle.addTarget(self, action: #selector(toggle6Pressed), for: .valueChanged)
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 1
                formatter.maximumFractionDigits = 2
                cell.firstValue.text = ""
                cell.secondValue.text = formatter.string(for: pressureValue)
                cell.firstValue.isHidden = true
                cell.thirdValue.isHidden = true
                
                if cell.sensorToggle.isOn{
                    switchSate[6] = true
                    sensorCount += 1
                }
                if cell.sensorToggle.isOn == false{
                    sensorCount -= 1
                }
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cellHeights[indexPath] = cell.frame.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = cellHeights[indexPath] {
            return height ?? UITableView.automaticDimension
        }
        return UITableView.automaticDimension
    }
    
    
    @objc func toggle0Pressed(){
        if switchSate[0] == false{
            switchSate[0] = true
        }else{
            switchSate[0] = false
        }
        phoneSensorTableView.reloadData()
    }
    @objc func toggle1Pressed(){
        if switchSate[1] == false{
            switchSate[1] = true
        }else{
            switchSate[1] = false
        }
        phoneSensorTableView.reloadData()
    }
    @objc func toggle2Pressed(){
        if switchSate[2] == false{
            switchSate[2] = true
        }else{
            switchSate[2] = false
        }
        phoneSensorTableView.reloadData()
    }
    @objc func toggle3Pressed(){
        if switchSate[3] == false{
            switchSate[3] = true
        }else{
            switchSate[3] = false
        }
        phoneSensorTableView.reloadData()
    }
    @objc func toggle4Pressed(){
        if switchSate[4] == false{
            switchSate[4] = true
        }else{
            switchSate[4] = false
        }
        phoneSensorTableView.reloadData()
    }
    @objc func toggle5Pressed(){
        if switchSate[5] == false{
            switchSate[5] = true
        }else{
            switchSate[5] = false
        }
        phoneSensorTableView.reloadData()
    }
    @objc func toggle6Pressed(){
        if switchSate[6] == false{
            switchSate[6] = true
        }else{
            switchSate[6] = false
        }
        phoneSensorTableView.reloadData()
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
    
    
    
    
    @IBAction func connectButtonPressed(_ sender: Any) {
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action:#selector(PhoneSensorVC.back(sender:)))
        self.navigationItem.backBarButtonItem = newBackButton
        connectButton.tintColor = UIColor.white
        
        if serial.connectedPeripheral == nil {
            performSegue(withIdentifier: "showBluetoothScanner", sender: self)
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
//Last option dont resuse cells

