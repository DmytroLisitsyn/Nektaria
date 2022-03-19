//
//  Nektaria
//
//  Copyright (C) 2019 Dmytro Lisitsyn
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

extension String {

    public func justifyingCount(desired: Int, gapsFilling character: Character) -> String {
        let gapsToFillCount = desired - count

        if gapsToFillCount > 0 {
            let gapsString = Array(repeating: character, count: gapsToFillCount)
            return self + gapsString
        } else {
            return String(prefix(desired))
        }
    }

}

extension String {

    public func height(width: CGFloat = .infinity, font: UIFont) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)

        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]

        let rect = NSString(string: self).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return ceil(rect.height)
    }

    public func width(height: CGFloat = .infinity, font: UIFont) -> CGFloat {
        let size = CGSize(width: .greatestFiniteMagnitude, height: height)

        let attributes: [NSAttributedString.Key: Any] = [.font: font]
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]

        let rect = NSString(string: self).boundingRect(with: size, options: options, attributes: attributes, context: nil)
        return ceil(rect.width)
    }

}

extension NSAttributedString {

    public func height(width: CGFloat = .infinity) -> CGFloat {
        let size = CGSize(width: width, height: .greatestFiniteMagnitude)

        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]

        let rect = boundingRect(with: size, options: options, context: nil)
        return ceil(rect.height)
    }

    public func width(height: CGFloat = .infinity) -> CGFloat {
        let size = CGSize(width: .greatestFiniteMagnitude, height: height)

        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin, .usesFontLeading]

        let rect = boundingRect(with: size, options: options, context: nil)
        return ceil(rect.width)
    }

}
