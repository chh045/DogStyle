//
//  MyDogAPI.swift
//  MyDogStyle
//
//  Created by Huang Edison on 6/4/18.
//  Copyright © 2018 Huang Edison. All rights reserved.
//

import Foundation

class MyDogAPI {
    static let shared = MyDogAPI()
    private init() {}
    
    func listAllBreeds(completion: @escaping (_ breeds: [Breed])->()) {
        
        let endpoint = "https://dog.ceo/api/breeds/list/all"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            if error != nil {
                print("error calling GET on \(endpoint)", error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                let breeds = try Breed.parse(data: responseData)
                DispatchQueue.main.async { [completion] in
                    completion(breeds)
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    
    func getImageUrlByBreed(breed: String, completion: @escaping (_ urlStrings: [String])->()) {
        
        let endpoint = "https://dog.ceo/api/breed/\(breed)/images"
        
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            if error != nil {
                print("error calling GET on \(endpoint)", error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                let urlStrings = try Breed.getAllImagesUrl(data: responseData)
                DispatchQueue.main.async { [completion] in
                    completion(urlStrings)
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    
    func getRandomImageByBreed(breed: String, completion: @escaping (_ urlString: String)->()) {
        
        let endpoint = "https://dog.ceo/api/breed/\(breed)/images"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            if error != nil {
                print("error calling GET on \(endpoint)", error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                let urlStrings = try Breed.getAllImagesUrl(data: responseData)
                let index = Int(arc4random_uniform(UInt32(urlStrings.count)))
                DispatchQueue.main.async { [completion] in
                    completion(urlStrings[index])
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }
    
    
    func extractImageUrl(from breeds: [Breed], completion: @escaping ((_ urlStrings: [String])->())) {
        DispatchQueue.global().async { [unowned self] in
            let imageGroup = DispatchGroup()
            var images = [String]()
            for breed in breeds {
                imageGroup.enter()
                self.getImageUrlByBreed(breed: breed.name) { (urls) in
                    images += urls
                    imageGroup.leave()
                }
            }
            imageGroup.notify(queue: .main) {
                completion(images)
            }
        }
    }
    
    func getAllDogs(completion: @escaping ((_ dogs: [Dog])->())) {
        let endpoint = "https://dog.ceo/api/breeds/list/all"
        guard let url = URL(string: endpoint) else {
            print("Error: cannot create URL")
            return
        }
        let urlRequest = URLRequest(url: url)
        let config = URLSessionConfiguration.default
        let session = URLSession(configuration: config)
        let task = session.dataTask(with: urlRequest) {
            (data, response, error) in
            if error != nil {
                print("error calling GET on \(endpoint)", error!)
                return
            }
            guard let responseData = data else {
                print("Error: did not receive data")
                return
            }
            do {
                let breeds = try Breed.parse(data: responseData)
                let imageGroup = DispatchGroup()
                var dogs = [Dog]()
                for breed in breeds {
                    imageGroup.enter()
                    self.getImageUrlByBreed(breed: breed.name) { (urls) in
                        dogs += urls.map{Dog(breed: breed.name, imageUrl: $0)}
                        imageGroup.leave()
                    }
                }
                imageGroup.notify(queue: .main) {
                    completion(dogs)
                }
            } catch  {
                print("error trying to convert data to JSON")
                return
            }
        }
        task.resume()
    }

}
