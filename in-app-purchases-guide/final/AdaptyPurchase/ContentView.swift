//
//  ContentView.swift
//  AdaptyPurchase
//
//  Created by kondranton (Anton Kondrashov)

import SwiftUI
import StoreKit

struct ContentView: View {
    @EnvironmentObject var store: Store
    @AppStorage(Persistence.consumablesCountKey) var consumableCount: Int = 0
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("You have")) {
                    HStack {
                        Spacer()
                        ProductView(
                            icon: "❤️",
                            quantity: "\(consumableCount)"
                        )
                        Spacer()
                        ProductView(
                            icon: "🥌",
                            quantity: "\(store.purchasedNonConsumables.count)"
                        )
                        Spacer()
                        ProductView(
                            icon: "📺",
                            quantity: "\(store.purchasedNonRenewables.count)"
                        )
                        Spacer()
                        ProductView(
                            icon: "⚽️",
                            quantity: "\(store.purchasedSubscriptions.count)"
                        )
                        Spacer()
                    }
                }
                
                Section(header: Text("To buy")) {
                    ForEach(store.products) { product in
                        HStack {
                            Text(product.displayName)
                            Spacer()
                            Button("\(product.displayPrice)") {
                                Task {
                                    try await store.purchase(product)
                                }
                            }
                        }
                    }
                }
                
                Button("Restore purchases") {
                    Task {
                        try await AppStore.sync()
                    }
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
