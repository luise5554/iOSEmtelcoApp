//
//  CartManager.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import Foundation

import RealmSwift

class CartManager: ObservableObject {
    @Published var cartCount: Int = 0
    
    private var notificationToken: NotificationToken?
    private let realm = try! Realm()
    
    init() {
        observeCart()
    }
    
    private func observeCart() {
        let results = realm.objects(ShoppingCartItem.self)
        cartCount = results.reduce(0) { $0 + $1.quantity }
        
        // Observa cambios en tiempo real
        notificationToken = results.observe { [weak self] _ in
            self?.cartCount = results.reduce(0) { $0 + $1.quantity }
        }
    }
    
    deinit {
        notificationToken?.invalidate()
    }
    
    func addToCart(_ pokemon: PokemonResult) {
        guard let urlString = pokemon.imageURL?.absoluteString else { return }
        
        let randomPrice = Double(Int.random(in: 10_000...100_000))
        
        try! realm.write {
            if let existing = realm.object(ofType: ShoppingCartItem.self, forPrimaryKey: pokemon.name) {
                existing.quantity += 1
            } else {
                let newItem = ShoppingCartItem(
                    name: pokemon.name,
                    imageURL: urlString,
                    price: randomPrice,
                    quantity: 1
                )
                realm.add(newItem)
            }
        }
    }
}
