//
//  GamePadVC.swift
//  Dabble
//
//  Created by Vivek Rai on 31/05/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit

class GamePadVC: UIViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    
    //MARK: Rotate device
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIDevice.current.setValue(UIInterfaceOrientation.landscapeLeft.rawValue, forKey: "orientation")
        
    }
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask{
        return .landscapeLeft
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeLeft
    }
   
    //    MARK: Back button pressed
    @IBAction func buttonPressed(_ sender: Any) {
        UIDevice.current.setValue(UIInterfaceOrientation.portrait.rawValue, forKey: "orientation")
        dismiss(animated: false, completion: nil)
    }
    @objc func canRotate() -> Void {}
}
