//
//  UIViewUtilities.swift
//  SmartRun
//
//  Created by Dmytro Lisitsyn on 29.07.2019.
//  Copyright © 2019 SmartRun. All rights reserved.
//

import UIKit

extension UIView {

    public func snapshot() -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(layer.bounds.size, false, UIScreen.main.scale)

        var image: UIImage?
        if let context = UIGraphicsGetCurrentContext() {
            layer.render(in: context)
            image = UIGraphicsGetImageFromCurrentImageContext()
        }

        UIGraphicsEndImageContext()

        return image
    }

    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if radius == 0 {
            layer.cornerRadius = 0
            layer.mask = nil
            return
        }

        if corners == .allCorners {
            layer.cornerRadius = radius
            layer.mask = nil
            return
        }

        let cornerRadii = CGSize(width: radius, height: radius)
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: cornerRadii)
        let mask = CAShapeLayer()
        mask.path = path.cgPath

        layer.cornerRadius = 0
        layer.mask = mask
    }

    convenience init(contentMode: UIView.ContentMode) {
        self.init(frame: .zero)

        self.contentMode = contentMode
    }

}
