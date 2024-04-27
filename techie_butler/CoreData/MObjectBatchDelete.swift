//
//  MObjectBatchDelete.swift
//  techie_butler
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    
    func batchDelete(fetchRequest: NSFetchRequest<NSFetchRequestResult>, mergeTo contexts: [NSManagedObjectContext]) {
        
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeObjectIDs
        
        do {
            let result = try self.execute(deleteRequest) as? NSBatchDeleteResult
            let objectIDArray = result?.result as? [NSManagedObjectID]
            let changes = [NSDeletedObjectsKey: objectIDArray]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: contexts)
        } catch {
            // TODO: - Handle the error.
        }
    }
}
