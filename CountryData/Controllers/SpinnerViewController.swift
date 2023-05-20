//
//  SpinnerViewController.swift
//  CountryData
//
//  Created by Alex on 20/05/2023.
//

import UIKit

final class SpinnerViewController: UIViewController {
    
    private let spinner: UIActivityIndicatorView = {
        let activityView = UIActivityIndicatorView(style: .medium)
        activityView.translatesAutoresizingMaskIntoConstraints = false
        return activityView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .semibold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 12
        stack.distribution = .fillProportionally
        stack.alignment = .center
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 12
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 0, leading: 26, bottom: 0, trailing: 26)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(message: String = "") {
        label.text = message
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 0.2)
        spinner.startAnimating()
        
        stack.addArrangedSubview(spinner)
        stack.addArrangedSubview(label)
        
        view.addSubview(stack)
        
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 60).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.64).isActive = true
    }
}
