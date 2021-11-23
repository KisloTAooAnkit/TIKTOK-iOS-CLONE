//
//  RecordButton.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 22/11/21.
//

import UIKit

class RecordButton: UIButton {

    enum ToggleState {
        case recording
        case notRecording
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        layer.masksToBounds = true
        layer.borderColor = UIColor.white.cgColor
        layer.borderWidth = 2.5
    }

    required init?(coder: NSCoder) {
        fatalError()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = height/2
    }
    
    
    public func toggle(for state : ToggleState){
        switch state {
        case .recording:
            backgroundColor = .systemRed
        case .notRecording:
            backgroundColor = .clear
        }
    }
}
