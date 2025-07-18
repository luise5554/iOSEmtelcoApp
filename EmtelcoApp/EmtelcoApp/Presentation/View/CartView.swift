//
//  CartView.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import Foundation
import RealmSwift
import SwiftUI
import Kingfisher

struct CartView: View {
    @State private var cartItems: [ShoppingCartItem] = []
    @State private var total: Double = 0
    
    var body: some View {
        VStack {
            // 🛒 Lista de items
            List {
                ForEach(cartItems, id: \.id) { item in
                    HStack {
                        KFImage(URL(string: item.imageURL))
                            .resizable()
                            .frame(width: 50, height: 50)
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                        
                        VStack(alignment: .leading) {
                            Text(item.name.capitalized)
                            Text("Precio: \(Int(item.price)) COP")
                                .font(.caption)
                            Text("Cantidad: \(item.quantity)")
                                .font(.caption2)
                        }
                        Spacer()
                        Text("\(Int(item.price * Double(item.quantity))) COP")
                            .font(.subheadline)
                    }
                }
            }
            
            // ✅ Total en la parte inferior
            VStack {
                Divider()
                HStack {
                    Text("Total:")
                        .font(.headline)
                    Spacer()
                    Text("\(Int(total)) COP")
                        .font(.headline)
                }
                .padding()
            }
        }
        .navigationTitle("Carrito")
        .toolbar {
            // ❌ Botón para borrar todo
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    clearCart()
                }) {
                    Image(systemName: "trash")
                        .foregroundColor(.red)
                }
            }
        }
        .onAppear {
            loadCartItems()
        }
    }
    
    // ✅ Cargar items y calcular total
    func loadCartItems() {
        let realm = try! Realm()
        let items = realm.objects(ShoppingCartItem.self)
        cartItems = Array(items)
        
        total = cartItems.reduce(0) { sum, item in
            sum + (item.price * Double(item.quantity))
        }
    }
    
    // ❌ Eliminar todo el carrito
    func clearCart() {
        let realm = try! Realm()
        try! realm.write {
            let allItems = realm.objects(ShoppingCartItem.self)
            realm.delete(allItems)
        }
        loadCartItems()
    }
}
