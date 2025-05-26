//
//  SwiftUIView.swift
//  SwiftLens
//
//  Created by Karin Prater on 23/05/2025.
//

import SwiftUI

struct DemoAlertView: View {
    
    @State private var count = 3
    @State private var showingAlert = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Count: \(count)")
                .lensTracked(id: "countLabel", info: ["value" : count])

            Button("Reset") {
                showingAlert = true
            }
            .lensButton(id: "resetButton")

        }
        .lensGroup(id: "content.counter")
        .lensAlert(
            id: "alert.content",
            title: "Reset Counter?",
            isPresented: $showingAlert,
            actions: {
                Button("Cancel", role: .cancel) {
                }
                .lensButton(id: "alert.button.cancel")
                Button("Clear", role: .destructive) {
                    count = 0
                }
                .lensButton(id: "alert.button.clear")
            },
            message: {
                Text("Are you sure you want to reset the count to zero?")
            }
        )
    }
}

//MARK: - Alert with presenting data

struct SaveDetails: Identifiable {
    let name: String
    let error: String
    let id = UUID()
}

struct SaveButton: View {
    
    @State private var alertIsShown = false
    @State private var details: SaveDetails?

    var body: some View {
        VStack {
            Button("Save") {
                alertIsShown = true
                details = SaveDetails(name: "File name XYZ",
                                      error: "corrupted file")
            }
            .lensButton(id: "button.show.alert")
        }
        .lensAlert(id: "alert.content",
                   title: "Save failed.",
                   isPresented: $alertIsShown,
                   presenting: details,
                   actions: { details in

            Button(role: .destructive) {
                // Handle the deletion.
            } label: {
                Text("Delete \(details.name)")
            }
            .lensButton(id: "alert.button.delete")
            
            Button("Retry") {
                // Handle the retry action.
            }
            .lensButton(id: "alert.button.retry")
            
        }, message: { details in
            Text(details.error)
        })
    }
}

//MARK: - Alert with Error

enum TicketPurchaseError: Error, LocalizedError {
    case invalidPaymentMethod
    case insufficientFunds
    case serviceUnavailable
    
    var errorDescription: String? {
        switch self {
            case .invalidPaymentMethod:
                "You don´t have a valid payment method"
            case .insufficientFunds:
                "Not enough funds"
            case .serviceUnavailable:
                "Service unavailable"
        }
    }
    
    var recoverySuggestion: String? {
        switch self {
            case .invalidPaymentMethod:
                "Please add a valid payment method."
            case .insufficientFunds:
                "Add more funds to your account."
            case .serviceUnavailable:
                "Please try again later."
        }
    }
}

struct DemoAlertErrorView: View {
    
    @State private var error: TicketPurchaseError? = nil
    @State private var showAlert = false

    var body: some View {
        Form {
            Button("go") {
                self.error = .insufficientFunds
                showAlert.toggle()
            }
            .lensButton(id: "button.show.alert")
        }
        .lensAlert(id: "alert", isPresented: $showAlert, error: error, actions: { _ in
            Button("OK") {
                // Handle acknowledgement.
            }
            .lensButton(id: "alert.button.okey")
        }, message: { error in
            Text(error.recoverySuggestion ?? "Try again later.")
        })
        /*.alert(isPresented: $showAlert, error: error) { _ in
            Button("OK") {
                // Handle acknowledgement.
            }
        } message: { error in
            Text(error.recoverySuggestion ?? "Try again later.")
        }
         */
    }
}
