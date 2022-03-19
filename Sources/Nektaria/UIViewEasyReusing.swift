//
//  Nektaria
//
//  Copyright (C) 2017 Konstantin Gerasimov
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

extension NSObject {

    fileprivate static var className: String {
        let objectClass: AnyClass = self
        let objectClassName = NSStringFromClass(objectClass)
        let objectClassNameComponents = objectClassName.components(separatedBy: ".")
        return objectClassNameComponents.last!
    }

}

extension UIStoryboard {

    public func instantiate<ViewController: UIViewController>(_ viewController: ViewController.Type) -> ViewController {
        return instantiateViewController(withIdentifier: viewController.className) as! ViewController
    }

}

extension UIViewController {

    public static func loadFromNib() -> Self {
        return loadViewControllerFromNib()
    }

    private static func loadViewControllerFromNib<ViewController: UIViewController>() -> ViewController {
        return ViewController(nibName: className, bundle: Bundle(for: ViewController.self))
    }

}

extension UIView {

    public static func loadFromNib() -> Self {
        return loadViewFromNib()
    }

    private static func loadViewFromNib<View: UIView>() -> View {
        let nibContent = Bundle(for: View.self).loadNibNamed(className, owner: nil, options: nil)
        var viewToReturn: View!

        for objectFromNib in nibContent! {
            guard let objectFromNib = objectFromNib as? View else { continue }

            viewToReturn = objectFromNib
            break
        }

        return viewToReturn
    }

}

extension UITableView {

    public enum RegistrationTarget<View: UIView> {
        case cellClass(View.Type)
        case cellNib(View.Type)
        case headerFooterClass(View.Type)
        case headerFooterNib(View.Type)
    }

    public func register(_ target: RegistrationTarget<UIView>) {
        switch target {
        case .cellClass(let type):
            register(type, forCellReuseIdentifier: type.className)
        case .cellNib(let type):
            let bundle = Bundle(for: type)
            let nib = UINib(nibName: type.className, bundle: bundle)
            register(nib, forCellReuseIdentifier: type.className)
        case .headerFooterClass(let type):
            register(type, forHeaderFooterViewReuseIdentifier: type.className)
        case .headerFooterNib(let type):
            let bundle = Bundle(for: type)
            let nib = UINib(nibName: type.className, bundle: bundle)
            register(nib, forHeaderFooterViewReuseIdentifier: type.className)
        }
    }

    public func dequeue<Cell: UITableViewCell>(at indexPath: IndexPath, cell: Cell.Type = Cell.self) -> Cell {
        let cell = dequeueReusableCell(withIdentifier: cell.className, for: indexPath) as? Cell
        return cell!
    }

    public func dequeue<View: UITableViewHeaderFooterView>(_ view: View.Type = View.self) -> View {
        return dequeueReusableHeaderFooterView(withIdentifier: view.className) as! View
    }

}

extension UICollectionView {

    public enum RegistrationTarget<View> {
        case cellClass(View.Type)
        case cellNib(View.Type)
        case supplementaryViewClass(View.Type, kind: String)
        case supplementaryViewNib(View.Type, kind: String)
    }

    public func register(_ target: RegistrationTarget<UIView>) {
        switch target {
        case .cellClass(let type):
            register(type, forCellWithReuseIdentifier: type.className)
        case .cellNib(let type):
            let bundle = Bundle(for: type)
            let nib = UINib(nibName: type.className, bundle: bundle)
            register(nib, forCellWithReuseIdentifier: type.className)
        case .supplementaryViewClass(let type, let kind):
            register(type, forSupplementaryViewOfKind: kind, withReuseIdentifier: type.className)
        case .supplementaryViewNib(let type, let kind):
            let bundle = Bundle(for: type)
            let nib = UINib(nibName: type.className, bundle: bundle)
            register(nib, forSupplementaryViewOfKind: kind, withReuseIdentifier: type.className)
        }
    }

    public func dequeue<Cell: UICollectionViewCell>(at indexPath: IndexPath, cell: Cell.Type = Cell.self) -> Cell {
        let cell = dequeueReusableCell(withReuseIdentifier: cell.className, for: indexPath) as? Cell
        return cell!
    }

    public func dequeue<View: UICollectionReusableView>(at indexPath: IndexPath, view: View.Type = View.self, ofKind kind: String) -> View {
        let cell = dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: view.className, for: indexPath) as? View
        return cell!
    }

}
