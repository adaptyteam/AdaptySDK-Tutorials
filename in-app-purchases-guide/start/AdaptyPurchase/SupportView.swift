//
//  SupportView.swift
//  AdaptyPurchase
//
//  Created by kondranton (Anton Kondrashov)

import SwiftUI
import StoreKit

struct SupportView: View {
    var body: some View {
        Form {
            Button("Subscription management") {
            }
            Button("Redeem code") {
            }
            NavigationLink("Request a refund") {
            }
        }
    }
}

struct SupportView_Previews: PreviewProvider {
    static var previews: some View {
        SupportView()
    }
}
