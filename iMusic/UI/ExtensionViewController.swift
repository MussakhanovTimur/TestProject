//
//  ExtensionViewController.swift
//  iMusic
//
//  Created by Тимур Мусаханов on 18.01.2021.
//

import UIKit

extension UIViewController {
    func presentErrorAlertController(withTitle title: String, message: String? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        present(alert, animated: true)
        
        Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: {_ in
            alert.dismiss(animated: true)
        })
    }
    
    func setShadow(_ view: UIView) {
        view.layer.shadowRadius = 9
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 5, height: 8)
    }
    
    func getYear(_ date: String?) -> String {
        var year = ""
        if let text = date {
            for (i, character) in text.enumerated() {
                switch i {
                case 0, 1, 2, 3:
                    year.append(character)
                default:
                    break
                }
            }
        }
        return year
    }
}
