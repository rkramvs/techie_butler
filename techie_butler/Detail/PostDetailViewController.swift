//
//  PostDetailViewController.swift
//  techie_butler
//
//  Created by Ram Kumar on 27/04/24.
//

import Foundation
import UIKit

class PostDetailViewController: UIViewController {
    
    var viewModel: PostDetailViewModel
    
    var titleLabel: UILabel = UILabel()
    var body: UILabel = UILabel()
    lazy var stackView: UIStackView = UIStackView(arrangedSubviews: [titleLabel, body])

    init(viewModel: PostDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupViewHierarchy()
        setupViewConstraints()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        
        titleLabel.text = viewModel.post.title
        titleLabel.numberOfLines = 0
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        
        body.text = viewModel.post.body
        body.numberOfLines = 0
        body.font = UIFont.systemFont(ofSize: 15, weight: .regular)
        
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
    }
    
    func setupViewHierarchy() {
        view.addSubview(stackView)
    }
    
    func setupViewConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor)
        ])
    }
}
