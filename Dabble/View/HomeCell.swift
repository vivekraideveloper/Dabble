//
//  HomeCell.swift
//  Dabble
//
//  Created by Vivek Rai on 23/05/19.
//  Copyright © 2019 Vivek Rai. All rights reserved.
//

import UIKit
import ChameleonFramework

class HomeCell: UICollectionViewCell {
    
    @IBOutlet weak var homeLabel: UILabel!
    @IBOutlet weak var homeImage: UIImageView!
    @IBOutlet weak var homeView: UIView!
    var gradient: CAGradientLayer!
    
    func updateViews(components: Components){
        homeLabel.text = components.title
        homeImage.image = UIImage(named: components.imageName)
        homeView.backgroundColor = UIColor(gradientStyle:UIGradientStyle.topToBottom, withFrame:frame  , andColors:[UIColor(rgb: components.color1), UIColor(rgb: components.color2)])
        
        
    }
    
    
    
}
