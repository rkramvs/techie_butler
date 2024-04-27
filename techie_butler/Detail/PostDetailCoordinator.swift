//
//  PostDetailCoordinator.swift
//  techie_butler
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation
import UIKit

class PostDetailCoordinator {
    private var navigationVC: UINavigationController?
    init(navigationVC: UINavigationController?) {
        self.navigationVC = navigationVC
    }
    
    func show(post: PostModel) {
        let vc = PostDetailViewController(viewModel: PostDetailViewModel(post: post))
        navigationVC?.pushViewController(vc, animated: true)
    }
}

