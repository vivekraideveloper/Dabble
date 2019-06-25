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
import Instabug
import MessageUI
import SafariServices

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, BluetoothSerialDelegate, MFMailComposeViewControllerDelegate{
    
    let navDrawer: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    let navCoverView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 11/255.0, green: 44/255.0, blue: 96/255.0, alpha: 1.0)
        return view
    }()
    
    let dabbelView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(red: 11/255.0, green: 44/255.0, blue: 96/255.0, alpha: 1.0)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "dabble")
        view.addSubview(imageView)
        imageView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 90, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 150, height: 40)
        return view
    }()
    
    let tutorials: UIButton = {
        let button = UIButton()
        button.setTitle("Tutorials", for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 10)
        button.setTitleColor(UIColor(red: 95, green: 99, blue: 104), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "tutorials")
        button.addSubview(imageView)
        imageView.anchor(top: button.topAnchor, left: button.leftAnchor, bottom: button.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 5, paddingBottom: 8, paddingRight: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(tutorialsButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let help: UIButton = {
        let button = UIButton()
        button.setTitle("Help", for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 10)
        button.setTitleColor(UIColor(red: 95, green: 99, blue: 104), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "help")
        button.addSubview(imageView)
        imageView.anchor(top: button.topAnchor, left: button.leftAnchor, bottom: button.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 5, paddingBottom: 8, paddingRight: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(helpButtonPressed), for: .touchUpInside)
        return button
    }()
    let feedback: UIButton = {
        let button = UIButton()
        button.setTitle("Feedback", for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 10)
        button.setTitleColor(UIColor(red: 95, green: 99, blue: 104), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "feedback")
        button.addSubview(imageView)
        imageView.anchor(top: button.topAnchor, left: button.leftAnchor, bottom: button.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 5, paddingBottom: 8, paddingRight: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(feedbackButtonPressed), for: .touchUpInside)
        return button
    }()
    let aboutUs: UIButton = {
        let button = UIButton()
        button.setTitle("About Us", for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 10)
        button.setTitleColor(UIColor(red: 95, green: 99, blue: 104), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "aboutUs")
        button.addSubview(imageView)
       imageView.anchor(top: button.topAnchor, left: button.leftAnchor, bottom: button.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 5, paddingBottom: 8, paddingRight: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(aboutUsButtonPressed), for: .touchUpInside)
        return button
    }()
    let rateUs: UIButton = {
        let button = UIButton()
        button.setTitle("Rate Us", for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 10)
        button.setTitleColor(UIColor(red: 95, green: 99, blue: 104), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "rateUs")
        button.addSubview(imageView)
       imageView.anchor(top: button.topAnchor, left: button.leftAnchor, bottom: button.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 5, paddingBottom: 8, paddingRight: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(rateUsButtonPressed), for: .touchUpInside)
        return button
    }()
    let share: UIButton = {
        let button = UIButton()
        button.setTitle("Share Dabble", for: .normal)
        button.contentHorizontalAlignment = .left
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 40, bottom: 10, right: 10)
        button.setTitleColor(UIColor(red: 95, green: 99, blue: 104), for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        let imageView = UIImageView()
        imageView.image = UIImage(named: "share")
        button.addSubview(imageView)
        imageView.anchor(top: button.topAnchor, left: button.leftAnchor, bottom: button.bottomAnchor, right: nil, paddingTop: 8, paddingLeft: 5, paddingBottom: 8, paddingRight: 0, width: 20, height: 20)
        button.addTarget(self, action: #selector(shareButtonPressed), for: .touchUpInside)
        return button
    }()
    
    let stempedia: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "stempedia")
        
        return imageView
    }()
    
    //    MARK: Variables here
    
    private(set) public var components = [Components]()
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    let margin: CGFloat = 0.0
    let cellsPerRow = 2
    var message = ""
    var checkFramesIncomingBool: Bool = false
    
    //    MARK:  IB Outlets here
    
    @IBOutlet weak var homeCollectionView: UICollectionView!
    @IBOutlet weak var dabbleIcon: UIBarButtonItem!
    @IBOutlet weak var connectButton: UIBarButtonItem!
    

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
        let window = UIApplication.shared.keyWindow!
        window.addSubview(navCoverView)
        navCoverView.anchor(top: window.topAnchor, left: window.leftAnchor, bottom: nil, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 3*(view.bounds.width/4), height: 2*(self.navigationController?.navigationBar.bounds.height)!)
        view.addSubview(navDrawer);
        navDrawer.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: nil, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 3*(view.bounds.width/4), height: 50)
        navDrawer.addSubview(dabbelView)
        dabbelView.anchor(top: navDrawer.topAnchor, left: navDrawer.leftAnchor, bottom: nil, right: navDrawer.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 0, height: 180)
        
        let stackView = UIStackView(arrangedSubviews: [tutorials, help, rateUs, feedback, aboutUs, share])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        navDrawer.addSubview(stackView)
        stackView.anchor(top: dabbelView.bottomAnchor, left: navDrawer.leftAnchor, bottom: nil, right: navDrawer.rightAnchor, paddingTop: 10, paddingLeft: 10, paddingBottom: 0, paddingRight: 10, width: 100, height: 270)

        navDrawer.addSubview(stempedia)
        stempedia.anchor(top: nil, left: navDrawer.leftAnchor, bottom: navDrawer.bottomAnchor, right: navDrawer.rightAnchor, paddingTop: 0, paddingLeft: 80, paddingBottom: 40, paddingRight: 80, width: 20, height: 50)
        navDrawer.isHidden = true
        navCoverView.isHidden = true
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeft))
        swipe.direction = UISwipeGestureRecognizer.Direction.left
        navDrawer.addGestureRecognizer(swipe)
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        reloadView()
        NotificationCenter.default.addObserver(self, selector: #selector(HomeVC.reloadView), name: NSNotification.Name(rawValue: "reloadStartViewController"), object: nil)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if serial.isPoweredOn{
            serial.sendBytesToDevice(toByteArray("FF0003000000"))
            print(toByteArray("FF0003000000"))
        }
    }
    
    @objc func swipeLeft(){
        navDrawer.animHide()
        navCoverView.animHide()
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
        if navDrawer.isHidden == true{
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
   
    @objc func tutorialsButtonPressed(){
        print("Tut")
        UIApplication.shared.open(URL(string: "https://thestempedia.com/docs/dabble/")!, options: [:], completionHandler: nil)
    }
    @objc func helpButtonPressed(){
        let myAlert = UIAlertController(title: "How to use Dabble", message: nil, preferredStyle: .alert)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let messageText = NSMutableAttributedString(
            string: "\n1. In the top-right corner, you will see two icons: a connect-disconnect icon, and a gear. Click on the connect-disconnect icon.\n2. A dialogue box will be asking for permission to turn on Bluetooth. Click on Allow.\n3. A list of nearby devices will appear. Select the device you want to pair your Smartphone with.\n4. In case you don’t see the name of the device you want to pair with, go to the Bluetooth settings of your Smartphone and search for it there and pair with it.\n5. Once the connection is made, a connect-disconnect icon will appear in the top-left corner of the notification bar.\n6. Now, upload the code of your respective project/experiment to your board.\n7. After uploading the code, select the module that you want to use.",
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
                NSAttributedString.Key.foregroundColor : UIColor.black
            ]
        )
        
        myAlert.setValue(messageText, forKey: "attributedMessage")
        let knowMore = UIAlertAction(title: "Explore", style: .default) { action in
            UIApplication.shared.open(URL(string: "https://thestempedia.com/docs/dabble")!, options: [:], completionHandler: nil)
        }
        let close = UIAlertAction(title: "Ok", style: .default) { action in
        }
        myAlert.addAction(knowMore)
        myAlert.addAction(close)
        self.present(myAlert, animated: true, completion: nil)
        navDrawer.animHide()
        navCoverView.animHide()
        
        print("Help")
    }
    @objc func rateUsButtonPressed(){
        if let url = URL(string: "itms-apps://itunes.apple.com/app/id1024941703"),
            UIApplication.shared.canOpenURL(url){
            UIApplication.shared.openURL(url)
        }
        
    }
    @objc func aboutUsButtonPressed(){
        let myAlert = UIAlertController(title: "How to use Dabble", message: nil, preferredStyle: .alert)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let messageText = NSMutableAttributedString(
            string: "\nDabble transforms a Smartphone into a virtual I/O device. It communicates with hardware like evive, ESP32, and Arduino boards (Uno, Mega, and Nano) using Bluetooth modules like HC-05, HC-06 or HM-10 (BT 2.0, 4.0 or BLE). The app consists of modules that provide access to different functionalities of the smartphone like sensors (accelerometer, GPS, mic, etc.), camera, internet, etc. and consists of certain user interfaces for hardware control and project-making.\n\nApp Version: X.X.X (Updated on: DD Month 20XX)\nCopyright © 2018-2019, Agilo Research Pvt. Ltd. All rights reserved.\nSTEMpedia, PictoBlox, Dabble, and evive are either registered trademarks or trademarks of Agilo Research Pvt. Ltd. in India and/or other countries.\nDabble is developed by the STEMpedia, who is committed to providing a one-stop solution for STEM education to enthusiastic students, educators, and makers. STEMpedia strives towards transforming young minds into innovators of tomorrow!\n\nTerms and Conditions\nThe application is provided “as-is” and without warranty of any kind, express, implied or otherwise, including without limitation, any warranty of merchantability or fitness for a particular purpose. In no event shall the copyright holder or contributors be liable for any direct, indirect, incidental, special, exemplary, or consequential damages (including, but not limited to, procurement of substitute goods or services; loss of use, data, or profits; or business interruption) however caused and on any theory of liability, whether in contract, strict liability, or tort (including negligence or otherwise) arising in any way out of the use of this app, even if advised of the possibility of such damage.\n\nPrivacy Policy\nWe may update our Terms and Privacy Policy from time to time and you are advised to check this page from time to time for any changes. Any changes are effective immediately.\nIf you have any queries regarding this policy, or any other matter, you can contact us at contact@thestempedia.com.\nWith <heart> from India!  ",
            
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font : UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body),
                NSAttributedString.Key.foregroundColor : UIColor.black
            ]
        )
        
        myAlert.setValue(messageText, forKey: "attributedMessage")
        let close = UIAlertAction(title: "Okay", style: .default) { action in
        }
        myAlert.addAction(close)
        self.present(myAlert, animated: true, completion: nil)
        navDrawer.animHide()
        navCoverView.animHide()
        
        print("About Us")
        
    }
    @objc func feedbackButtonPressed(){
        let mailVC = MFMailComposeViewController()
        mailVC.mailComposeDelegate = self
        mailVC.setToRecipients(["contact@thestempedia.com"])
        mailVC.setSubject("Dabble Feedback")
        mailVC.setMessageBody("Type your message here ...", isHTML: false)
        navDrawer.animHide()
        navCoverView.animHide()
        present(mailVC, animated: true, completion: nil)
        print("Feedback")
    }
    @objc func shareButtonPressed(){
        navDrawer.animHide()
        navCoverView.animHide()
        let text = "This is the text....."
        let textShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textShare , applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func settingsButtonPressed(_ sender: Any) {
        if navDrawer.isHidden == true{
            performSegue(withIdentifier: "settings", sender: self)
        }
        
    }
    
    @IBAction func dabbleIconPressed(_ sender: Any) {
            navCoverView.animShow()
            navDrawer.animShow()
        
    }
    
   
    @IBAction func connectButtonPressed(_ sender: Any) {
        if navDrawer.isHidden == true{
            if serial.connectedPeripheral == nil {
                performSegue(withIdentifier: "showBluetoothScanner", sender: self)
            } else if serial.connectedPeripheral != nil {
                serial.disconnect()
                reloadView()
            }
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
