//
//  CustomHeaderView.swift
//  AvitoTestProject
//
//  Created by Матвей Федышин on 22.12.2023.
//

import UIKit

class CustomHeaderView: UICollectionReusableView {
    
    static let id = "CustomHeaderView"
    
    lazy var titleLabel: UILabel = {
        let title = UILabel()
        title.numberOfLines = 0
        title.font = .boldSystemFont(ofSize: Metrics.headerFontSize)
        return title
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel.frame = bounds
    }
    
    func configure(with model: String) {
        titleLabel.text = model
    }
}
