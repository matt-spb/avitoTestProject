//
//  AdvertCollectionViewCell.swift
//  AvitoTestProject
//
//  Created by Матвей Федышин on 10.12.2023.
//

import UIKit

class AdvertCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Variables
    
    static let id = "AdvertCollectionViewCell"
    private let networkManager = NetworkManager()
    
    // MARK: - UI Components
    
    lazy var iconImageView: UIImageView = {
        let icon = UIImageView()
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.clipsToBounds = true
        icon.layer.cornerRadius = icon.bounds.height / 2
        icon.contentMode = .scaleAspectFit
        return icon
    }()
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.font = .boldSystemFont(ofSize: Metrics.titleLabelFontSize)
        return title
    }()
    
    lazy var descriptionLabel: UILabel = {
        let description = UILabel()
        description.font = .systemFont(ofSize: Metrics.descriptionLabelFontSize)
        description.numberOfLines = 0
        return description
    }()
    
    lazy var priceLabel: UILabel = {
        let price = UILabel()
        price.font = .boldSystemFont(ofSize: Metrics.priceLabelFontSize)
        return price
    }()
    
    lazy var checkMarkImageView: UIImageView = {
        let checkMark = UIImageView()
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        checkMark.image = UIImage(systemName: "checkmark.circle.fill")
        return checkMark
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [titleLabel, descriptionLabel, priceLabel])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = Metrics.stackViewSpacing
        stackView.distribution = .fill
        return stackView
    }()
    
    // MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.backgroundColor = Metrics.cellBackgroundColor
        contentView.layer.cornerRadius = Metrics.cellCornerRadius
        contentView.addSubview(iconImageView)
        contentView.addSubview(stackView)
        contentView.addSubview(checkMarkImageView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        NSLayoutConstraint.activate([
            iconImageView.widthAnchor.constraint(equalToConstant: Metrics.iconSize),
            iconImageView.heightAnchor.constraint(equalToConstant: Metrics.iconSize),
            iconImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: Metrics.standartSpacing),
            iconImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: Metrics.standartSpacing),
            
            checkMarkImageView.widthAnchor.constraint(equalToConstant: Metrics.checkMarkSize),
            checkMarkImageView.heightAnchor.constraint(equalToConstant: Metrics.checkMarkSize),
            checkMarkImageView.centerYAnchor.constraint(equalTo: iconImageView.centerYAnchor),
            checkMarkImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -Metrics.standartSpacing),
            
            stackView.leadingAnchor.constraint(equalTo: iconImageView.trailingAnchor, constant: Metrics.standartSpacing),
            stackView.topAnchor.constraint(equalTo: iconImageView.topAnchor, constant: Metrics.stackViewTopSpace),
            stackView.trailingAnchor.constraint(equalTo: checkMarkImageView.leadingAnchor, constant: -Metrics.standartSpacing),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -Metrics.stackViewBottomSpace)
        ])
    }
    
    // MARK: - Configuration

    override var isSelected: Bool {
        willSet {
            updateState(with: newValue)
        }
    }
    
    func updateState(with showCheckMark: Bool) {
        checkMarkImageView.isHidden = showCheckMark ? false : true
        layoutSubviews()
    }
    
    override func preferredLayoutAttributesFitting(_ layoutAttributes: UICollectionViewLayoutAttributes) -> UICollectionViewLayoutAttributes {
        let targetSize = CGSize(width: layoutAttributes.frame.width, height: 0)
        layoutAttributes.frame.size = contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        return layoutAttributes
    }
    
    func configure(with data: List) {
        setIconImage(with: data.icon.size)
        checkMarkImageView.isHidden = data.isSelected && isSelected ? false : true
        titleLabel.text = data.title
        descriptionLabel.text = data.description
        descriptionLabel.setLineSpacing(lineSpacing: 5)
        priceLabel.text = data.price
    }
    
    private func setIconImage(with data: String) {
        networkManager.getIconImage(with: data) { result in
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.iconImageView.image = UIImage(data: data)
                }
            case .failure:
                print(ErrorMessage.invalidData)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = ""
        descriptionLabel.text = ""
        iconImageView.image = nil
        priceLabel.text = ""
    }
}
