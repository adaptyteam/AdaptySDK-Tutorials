//
//  AdaptyPurchaseApp.swift
//  AdaptyPurchase
//
//  Created by kondranton (Anton Kondrashov)

import SwiftUI

@main
struct AdaptyPurchaseApp: App {
    @StateObject var store = Store()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
