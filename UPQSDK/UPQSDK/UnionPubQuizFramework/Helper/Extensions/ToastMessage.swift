//
//  ToastMessage.swift
//  RRApp
//
//  Created by Ganesh on 29/07/20.
//  Copyright © 2020 Dotsquares. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController {
        
    func showToast(message: String, isUp:Bool =  false, type:showToastType = .success) {
        let toastContainer = UIView(frame: CGRect())
        toastContainer.backgroundColor = type ==  .success ? #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0):#colorLiteral(red: 0.9254902005, green: 0.2352941185, blue: 0.1019607857, alpha: 1)
        toastContainer.alpha = 0.0
        toastContainer.layer.cornerRadius = 12;
        toastContainer.clipsToBounds  =  true

        let toastLabel = UILabel(frame: CGRect())
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "HammersmithOne", size: 14.0) ?? UIFont.systemFont(ofSize: 14.0)
        toastLabel.text = message
        toastLabel.clipsToBounds  =  true
        toastLabel.numberOfLines = 0

        toastContainer.addSubview(toastLabel)
        self.view.addSubview(toastContainer)

        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastContainer.translatesAutoresizingMaskIntoConstraints = false

        let a1 = NSLayoutConstraint(item: toastLabel, attribute: .leading, relatedBy: .equal, toItem: toastContainer, attribute: .leading, multiplier: 1, constant: 15)
        let a2 = NSLayoutConstraint(item: toastLabel, attribute: .trailing, relatedBy: .equal, toItem: toastContainer, attribute: .trailing, multiplier: 1, constant: -15)
        let a3 = NSLayoutConstraint(item: toastLabel, attribute: .bottom, relatedBy: .equal, toItem: toastContainer, attribute: .bottom, multiplier: 1, constant: -15)
        let a4 = NSLayoutConstraint(item: toastLabel, attribute: .top, relatedBy: .equal, toItem: toastContainer, attribute: .top, multiplier: 1, constant: 15)
        toastContainer.addConstraints([a1, a2, a3, a4])

        let c1 = NSLayoutConstraint(item: toastContainer, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1, constant: 65)
        let c2 = NSLayoutConstraint(item: toastContainer, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: -65)
      
        if isUp {
              let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: -75)
             self.view.addConstraints([c1, c2, c3])
        }
        else{
          let c3 = NSLayoutConstraint(item: toastContainer, attribute: .bottom, relatedBy: .equal, toItem: self.view, attribute: .bottom, multiplier: 1, constant: -75)
          self.view.addConstraints([c1, c2, c3])
        }
        
        toastContainer.transform =
        CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        UIView.animate(withDuration: 0.5, delay: 0.2, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.0, options: .transitionCurlUp, animations: {
            toastContainer.alpha = 1.0
            toastContainer.transform =
            CGAffineTransform.identity.scaledBy(x: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.5, delay: 2.8, options: .transitionCurlDown, animations: {
                toastContainer.alpha = 0.0
                toastContainer.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
            }, completion: {_ in
                toastContainer.transform = .identity
                toastContainer.removeFromSuperview()
                 
            })
        })
    }
}

enum showToastType:Int{
    case success
    case failed
    case error
}
