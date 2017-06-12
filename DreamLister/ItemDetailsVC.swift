//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Matt Tripodi on 6/8/17.
//  Copyright © 2017 Matt Tripodi. All rights reserved.
//

import UIKit
import CoreData


class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

	@IBOutlet weak var storePicker: UIPickerView!
	@IBOutlet weak var titleField: CustomTextField!
	@IBOutlet weak var PriceField: CustomTextField!
	@IBOutlet weak var detailsField: CustomTextField!
	@IBOutlet weak var thumbImg: UIImageView!
	@IBOutlet weak var selectStoreAndItemTypeLbl: UILabel!
	@IBOutlet weak var saveItemBtn: UIButton!
	
	var stores = [Store]()
	var itemTypes = [ItemType]()
	var itemToEdit: Item?
	var imagePicker: UIImagePickerController!
	
    override func viewDidLoad() {
        super.viewDidLoad()
		
		saveItemBtn.layer.cornerRadius = 5 // To give the save button rounded corners 
		
		self.hideKeyboard()
		
		if let topItem = self.navigationController?.navigationBar.topItem {
			
			topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
		}
		
		storePicker.delegate = self
		storePicker.dataSource = self
	
		imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		
		getStores()
		getItemTypes()
		
		if itemToEdit != nil {
			loadItemData()
		}

    }
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		if component == 0 {
			let store = stores[row]
			return store.name
		} else if component == 1 {
			let itemType = itemTypes[row]
			return itemType.type
		} else {
			return "" //error
		}
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
		if component == 0 {
			return stores.count
		} else if component == 1 {
			return itemTypes.count
		} else {
			return -1 //throw error
		}
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		
		return 2
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		// update when selected
	}
	
	func getStores() {
		
		let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
		
		do {
			
			self.stores = try context.fetch(fetchRequest)
			self.storePicker.reloadAllComponents()
			
		} catch {
			
			// handle the error
		}
	}
	
	func getItemTypes() {
		
		let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
		do {
			
			self.itemTypes = try context.fetch(fetchRequest)
			self.storePicker.reloadAllComponents()
		} catch {
			
			// handle the error
		}
	}
	
	@IBAction func savePressed(_ sender: UIButton) {
		
		var item: Item!
		let picture = Image(context: context)
		picture.image = thumbImg.image
		
		if itemToEdit == nil {
			
			item = Item(context: context)
			
		} else {
			
			item = itemToEdit
		}
		
		item.toImage = picture
		
		if let title = titleField.text {
			
			item.title = title
		}
		
		if let price = PriceField.text {
			
			item.price = (price as NSString).doubleValue
			
		}
		
		if let details = detailsField.text {
			
			item.details = details
		}
		
		item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
//		item.toItemType = itemTypes[storePicker.selectedRow(inComponent: 1)]
		
		ad.saveContext()
		
		navigationController?.popViewController(animated: true)
	}
	
	func loadItemData() {
		
		if let item = itemToEdit {
			
			titleField.text = item.title
			PriceField.text = "\(item.price)"
			detailsField.text = item.details
			thumbImg.image = item.toImage?.image as? UIImage
			
			if let itemType = item.toItemType {
				var index = 0
				repeat {
					let iT = itemTypes[index]
					if iT.type == itemType.type {
						storePicker.selectRow(index, inComponent: 0, animated: false)
					}
					index += 1
				} while (index < itemTypes.count)
			}
		}
	}
	
	@IBAction func deletePressed(_ sender: UIBarButtonItem) {
		
		if itemToEdit != nil {
			
			context.delete(itemToEdit!)
			ad.saveContext()
		}
		
		navigationController?.popViewController(animated: true)
	}
	
	@IBAction func addImage(_ sender: UIButton) {
		
		present(imagePicker, animated: true, completion: nil)
	}
	
	func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
		
		if let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
			
			thumbImg.image = img
		}
		
		imagePicker.dismiss(animated: true, completion: nil)
	}
	
}

extension UIViewController
{
	func hideKeyboard()
	{
		let tap: UITapGestureRecognizer = UITapGestureRecognizer(
			target: self,
			action: #selector(UIViewController.dismissKeyboard))
		
		view.addGestureRecognizer(tap)
	}
	
	func dismissKeyboard()
	{
		view.endEditing(true)
	}
}
















