//
//  BaseViewController.swift
//  CountryData
//
//  Created by Alex on 20/05/2023.
//

import UIKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
    }

    func present(spinner: UIViewController) {
        addChild(spinner)
        spinner.view.frame = view.frame
        view.addSubview(spinner.view)
        spinner.didMove(toParent: self)
    }
    
    func dismiss(spinner: UIViewController?) {
        spinner?.willMove(toParent: nil)
        spinner?.view.removeFromSuperview()
        spinner?.removeFromParent()
    }
    
}
