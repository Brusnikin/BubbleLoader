//
//  ViewController.swift
//  BubbleLoader
//
//  Created by Blashkin Georgiy on 17/04/2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	let loader = BubbleLoader()

	override func viewDidLoad() {
		super.viewDidLoad()
		loader.center = CGPoint(x: view.center.x - loader.viewWidth() / 2, y: view.center.y)
		view.addSubview(loader)
	}

	override func viewDidAppear(_ animated: Bool) {
		super.viewDidAppear(animated)
		loader.start()
	}
}

