//
//  Components.swift
//  Dabble
//
//  Created by Vivek Rai on 24/05/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import Foundation

struct Components {
    
    private(set) public var title: String
    private(set) public var imageName: String
    private(set) public var color1: Int
    private(set) public var color2: Int

    init(title: String, imageName: String, color1: Int, color2: Int) {
        self.title = title
        self.imageName = imageName
        self.color1 = color1
        self.color2 = color2
    }
}

