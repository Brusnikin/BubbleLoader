//
//  BubbleLoader.swift
//  BubbleLoader
//
//  Created by Blashkin Georgiy on 17/04/2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

protocol BubbleLoaderProtocol {
	func start()
	func stop()
}

class BubbleLoader: UIView {

	// MARK: - Properties

	var offset: Int
	var size: CGSize
	var color: UIColor
	var duration: Double
	var count: Int

	// MARK: - Constraction

	init(offset: Int = 10,
		 size: CGSize = CGSize(width: 10, height: 10),
		 color: UIColor = .red,
		 duration: Double = 0.5,
		 count: Int = 5) {
		self.offset = offset
		self.size = size
		self.color = color
		self.duration = duration
		self.count = count
		super.init(frame: .zero)

		var x = 0
		for index in 1...count {
			let point = CGPoint(x: x, y: 0)
			x = (offset + Int(size.width)) * index
			let bubble = layer(with: CGRect(origin: point, size: size))
			layer.addSublayer(bubble)
		}
	}

	required init?(coder aDecoder: NSCoder) {
		fatalError("init(coder:) has not been implemented")
	}

	// MARK: - Public functions

	func viewWidth() -> CGFloat {
		return (size.width + CGFloat(offset)) * CGFloat(count)
	}
	
	// MARK: - Private functions

	private func animate(bubble: CAShapeLayer, beginTime: Double) {
		let animation = CABasicAnimation(keyPath: "transform.scale")
		animation.fromValue = 1
		animation.toValue = 1.5
		animation.duration = duration
		animation.beginTime = beginTime
		animation.repeatCount = .infinity
		animation.autoreverses = true
		animation.isRemovedOnCompletion = false
		bubble.add(animation, forKey: nil)
	}

	private func layer(with rect: CGRect) -> CAShapeLayer {
		let layer = CAShapeLayer()
		layer.bounds = rect
		layer.frame = rect
		layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
		layer.strokeColor = UIColor.clear.cgColor
		layer.fillColor = color.cgColor
		layer.path = UIBezierPath(ovalIn: rect).cgPath
		return layer
	}
}

extension BubbleLoader: BubbleLoaderProtocol {
	func start() {
		guard let sublayers = layer.sublayers else {
			return
		}

		for (index, layer) in sublayers.enumerated() {
			layer.isHidden = false
			if let shapeLayer = (layer as? CAShapeLayer) {
				animate(bubble: shapeLayer, beginTime: duration / Double(sublayers.count - index))
			}
		}
	}

	func stop() {
		guard let sublayers = layer.sublayers else {
			return
		}

		sublayers.forEach { layer in
			layer.isHidden = true
			layer.removeAllAnimations()
		}
	}
}
