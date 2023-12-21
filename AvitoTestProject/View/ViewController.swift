//
//  ViewController.swift
//  AvitoTestProject
//
//  Created by Матвей Федышин on 10.12.2023.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: - Variables
    private let dbServise = DBServise()
    private var datasource: ServerResponce?
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 15
    
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collection.showsVerticalScrollIndicator = false
        collection.register(PlainCollectionViewCell.self,
                           forCellWithReuseIdentifier: PlainCollectionViewCell.id)
        collection.register(AdvertCollectionViewCell.self,
                           forCellWithReuseIdentifier: AdvertCollectionViewCell.id)
        return collection
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        view.backgroundColor = .cyan
        
        dbServise.fetchData { result in
            switch result {
            case .success(let jsonData):
                self.datasource = jsonData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.frame = view.bounds
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let datasource else { return 1}
        return datasource.result.list.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertCollectionViewCell.id, for: indexPath) as? AdvertCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let datasource else { return UICollectionViewCell() }
        let cellData = datasource.result.list[indexPath.row]

        cell.configure(with: cellData)
        cell.layoutIfNeeded()
        return cell
    }
}

//  MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 40,
                          height: view.frame.size.width / 3)
    }
}


// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if let cell = collectionView.cellForItem(at: indexPath) as? AdvertCollectionViewCell {
            cell.toggleCheckMark()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath) as? AdvertCollectionViewCell {
            cell.setDefaultState()
        }
    }
}
