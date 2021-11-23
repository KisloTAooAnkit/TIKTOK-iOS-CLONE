//
//  SignUpViewController.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//
import SafariServices
import UIKit

class SignUpViewController: UIViewController , UITextFieldDelegate{
    
    private let logoImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "logo")
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        return imageView
    }()
    
    private let usernameField = AuthField(type: .username)
    private let emailField = AuthField(type: .email)
    private let passwordField = AuthField(type: .password)
    
    private let signUpButton = AuthButton(type: .signUp,title:nil)
    private let termsButton = AuthButton(type: .plain,title:"Terms of Service")
    
    
    public var completion : (()->Void)?
    
    //MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubviews()
        configureButtons()
        configureFields()
        
        // Do any additional setup after loading the view.
        view.backgroundColor = .systemBackground
        title = "Create Account"
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        usernameField.becomeFirstResponder()
    }
    
    private func configureFields(){
        emailField.delegate = self
        passwordField.delegate = self
        usernameField.delegate = self
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.width, height: 50))
        toolBar.items = [
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil),
            UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(didTapKeyboardDone))
        ]
        toolBar.sizeToFit()
        emailField.inputAccessoryView = toolBar
        passwordField.inputAccessoryView = toolBar
        usernameField.inputAccessoryView = toolBar
        
    }
    
    @objc func didTapKeyboardDone(){
        usernameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
    }
    
    private func addSubviews() {
        view.addSubview(logoImageView)
        view.addSubview(emailField)
        view.addSubview(passwordField)
        view.addSubview(signUpButton)
        view.addSubview(termsButton)
        view.addSubview(usernameField)
    }
    
    private func configureButtons(){
        signUpButton.addTarget(self, action: #selector(didTapSignUp), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(didTapTerms), for: .touchUpInside)
        
    }
    
    
    private func layoutUI(){
        let imageSize :CGFloat = 100
        logoImageView.frame = CGRect(x: (view.width - imageSize)/2, y: view.safeAreaInsets.top + 5, width: imageSize, height: imageSize)
        
        usernameField.frame = CGRect(x: 20, y: logoImageView.bottom + 20, width: view.width - 40, height: 50)
        emailField.frame = CGRect(x: 20, y: usernameField.bottom + 15, width: view.width - 40, height: 50)
        passwordField.frame = CGRect(x: 20, y: emailField.bottom + 15, width: view.width - 40, height: 50)
        
        
        signUpButton.frame = CGRect(x: 20, y: passwordField.bottom + 20, width: view.width - 40, height: 55)
        termsButton.frame = CGRect(x: 20, y: signUpButton.bottom + 40, width: view.width - 40, height: 55)
        
        
        
    }
    
    
    //MARK: - Button Actions
    
    @objc func didTapTerms(){
        didTapKeyboardDone()
        guard let url = URL(string: "https://www.tiktok.com/terms") else {
            return
        }
        
        let vc = SFSafariViewController(url: url)
        present(vc, animated: true, completion: nil)
    }
    
    
    @objc func didTapSignUp() {
        didTapKeyboardDone()
        guard let username = usernameField.text ,
              let email = emailField.text ,
              let password = passwordField.text ,
              !username.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty,
              password.count >= 6
        else {
            let alert = UIAlertController(
                title: "Woops",
                message: "Please make sure to enter a valid username,email and password. Your password must be atleast 6 characters long",
                preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            present(alert,animated: true, completion: nil)
            return
        }
        
        AuthManager.shared.signUp(with: username, emailAddress: email, password: password) { [weak self] status in
            if status {
                print("signed up")
                self?.dismiss(animated: true, completion: nil)
            }
            else {
                DispatchQueue.main.async {
                    let alert = UIAlertController(
                        title: "SignUp failed",
                        message: "Something went wrong when trying to register",
                        preferredStyle: .alert)
                    
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
                    self?.present(alert,animated: true, completion: nil)
                }

            }
        }
        
    }
    
    @objc func didTapForgotPassword() {
        didTapKeyboardDone()
        
    }
    
}
