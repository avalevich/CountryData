//
//  DetailViewController.swift
//  CountryData
//
//  Created by Alex on 19/05/2023.
//

import UIKit

final class DetailViewController: BaseViewController {
    
    private let country: Country
    private let alertWait = SpinnerViewController(message: "Please wait...")
    private var countryInfo: CountryWithInfo?
    
    private let noInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "No information found!"
        label.font = .systemFont(ofSize: 30)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .equalSpacing
        stack.alignment = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
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
        setup()
    }
    
    private func setup() {
        title = country.name
        
        present(spinner: alertWait)
        
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
                        self?.countryInfo = countryWithInfo
                        self?.dismiss(spinner: self?.alertWait)
                    }
                    hasInfo = true
                } else {
                    DispatchQueue.main.async {
                        self?.dismiss(spinner: self?.alertWait)
                        self?.showError(with: "No information found about this country.")
                        
                    }
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self?.dismiss(spinner: self?.alertWait)
                    self?.showError(with: failure.description)
                }
            }
            DispatchQueue.main.async {
                self?.layout(withInfo: hasInfo)
            }
        }
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .separator
        separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
    
    private func createRow(title: String, value: String) -> UIView {
        let titleLabel = UILabel()
        titleLabel.text = title
        titleLabel.textColor = .systemBlue
        titleLabel.font = .systemFont(ofSize: 18)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let valueLabel = UILabel()
        valueLabel.text = value
        valueLabel.font = .systemFont(ofSize: 18)
        valueLabel.numberOfLines = 0
        valueLabel.textAlignment = .right
        valueLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        stack.addArrangedSubview(titleLabel)
        stack.addArrangedSubview(valueLabel)
        
        return stack
    }
    
    private func layout(withInfo: Bool) {
        guard let info = countryInfo, withInfo else {
            view.addSubview(noInfoLabel)
            
            NSLayoutConstraint.activate([
                noInfoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                noInfoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                noInfoLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
                noInfoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
            ])
            return
        }
        
        let views: [UIView] = [
            createRow(title: "Official Name:", value: info.officialName),
            createRow(title: "Currency:", value: info.currency),
            createRow(title: "Population:", value: info.population),
            createRow(title: "Subregion:", value: info.subregion),
            createRow(title: "Capital(s):", value: info.capital),
            createRow(title: "Language(s):", value: info.languages)
        ]
        
        stack.addArrangedSubview(createSeparator())
        for el in views {
            stack.addArrangedSubview(el)
            stack.addArrangedSubview(createSeparator())
        }
        
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.topAnchor, multiplier: 2),
            stack.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 2),
            view.safeAreaLayoutGuide.trailingAnchor.constraint(equalToSystemSpacingAfter: stack.trailingAnchor, multiplier: 2)
        ])
    }
    
    private func showError(with message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel))
            self?.present(alert, animated: true)
        }
    }
}
