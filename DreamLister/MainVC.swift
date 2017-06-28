//
//  MainVC.swift
//  DreamLister
//
//  Created by Matt Tripodi on 6/6/17.
//  Copyright © 2017 Matt Tripodi. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {
	
	//IBOutlets
	@IBOutlet weak var tableView: UITableView!
	@IBOutlet weak var segment: UISegmentedControl!
	@IBOutlet weak var totalCostLabel: UILabel!
	
	var controller: NSFetchedResultsController<Item>!
	var itemToEdit: Item?
	var items = [Item]()
	var theItems = ItemCell()

	// ViewDidLoad
	override func viewDidLoad() {
		super.viewDidLoad()
		
		totalCostLabel.layer.borderColor = UIColor.darkGray.cgColor
		totalCostLabel.layer.borderWidth = 1
		totalCostLabel.layer.cornerRadius = 5 // To give the label a border with rounded corners
		
		tableView.delegate = self
		tableView.dataSource = self
		
		attemptFetch()
	}
	
	// ViewDidAppear
	override func viewDidAppear(_ animated: Bool) {
		
		updateTotalCost()
	}
	
	func updateTotalCost() {
		
		
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		
		let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
		configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
		return cell
	}
	
	func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
		
		let item = controller.object(at: indexPath as IndexPath)
		cell.configureCell(item: item)
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		
		if let objs = controller.fetchedObjects , objs.count > 0 {
			
			let item = objs[indexPath.row]
			performSegue(withIdentifier: "ItemDetailsVC", sender: item)
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		
		if segue.identifier == "ItemDetailsVC" {
			
			if let desination = segue.destination as? ItemDetailsVC {
				
				if let item = sender as? Item {
					
					desination.itemToEdit = item 
				}
			}
		}
	}
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		
		if let sections = controller.sections {
			
			let sectionInfo = sections[section]
			return sectionInfo.numberOfObjects
		}
		
		return 0
	}
	
	func numberOfSections(in tableView: UITableView) -> Int {
		
		if let sections = controller.sections {
			return sections.count
		}
		
		return 0
	}
	
	func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
		
		return 162
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	
	func attemptFetch() {
		
		let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
		
		let dateSort = NSSortDescriptor(key: "created", ascending: false)
		let priceSort = NSSortDescriptor(key: "price", ascending: true)
		let titleSort = NSSortDescriptor(key: "title", ascending: true)
		let typeSort = NSSortDescriptor(key: "toItemType.type", ascending: true)
		
		if segment.selectedSegmentIndex == 0 {
			fetchRequest.sortDescriptors = [dateSort]
			
		} else if segment.selectedSegmentIndex == 1 {
			fetchRequest.sortDescriptors = [priceSort]
			
		} else if segment.selectedSegmentIndex == 2 {
			fetchRequest.sortDescriptors = [titleSort]
			
		} else if segment.selectedSegmentIndex == 3 {
			fetchRequest.sortDescriptors = [typeSort]
		}
		
		let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
		
		controller.delegate = self
		
		self.controller = controller
		
		do {
			
			try controller.performFetch()
		} catch {
			
			let error = error as NSError
			print("\(error)")
			
		}

	}
	
	@IBAction func segmentChange(_ sender: Any) {
		
		attemptFetch()
		tableView.reloadData()
	}
	
	
	func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		
		tableView.beginUpdates()
	}
	
	func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
		
		tableView.endUpdates()
	}
	
	func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
		
		switch(type) {
			
		case.insert:
			if let indexPath = newIndexPath {
				
				tableView.insertRows(at: [indexPath], with: .fade)
			}
			break
		case.delete:
			if let indexPath = indexPath {
				
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			break
		case.update:
			if let indexPath = indexPath {
				let cell = tableView.cellForRow(at: indexPath) as! ItemCell
				configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
			}
			break
		case.move:
			if let indexPath = indexPath {
				
				tableView.deleteRows(at: [indexPath], with: .fade)
			}
			if let indexPath = newIndexPath {
				tableView.insertRows(at: [indexPath], with: .fade)
			}
			break
		}
	}
	
}























