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
		
		selectStoreAndItemTypeLbl.layer.borderColor = UIColor.darkGray.cgColor // To give the label a border with rounded corners 
		selectStoreAndItemTypeLbl.layer.borderWidth = 1
		selectStoreAndItemTypeLbl.layer.cornerRadius = 5
		
		saveItemBtn.layer.cornerRadius = 5 // To give the save button rounded corners 
		
		self.hideKeyboard()
		
		if let topItem = self.navigationController?.navigationBar.topItem {
			
			topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
		}
		
		storePicker.delegate = self
		storePicker.dataSource = self
	
		imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		
		//getStores()
		getItemTypes()
		
		if itemToEdit != nil {
			loadItemData()
		}
		
		itemTypes.sort {$0.type! < $1.type!} // Sort the PickerView in alphabetical order

    }
	
	func generateItemTypeData() {
		
		let type1 = ItemType(context: context)
		type1.type = "Electronics"
		let type2 = ItemType(context: context)
		type2.type = "Appliances"
		let type3 = ItemType(context: context)
		type3.type = "Motor Vehicles"
		let type4 = ItemType(context: context)
		type4.type = "Food"
		let type5 = ItemType(context: context)
		type5.type = "Houses"
		let type6 = ItemType(context: context)
		type6.type = "Boats"
		let type7 = ItemType(context: context)
		type7.type = "Land"
		let type8 = ItemType(context: context)
		type8.type = "Other"
		let type9 = ItemType(context: context)
		type9.type = "Pets"
		let type10 = ItemType(context: context)
		type10.type = "Fashion"
		let type11 = ItemType(context: context)
		type11.type = "Furniture"
		let type12 = ItemType(context: context)
		type12.type = "Vacations"
		let type13 = ItemType(context: context)
		type13.type = "Art"
		let type14 = ItemType(context: context)
		type14.type = "Toys"
		let type15 = ItemType(context: context)
		type15.type = "Tools"
		let type16 = ItemType(context: context)
		type16.type = "Activities"
		
		ad.saveContext()
	}
	
	func generateStoreData() {
		
		let store = Store(context: context)
		store.name = "Amazon"
		let store1 = Store(context: context)
		store1.name = "Apple"
		let store2 = Store(context: context)
		store2.name = "Walmart"
		let store3 = Store(context: context)
		store3.name = "Car Dealership"
		let store4 = Store(context: context)
		store4.name = "Electronics Store"
		let store5 = Store(context: context)
		store5.name = "Appliance Stores"
		let store6 = Store(context: context)
		store6.name = "Motorcyle Shop"
		let store7 = Store(context: context)
		store7.name = "Sporting Goods Store"
		let store8 = Store(context: context)
		store8.name = "Super Market"
		
		ad.saveContext()
	}
	
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
//		if component == 0 {
//			let store = stores[row]
//			return store.name
//		} else if component == 1 {
//			let itemType = itemTypes[row]
//			return itemType.type
//		} else {
//			return "" //error
//		}
		
		let itemType = itemTypes[row]
		return itemType.type
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
//		if component == 0 {
//			return stores.count
//		} else if component == 1 {
//			return itemTypes.count
//		} else {
//			return -1 //throw error
//		}
		
		return itemTypes.count
	}
	
	func numberOfComponents(in pickerView: UIPickerView) -> Int {
		
		return 1
	}
	
	func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
		
		// update when selected
	}
	
	func getItemTypes() {
		
		let fetchRequest: NSFetchRequest<ItemType> = ItemType.fetchRequest()
		
		do {
			
			self.itemTypes = try context.fetch(fetchRequest)
			if self.itemTypes.count == 0 {
				
				generateItemTypeData()
				getItemTypes()
				return
			}
			self.storePicker.reloadAllComponents()
			
		} catch {
			
			// handle the error
		}
	}
	
	func getStores() {
		
		let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
		
		do {
			
			self.stores = try context.fetch(fetchRequest)
			if self.stores.count == 0 {
				
				generateStoreData()
				getStores()
				return
			}
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
		
		item.toItemType = itemTypes[storePicker.selectedRow(inComponent: 0)]
		
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

















