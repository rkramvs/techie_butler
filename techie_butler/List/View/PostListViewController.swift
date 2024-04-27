//
//  PostListViewController.swift
//  techie_butler
//
//  Created by Ram Kumar on 27/04/24.
//

import UIKit
import CoreData

class PostListViewController: UIViewController {

    typealias DataSource = UICollectionViewDiffableDataSource<Int, NSManagedObjectID>
    
    private lazy var collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        var collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.contentInset.bottom = 82
        return collectionView
    }()
    
    var loadingView: LoadingView?
    private var dataSource: DataSource?
    var viewModel: PostListViewModel
    
    var showDetailHandler: ((PostModel) -> ())?
    
    init(viewModel: PostListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        title = "Posts"
        self.viewModel.listFRC.delegate = self
        self.viewModel.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        setupViewHierarchy()
        setupViewConstraints()
        setupCollectionView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
    }
    
    func setupViewHierarchy() {
        loadingView = LoadingView(superView: self.view)
        view.addSubview(collectionView)
    }
    
    func setupViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    func setupCollectionView() {
        
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, NSManagedObjectID> {[weak self] (cell, indexPath, item) in
            guard let self else { return }
            
            let object = self.viewModel.listFRC.object(at: indexPath)
            var config = cell.defaultContentConfiguration()
            config.text = object.title
            config.secondaryText = "\(object.id)"
            cell.contentConfiguration = config
            cell.accessories = [.disclosureIndicator()]
        }
     
        
        dataSource = UICollectionViewDiffableDataSource<Int, NSManagedObjectID>(collectionView: collectionView) {collectionView, IndexPath, item in
            let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: IndexPath, item: item)
            return cell
        }
      
        collectionView.dataSource = dataSource
        collectionView.delegate = self
        try? viewModel.listFRC.performFetch()
        Task(priority: .userInitiated) {
            do {
                try await self.viewModel.getPosts()
            }
            catch {
                await MainActor.run{
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            }
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        let offsetY = scrollView.contentOffset.y
            let contentHeight = scrollView.contentSize.height
            let height = scrollView.frame.size.height

            // Check if the user has scrolled to the end of the collection view
            if offsetY > contentHeight - height {
               self.viewModel.loadMorePostIfAvailable()
            }
       }
}

extension PostListViewController: PostListViewModel.ViewModelDelegate {
}

//MARK: - NSFetchedResultsControllerDelegate
extension PostListViewController: NSFetchedResultsControllerDelegate {
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChangeContentWith snapshot: NSDiffableDataSourceSnapshotReference) {
        let snapShot = snapshot as NSDiffableDataSourceSnapshot<Int, NSManagedObjectID>
        dataSource?.apply(snapShot)
    }
}


//MARK: - CollectionView DataSource & Delegate

extension PostListViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = self.viewModel.listFRC.object(at: indexPath).model
        showDetailHandler?(model)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
