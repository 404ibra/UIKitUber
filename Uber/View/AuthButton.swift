//
//  AuthButton.swift
//  UberClone
//
//  Created by İbrahim Aktaş on 5.02.2024.
//

import UIKit

class AuthButton: UIButton {
    
    //MARK: - Life Cycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupAuthButton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension AuthButton {
    func setupAuthButton() {
        setTitleColor(UIColor(white: 1, alpha: 0.5), for: .normal)
        backgroundColor = .mainBlueTint
        layer.cornerRadius = 5
        snp.makeConstraints { make in
            make.height.equalTo(50)
        }
    }
}
