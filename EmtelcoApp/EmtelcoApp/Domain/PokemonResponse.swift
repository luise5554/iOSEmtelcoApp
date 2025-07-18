//
//  PokemonResponse.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import Foundation

struct PokemonResponse: Decodable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [PokemonResult]
}

struct PokemonResult: Decodable, Identifiable {
    let name: String
    let url: String
    
    var id: String { url }
    
    /// Obtiene el ID del Pokémon desde la URL
    var pokemonID: String {
        String(url.split(separator: "/").last(where: { !$0.isEmpty }) ?? "")
    }
    
    /// Construye la URL de la imagen oficial
    var imageURL: URL? {
        URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/\(pokemonID).png")
    }
}
