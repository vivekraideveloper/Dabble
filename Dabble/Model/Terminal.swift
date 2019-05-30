//
//  Terminal.swift
//  Dabble
//
//  Created by Vivek Rai on 28/05/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import Foundation

struct Terminal {
    private(set) public var phoneText: String
    private(set) public var eviveText: String
    private(set) public var phoneTime: String
    private(set) public var eviveTime: String
    
    init(phoneText: String, eviveText: String, phoneTime: String, eviveTime: String) {
        self.phoneText = phoneText
        self.eviveText = eviveText
        self.phoneTime = phoneTime
        self.eviveTime = eviveTime
    }
}
