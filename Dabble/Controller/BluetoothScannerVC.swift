//
//  BluetoothScannerVC.swift
//  Dabble
//
//  Created by Vivek Rai on 27/05/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit
import CoreBluetooth
import MBProgressHUD
import QuartzCore

class BluetoothScannerVC: UIViewController, UITableViewDelegate, UITableViewDataSource, BluetoothSerialDelegate {
    
    //    MARK: IBOutlets here
    
    @IBOutlet weak var bluetoothScannerTableView: UITableView!
    @IBOutlet weak var tryAgainButton: UIBarButtonItem!
    
    //    MARK: Variables here
    
    /// The peripherals that have been discovered (no duplicates and sorted by asc RSSI)
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    
    /// The peripheral the user has selected
    var selectedPeripheral: CBPeripheral?
    
    /// Progress hud shown
    var progressHUD: MBProgressHUD?
    
    
    //    MARK: Methods here
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bluetoothScannerTableView.delegate = self
        bluetoothScannerTableView.dataSource = self
        
        
        // tryAgainButton is only enabled when we've stopped scanning
        tryAgainButton.isEnabled = false
        
        // remove extra seperator insets
        bluetoothScannerTableView.tableFooterView = UIView(frame: CGRect.zero)
        
        // tell the delegate to notificate US instead of the previous view if something happens
        serial.delegate = self
        if serial.centralManager.state != .poweredOn {
            title = "Bluetooth turned off"
            return
        }
        
        // start scanning and schedule the time out
        serial.startScan()
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(BluetoothScannerVC.scanTimeOut), userInfo: nil, repeats: false)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Should be called 10s after we've begun scanning
    
    @objc func scanTimeOut() {
        // timeout has occurred, stop scanning and give the user the option to try again
        serial.stopScan()
        tryAgainButton.isEnabled = true
        title = "Done scanning"
    }
    
    // Should be called 10s after we've begun connecting
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

    //    MARK: TableView Delegate and Data Source Methds
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as? BluetoothScannerCell{
            cell.deviceLabel.text = peripherals[indexPath.row].peripheral.name
            cell.connectionLabel.text = "Connect"
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        bluetoothScannerTableView.deselectRow(at: indexPath, animated: true)
        // the user has selected a peripheral, so stop scanning and proceed to the next view
        serial.stopScan()
        selectedPeripheral = peripherals[(indexPath as NSIndexPath).row].peripheral
        serial.connectToPeripheral(selectedPeripheral!)
        
        progressHUD = MBProgressHUD.showAdded(to: view, animated: true)
        progressHUD!.label.text = "Connecting"
        
        
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(BluetoothScannerVC.connectTimeOut), userInfo: nil, repeats: false)
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
        bluetoothScannerTableView.reloadData()
    }
    
    func serialDidFailToConnect(_ peripheral: CBPeripheral, error: NSError?) {
        if let hud = progressHUD {
            hud.hide(animated: false)
        }
        
        tryAgainButton.isEnabled = true
        
        let hud = MBProgressHUD.showAdded(to: view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.label.text = "Failed to connect"
        hud.hide(animated: true, afterDelay: 1.0)
    }
    
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        if let hud = progressHUD {
            hud.hide(animated: false)
        }
        
        tryAgainButton.isEnabled = true
        
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
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)
    }
    
    func serialDidChangeState() {
        if let hud = progressHUD {
            hud.hide(animated: false)
        }
        
        if serial.centralManager.state != .poweredOn {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "reloadStartViewController"), object: self)
            dismiss(animated: true, completion: nil)
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
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        serial.stopScan()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tryAgainButtonPressed(_ sender: Any) {
        // empty array an start again
        peripherals = []
        bluetoothScannerTableView.reloadData()
        tryAgainButton.isEnabled = false
        title = "Scanning..."
        serial.startScan()
        Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(BluetoothScannerVC.scanTimeOut), userInfo: nil, repeats: false)
    }

}
