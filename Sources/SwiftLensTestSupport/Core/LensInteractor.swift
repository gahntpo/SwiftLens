//
//  LensInteractor.swift
//
//  Created by Karin Prater on 28/04/2025.
//

import Foundation
import Combine

public class LensInteractor {
    
    let notificationCenter: NotificationCenter

    public init(notificationCenter: NotificationCenter) {
        self.notificationCenter = notificationCenter
    }
    
    public func toggle(withID id: String, to value: Bool) {
        notificationCenter.post(name: .simulateToggleChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "value": value])
    }

    public func tapButton(withID id: String) {
        notificationCenter.post(name: .simulateButtonTap,
                                object: nil,
                                userInfo: ["id": id])
    }
    
    public func picker(withID id: String, to value: AnyHashable) {
        notificationCenter.post(name: .simulatePickerChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "value": value])
    }
    
    public func slider(withID id: String, to value: AnyHashable) {
        notificationCenter.post(name: .simulateSliderChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "value": value])
    }
    
    public func stepper(withID id: String, to value: AnyHashable) {
        notificationCenter.post(name: .simulateStepperChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "value": value])
    }
    
    public func textField(withID id: String, to value: String) {
        notificationCenter.post(name: .simulateTextFieldChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "value": value])
    }
    
    public func textFieldMakeFocus(withID id: String) {
        notificationCenter.post(name: .simulateTextFieldFocusChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "focused": true])
    }
    
    public func textFieldNotFocus(withID id: String) {
        notificationCenter.post(name: .simulateTextFieldFocusChange,
                                object: nil,
                                userInfo: ["id": id,
                                           "focused": false])
    }
}
