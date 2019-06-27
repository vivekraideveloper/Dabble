//
//  SettingsVC.swift
//  Dabble
//
//  Created by Vivek Rai on 01/06/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit
import CoreBluetooth
import MBProgressHUD

class SettingsVC: UIViewController, BluetoothSerialDelegate {
    
    let autoConnectedView: UIView = {
        let view = UIView()
        let autoConnectedLabel = UILabel()
        autoConnectedLabel.text = "Auto-Connect to Last Device"
        autoConnectedLabel.textColor = UIColor.black
        autoConnectedLabel.textAlignment = NSTextAlignment.left
        autoConnectedLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(autoConnectedLabel)
        autoConnectedLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 5, paddingRight: 0, width: view.bounds.width, height: 20)
        let deviceLabel = UILabel()
        if DataService.instance.boardName != ""{
            deviceLabel.text = DataService.instance.boardName
        }else{
            deviceLabel.text = "No Device Connected"
        }
        deviceLabel.tag = 1
        deviceLabel.textColor = UIColor(red: 77, green: 77, blue: 77)
        deviceLabel.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(deviceLabel)
        deviceLabel.anchor(top: autoConnectedLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 10, paddingRight: 0, width: view.bounds.width, height: 20)
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.tintColor = UIColor(red: 11, green: 44, blue: 96)
        toggle.onTintColor = UIColor(red: 11, green: 44, blue: 96)
        view.addSubview(toggle)
        toggle.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 5, paddingRight: 25, width: 50, height: 12)
        toggle.addTarget(self, action: #selector(connectToLastDevice), for: .valueChanged)
        let separator = UIView()
        separator.backgroundColor = UIColor.gray
        view.addSubview(separator)
        separator.anchor(top: deviceLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.bounds.width, height: 1)
        return view
    }()
    
    let connectedView: UIView = {
        let view = UIView()
        let connectedLabel = UILabel()
        connectedLabel.text = "Connected Board"
        connectedLabel.textColor = UIColor.black
        connectedLabel.textAlignment = NSTextAlignment.left
        connectedLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(connectedLabel)
        connectedLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 5, paddingRight: 0, width: view.bounds.width, height: 20)
        let boardLabel = UILabel()
        if DataService.instance.boardName != "" && serial.isReady{
            boardLabel.text = DataService.instance.boardName
        }else{
            boardLabel.text = "No Board Connected"
        }
        boardLabel.textColor = UIColor(red: 77, green: 77, blue: 77)
        boardLabel.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(boardLabel)
        boardLabel.anchor(top: connectedLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 10, paddingRight: 0, width: view.bounds.width, height: 20)
        let separator = UIView()
        separator.backgroundColor = UIColor.gray
        view.addSubview(separator)
        separator.anchor(top: boardLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.bounds.width, height: 1)
        return view
    }()
    
    let libraryView: UIView = {
        let view = UIView()
        //        view.backgroundColor = UIColor(red: 11/255.0, green: 44/255.0, blue: 96/255.0, alpha: 1.0)
        let libraryLabel = UILabel()
        libraryLabel.text = "Library Version on Board"
        libraryLabel.textColor = UIColor.black
        libraryLabel.textAlignment = NSTextAlignment.left
        libraryLabel.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(libraryLabel)
        libraryLabel.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 5, paddingRight: 0, width: view.bounds.width, height: 20)
        let versionLabel = UILabel()
        if DataService.instance.versionNumber != "" && serial.isReady{
            versionLabel.text = DataService.instance.versionNumber
        }else{
            versionLabel.text = "No Board Connected"
        }
        versionLabel.textColor = UIColor(red: 77, green: 77, blue: 77)
        versionLabel.font = UIFont.systemFont(ofSize: 12)
        view.addSubview(versionLabel)
        versionLabel.anchor(top: libraryLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 5, paddingLeft: 20, paddingBottom: 10, paddingRight: 0, width: view.bounds.width, height: 20)
        let separator = UIView()
        separator.backgroundColor = UIColor.gray
        view.addSubview(separator)
        separator.anchor(top: versionLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.bounds.width, height: 1)
        return view
    }()
    
    let notification: UIView = {
        let view = UIView()
        let button = UIButton()
        button.setTitle("Notifications", for: .normal)
        button.setTitleColor(UIColor.black, for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(button)
        button.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 15, paddingLeft: 20, paddingBottom: 15, paddingRight: 0, width: 0, height: 50)
        button.addTarget(self, action: #selector(notificationSettings), for: .touchUpInside)
        let separator = UIView()
        separator.backgroundColor = UIColor.gray
        view.addSubview(separator)
        separator.anchor(top: button.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.bounds.width, height: 1)
        return view
    }()
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    /// The peripherals that have been discovered (no duplicates and sorted by asc RSSI)
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    
    /// The peripheral the user has selected
    var selectedPeripheral: CBPeripheral?
    
    /// Progress hud shown
    var progressHUD: MBProgressHUD?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let stackView = UIStackView(arrangedSubviews: [autoConnectedView ,connectedView, libraryView, notification])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
         view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 90, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.bounds.width, height: 250)

//        Blutooth Scanning
        serial.delegate = self
        if serial.centralManager.state != .poweredOn {
            let alert = UIAlertController(title: "Settings", message: "Turn on your Bluetooth", preferredStyle: .alert)
            let cancel = UIAlertAction(title: "Close", style: .cancel) { (action) in
                
            }
            alert.addAction(cancel)
            self.present(alert, animated: true, completion: nil)
            return
        }
        
        reloadView()
        // start scanning and schedule the time out
        serial.startScan()
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(SettingsVC.scanTimeOut), userInfo: nil, repeats: false)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
    }
    
    @objc func connectToLastDevice(){

        let toggle = autoConnectedView.subviews.first(where: { $0 is UISwitch }) as? UISwitch
        if toggle!.isOn{
            for i in peripherals{
                if i.peripheral.identifier.uuidString == UserDefaults.standard.string(forKey: "lastDevice")!{
                    serial.connectToPeripheral(i.peripheral)
                    for j in autoConnectedView.subviews{
                        if j.tag == 1{
                            (j as? UILabel)?.text = i.peripheral.name!
                        }
                    }
                    let hud = MBProgressHUD.showAdded(to: view, animated: true)
                    hud.mode = MBProgressHUDMode.text
                    hud.label.text = "Connected"
                    hud.hide(animated: true, afterDelay: 1.5)
                    self.appDelegate?.scheduleNotification(notificationType: "Connected")
                }else{
                    let hud = MBProgressHUD.showAdded(to: view, animated: true)
                    hud.mode = MBProgressHUDMode.text
                    hud.label.text = "No Device was Connected Earlier"
                    hud.hide(animated: true, afterDelay: 1.5)
                    toggle?.isOn = false
                    return
                }
            }
            
        }else{
            serial.disconnect()
            toggle?.isOn = false
            for i in autoConnectedView.subviews{
                if i.tag == 1{
                    (i as? UILabel)?.text = "No Device Connected"
                }
            }
        }
    }
    
    @objc func notificationSettings(){
        performSegue(withIdentifier: "notificationSettings", sender: self)
    }
    
    @objc func scanTimeOut() {
        // timeout has occurred, stop scanning and give the user the option to try again
        serial.stopScan()
    }
    
    @objc func connectTimeOut() {
        
        // don't if we've already connected
        if let _ = serial.connectedPeripheral {
            return
        }
        
        if let hud = progressHUD {
            hud.hide(animated: false)
        }
        
        if let _ = selectedPeripheral {
            serial.disconnect()
            selectedPeripheral = nil
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = "Failed to connect"
        hud.hide(animated: true, afterDelay: 2)
    }
    
    //    MARK: BluetoothSerial Delegate Methods here
    
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        // check whether it is a duplicate
        for exisiting in peripherals {
            if exisiting.peripheral.identifier == peripheral.identifier { return }
        }
        
        // add to the array, next sort & reload
        let theRSSI = RSSI?.floatValue ?? 0.0
        peripherals.append((peripheral: peripheral, RSSI: theRSSI))
        peripherals.sort { $0.RSSI < $1.RSSI }
    }
    
    func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {
        if let hud = progressHUD {
            hud.hide(animated: false)
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = "Failed to connect"
        hud.hide(animated: true, afterDelay: 1.0)
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        if let hud = progressHUD {
            hud.hide(animated: false)
        }
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = "Failed to connect"
        hud.hide(animated: true, afterDelay: 1.0)
        
    }
    
    func serialDidReceiveBytes(_ bytes: [UInt8]) {
        print(bytes)
    }
    func serialIsReady(_ peripheral: CBPeripheral) {
        if let hud = progressHUD {
            hud.hide(animated: false)
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadStartViewController"), object: self)
//        navigationController?.popViewController(animated: true)
//        dismiss(animated: true, completion: nil)
    }
    func serialDidChangeState() {
        if let hud = progressHUD {
            hud.hide(animated: false)
        }
        
        if serial.centralManager.state != .poweredOn {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadStartViewController"), object: self)
//            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func reloadView() {
        // in case we're the visible view again
        serial.delegate = self
        let toggle = autoConnectedView.subviews.first(where: { $0 is UISwitch }) as? UISwitch
        if serial.isReady {
            toggle?.isOn = true
            for i in autoConnectedView.subviews{
                if i.tag == 1{
                    (i as? UILabel)?.text = serial.connectedPeripheral?.name!
                }
            }
        } else if serial.centralManager.state == .poweredOn {
            toggle?.isOn = false
            for i in autoConnectedView.subviews{
                if i.tag == 1{
                    (i as? UILabel)?.text = "No Device Connected"
                }
            }
        } else {
          toggle?.isOn = false
            for i in autoConnectedView.subviews{
                if i.tag == 1{
                    (i as? UILabel)?.text = "No Device Connected"
                }
            }
        }
    }

}
