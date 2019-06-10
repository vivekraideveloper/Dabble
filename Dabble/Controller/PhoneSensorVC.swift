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

class PhoneSensorVC: UIViewController, UITableViewDelegate, UITableViewDataSource, BluetoothSerialDelegate {

    @IBOutlet weak var phoneSensorTableView: UITableView!
    @IBOutlet weak var connectButton: UIBarButtonItem!
    @IBOutlet weak var menuIcon: UIBarButtonItem!
    
    
    //    MARK: Variables
    var motionManager: CMMotionManager!
    var accelX: Double = 0
    var accelY: Double = 0
    var accelZ: Double = 0
    var gyroX: Double = 0
    var gyroY: Double = 0
    var gyroZ: Double = 0
    var magnetoX: Double = 0
    var magnetoY: Double = 0
    var magnetoZ: Double = 0
    
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
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 3
                
                let x = formatter.string(for: accelX)
                let y = formatter.string(for: accelY)
                let z = formatter.string(for: accelZ)
                cell.firstValue.text = x
                cell.secondValue.text = y
                cell.thirdValue.text = z
            }
            
            if indexPath.row == 1{
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 3
                
                let x = formatter.string(for: gyroX)
                let y = formatter.string(for: gyroY)
                let z = formatter.string(for: gyroZ)
                cell.firstValue.text = x
                cell.secondValue.text = y
                cell.thirdValue.text = z
            }
            
            if indexPath.row == 2{
                let formatter = NumberFormatter()
                formatter.minimumFractionDigits = 2
                formatter.maximumFractionDigits = 3
                
                let x = formatter.string(for: magnetoX)
                let y = formatter.string(for: magnetoY)
                let z = formatter.string(for: magnetoZ)
                cell.firstValue.text = x
                cell.secondValue.text = y
                cell.thirdValue.text = z
            }
            
            if indexPath.row == 3{
                let device = UIDevice.current
                device.isProximityMonitoringEnabled = true
                if device.isProximityMonitoringEnabled {
                    cell.secondValue.text = "\(0)"
                    
                }else{
                    cell.secondValue.text = "\(10)"

                }
            
            }
            
            if cell.firstValue.text == ""{
                cell.firstValue.isHidden = true
            }
            if cell.secondValue.text == ""{
                cell.secondValue.isHidden = true
            }
            if cell.thirdValue.text == ""{
                cell.thirdValue.isHidden = true
            }
            
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
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
