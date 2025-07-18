//
//  PokemonService.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import Foundation
import Alamofire
import Combine
import Factory

protocol PokemonServiceProtocol {
    func fetchPokemonList(from url: String) -> AnyPublisher<PokemonResponse, AFError>
}

class PokemonService: PokemonServiceProtocol {
    func fetchPokemonList(from url: String) -> AnyPublisher<PokemonResponse, AFError> {
        return AF.request(url)
            .publishDecodable(type: PokemonResponse.self)
            .value()
            .eraseToAnyPublisher()
    }
}

extension Container {
    var pokemonService: Factory<PokemonServiceProtocol> {
        self { PokemonService() }
            .singleton
    }
}
