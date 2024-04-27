//
//  PostListCoordinator.swift
//  techie_butler
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation
import UIKit

class PostListCoordinator {
    private var window: UIWindow
    private var navigationVC: UINavigationController?
    private var postDetailCoordinator: PostDetailCoordinator?
    init(window: UIWindow) {
        self.window = window
    }
    
    func show() {
        let listVC = PostListViewController(viewModel: PostListViewModel())
        listVC.showDetailHandler = {[weak self] post in
            self?.showPostDetail(post: post)
        }
        let navVC = UINavigationController(rootViewController: listVC)
        navigationVC = navVC
        window.rootViewController = navVC
        window.makeKeyAndVisible()
    }
    
    private func showPostDetail(post: PostModel) {
        postDetailCoordinator = PostDetailCoordinator(navigationVC: navigationVC)
        postDetailCoordinator?.show(post: post)
    }
}
