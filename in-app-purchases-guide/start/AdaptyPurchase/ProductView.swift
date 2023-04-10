//
//  ProductView.swift
//  AdaptyPurchase
//
//  Created by kondranton (Anton Kondrashov)

import SwiftUI

struct ProductView: View {
    var icon: String
    var quantity: String
    
    var body: some View {
        VStack {
            Text(icon)
            Text(quantity)
        }
        .padding()
    }
}
