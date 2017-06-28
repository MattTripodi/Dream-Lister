//
//  ItemDetailsVC.swift
//  DreamLister
//
//  Created by Matt Tripodi on 6/8/17.
//  Copyright © 2017 Matt Tripodi. All rights reserved.
//

import UIKit
import CoreData


class ItemDetailsVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate{

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
		
		selectStoreAndItemTypeLbl.layer.borderColor = UIColor.darkGray.cgColor
		selectStoreAndItemTypeLbl.layer.borderWidth = 1
		selectStoreAndItemTypeLbl.layer.cornerRadius = 5 // To give the label a border with rounded corners 
		
		saveItemBtn.layer.cornerRadius = 5 // To give the save button rounded corners 
		
		self.hideKeyboard()
		self.titleField.delegate = self
		self.PriceField.delegate = self
		self.detailsField.delegate = self
		
		if let topItem = self.navigationController?.navigationBar.topItem {
			
			topItem.backBarButtonItem = UIBarButtonItem(title: "", style: UIBarButtonItemStyle.plain, target: nil, action: nil)
		}
		
		storePicker.delegate = self
		storePicker.dataSource = self
	
		imagePicker = UIImagePickerController()
		imagePicker.delegate = self
		
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
		let type17 = ItemType(context: context)
		type17.type = "Books"
		let type18 = ItemType(context: context)
		type18.type = "Schooling"
		let type19 = ItemType(context: context)
		type19.type = "Children"
		let type20 = ItemType(context: context)
		type20.type = "Collectables"
		
		ad.saveContext()
	}
	
	func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
		
		let itemType = itemTypes[row]
		return itemType.type
	}
	
	func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
		
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
	
	// Alert for when delete is pressed, just incase it was pressed on accident
	func deleteAlert(title: String, message: String) {
		
		let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "No", style: .default, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
		}))
		
		alert.addAction(UIAlertAction(title: "Yes", style: .destructive, handler: { (action) in
			alert.dismiss(animated: true, completion: nil)
			
			if self.itemToEdit != nil {
				
				context.delete(self.itemToEdit!)
				ad.saveContext()
			}
			
			self.navigationController?.popViewController(animated: true)
		}))
		
		self.present(alert, animated: true, completion:  nil)
	}
	
	@IBAction func deletePressed(_ sender: UIBarButtonItem) {
		
		deleteAlert(title: "Delete this item", message: "Are you sure?")
		
		//navigationController?.popViewController(animated: true)
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

// To dismiss the keyboard when outside of the keyboard is pressed
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
	
	// To dismiss keyboard when return is pressed
	func textFieldShouldReturn(_ textField: UITextField) -> Bool {
		self.view.endEditing(true)
		return false
	}
}

















