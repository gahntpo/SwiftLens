//
//  Notification+Name.swift
//  UserInteractionSimulationProject
//
//  Created by Karin Prater on 23/04/2025.
//

import Foundation
import SwiftUI

extension EnvironmentValues {
    @Entry public var notificationCenter: NotificationCenter = .default
}

extension Notification.Name {
    
    static public let buttonWasTapped = Notification.Name("buttonWasTapped")
    static public let simulateButtonTap = Notification.Name("simulateButtonTap")
    
    static public let toggleWasChanged = Notification.Name("toggleWasChanged")
    static public let simulateToggleChange = Notification.Name("simulateToggleChange")
    
    static public let sliderWasChanged = Notification.Name("sliderWasChanged")
    static public let simulateSliderChange = Notification.Name("simulateSliderChange")
    
    static public let stepperWasChanged = Notification.Name("stepperWasChanged")
    static public let simulateStepperChange = Notification.Name("simulateStepperChange")
    
    static public let pickerWasChanged = Notification.Name("pickerWasChanged")
    static public let simulatePickerChange = Notification.Name("simulatePickerChange")
    
    static public let textFieldWasChanged = Notification.Name("textFieldWasChanged")
    static public let simulateTextFieldChange = Notification.Name("simulateTextFieldChange")
    
    static public let textFieldFocusChanged = Notification.Name("textFieldFocusChanged")
    static public let simulateTextFieldFocusChange = Notification.Name("simulateTextFieldFocusChange")
    static public let textFieldCommitChanged = Notification.Name("textFieldCommitChanged")
}
