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
    private var selectedItem: IndexPath?
    
    // MARK: - UI Components
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 12
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.translatesAutoresizingMaskIntoConstraints = false
        collection.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        collection.showsVerticalScrollIndicator = false
        collection.register(AdvertCollectionViewCell.self,
                            forCellWithReuseIdentifier: AdvertCollectionViewCell.id)
        collection.register(CustomHeaderView.self,
                            forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: CustomHeaderView.id)
        return collection
    }()
    
    private lazy var closeButton: UIButton = {
        let closeButton = UIButton()
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        let closeButtonConfig = UIImage.SymbolConfiguration(pointSize: 16, weight: .bold, scale: .large)
        closeButton.setImage(UIImage(systemName: "xmark",
                                     withConfiguration: closeButtonConfig),
                             for: .normal)
        closeButton.tintColor = .black
        closeButton.isUserInteractionEnabled = false
        return closeButton
    }()
    
    private lazy var chooseButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Выбрать", for: .normal)
        button.layer.cornerRadius = Metrics.chooseButtonCornerRadius
        button.tintColor = Metrics.buttonTintColor
        button.backgroundColor = .systemBlue
        button.addAction(
            UIAction { _ in
                self.showAlert()
            },
            for: .touchUpInside
        )
        return button
    }()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        view.backgroundColor = .white
        setupHierarchy()
        setupLayout()
        getData()
        findSelectedIndexPath()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.selectItem(at: selectedItem, animated: false, scrollPosition: .centeredHorizontally)
    }
    
    // MARK: - Private Functions
    private func findSelectedIndexPath() {
        guard let datasource else { return }
        for index in datasource.result.list.indices {
            if datasource.result.list[index].isSelected == true {
                selectedItem = [0, index]
                return
            }
        }
    }
    
    private func setupHierarchy() {
        view.addSubview(collectionView)
        view.addSubview(closeButton)
        view.addSubview(chooseButton)
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 55),
            
            chooseButton.widthAnchor.constraint(equalToConstant: view.frame.width - 40),
            chooseButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -25),
            chooseButton.heightAnchor.constraint(equalToConstant: 55),
            chooseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: chooseButton.topAnchor, constant: -5)
        ])
    }
    
    private func getData() {
        dbServise.fetchData { result in
            switch result {
            case .success(let jsonData):
                self.datasource = jsonData
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    private func showAlert() {
        guard let datasource else { return }
        guard let selectedItem else { return }
        let alert = UIAlertController(title: "Вы выбрали",
                                      message: "",
                                      preferredStyle: .alert)
        let messageAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 18)]
        let messageString = NSAttributedString(string: datasource.result.list[selectedItem.row].title as String, attributes: messageAttributes)
        alert.setValue(messageString, forKey: "attributedMessage")
        alert.addAction(.init(title: "OK", style: .default))
        alert.addAction(.init(title: "Отмена", style: .cancel))
        alert.preferredAction = alert.actions.first
        self.present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return datasource?.result.list.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AdvertCollectionViewCell.id, for: indexPath) as? AdvertCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        guard let datasource else { return UICollectionViewCell() }
        let cellData = datasource.result.list[indexPath.row]
        
        cell.configure(with: cellData)
        cell.layoutIfNeeded()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let header = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: CustomHeaderView.id,
            for: indexPath) as? CustomHeaderView else {
            return UICollectionReusableView()
        }
        guard let datasource else { return UICollectionViewCell() }
        let title = datasource.result.title
        header.configure(with: title)
        return header
    }
}

//  MARK: - UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width - 40,
                      height: view.frame.size.width / 3)
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.size.width,
                      height: view.frame.size.width / 2.3)
    }
}

// MARK: - UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        
        datasource?.result.list[indexPath.row].isSelected.toggle()
        if selectedItem == indexPath {
            let cell = collectionView.cellForItem(at: indexPath) as? AdvertCollectionViewCell
            cell?.updateState(with: false)
            selectedItem = nil
        } else {
            selectedItem = indexPath
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath == selectedItem {
            let cell = collectionView.cellForItem(at: indexPath)
            cell?.layoutSubviews()
        }
    }
}
