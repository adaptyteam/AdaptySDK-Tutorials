//
//  ContentView.swift
//  AdaptyPurchase
//
//  Created by Anton Kondrashov

import SwiftUI
import StoreKit

struct ContentView: View {
    @EnvironmentObject var store: Store
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("You have")) {
                    HStack {
                        Spacer()
                        ProductView(
                            icon: "❤️",
                            quantity: "0"
                        )
                        Spacer()
                        ProductView(
                            icon: "🥌",
                            quantity: "0"
                        )
                        Spacer()
                        ProductView(
                            icon: "📺",
                            quantity: "0"
                        )
                        Spacer()
                        ProductView(
                            icon: "⚽️",
                            quantity: "0"
                        )
                        Spacer()
                    }
                }
                
                Section(header: Text("To buy")) {
                }
                
                Button("Restore purchases") {
                }
                NavigationLink("Support", destination: SupportView())
                
            }
        }
    }
}
    
    struct ContentView_Previews: PreviewProvider {
        static var previews: some View {
            ContentView()
        }
    }
