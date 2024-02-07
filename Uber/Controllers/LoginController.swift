//
//  ViewController.swift
//  UberClone
//
//  Created by İbrahim Aktaş on 3.02.2024.
//

import UIKit
import SnapKit
import Firebase

class LoginController: UIViewController {
    
    //MARK: - Properties
    lazy var viewHeadline: UILabel = {
        let label = UILabel()
        label.text = "UBER"
        label.font = UIFont(name: "Avenir-Light", size: 36)
        label.textColor = UIColor(white: 1, alpha: 0.8)
        return label
    }()
    
    private func setupViewHeadline() {
        viewHeadline.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.centerX.equalToSuperview()
        }
    }
    
    lazy var emailContainerView: UIView = {
        let containerView = UIView().inputContainerView(image: "envelope", textField: emailTextField)
        containerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        return containerView
    }()
    
    
    lazy var emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    lazy var passwordContainerView: UIView = {
        let containerView = UIView().inputContainerView(image: "lock", textField: passwordTextField)
        containerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        return containerView
    }()
    
    lazy var loginButton: AuthButton = {
       let button = AuthButton()
        button.setTitle("Log In", for: .normal)
        return button
    }()
    
    
    lazy var passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailContainerView, passwordContainerView, loginButton])
        stack.axis = .vertical
        stack.spacing = 16
        stack.distribution = .fillEqually
        return stack
    }()
    
    lazy var dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ",
                                                        attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
                                                                     NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Sign Up", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.mainBlueTint]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignup), for: .touchUpInside)
        return button
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

//MARK: - Setup View's
extension LoginController {
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(viewHeadline).inset(90)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    private func setupDontHaveButton() {
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(32)
            make.centerX.equalToSuperview()
        }
    }
}
//MARK: - Selectors
extension LoginController {
    @objc func handleLoginButton() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        
        Auth.auth().signIn(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Error occuring when sign in \(error)")
                return
            }
            self.dismiss(animated: true)
        }
    }
    
    @objc func handleShowSignup() {
        let controller = SignUpController()
        navigationController?.pushViewController(controller, animated: true)
    }
}

//MARK: - Helpers
extension LoginController {
    func configureView() {
        view.backgroundColor = UIColor.backgroundColor
        view.addSubview(viewHeadline)
        setupStackView()
        setupViewHeadline()
        setupDontHaveButton()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
}
