//
//  LocationInputView.swift
//  UberClone
//
//  Created by İbrahim Aktaş on 6.02.2024.
//

import UIKit
import SnapKit

protocol LocationInputViewDelegate: AnyObject {
    func dismissLocationInputView()
}

class LocationInputView: UIView {
    
    //MARK: - Properties
    
    var user: User? {
        didSet { titleLabel.text = user?.email }
    }
    
    weak var delegate: LocationInputViewDelegate?
    
    lazy var backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "arrow.backward")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleBackTapped), for: .touchUpInside)
        return button
    }()
    
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .darkGray
        label.font = UIFont.systemFont(ofSize: 16)
        return label
    }()
    
    lazy var startLocationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        view.layer.cornerRadius = 4
        return view
    }()
    
    lazy var linkingView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        return view
    }()
    
    lazy var destinationIndicatorView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var startingLocationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Current Location"
        textField.backgroundColor = .groupTableViewBackground
        textField.isEnabled = false
        textField.font = UIFont.systemFont(ofSize: 14)
        
        let paddingView = UIView()
        paddingView.snp.makeConstraints { make in
            make.width.equalTo(8)
            make.height.equalTo(30)
        }
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()
    
    private lazy var destinationLocationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter a destination"
        textField.backgroundColor = .lightGray
        textField.returnKeyType = .search
        textField.font = UIFont.systemFont(ofSize: 14)
        
        
        let paddingView = UIView()
        paddingView.snp.makeConstraints { make in
            make.width.equalTo(8)
            make.height.equalTo(30)
        }
        textField.leftView = paddingView
        textField.leftViewMode = .always
        return textField
    }()
    
    //MARK: - Selectors
    @objc func handleBackTapped() {
        delegate?.dismissLocationInputView()
    }
    
    //MARK: - Life Cycles
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBackButton()
        configureUI()
        setupTitleLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
//MARK: - Setup Views
extension LocationInputView {
    private func configureUI() {
        backgroundColor = .white
        addShadow()
        setupCurrentLocationTextField()
        setupDestinationLocationTextField()
        setupStartLocationIndicatorView()
        setupDestinationLocationIndicatorView()
        setupIndicatorViewsLinking()
    }
    
    private func setupBackButton() {
        addSubview(backButton)
        backButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(50)
            make.left.equalToSuperview().inset(12)
            make.width.equalTo(24)
            make.height.equalTo(25)
        }
    }
    
    private func setupTitleLabel() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(backButton)
            make.centerX.equalToSuperview()
            
        }
    }
    
    private func setupCurrentLocationTextField() {
        addSubview(startingLocationTextField)
        startingLocationTextField.snp.makeConstraints { make in
            make.top.equalTo(backButton).inset(30)
            make.left.equalToSuperview().inset(40)
            make.right.equalToSuperview().inset(40)
            make.height.equalTo(30)
        }
    }
    
    private func setupDestinationLocationTextField() {
        addSubview(destinationLocationTextField)
        destinationLocationTextField.snp.makeConstraints { make in
            make.top.equalTo(startingLocationTextField.snp.bottom).offset(12)
            make.left.equalToSuperview().inset(40)
            make.right.equalToSuperview().inset(40)
            make.right.equalToSuperview()
            make.height.equalTo(30)
        }
    }
    
    private func setupStartLocationIndicatorView() {
        addSubview(startLocationIndicatorView)
        startLocationIndicatorView.snp.makeConstraints { make in
            make.centerY.equalTo(startingLocationTextField)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(8)
            make.height.equalTo(8)
        }
    }
    
    private func setupDestinationLocationIndicatorView() {
        addSubview(destinationIndicatorView)
        destinationIndicatorView.snp.makeConstraints { make in
            make.centerY.equalTo(destinationLocationTextField)
            make.left.equalToSuperview().inset(20)
            make.width.equalTo(8)
            make.height.equalTo(8)
        }
    }
    
    private func setupIndicatorViewsLinking() {
        addSubview(linkingView)
        linkingView.snp.makeConstraints { make in
            make.top.equalTo(startLocationIndicatorView.snp.bottom).offset(4)
            make.bottom.equalTo(destinationIndicatorView.snp.top).inset(-4)
            make.width.equalTo(0.5)
            make.centerX.equalTo(startLocationIndicatorView)
        }
    }
}
