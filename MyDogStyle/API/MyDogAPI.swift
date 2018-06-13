//
//  MyDogAPI.swift
//  MyDogStyle
//
//  Created by Huang Edison on 6/4/18.
//  Copyright © 2018 Huang Edison. All rights reserved.
//

import Foundation
import Alamofire

class MyDogAPI {
    static let shared = MyDogAPI()
    private init() {}
    
    func listAllBreeds(completion: @escaping (_ breeds: [Breed])->()) {
        
        let endpoint = "https://dog.ceo/api/breeds/list/all"
        Alamofire.request(endpoint).responseJSON { response in
            guard response.result.isSuccess,
                let responseData = response.data else {
                    print("error fetching data: \(String(describing: response.result.error))")
                    return
            }
            do {
                let breeds = try Breed.parse(data: responseData)
                DispatchQueue.main.async { [completion] in
                    completion(breeds)
                }
            } catch {
                print("error trying to convert data to JSON")
                return
            }
        }
    }
    
    
    func getImageUrlByBreed(breed: String, completion: @escaping (_ urlStrings: [String])->()) {
        
        let endpoint = "https://dog.ceo/api/breed/\(breed)/images"
        Alamofire.request(endpoint).responseJSON { response in
            guard response.result.isSuccess,
                let responseData = response.data else {
                    print("error fetching data: \(String(describing: response.result.error))")
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
    }
    
    
    func getRandomImageByBreed(breed: String, completion: @escaping (_ urlString: String)->()) {
        
        let endpoint = "https://dog.ceo/api/breed/\(breed)/images"
        Alamofire.request(endpoint).responseJSON { response in
            guard response.result.isSuccess,
                let responseData = response.data else {
                    print("error fetch data: \(String(describing: response.result.error))")
                    return
            }
            do {
                let urlStrings = try Breed.getAllImagesUrl(data: responseData)
                let index = Int(arc4random_uniform(UInt32(urlStrings.count)))
                DispatchQueue.main.async { [completion] in
                    completion(urlStrings[index])
                }
            } catch {
                print("error trying to convert data to JSON")
                return
            }
        }
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
        Alamofire.request(endpoint).responseJSON { response in
            guard response.result.isSuccess,
                let responseData = response.data else {
                    print("error fetching data: \(String(describing: response.result.error))")
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
            } catch {
                print("error trying to convert data to JSON")
                return
            }
        }
    }
}
