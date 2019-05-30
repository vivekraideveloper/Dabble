//
//  Extensions.swift
//  Dabble
//
//  Created by Vivek Rai on 27/05/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}


extension String {
    
    func subString( _ from: Int, length: Int ) -> String {
        
        let size = self.count
        
        let to = length + from
        if from < 0 || to > size {
            
            return ""
        }
        
        var result = ""
        
        for ( idx, char ) in self.enumerated() {
            
            if idx >= from && idx < to {
                
                result.append( char )
            }
        }
        
        return result
    }
    
    func removeWord( _ word:String ) -> String {
        
        var result = ""
        
        let textCharArr = Array( self)
        let wordCharArr = Array(word)
        
        var possibleMatch = ""
        
        var i = 0, j = 0
        while i < textCharArr.count {
            
            if textCharArr[ i ] == wordCharArr[ j ] {
                
                if j == wordCharArr.count - 1 {
                    
                    possibleMatch = ""
                    j = 0
                }
                else {
                    
                    possibleMatch.append( textCharArr[ i ] )
                    j += 1
                }
            }
            else {
                
                result.append( possibleMatch )
                possibleMatch = ""
                
                if j == 0 {
                    
                    result.append( textCharArr[ i ] )
                }
                else {
                    
                    j = 0
                    i -= 1
                }
            }
            
            i += 1
        }
        
        return result
    }
}

