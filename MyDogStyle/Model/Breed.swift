//
//  Breed.swift
//  MyDogStyle
//
//  Created by Huang Edison on 6/10/18.
//  Copyright © 2018 Huang Edison. All rights reserved.
//

import Foundation

private struct BreedResponse: Decodable {
    let status: String
    let message: [String: [String]]
}

private struct ImageResponse: Decodable {
    let status: String
    let message: [String]
}

struct Breed: Decodable {
    let name: String
    
    static func parse(data: Data) throws -> [Breed] {
        let response = try JSONDecoder().decode(BreedResponse.self, from: data)
        var breeds = [Breed]()
        for (breed, subbreeds) in response.message {
            if subbreeds.count == 0 {
                breeds.append(Breed(name: breed))
            }
            else {
                for subbreed in subbreeds {
                    breeds.append(Breed(name: breed + "-" + subbreed))
                }
            }
        }
        return breeds
    }
    
    static func getAllImagesUrl(data: Data) throws -> [String] {
        let response = try JSONDecoder().decode(ImageResponse.self, from: data)
        return response.message
    }
}
