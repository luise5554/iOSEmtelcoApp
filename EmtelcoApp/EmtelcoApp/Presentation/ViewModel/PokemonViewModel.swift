//
//  PokemonViewModel.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import Combine
import SwiftUI
import RealmSwift
import LocalAuthentication
import Factory

class PokemonViewModel: ObservableObject {
    @Injected(\.pokemonService) private var service
    @Published var pokemons: [PokemonResult] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var cancellables = Set<AnyCancellable>()
    
    private var nextURL: String? = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0"
    
    func loadPokemons(initial: Bool = false) {
        guard let url = nextURL else { return } // No hay más páginas
        
        isLoading = true
        errorMessage = nil
        
        service.fetchPokemonList(from: url)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case let .failure(error) = completion {
                    self?.errorMessage = error.localizedDescription
                }
            } receiveValue: { [weak self] response in
                if initial {
                    self?.pokemons = response.results
                } else {
                    self?.pokemons.append(contentsOf: response.results)
                }
                self?.nextURL = response.next // Guardar la URL de la siguiente página
                
                // ✅ Guardar en cache offline
                self?.savePokemonsToCache(response.results)
            }
            .store(in: &cancellables)
    }
    
    func loadMorePokemonsIfNeeded(currentItem: PokemonResult) {
        guard let last = pokemons.last else { return }
        if currentItem.id == last.id && !isLoading {
            loadPokemons()
        }
    }
    
    func savePokemonsToCache(_ pokemons: [PokemonResult]) {
        let realm = try! Realm()
        try! realm.write {
            for pokemon in pokemons {
                if let url = pokemon.imageURL?.absoluteString {
                    let cache = PokemonCache(name: pokemon.name, imageURL: url)
                    realm.add(cache, update: .modified) // evita duplicados
                }
            }
        }
    }
    
    func loadCachedPokemons() {
        let realm = try! Realm()
        let cachedPokemons = realm.objects(PokemonCache.self)
        
        self.pokemons = cachedPokemons.map {
            PokemonResult(name: $0.name, url: $0.imageURL)
        }
    }
    
    func addToCart(_ pokemon: PokemonResult) {
        guard let urlString = pokemon.imageURL?.absoluteString else { return }
        
        let realm = try! Realm()
        
        // Generar precio aleatorio entre 10.000 y 100.000
        let randomPrice = Double(Int.random(in: 10_000...100_000))
        
        try! realm.write {
            // Si ya existe, solo aumenta la cantidad
            if let existingItem = realm.object(ofType: ShoppingCartItem.self, forPrimaryKey: pokemon.name) {
                existingItem.quantity += 1
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
    
    func authenticateUser(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // 1️⃣ Intentar biometría pura primero
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Autentícate con Face ID o Touch ID para acceder al carrito"
            
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    if success {
                        completion(true) // ✅ Face ID / Touch ID OK
                    } else {
                        // 2️⃣ Si biometría falla, intentar PIN como fallback
                        self.authenticateWithPIN(completion: completion)
                    }
                }
            }
        } else {
            // 2️⃣ Si no hay biometría disponible, ir directo a PIN
            authenticateWithPIN(completion: completion)
        }
    }

    private func authenticateWithPIN(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Confirma tu identidad para acceder al carrito"
            
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authError in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            // No hay PIN configurado
            completion(false)
        }
    }
    
}
