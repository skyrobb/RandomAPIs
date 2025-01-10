//
//  Network.swift
//  APIs
//
//  Created by Mike Collier on 12/3/24.
//

import Foundation
import UIKit

//This is an error enum designed to communicate errors that occured during the execution of functions below
enum NetworkError: LocalizedError {
    case imageDataMissing
    case representativeDataMissing
}

//This Codable struct has property names that match the keys in the JSON returned from the dog.ceo API call below.  It is used as a template for the JSON decoder to map the instance of Data to a usable instance of DogPhotoResponse (line 31)
struct DogPhotoResponse: Codable {
    let message: String
    let status: String
}

struct Representative: Codable {
    let name: String
    let party: String
    let state: String
    let link: String
}

struct RepresentativeResponse: Codable {
    let results: [Representative]
}

struct Network {
    static func fetchDogPhoto() async throws -> UIImage {
        //This creates a URL from the URL string you want to call
        let url = URL(string: "https://dog.ceo/api/breeds/image/random")!
        
        //This calls the URL above and gets an instance of type Data back
        let (data, response) = try await URLSession.shared.data(from: url)
        
        //This uses a JSONDecoder to get an instance from the fetched Data
        let photoResponse = try JSONDecoder().decode(DogPhotoResponse.self, from: data)
        
        //This is a very simple validation / error handling to make sure the call was successful
        guard photoResponse.status == "success", let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.imageDataMissing
        }
        
        //This calls the fetchImage function below to get an UIImage from the URL
        return try await Network.fetchImage(from: URL(string: photoResponse.message)!)
    }

    static func fetchImage(from url: URL) async throws -> UIImage {
        //This calls the URL above and gets an instance of type Data back
        let (data, response) = try await URLSession.shared.data(from: url)
        
        //This is a very simple validation / error handling to make sure the call was successful
        //This also creates the UIImage object from the data returned from the URL
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200, let image = UIImage(data: data) else {
            throw NetworkError.imageDataMissing
        }
        
        //Returns the image created from data above
        return image
    }
    
    static func fetchRepresentatives(from url: URL) async throws -> [Representative] {
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.representativeDataMissing
        }
        
        let representativeResponse = try JSONDecoder().decode(RepresentativeResponse.self, from: data)
        let representatives = representativeResponse.results
        
        return representatives
    }
}
