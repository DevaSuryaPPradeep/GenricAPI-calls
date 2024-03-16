//
//  APIManager.swift
//  Genric API calls
//
//  Created by Devasurya on 16/03/24.
//

import Foundation

class APIManager {
    static let shared = APIManager()
    func downloadData <T:Codable>(fromURL:String) async-> T?{
        do {
            guard let url = URL(string: fromURL ) else {
                throw NetworkError.badUrl
            }
            let (data,response) = try await URLSession.shared.data(for: URLRequest(url: url))
            guard let response = response as? HTTPURLResponse else{
                throw NetworkError.badResponse
            }
            guard response.statusCode >= 200 && response.statusCode < 300 else {
                throw NetworkError.badStatus
            }
            guard  let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                throw NetworkError.failedToDecodeResponse
            }
            return decodedData
            
        }
        catch NetworkError.badUrl {
            print("Invalid URL.")
        }
        catch NetworkError.badResponse {
            print("Invalid Response.")
        }
        catch NetworkError.badStatus {
            print("Did not get a 2xx status code from the response.")
        }
        catch NetworkError.failedToDecodeResponse {
            print("Failed to decode response into the given type.")
        }
        catch {
            print("An error occured during downloading data.")
        }
        return nil
    }
}

enum NetworkError: Error {
    case badUrl
    case invalidRequest
    case badResponse
    case badStatus
    case failedToDecodeResponse
}

