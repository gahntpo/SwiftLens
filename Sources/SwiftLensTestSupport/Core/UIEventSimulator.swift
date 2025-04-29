//
//  UIEventSimulator.swift
//  UserInteractionSimulationProject
//
//  Created by Karin Prater on 28/04/2025.
//

import Foundation
import Combine

class UIEventSimulator {
    
    let notificationCenter: NotificationCenter

    init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    func toggle(withID id: String, to value: Bool) {
        notificationCenter.post(name: .simulateToggleChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "value": value])
    }

    func buttonTap(withID id: String) {
        notificationCenter.post(name: .simulateButtonTap,
                                object: nil,
                                userInfo: ["id": id])
    }
    
    func picker(withID id: String, to value: AnyHashable) {
        notificationCenter.post(name: .simulatePickerChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "value": value])
    }
    
    func slider(withID id: String, to value: AnyHashable) {
        notificationCenter.post(name: .simulateSliderChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "value": value])
    }
    
    func stepper(withID id: String, to value: AnyHashable) {
        notificationCenter.post(name: .simulateStepperChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "value": value])
    }
    
    func textField(withID id: String, to value: String) {
        notificationCenter.post(name: .simulateTextFieldChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "value": value])
    }
    
    func textFieldMakeFocus(withID id: String) {
        notificationCenter.post(name: .simulateTextFieldFocusChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "focused": true])
    }
    
    func textFieldNotFocus(withID id: String) {
        notificationCenter.post(name: .simulateTextFieldFocusChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "focused": false])
    }
}
