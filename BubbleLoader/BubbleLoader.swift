//
//  BubbleLoader.swift
//  BubbleLoader
//
//  Created by Blashkin Georgiy on 17/04/2019.
//  Copyright © 2019 Blashkin Georgiy. All rights reserved.
//

import UIKit

@objc
protocol BubbleLoader: class {
    var hidesWhenStopped: Bool { get set }

    func startAnimating()
    func stopAnimating()
}

protocol ButtonBubbleLoader: BubbleLoader {
    func button() -> UIButton
}

final class EllipsisButton: UIButton {

    // MARK: - Properties

    /// Default is `true`. Calls `isHidden` when animating gets set to false
    var hidesWhenStopped = true

    /// The color of the bubble
    private(set) var color: UIColor = .groupTableViewBackground

    /// The duration of the bubble transform animation. Default is 0.5 seconds
    private(set) var duration = 0.5

    /// The total bubbles count to present
    private(set) var count: Int = 3

    /// The scale of the bubble transform during animation
    private(set) var scale: CGFloat = 1.5

    // MARK: - Init

    init(color: UIColor = .groupTableViewBackground, duration: Double = 0.5, count: Int = 3) {
        self.color = color
        self.duration = duration
        self.count = count

        super.init(frame: .zero)

        configure()
    }

    private override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        configure()
    }

    // MARK: - Lifecycle

    override func layoutSubviews() {
        super.layoutSubviews()
        layout()
    }

    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        bounds.insetBy(dx: -10, dy: -10).contains(point)
    }

    // MARK: - Private methods

    private func configure() {
        titleLabel?.isHidden = true

        (0..<count).forEach { _ in
            layer.addSublayer(CAShapeLayer())
        }
    }

    private func layout() {
        guard let sublayers = layer.sublayers else {
            return
        }

        var x: CGFloat = 0.0
        let floatCount = CGFloat(count)
        let size = frame.width / floatCount / scale
        let offset = (frame.width - (size * floatCount)) / floatCount - 1

        sublayers.enumerated().forEach { (index, layer) in
            let point = CGPoint(x: x, y: bounds.midY - size / 2)
            x = (offset + size) * CGFloat(index)
            layer.frame = CGRect(origin: point, size: CGSize(width: size, height: size))
            if let shapeLayer = (layer as? CAShapeLayer) {
                rounded(layer: shapeLayer)
            }
        }
    }

    private func animate(bubble: CAShapeLayer, beginTime: Double) {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.fromValue = 1
        animation.toValue = scale
        animation.duration = duration
        animation.beginTime = beginTime
        animation.repeatCount = .infinity
        animation.autoreverses = true
        animation.isRemovedOnCompletion = false
        bubble.add(animation, forKey: nil)
    }

    private func rounded(layer: CAShapeLayer) {
        layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)
        let rect = layer.frame
        if #available(iOS 13.0, *) {
            layer.cornerRadius = min(rect.width, rect.height) / 2
            layer.cornerCurve = .circular
            layer.masksToBounds = true
            layer.backgroundColor = color.cgColor
        } else if #available(iOS 11.0, *) {
            layer.backgroundColor = color.cgColor
            layer.masksToBounds = true
            layer.cornerRadius = min(rect.width, rect.height) / 2
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner, .layerMaxXMinYCorner]
        } else {
            layer.strokeColor = UIColor.clear.cgColor
            layer.fillColor = color.cgColor
            layer.path = UIBezierPath(ovalIn: rect).cgPath
        }
    }
}

extension EllipsisButton: ButtonBubbleLoader {
    func startAnimating() {
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

    func stopAnimating() {
        guard let sublayers = layer.sublayers else {
            return
        }

        sublayers.forEach { layer in
            layer.isHidden = hidesWhenStopped
            layer.removeAllAnimations()
        }
    }

    func button() -> UIButton {
        self
    }
}
