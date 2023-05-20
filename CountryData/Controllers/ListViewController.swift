//
//  ListViewController.swift
//  CountryData
//
//  Created by Alex on 19/05/2023.
//

import UIKit

final class ListViewController: UIViewController {
    
    private let countriesWithInfo: [CountryWithInfo]
    
    init(data: [CountryWithInfo]) {
        self.countriesWithInfo = data
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        self.countriesWithInfo = []
        super.init(coder: coder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .blue
    }
}
