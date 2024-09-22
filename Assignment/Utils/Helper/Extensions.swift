//
//  Extensions.swift
//  Assignment
//
//  Created by M.Shariq Hasnain on 31/05/2024.
//

import UIKit

extension UIView {
    
    func show() {
        self.isHidden = false
    }
    
    func hide() {
        self.isHidden = true
    }
    
    func addDropShadow() {
        layer.shadowColor = UIColor.lightGray.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 3.0)
        layer.shadowOpacity = 0.4
        layer.shadowRadius = 5.0
        layer.masksToBounds = false
    }
    
    func slightRound(radius: CGFloat = 15, isFullRound: Bool? = true, isBorder: Bool = false, color: UIColor = .gray) {
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        
        if isBorder {
            self.layer.borderWidth = 1
            self.layer.borderColor = color.cgColor
        } else {
            self.layer.borderWidth = 0
            self.layer.borderColor = UIColor.clear.cgColor
        }
    }
    
    func halfRound() {
        self.layer.cornerRadius = self.frame.size.height / 2
        self.clipsToBounds = true
    }
    
    func completeRound() {
        self.layer.cornerRadius = self.frame.size.width / 2
        self.clipsToBounds = true
    }

}

extension UIApplication {
    class func topViewController(controller: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(controller: navigationController.visibleViewController)
        }
        if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(controller: selected)
            }
        }
        if let presented = controller?.presentedViewController {
            return topViewController(controller: presented)
        }
        return controller
    }
}

extension UITableView {
    func reloadWithScroll() {
        self.reloadData()
        let indexPath = IndexPath(row: 0, section: 0)
        self.scrollToRow(at: indexPath, at: .top, animated: false)
    }
}

extension Sequence {
    func limit(_ max: Int) -> [Element] {
        return self.enumerated()
            .filter { $0.offset < max }
            .map { $0.element }
    }
}

