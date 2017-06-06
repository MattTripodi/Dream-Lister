//
//  ItemType+CoreDataProperties.swift
//  DreamLister
//
//  Created by Matt Tripodi on 6/6/17.
//  Copyright © 2017 Matt Tripodi. All rights reserved.
//

import Foundation
import CoreData


extension ItemType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ItemType> {
        return NSFetchRequest<ItemType>(entityName: "ItemType")
    }

    @NSManaged public var type: String?
    @NSManaged public var toItem: Item?

}
