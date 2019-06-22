//
//  SettingsVC.swift
//  Dabble
//
//  Created by Vivek Rai on 01/06/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    
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
        if DataService.instance.boardName != ""{
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
        if DataService.instance.versionNumber != ""{
            versionLabel.text = DataService.instance.boardName
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
        separator.anchor(top: versionLabel.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.bounds.width, height: 1)
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
        button.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 25, paddingLeft: 20, paddingBottom: 20, paddingRight: 0, width: 0, height: 50)
        button.addTarget(self, action: #selector(notificationSettings), for: .touchUpInside)
        let separator = UIView()
        separator.backgroundColor = UIColor.gray
        view.addSubview(separator)
        separator.anchor(top: button.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 10, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.bounds.width, height: 1)
        return view
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        let stackView = UIStackView(arrangedSubviews: [autoConnectedView ,connectedView, libraryView, notification])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
         view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 90, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.bounds.width, height: 250)


        
    }
    
    @objc func notificationSettings(){
        performSegue(withIdentifier: "notificationSettings", sender: self)
    }

}
