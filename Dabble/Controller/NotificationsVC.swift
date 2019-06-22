//
//  NotificationsVC.swift
//  Dabble
//
//  Created by Vivek Rai on 22/06/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit

class NotificationsVC: UIViewController {
    
    let dabbleModuleView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "Dabble Modules"
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: view.bounds.width, height: 20)
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.tintColor = UIColor(red: 11, green: 44, blue: 96)
        toggle.onTintColor = UIColor(red: 11, green: 44, blue: 96)
        view.addSubview(toggle)
        toggle.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 40, height: 12)
        let separator = UIView()
        separator.backgroundColor = UIColor.gray
        view.addSubview(separator)
        separator.anchor(top: label.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.bounds.width, height: 1)
        return view
    }()
    
    let projectsView: UIView = {
        let view = UIView()
        let label = UILabel()
        label.text = "Projects"
        label.textAlignment = NSTextAlignment.left
        label.font = UIFont.systemFont(ofSize: 18)
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: nil, paddingTop: 20, paddingLeft: 20, paddingBottom: 0, paddingRight: 0, width: view.bounds.width, height: 20)
        let toggle = UISwitch()
        toggle.isOn = false
        toggle.tintColor = UIColor(red: 11, green: 44, blue: 96)
        toggle.onTintColor = UIColor(red: 11, green: 44, blue: 96)
        view.addSubview(toggle)
        toggle.anchor(top: view.topAnchor, left: nil, bottom: nil, right: view.rightAnchor, paddingTop: 20, paddingLeft: 0, paddingBottom: 0, paddingRight: 20, width: 40, height: 12)
        let separator = UIView()
        separator.backgroundColor = UIColor.gray
        view.addSubview(separator)
        separator.anchor(top: label.bottomAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 30, paddingLeft: 5, paddingBottom: 0, paddingRight: 5, width: view.bounds.width, height: 1)
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let stackView = UIStackView(arrangedSubviews: [dabbleModuleView, projectsView])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        view.addSubview(stackView)
        stackView.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: nil, right: view.rightAnchor, paddingTop: 90, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: view.bounds.width, height: 130)
    }

}
