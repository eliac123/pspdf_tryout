//
//  ObjectiveCViewControllerWrapper.swift
//  dev
//
//  Created by Elie Abi Char on 25/03/2025.
//

import SwiftUI

struct ObjectiveCViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return EditPdfPanelViewController() // Calls the Objective-C ViewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
