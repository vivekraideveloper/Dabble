//
//  DataService.swift
//  Dabble
//
//  Created by Vivek Rai on 24/05/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import Foundation

class DataService {
    
    static let instance = DataService()
    
    private let components = [
        Components(title: "LED Controller", imageName: "ledController", color1: 0x35ad4a, color2: 0x0e7a3d),
        Components(title: "Terminal", imageName: "terminal", color1: 0x3f4a9e, color2: 0x201d58),
        Components(title: "Gamepad",imageName: "gamepad", color1: 0xf37a20, color2: 0xd83a27),
        Components(title: "Pin Monitor", imageName: "ledController",color1: 0xec1c25, color2: 0x951b1e),
        Components(title: "Motor Controller", imageName: "ledController",color1: 0xf9cb0d, color2: 0xe59524),
        Components(title: "Inputs", imageName: "ledController",color1: 0x00b794, color2: 0x00604e),
        Components(title: "Camera Module", imageName: "ledController",color1: 0x96002b, color2: 0xd11141),
        Components(title: "Phone Sensor", imageName: "ledController",color1: 0x1c397c, color2: 0x071b47),
        Components(title: "Camera and Video", imageName: "ledController",color1: 0xf37735, color2: 0xe25314),
        Components(title: "Color Detector", imageName: "ledController",color1: 0xffc425, color2: 0xe2a334),
        Components(title: "Oscilloscope", imageName: "ledController",color1: 0x540d6e, color2: 0x38004f),
        Components(title: "IOT", imageName: "ledController",color1: 0x03b159, color2: 0x098443),
        Components(title: "Touch Tune", imageName: "ledController",color1: 0x1c77c3, color2: 0x09588e),
        Components(title: "Projects", imageName: "ledController",color1: 0xffc425, color2: 0xcc8e11),
    ]
    
    func getComponents() -> [Components] {
        return components
    }
    
}




