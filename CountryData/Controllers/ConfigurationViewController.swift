//
//  ViewController.swift
//  CountryData
//
//  Created by Alex on 19/05/2023.
//

import UIKit

final class ConfigurationViewController: BaseViewController {
    
    private let pickerDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "Pick some continent"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let pickerView: UIPickerView = {
        let picker = UIPickerView()
        picker.translatesAutoresizingMaskIntoConstraints = false
        return picker
    }()
    
    private let textFieldDescriptionLabel: UILabel = {
        let label = UILabel()
        label.text = "How many countries to show?"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .darkGray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter a number from 2 to 10"
        field.font = .systemFont(ofSize: 14)
        field.textAlignment = .center
        field.translatesAutoresizingMaskIntoConstraints = false
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.separator.cgColor
        field.layer.cornerRadius = 8
        field.tintColor = .black
        field.autocorrectionType = .no
        field.keyboardType = .numberPad
        field.backgroundColor = .tertiarySystemBackground
        return field
    }()
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 8
        stack.distribution = .fillProportionally
        stack.backgroundColor = .secondarySystemBackground
        stack.layer.cornerRadius = 6
        stack.isLayoutMarginsRelativeArrangement = true
        stack.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8)
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let separatorOne: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let separatorTwo: UIView = {
        let view = UIView()
        view.backgroundColor = .separator
        view.heightAnchor.constraint(equalToConstant: 1).isActive = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let alertWait = SpinnerViewController(message: "Please wait...")
    
    private let continents: [String] = Constants.countriesToCode.keys.map{ $0 }
    private var stackCenterYConstraint: NSLayoutConstraint?
    private var selectedContinentIndex = Constants.countriesToCode.keys.count / 2
    private var countriesToShow: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        setup()
        layout()
    }
    
    private func setup() {
        title = "Configure"
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.selectRow(continents.count / 2, inComponent: 0, animated: false)
        
        textField.delegate = self
        textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapDoneButton))
    }
    
    private func layout() {
        stack.addArrangedSubview(pickerDescriptionLabel)
        stack.addArrangedSubview(separatorOne)
        stack.addArrangedSubview(pickerView)
        stack.addArrangedSubview(separatorTwo)
        stack.addArrangedSubview(textFieldDescriptionLabel)
        stack.addArrangedSubview(textField)
        view.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalToSystemSpacingAfter: view.leadingAnchor, multiplier: 1),
            view.trailingAnchor.constraint(equalToSystemSpacingAfter: stack.trailingAnchor, multiplier: 1),
            stack.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.6)
        ])
        stackCenterYConstraint = stack.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        stackCenterYConstraint?.isActive = true
    }
    
    // hidding keyboard only on touches outside the stack on purpose
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismissKeyboardWithAnimation()
    }
    
    private func dismissKeyboardWithAnimation() {
        UIView.animate(withDuration: 0.3) { [weak self] in
            guard let strongSelf = self else { return }
            strongSelf.stackCenterYConstraint?.constant = 0
            strongSelf.view.layoutIfNeeded()
        }
        view.endEditing(true)
    }
    
    private func goToListVC(_ toShow: Int) {
        present(spinner: alertWait)
        
        APICaller.shared.getCountries(for: Constants.countriesToCode[continents[selectedContinentIndex]]!) { [weak self] result in
            switch result {
            case .success(let countries):
                let chosenCountries = countries.shuffled().prefix(toShow)
                DispatchQueue.main.async {
                    let vc = ListViewController(data: chosenCountries.sorted(by: { first, second in
                        first.name < second.name
                    }), continent: self?.continents[self?.selectedContinentIndex ?? 0] ?? "")
                    
                    self?.dismiss(spinner: self?.alertWait)
                    self?.navigationController?.pushViewController(vc, animated: true)
                }
            case .failure(let failure):
                DispatchQueue.main.async {
                    self?.dismiss(spinner: self?.alertWait)
                    self?.showError(with: failure.description)
                }
            }
        }
    }
    
    private func showError(with message: String) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Close", style: .cancel))
            self?.present(alert, animated: true)
        }
    }
}

//MARK: - Selectors
extension ConfigurationViewController {
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardUpY = keyboardFrame.cgRectValue.minY
            UIView.animate(withDuration: 2) { [weak self] in
                guard let strongSelf = self else { return }
                let stackDownY = strongSelf.stack.frame.maxY
                if keyboardUpY < stackDownY {
                    strongSelf.stackCenterYConstraint?.constant = -(stackDownY - keyboardUpY + 10)
                }
                strongSelf.view.layoutIfNeeded()
            }
        }
    }
    
    @objc func didTapDoneButton() {
        if let text = countriesToShow {
            if let numberOfCountries = Int(text), numberOfCountries >= 2, numberOfCountries <= 10 {
                dismissKeyboardWithAnimation()
                goToListVC(numberOfCountries)
            } else {
                textField.layer.borderColor = UIColor.systemRed.cgColor
                textField.text = ""
                countriesToShow = ""
                showError(with: "You can use only numbers. No letters or special symbols allowed. Enter a number from 2 to 10.")
            }
        } else {
            textField.layer.borderColor = UIColor.systemRed.cgColor
            showError(with: "There is no number provided. Enter a number from 2 to 10.")
        }
    }
    
    @objc func textFieldDidChange() {
        textField.layer.borderColor = UIColor.separator.cgColor
        countriesToShow = textField.text
    }
}

//MARK: - UIPickerViewDelegate
extension ConfigurationViewController: UIPickerViewDelegate {
    
}

//MARK: - UIPickerViewDataSource
extension ConfigurationViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        continents.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        continents[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedContinentIndex = row
    }
}

//MARK: - UITextFieldDelegate
extension ConfigurationViewController: UITextFieldDelegate {
    
}
