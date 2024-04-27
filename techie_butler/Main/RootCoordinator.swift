//
//  RootCoordinator.swift
//  techie_butler
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation
import UIKit
import SwiftUI

class RootCoordinator {
    
    private var window: UIWindow
    var coreDataHelper = CoreDataHelper.shared
    private var listCoordinator: PostListCoordinator?
    
    init(window: UIWindow) {
        self.window = window
    }

    func start() {
        
        guard !CoreDataHelper.shared.isPersistentStoreGetLoaded else {
            coreDataLoaded()
            return
        }
    
        CoreDataHelper.shared.loadContainer {[weak self] error in
            guard let self else { return }
           
            guard let error else {
                coreDataLoaded()
                return
            }
            
            self.showCoreDataFailureScreen(error: error)
        }
    }
    
    private func coreDataLoaded()  {
        self.showList()
    }
    
    // TODO: - Handle CoreData Failure Error
    private func showCoreDataFailureScreen(error: Error) {
        
    }
    
    private func showList() {
        listCoordinator = PostListCoordinator(window: window)
        listCoordinator?.show()
    }
}


