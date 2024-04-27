//
//  PostMObject.swift
//  techie_butler
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation
import CoreData

class PostMObject: NSManagedObject {
    @NSManaged var id: Int64
    @NSManaged var userId: Int64
    @NSManaged var title: String
    @NSManaged var body: String
    
    func extract(from model: PostModel) {
        id = Int64(model.id)
        userId = Int64(model.userId)
        title = model.title
        body = model.body
    }
    
    var model: PostModel {
        return PostModel(id: Int(id),
                         userId: Int(userId),
                         title: title,
                         body: body)
    }
}
