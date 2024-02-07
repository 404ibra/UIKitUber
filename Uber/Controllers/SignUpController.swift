//
//  SignUpController.swift
//  UberClone
//
//  Created by İbrahim Aktaş on 5.02.2024.
//

import UIKit
import Firebase
 

class SignUpController: UIViewController {
    
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
    
    lazy var fullNameContainerView: UIView = {
        let containerView = UIView().inputContainerView(image: "person", textField: fullNameTextField)
        containerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        return containerView
    }()
    
    lazy var accountTypeContainer: UIView = {
        let accountTypeContainer = UIView().inputContainerView(image: "person.fill", segmentControl: accountTypeSegmentControl)
        
        accountTypeContainer.snp.makeConstraints { make in
            make.height.equalTo(75)
        }
        return accountTypeContainer
    }()
    
    lazy var fullNameTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Full Name", isSecureTextEntry: false)
    }()
    
    lazy var emailTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Email", isSecureTextEntry: false)
    }()
    
    lazy var accountTypeSegmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["Rider", "Driver"])
        segmentControl.backgroundColor = .backgroundColor
        segmentControl.tintColor = UIColor(white: 1, alpha: 0.87)
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    lazy var passwordContainerView: UIView = {
        let containerView = UIView().inputContainerView(image: "lock", textField: passwordTextField)
        containerView.snp.makeConstraints { make in
            make.height.equalTo(50)
        }
        return containerView
    }()
    
    lazy var signupButton: AuthButton = {
        let button = AuthButton()
        button.setTitle("Sign Up", for: .normal)
        button.addTarget(self, action: #selector(handleSignupButton), for: .touchUpInside)
        return button
    }()
    
    lazy var haveAlreadyAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Do you have an account?  ",
                                                        attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16),
                                                                     NSAttributedString.Key.foregroundColor : UIColor.lightGray])
        attributedTitle.append(NSAttributedString(string: "Log In", attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16), NSAttributedString.Key.foregroundColor : UIColor.mainBlueTint]))
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    
    lazy var passwordTextField: UITextField = {
        return UITextField().textField(withPlaceholder: "Password", isSecureTextEntry: true)
    }()
    
    lazy var stackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [emailContainerView, fullNameContainerView, passwordContainerView, accountTypeContainer, signupButton])
        stack.axis = .vertical
        stack.spacing = 32
        stack.distribution = .fillEqually
        return stack
    }()
    
    
    
    //MARK: - Inits
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
    }
}

//MARK: - Setup View's
extension SignUpController {
    private func setupStackView() {
        view.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.equalTo(viewHeadline).inset(90)
            make.left.equalToSuperview().inset(16)
            make.right.equalToSuperview().inset(16)
        }
    }
    
    
    private func setupAlreadyHaveAccountButton() {
        view.addSubview(haveAlreadyAccountButton)
        haveAlreadyAccountButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.height.equalTo(32)
            make.centerX.equalToSuperview()
        }
    }
 }

//MARK: - Helpers
extension SignUpController {
    func configureView() {
        view.backgroundColor = UIColor.backgroundColor
        view.addSubview(viewHeadline)
        setupStackView()
        setupViewHeadline()
        setupAlreadyHaveAccountButton()
        configureNavigationBar()
    }
    
    func configureNavigationBar() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
}

//MARK: - Selectors
extension SignUpController {
    @objc func handleSignupButton() {
        guard let email = emailTextField.text else { return }
        guard let password = passwordTextField.text else { return }
        guard let fullName = fullNameTextField.text else { return }
        let accountTypeIndex = accountTypeSegmentControl.selectedSegmentIndex
        
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                print("Failed to register user with error \(error)")
                return
            }
            guard let uid = result?.user.uid else { return }
            
            let values = ["email": email,
                          "fullName": fullName,
                          "accountType": accountTypeIndex] as [String : Any]
            Firestore.firestore().collection("Users").document(uid).setData(values) { error in
                if let error = error {
                    print("Error occuring when user data's saved to db. \(error)")
                }
                self.dismiss(animated: true)
            }
        }
    }
    
    @objc func handleShowLogin() {
        let controller = LoginController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
}
