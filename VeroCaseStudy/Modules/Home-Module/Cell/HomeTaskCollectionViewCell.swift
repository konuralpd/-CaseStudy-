//
//  HomeTaskCollectionViewCell.swift
//  VeroCaseStudy
//
//  Created by Mac on 9.02.2023.
//

import Foundation
import UIKit



class HomeTaskCollectionViewCell: UICollectionViewCell {
    
    let activityIndicator = UIActivityIndicatorView()
    private var verticalStackView: UIStackView!
    
    static let identifier = "HomeTaskCollectionViewCell"

    private let cellBackground: UIView = {
       let uv = UIView()
        uv.layer.masksToBounds = true
        uv.layer.cornerRadius = 8
        return uv
    }()
    
    private let taskLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 18)
        label.numberOfLines = 0
        return label
    }()
    
    private let titleLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    private let descriptionLabel: UILabel = {
       let label = UILabel()
        label.textColor = .white
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 14)
        label.numberOfLines = 0
        return label
    }()



    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(cellBackground)
        setupVerticalStackView()
     
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        cellBackground.frame = contentView.bounds


    }
    
    private func setupVerticalStackView() {
        verticalStackView = UIStackView(arrangedSubviews: [taskLabel, titleLabel, descriptionLabel])
        verticalStackView.axis = .vertical
        verticalStackView.alignment = .fill
        verticalStackView.distribution = .fillEqually
        verticalStackView.spacing = 8
        
        cellBackground.addSubview(verticalStackView)
        
        verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: cellBackground.leadingAnchor, constant: 12),
            verticalStackView.trailingAnchor.constraint(equalTo: cellBackground.trailingAnchor, constant: -12),
            verticalStackView.topAnchor.constraint(equalTo: cellBackground.topAnchor, constant: 8),
            verticalStackView.bottomAnchor.constraint(equalTo: cellBackground.bottomAnchor)
        ])
    }
    

    
    func set(task: TaskResponseElement) {
        guard let taskTitle = task.task else { return }
        guard let title = task.title else { return }
        guard let description = task.description else { return }
        guard let bgColor = task.colorCode else { return }
        cellBackground.backgroundColor = UIColor(hexString: bgColor, alpha: 1)
        taskLabel.text = taskTitle
        titleLabel.text = title
        descriptionLabel.text = description
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
