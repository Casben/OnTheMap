//
//  LoginVC.swift
//  OnTheMap
//
//  Created by Herbert Dodge on 7/18/20.
//  Copyright © 2020 Herbert Dodge. All rights reserved.
//

import UIKit

protocol AuthenticationControllerProtocol {
    func checkFormStatus()
}

class LoginVC: UIViewController {
    
    //MARK: - Properties
    private var viewModel = LoginViewModel()
    let logoLabel = CustomLabel(fontSize: 40)
    private let emailTextField = CustomTextField(placholder: "Email")
    
    
    private let passwordTextField: CustomTextField = {
       let textField = CustomTextField(placholder: "Password")
        textField.isSecureTextEntry = true
        return textField
    }()
    
    private let loginButton: CustomButton = {
        let button = CustomButton(title: "Login")
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    
    let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedTitle = NSMutableAttributedString(string: "Don't have an account?  ", attributes: [.font: UIFont.systemFont(ofSize: 16), .foregroundColor: UIColor.white])
        attributedTitle.append(NSAttributedString(string: "Sign Up!", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        button.addTarget(self, action: #selector(handleShowSignUp), for: .touchUpInside)
        return button
    }()
    //MARK: - lifecycles

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Methods
    func setTextfieldObservers() {
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }
    
    func resetLoginVC() {
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    
    //MARK: - Helpers
    @objc func handleLogin() {
        NetworkAuthenticationManager.shared.authenticateUser(withEmail: emailTextField.text ?? "", password: passwordTextField.text ?? "") { (dataResponse, error) in
            
            if error != nil {
                self.presentCustomAlertOnMainThread(title: "Something went wrong..", message: "Invalid email or password or network error, please try again.", buttonTitle: "Ok")
            }
            guard let responseData = dataResponse else { return }
            
            DispatchQueue.main.async {
                let tabBarVC = TabBarVC()
                TabBarVC.studentKey = responseData.account.key
                self.present(tabBarVC, animated: true)
                self.resetLoginVC()
            }
            print(responseData)
            
        }
    }
    
    @objc func textDidChange(sender: UITextField) {
        if sender == emailTextField {
            viewModel.email = sender.text
        } else {
            viewModel.password = sender.text
        }
        checkFormStatus()
    }
    
    @objc func handleShowSignUp() {
        let app = UIApplication.shared
        app.openURL(URL(string: "https://auth.udacity.com/sign-up")!)
    }
    
    
    
    //MARK: - Configuration
    
    func configureUI() {
        configureGradientBackground()
        view.addSubviews(logoLabel, emailTextField, passwordTextField, loginButton, dontHaveAccountButton)
        let padding: CGFloat = 50
        let spacing: CGFloat = 24
        
        NSLayoutConstraint.activate([
            logoLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -275),
            logoLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: padding),
            logoLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -padding),
            logoLabel.heightAnchor.constraint(equalToConstant: padding),
            
            emailTextField.topAnchor.constraint(equalTo: logoLabel.bottomAnchor, constant: spacing),
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: spacing),
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: spacing),
            dontHaveAccountButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 10)
        ])
        
        configureUIElements(emailTextField, passwordTextField, loginButton, dontHaveAccountButton)
        setTextfieldObservers()
        logoLabel.text = "On the Map"
    }
    
    func configureGradientBackground() {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor.systemIndigo.cgColor, UIColor.systemTeal.cgColor]
        gradient.locations = [0, 1]
        view.layer.addSublayer(gradient)
        gradient.frame = view.frame
    }
    
}
extension LoginVC: AuthenticationControllerProtocol {
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = #colorLiteral(red: 0.9098039269, green: 0.4784313738, blue: 0.6431372762, alpha: 1)
        } else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = #colorLiteral(red: 0.5568627715, green: 0.3529411852, blue: 0.9686274529, alpha: 1).withAlphaComponent(0.5)
        }
    }
}


