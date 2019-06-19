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
    var boardName = ""
    var versionNumber = ""
    var pinArray: [Int] = []
    
    private let components = [
        Components(title: "LED Controller", imageName: "ledController", color1: 0x35ad4a, color2: 0x0e7a3d),
        Components(title: "Terminal", imageName: "terminal", color1: 0x3f4a9e, color2: 0x201d58),
        Components(title: "Gamepad",imageName: "gamepad", color1: 0xf37a20, color2: 0xd83a27),
        Components(title: "Pin Monitor", imageName: "ledController",color1: 0xec1c25, color2: 0x951b1e),
        Components(title: "Motor Controller", imageName: "ledController",color1: 0xf9cb0d, color2: 0xe59524),
        Components(title: "Inputs", imageName: "ledController",color1: 0x00b794, color2: 0x00604e),
        Components(title: "Camera Module", imageName: "ledController",color1: 0x96002b, color2: 0xd11141),
        Components(title: "Phone Sensor", imageName: "phoneSensor",color1: 0x1c397c, color2: 0x071b47),
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
    
    
    private let sensorComponents = [
        SensorComponents(sensorName: " Accelerometer", firstLabel: "X-axis", secondLabel: "Y-axis", thirdLabel: "Z-axis", firstUnit: "m/s", secondUnit: "m/s", thirdUnit: "m/s", sensorImage: "accelerometer"),
        SensorComponents(sensorName: " Gyroscope", firstLabel: "X-axis", secondLabel: "Y-axis", thirdLabel: "Z-axis", firstUnit: "rad/s", secondUnit: "rad/s", thirdUnit: "rad/s", sensorImage: "gyroscope"),
        SensorComponents(sensorName: " Magnetometer", firstLabel: "X-axis", secondLabel: "Y-axis", thirdLabel: "Z-axis", firstUnit: "μT", secondUnit: "μT", thirdUnit: "μT", sensorImage: "magnetometer"),
        SensorComponents(sensorName: " Proximity Meter", firstLabel: "", secondLabel: "Distance", thirdLabel: "", firstUnit: "", secondUnit: "CM", thirdUnit: "", sensorImage: "proximity"),
        SensorComponents(sensorName: " Sound Meter", firstLabel: "", secondLabel: "Intensity", thirdLabel: "", firstUnit: "", secondUnit: "dB", thirdUnit: "", sensorImage: "soundMeter"),
        SensorComponents(sensorName: " Location", firstLabel: "Longitude", secondLabel: "Latitude", thirdLabel: "", firstUnit: "", secondUnit: "", thirdUnit: "", sensorImage: "location"),
        SensorComponents(sensorName: " Barometer", firstLabel: "", secondLabel: "Pressure", thirdLabel: "", firstUnit: "", secondUnit: "Kpa", thirdUnit: "", sensorImage: "barometer")
    ]
    
    func getSensorComponents() -> [SensorComponents]{
        return sensorComponents
    }
    
    func getVersionData(_ bytes: [UInt8]) -> String{
        versionNumber = "\(Int(bytes[6])).\(Int(bytes[7])).\(bytes[8])"
        return versionNumber
    }
    
    func getBoardData(_ bytes: [UInt8]) -> String{
        
        if Int(bytes[5]) == 2{
            boardName = "Mega"
            pinArray = [2,3,4,5,6,7,8,9,10,11,12,13,44,45,46]
        }
        if Int(bytes[5]) == 3{
            boardName = "Uno"
            pinArray = [3, 5, 6, 9, 10, 11]
        }
        if Int(bytes[5]) == 4{
            boardName = "Nano"
            pinArray = [3, 5, 6, 9, 10, 11]
        }
        if Int(bytes[5]) == 5{
            boardName = "Other"
        }
        return boardName
    }
}




