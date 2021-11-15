//
//  AuthButton.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 14/11/21.
//

import UIKit

class AuthButton: UIButton {

    private let type : ButtonType
    enum ButtonType {
        case signIn
        case signUp
        case plain
        
        var title : String {
            switch self {
            case .signIn:
                return "Sign In"
            case .signUp:
                return "Sign Up"
            case .plain:
                return "-"
            }
        }
    }
    
    init(type:ButtonType , title:String?){
        self.type = type
        super.init(frame: .zero)
        configureUI()
        if let title = title {
            setTitle(title, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureUI(){
        if type != .plain {
            setTitle(type.title, for: .normal)
        }
        setTitleColor(.white, for: .normal)
        switch type {
        case .signIn:
            backgroundColor = .systemBlue
        case .signUp:
            backgroundColor = .systemGreen
        case .plain:
            setTitleColor(.link, for: .normal)
            backgroundColor = .clear
        }
        titleLabel?.font = .systemFont(ofSize: 18,weight : .semibold)
        layer.cornerRadius = 8
        layer.masksToBounds = true
    }
}
