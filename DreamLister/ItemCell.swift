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
	@IBOutlet weak var itemType: UILabel!
	
	func configureCell(item: Item) {
		
		title.text = item.title
		price.text = "$\(item.price.withCommas())"
		details.text = item.details
		thumb.image = item.toImage?.image as? UIImage
		itemType.text = item.toItemType?.type
	}
}

extension Double {
	func withCommas() -> String {
		let numberFormatter = NumberFormatter()
		numberFormatter.numberStyle = NumberFormatter.Style.decimal
		return numberFormatter.string(from: NSNumber(value:self))!
	}
}
