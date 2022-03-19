//
//  Nektaria
//
//  Copyright (C) 2021 Dmytro Lisitsyn
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import UIKit

public struct Akro {

    fileprivate var targetView: UIView

    fileprivate var layoutAttributes: [NSLayoutConstraint.Attribute] = []

    fileprivate init(targetView: UIView) {
        self.targetView = targetView

        targetView.translatesAutoresizingMaskIntoConstraints = false
    }

}

extension Akro {

    public var all: Akro {
        return horizontal.vertical
    }

    public var horizontal: Akro {
        return leading.trailing
    }

    public var vertical: Akro {
        return top.bottom
    }

    public var center: Akro {
        return horizontalCenter.verticalCenter
    }

    public var horizontalCenter: Akro {
        var akro = self
        akro.layoutAttributes.append(.centerX)
        return akro
    }

    public var verticalCenter: Akro {
        var akro = self
        akro.layoutAttributes.append(.centerY)
        return akro
    }

    public var top: Akro {
        var akro = self
        akro.layoutAttributes.append(.top)
        return akro
    }

    public var bottom: Akro {
        var akro = self
        akro.layoutAttributes.append(.bottom)
        return akro
    }

    public var leading: Akro {
        var akro = self
        akro.layoutAttributes.append(.leading)
        return akro
    }

    public var trailing: Akro {
        var akro = self
        akro.layoutAttributes.append(.trailing)
        return akro
    }

    public var width: Akro {
        var akro = self
        akro.layoutAttributes.append(.width)
        return akro
    }

    public var height: Akro {
        var akro = self
        akro.layoutAttributes.append(.height)
        return akro
    }

    @discardableResult
    public func apply(to view: AkroApplicable?) -> [NSLayoutConstraint] {
        return apply(to: view, relation: .equal)
    }

    @discardableResult
    public func apply(
        to superview: AkroApplicable? = nil,
        attribute: NSLayoutConstraint.Attribute? = nil,
        relation: NSLayoutConstraint.Relation = .equal,
        multiplier: CGFloat = 1,
        constant: CGFloat = 0,
        priority: UILayoutPriority = .required
    ) -> [NSLayoutConstraint] {
        let akro = self

        var constraints: [NSLayoutConstraint] = []
        var layoutAttributes = akro.layoutAttributes
        var superview = superview

        if layoutAttributes.isEmpty {
            layoutAttributes.append(contentsOf: [.top, .bottom, .leading, .trailing])
        }

        for layoutAttribute in layoutAttributes {
            let edgeMultiplier = makeEdgeMultiplier(for: layoutAttribute)
            let constant = constant * edgeMultiplier
            let relation = makeRelation(relation, multipliedBy: edgeMultiplier)

            if superview == nil, canUseSuperviewAsDefaultView(layoutAttribute) {
                superview = akro.targetView.superview
            }

            let secondAttribute = attribute ?? layoutAttribute

            let constraint = NSLayoutConstraint(
                item: akro.targetView,
                attribute: layoutAttribute,
                relatedBy: relation,
                toItem: superview,
                attribute: secondAttribute,
                multiplier: multiplier,
                constant: constant
            )

            constraint.priority = priority
            constraint.isActive = true

            constraints.append(constraint)
        }

        return constraints
    }

}

extension Akro {

    private func makeEdgeMultiplier(for layoutAttribute: NSLayoutConstraint.Attribute) -> CGFloat {
        switch layoutAttribute {
        case .bottom, .trailing:
            return -1
        default:
            return 1
        }
    }

    private func makeRelation(_ relation: NSLayoutConstraint.Relation, multipliedBy edgeMultiplier: CGFloat) -> NSLayoutConstraint.Relation {
        switch relation {
        case .lessThanOrEqual where edgeMultiplier < 0:
            return .greaterThanOrEqual
        case .greaterThanOrEqual where edgeMultiplier < 0:
            return .lessThanOrEqual
        default:
            return relation
        }
    }

    private func canUseSuperviewAsDefaultView(_ layoutAttribute: NSLayoutConstraint.Attribute) -> Bool {
        return layoutAttribute != .width && layoutAttribute != .height
    }

}

public protocol AkroApplicable {

}

extension UIView: AkroApplicable {

    public var akro: Akro {
        return Akro(targetView: self)
    }

    public func akro(_ transaction: (Akro) -> Void) {
        transaction(akro)
    }

}

extension UILayoutGuide: AkroApplicable {

}
