//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Matt Tripodi on 6/8/17.
//  Copyright © 2017 Matt Tripodi. All rights reserved.
//

import UIKit

class ItemDetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
		
		if let topItem = self.navigationController?.navigationBar.topItem {
			
			topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
		}

    }

}
