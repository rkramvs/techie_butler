//
//  PostListViewModel.swift
//  techie_butler
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation
import CoreData

class PostListViewModel {
    
    typealias ViewModelDelegate = LoadingViewModelDelegate
    
    let mainContext =  CoreDataHelper.shared.mainContext
    var listAPI = PostListAPI()
    
    weak var delegate: ViewModelDelegate?
    
    lazy var listFRC: NSFetchedResultsController<PostMObject> = {
        let fetchRequest: NSFetchRequest<PostMObject> = NSFetchRequest(entityName: "Post")
        
        let sortDescriptor = NSSortDescriptor(key: "\(#keyPath(PostMObject.id))", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        fetchRequest.resultType = .managedObjectResultType
        fetchRequest.fetchBatchSize = 25

        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: mainContext, sectionNameKeyPath: nil, cacheName: nil)
        return controller
    }()
    
    init() { 
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSave(_:)), name: .NSManagedObjectContextDidSave, object: nil)
    }
    
    @objc func contextDidSave(_ notification: Notification) {
        // Merge changes into the main context on the main thread
        DispatchQueue.main.async {
            self.mainContext.mergeChanges(fromContextDidSave: notification)
        }
    }
    
    func getPosts() async throws {
        await self.delegate?.loadingView?.showLoading()
        let posts = try await listAPI.getList()
        
        let bgContext = CoreDataHelper.shared.bgContext
        try bgContext.performAndWait {
            bgContext.batchDelete(fetchRequest: NSFetchRequest<NSFetchRequestResult>(entityName: EntityName.post.rawValue),
                                  mergeTo: [])
            
            var postIterator = posts.makeIterator()
            
            let batchInsertRequest = NSBatchInsertRequest(entity: PostMObject.entity()) { (obj: NSManagedObject) in
                    guard let post = postIterator.next() else { return true }
 
                    if let postMO = obj as? PostMObject {
                        postMO.extract(from: post)
                    }

                    return false
                }
            batchInsertRequest.resultType = .objectIDs
            
            let result = try bgContext.execute(batchInsertRequest) as? NSBatchInsertResult
            let objectIDArray = (result?.result as? [NSManagedObjectID]) ?? []
            let changes = [NSInsertedObjectsKey: objectIDArray]
            NSManagedObjectContext.mergeChanges(fromRemoteContextSave: changes as [AnyHashable : Any], into: [bgContext, CoreDataHelper.shared.mainContext])
            try bgContext.save()
        }
        
        await self.delegate?.loadingView?.hideLoading()
    }
    
    var totalItemCount: Int {
        let fetchRequest: NSFetchRequest<NSNumber> = NSFetchRequest(entityName: "Post")
        fetchRequest.resultType = .countResultType
        guard let counts = try? mainContext.fetch(fetchRequest), let count = counts.first as? Int else { return 0 }
        return count
    }
    
    func loadMorePostIfAvailable() {
        guard self.listFRC.fetchedObjects?.count ?? 0 < totalItemCount else  {
            return
        }
        try? self.listFRC.performFetch()
    }
}
