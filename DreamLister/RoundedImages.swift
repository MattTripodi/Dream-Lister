//
//  RoundedImages.swift
//  DreamLister
//
//  Created by Matt Tripodi on 6/13/17.
//  Copyright © 2017 Matt Tripodi. All rights reserved.
//

import UIKit

private var roundedKey = false

extension UIImageView {
	
	@IBInspectable var roundedDesign: Bool {
		
		get {
			
			return roundedKey
		}
		set {
			
			roundedKey = newValue
			
			if roundedKey {
				
				self.layer.borderWidth = 0
				self.layer.masksToBounds = false
				//self.layer.borderColor = UIColor.black.cgColor
				self.layer.cornerRadius = self.frame.height/2
				self.clipsToBounds = true 
				
			} else {
				
				self.layer.borderWidth = 0
				self.layer.cornerRadius = 0
			
			}
		}
	}
}

