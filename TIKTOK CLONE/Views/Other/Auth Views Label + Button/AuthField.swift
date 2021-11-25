//
//  AuthField.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 14/11/21.
//

import UIKit

class AuthField: UITextField {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    enum TextFieldType {
        case email
        case password
        case username
        
        var title : String {
            switch self {
            case .email:
                return "Email Address"
            case .password:
                return "Password"
            case .username:
                return "Username"
            }
        }
    }
    
    private let type : TextFieldType
    
    init(type : TextFieldType){
        self.type = type
        super.init(frame: .zero)
        configureUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        autocapitalizationType = .none
        if self.type == .password {
            isSecureTextEntry = true
        }
        if type == .email {
            keyboardType = .emailAddress
            textContentType = .emailAddress
        }
        backgroundColor = .secondarySystemBackground
        layer.cornerRadius = 8
        layer.masksToBounds = true
        placeholder = type.title
        leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: height)) //text field ke baju mein jo icon aata hai woh wale space mein ek empty view rkh rhe hai 
        leftViewMode = .always
        returnKeyType = .done

        autocorrectionType = .no
        
    }
    
    
}
