//
//  ItemCell.swift
//  DreamLister
//
//  Created by Matt Tripodi on 6/6/17.
//  Copyright © 2017 Matt Tripodi. All rights reserved.
//

import UIKit

class ItemCell: UITableViewCell {
	
	@IBOutlet weak var thumb: UIImageView!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var price: UILabel!
	@IBOutlet weak var details: UILabel!
	
	func configureCell(item: Item) {
		
		title.text = item.title
		price.text = "\(item.price)"
		details.text = item.details
		
	}
}
