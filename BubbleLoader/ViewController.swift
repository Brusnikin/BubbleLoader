//
//  ViewController.swift
//  BubbleLoader
//
//  Created by Blashkin Georgiy on 17/04/2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    private lazy var button: EllipsisButton = {
        let button = EllipsisButton()
        button.hidesWhenStopped = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        if #available(iOS 13.0, *) {
            view.backgroundColor = .systemBackground
        } else {
            view.backgroundColor = .white
        }
        view.addSubview(button)
        button.widthAnchor.constraint(equalToConstant: 30).isActive = true
        button.heightAnchor.constraint(equalToConstant: 30).isActive = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        button.startAnimating()

        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [self] in
            button.stopAnimating()
        }
    }
}

