//
//  HomeVC.swift
//  Dabble
//
//  Created by Vivek Rai on 23/05/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit
import  CoreBluetooth
import MBProgressHUD
import QuartzCore

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, BluetoothSerialDelegate{
    
    //    MARK:  IB Outlets here
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var dabbleIcon: UIBarButtonItem!
    @IBOutlet weak var connectButton: UIBarButtonItem!
    //    MARK: Variables here
    
    private(set) public var components = [Components]()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    let margin: CGFloat = 0.0
    let cellsPerRow = 2
    var message = ""
    var checkFramesIncomingBool: Bool = false
    //    MARK: Method calls
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init serial
        serial = BluetoothSerial(delegate: self)
        
        // UI
        reloadView()
        
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
       
        homeCollectionView.delegate = self
        homeCollectionView.dataSource = self
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        collectionViewSetUp()
        
//         navigation back button
        self.navigationItem.hidesBackButton = true
        let newBackButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: self, action:#selector(HomeVC.back(sender:)))
            self.navigationItem.backBarButtonItem = newBackButton
        connectButton.tintColor = UIColor.white
        
//       navigationSliderFromLeft
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        if serial.isPoweredOn{
            serial.sendBytesToDevice(toByteArray("FF0003000000"))
            print(toByteArray("FF0003000000"))
        }
    }
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
    
    // NavController back button action
    
    @objc func back(sender: UIBarButtonItem) {
        // Perform your custom actions
        serial.stopScan()
        // Go back to the previous ViewController
        self.navigationController?.popViewController(animated: true)
    }
    
    // Reload view
    
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
    
    func serialDidReceiveBytes(_ bytes: [UInt8]) {
        print(bytes)
        print(DataService.instance.getBoardData(bytes))
        print(DataService.instance.getVersionData(bytes))
        
    }
    
    
    func collectionViewSetUp(){
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: screenWidth/3, height: screenWidth/3)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        homeCollectionView.collectionViewLayout = layout
        
        guard let collectionView = homeCollectionView, let flowLayout = UICollectionViewLayout() as? UICollectionViewFlowLayout else { return }
        
        flowLayout.minimumInteritemSpacing = margin
        flowLayout.minimumLineSpacing = margin
        flowLayout.sectionInset = UIEdgeInsets(top: margin, left: margin, bottom: margin, right: margin)
        
        collectionView.contentInsetAdjustmentBehavior = .always
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    //    MARK: CollectionView Delegate and DataSource
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return DataService.instance.getComponents().count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? HomeCell{
            let cellComponent = DataService.instance.getComponents()[indexPath.row]
            cell.updateViews(components: cellComponent)
            return cell
        }
        return HomeCell()
    }
    
    override func viewWillLayoutSubviews() {
        guard let collectionView = homeCollectionView, let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        let marginsAndInsets = flowLayout.sectionInset.left + flowLayout.sectionInset.right + collectionView.safeAreaInsets.left + collectionView.safeAreaInsets.right + flowLayout.minimumInteritemSpacing * CGFloat(cellsPerRow - 1)
        let itemWidth = ((collectionView.bounds.size.width - marginsAndInsets) / CGFloat(cellsPerRow)).rounded(.down)
        flowLayout.itemSize =  CGSize(width: itemWidth, height: itemWidth)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        homeCollectionView?.collectionViewLayout.invalidateLayout()
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0{
            performSegue(withIdentifier: "ledControl", sender: self)
        }
        if indexPath.row == 1{
            performSegue(withIdentifier: "terminal", sender: self)
        }
        if indexPath.row == 2{
            let next = self.storyboard?.instantiateViewController(withIdentifier: "gamePad") as! GamePadVC
            self.present(next, animated: true, completion: nil)
        }
        if indexPath.row == 7{
            performSegue(withIdentifier: "phoneSensors", sender: self)
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
   
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        performSegue(withIdentifier: "settings", sender: self)
    }
    
    
   
    @IBAction func connectButtonPressed(_ sender: Any) {
        if serial.connectedPeripheral == nil {
            performSegue(withIdentifier: "showBluetoothScanner", sender: self)
        } else if serial.connectedPeripheral != nil {
            serial.disconnect()
            reloadView()
        }
    }
}



extension HomeVC: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return CGSize(width: self.homeCollectionView.bounds.width/2, height: self.homeCollectionView.bounds.height/5)
    }
    

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
}
