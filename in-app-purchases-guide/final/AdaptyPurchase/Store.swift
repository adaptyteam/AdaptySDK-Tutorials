//
//  Store.swift
//  AdaptyPurchase
//
//  Created by kondranton (Anton Kondrashov)

import StoreKit

class Store: ObservableObject {
    private var productIDs = ["stone", "heart", "tournament", "membership.pro", "membership.elite"]
    
    @Published var products = [Product]()
    
    @Published var purchasedNonConsumables = Set<Product>()
    @Published var purchasedNonRenewables = Set<Product>()
    
    @Published var purchasedConsumables = [Product]()
    @Published var purchasedSubscriptions = Set<Product>()
    
    @Published var entitlements = [Transaction]()
    
    var transacitonListener: Task<Void, Error>?
    
    var tournamentEndDate: Date = {
        var components = DateComponents()
        components.year = 2033
        components.month = 2
        components.day = 1
        return Calendar.current.date(from: components)!
    }()
    
    init() {
        transacitonListener = listenForTransactions()
        
        Task {
            await requestProducts()
            // Must be called after the products are already fetched
            await updateCurrentEntitlements()
        }
    }
    
    @MainActor
    func requestProducts() async {
        do {
            products = try await Product.products(for: productIDs)
        } catch {
            print(error)
        }
    }
    
    @MainActor
    func purchase(_ product: Product) async throws {
        let result = try await product.purchase()
        
        switch result {
        case .success(let transacitonVerification):
            await handle(transactionVerification: transacitonVerification)
        default:
            return
        }
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached {
            for await result in Transaction.updates {
                await self.handle(transactionVerification: result)
            }
        }
    }
    
    @MainActor
    @discardableResult
    private func handle(transactionVerification result: VerificationResult<Transaction>) async -> Transaction? {
        switch result {
        case let .verified(transaction):
            guard let product = self.products.first(where: { $0.id == transaction.productID}) else { return transaction }
            
            guard !transaction.isUpgraded else { return nil }
            
            self.addPurchased(product)
            
            await transaction.finish()
            
            return transaction
        default:
            return nil
        }
    }
    
    @MainActor
    private func updateCurrentEntitlements() async {
        for await result in Transaction.currentEntitlements {
            if let transaction = await self.handle(transactionVerification: result) {
                entitlements.append(transaction)
            }
        }
    }
    
    private func addPurchased(_ product: Product) {
        switch product.type {
        case .consumable:
            purchasedConsumables.append(product)
            Persistence.increaseConsumablesCount()
        case .nonConsumable:
            purchasedNonConsumables.insert(product)
        case .nonRenewable:
            if Date() <= tournamentEndDate {
                purchasedNonRenewables.insert(product)
            }
        case .autoRenewable:
            purchasedSubscriptions.insert(product)
        default:
            return
        }
    }
}
