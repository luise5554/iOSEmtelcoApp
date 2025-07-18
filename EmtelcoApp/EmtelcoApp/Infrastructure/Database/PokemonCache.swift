//
//  PokemonCache.swift
//  EmtelcoApp
//
//  Created by Luis on 18/07/25.
//

import RealmSwift

class PokemonCache: Object {
    @Persisted(primaryKey: true) var id: String      // Usamos el nombre como ID único
    @Persisted var name: String
    @Persisted var imageURL: String
    
    convenience init(name: String, imageURL: String) {
        self.init()
        self.id = name
        self.name = name
        self.imageURL = imageURL
    }
}
