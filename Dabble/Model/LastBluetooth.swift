//
//  LastBluetooth.swift
//  Dabble
//
//  Created by Vivek Rai on 22/06/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import Foundation
import RealmSwift
import CoreBluetooth

class LastBluetooth: Object{
    
    @objc dynamic var lastDevice: NSObject?
    
}
