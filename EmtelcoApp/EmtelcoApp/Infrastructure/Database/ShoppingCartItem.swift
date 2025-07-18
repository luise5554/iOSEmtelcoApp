//
//  ShoppingCartItem.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import RealmSwift

class ShoppingCartItem: Object {
    @Persisted(primaryKey: true) var id: String    // Usamos el nombre del Pokémon como clave única
    @Persisted var name: String
    @Persisted var imageURL: String
    @Persisted var price: Double
    @Persisted var quantity: Int
    
    convenience init(name: String, imageURL: String, price: Double, quantity: Int = 1) {
        self.init()
        self.id = name
        self.name = name
        self.imageURL = imageURL
        self.price = price
        self.quantity = quantity
    }
}
