//
//  HapticsManager.swift
//  TIKTOK CLONE
//
//  Created by Ankit Singh on 30/10/21.
//

import Foundation
import UIKit


final class HapticsManager {
    static let shared = HapticsManager()
    
    
    private init() {
        
    }
    
    public func vibrateForSelection(){
    
        
      DispatchQueue.main.async {
          let generator = UISelectionFeedbackGenerator()
          generator.prepare()
          generator.selectionChanged()
        }
    }
    
    
    public func vibrate(for type: UINotificationFeedbackGenerator.FeedbackType){
    
        
      DispatchQueue.main.async {
          let generator = UINotificationFeedbackGenerator()
          generator.prepare()
          generator.notificationOccurred(type)
        }
    }
    
    
}
