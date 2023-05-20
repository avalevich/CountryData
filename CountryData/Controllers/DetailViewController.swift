//
//  DetailViewController.swift
//  CountryData
//
//  Created by Alex on 19/05/2023.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let countryWithInfo: CountryWithInfo
    
    private let noInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "No information found!"
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let officialNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Official Name: "
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "Currency: "
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let populationLabel: UILabel = {
        let label = UILabel()
        label.text = "Population: "
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subregionLabel: UILabel = {
        let label = UILabel()
        label.text = "Subregion: "
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let capitalLabel: UILabel = {
        let label = UILabel()
        label.text = "Capital(s): "
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let languageLabel: UILabel = {
        let label = UILabel()
        label.text = "Language(s): "
        label.font = .systemFont(ofSize: 18)
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.distribution = .equalSpacing
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    init(_ countryWithInfo: CountryWithInfo) {
        self.countryWithInfo = countryWithInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setup()
        layout()
    }
    
    private func setup() {
        title = countryWithInfo.name
        
        if countryWithInfo.hasInfo {
            var text = officialNameLabel.text ?? ""
            officialNameLabel.text = text + countryWithInfo.officialName
            text = currencyLabel.text ?? ""
            currencyLabel.text = text + countryWithInfo.currency
            text = populationLabel.text ?? ""
            populationLabel.text = text + countryWithInfo.population
            text = subregionLabel.text ?? ""
            subregionLabel.text = text + countryWithInfo.subregion
            text = capitalLabel.text ?? ""
            capitalLabel.text = text + countryWithInfo.capital
            text = languageLabel.text ?? ""
            languageLabel.text = text + countryWithInfo.languages
        }
    }
    
    private func layout() {
        if !countryWithInfo.hasInfo {
            view.addSubview(noInfoLabel)
            
            NSLayoutConstraint.activate([
                noInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                noInfoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                noInfoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                noInfoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
            return
        }
        
        let views: [UIView] = [officialNameLabel, currencyLabel, populationLabel, subregionLabel, capitalLabel, languageLabel]
        for el in views {
            let separator = UIView()
            separator.backgroundColor = .separator
            separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
            separator.translatesAutoresizingMaskIntoConstraints = false
            stack.addArrangedSubview(separator)
            stack.addArrangedSubview(el)
        }
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stack.trailingAnchor, multiplier: 1),
            stack.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 1),
            view.safeAreaLayoutGuide.bottomAnchor.constraint(equalToSystemSpacingBelow: stack.bottomAnchor, multiplier: 1)
        ])
    }
}
