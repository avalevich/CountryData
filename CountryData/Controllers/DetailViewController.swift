//
//  DetailViewController.swift
//  CountryData
//
//  Created by Alex on 19/05/2023.
//

import UIKit

final class DetailViewController: UIViewController {
    
    private let country: Country
    
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
    
    private let alertWait: UIAlertController = {
        let alert = UIAlertController(title: nil, message: "Please wait...", preferredStyle: .alert)
        alert.view.tintColor = UIColor.black
        let loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(10, 5, 50, 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = .medium
        loadingIndicator.startAnimating()
        alert.view.addSubview(loadingIndicator)
        return alert
    }()
    
    init(_ country: Country) {
        self.country = country
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setup()
    }
    
    private func setup() {
        title = country.name
        
        view.window?.rootViewController?.present(alertWait, animated: true)
        
        APICaller.shared.getDetailedInfo(for: country.name) { [weak self, country] res in
            var hasInfo = false
            switch res {
            case .success(let info):
                if let info = info {
                    var currency = ""
                    if info.currencies.array.first?.shortName == nil || info.currencies.array.first?.name == nil {
                        // will never happen
                        currency = "No information found!"
                    } else {
                        currency = info.currencies.array.first!.shortName + " (" + info.currencies.array.first!.name + ")"
                    }
                    
                    let countryWithInfo = CountryWithInfo(hasInfo: true, name: country.name + country.emoji, officialName: info.name.official, currency: currency, population: "\(info.population)", subregion: info.subregion, capital: info.capital.joined(separator: ", "), languages: info.languages.values.map{ $0 }.joined(separator: ", "))
                    
                    DispatchQueue.main.async {
                        self?.setLabels(with: countryWithInfo)
                        self?.alertWait.dismiss(animated: true)
                    }
                    hasInfo = true
                } else {
                    DispatchQueue.main.async {
                        self?.alertWait.dismiss(animated: true) {
                            self?.showError(with: "No information found about this country.")
                        }
                    }
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self?.alertWait.dismiss(animated: true) {
                        self?.showError(with: failure.description)
                    }
                }
            }
            DispatchQueue.main.async {
                self?.layout(withInfo: hasInfo)
            }
        }
    }
    
    private func layout(withInfo: Bool) {
        if !withInfo {
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
    
    private func showError(with message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel))
            self?.present(alert, animated: true)
        }
    }
    
    private func setLabels(with countryWithInfo: CountryWithInfo) {
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
