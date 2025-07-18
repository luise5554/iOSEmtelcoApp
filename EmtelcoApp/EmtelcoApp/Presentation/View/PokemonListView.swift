//
//  PokemonListView.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import SwiftUI
import Kingfisher

struct PokemonListView: View {
    
    @StateObject private var viewModel = PokemonViewModel()
    @StateObject private var cartManager = CartManager()
    @State private var showCart = false
    @State private var showAuthError = false
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(viewModel.pokemons) { pokemon in
                    HStack {
                        if let url = pokemon.imageURL {
                            KFImage(url)
                                .resizable()
                                .placeholder {
                                    ProgressView()
                                }
                                .cacheMemoryOnly(false)
                                .fade(duration: 0.25)
                                .frame(width: 50, height: 50)
                        }
                        
                        VStack(alignment: .leading) {
                            Text(pokemon.name.capitalized)
                                .font(.headline)
                            
                            Button(action: {
                                viewModel.addToCart(pokemon)
                            }) {
                                Text("Añadir al carrito")
                                    .font(.caption)
                                    .padding(6)
                                    .background(Color.blue.opacity(0.2))
                                    .cornerRadius(8)
                            }
                        }
                                    
                        Spacer()
                    }
                    // Cuando llegamos al final, cargamos más
                    .onAppear {
                        viewModel.loadMorePokemonsIfNeeded(currentItem: pokemon)
                    }
                }
                
                // Si está cargando más, mostramos un indicador
                if viewModel.isLoading {
                    HStack {
                        Spacer()
                        ProgressView("Cargando más…")
                        Spacer()
                    }
                }
            }
            .navigationTitle("Lista Pokemon")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        viewModel.authenticateUser { success in
                            if success {
                                showCart = true
                            } else {
                                showAuthError = true
                            }
                        }
                    } label: {
                        CartButtonView(count: cartManager.cartCount)
                    }
                }
            }
            .onAppear {
                if viewModel.pokemons.isEmpty {
                    viewModel.loadCachedPokemons()
                    viewModel.loadPokemons(initial: true)
                }
            }.navigationDestination(isPresented: $showCart) {
                CartView()
            }
            .alert("Autenticación fallida", isPresented: $showAuthError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("No se pudo autenticar con biometría")
            }
        }
    }
}
