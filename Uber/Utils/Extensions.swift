//
//  Extensions.swift
//  UberClone
//
//  Created by İbrahim Aktaş on 5.02.2024.
//

import Foundation
import UIKit
import SnapKit

extension UIView {
    func inputContainerView(image: String, textField: UITextField? = nil, segmentControl: UISegmentedControl? = nil) -> UIView {
        let view = UIView()
         let seperatorView = UIView()
         let imageView = UIImageView()
         
         view.addSubview(imageView)
         view.addSubview(seperatorView)
         
         imageView.image = UIImage(systemName: image)
         imageView.tintColor = .white
         imageView.alpha = 0.87

         seperatorView.backgroundColor = .lightGray
         seperatorView.snp.makeConstraints { make in
             make.left.equalTo(view).inset(8)
             make.right.equalTo(view)
             make.bottom.equalTo(view)
             make.height.equalTo(0.75)
         }
        
        if let textField = textField {
            view.addSubview(textField)
            textField.snp.makeConstraints { make in
                make.left.equalTo(imageView).inset(38)
                make.bottom.equalTo(view).inset(8)
                make.right.equalTo(view)
                make.centerY.equalToSuperview()
            }
            
            imageView.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(16)
                make.height.equalTo(24)
                make.width.equalTo(28)
                make.centerY.equalToSuperview()
            }
        }
        
        if let segmentControl = segmentControl {
            imageView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(8)
                make.left.equalToSuperview().inset(8)
                make.height.equalTo(24)
                make.width.equalTo(24)
            }
            view.addSubview(segmentControl)
            segmentControl.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(8)
                make.right.equalToSuperview()
                make.height.equalTo(75)
            }
        }
      
        
         return view
    }
    
    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.55
        layer.shadowOffset = CGSize(width: 0.5, height: 0.5)
        layer.masksToBounds = false
    }
}

extension UITextField {
    func textField(withPlaceholder placeholder: String, isSecureTextEntry: Bool? ) -> UITextField {
        let textField = UITextField()
         textField.borderStyle = .none
         textField.font = UIFont.systemFont(ofSize: 16)
         textField.textColor = .white
         textField.keyboardAppearance = .dark
        textField.isSecureTextEntry = isSecureTextEntry ?? false
         textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.lightGray])
         return textField
    }
}
