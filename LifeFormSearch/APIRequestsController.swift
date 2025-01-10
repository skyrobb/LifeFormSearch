//
//  APIRequestsController.swift
//  LifeFormSearch
//
//  Created by Skyler Robbins on 12/18/24.
//

import Foundation
import UIKit

class APIRequestsController {
    
    enum error: Error {
        case lifeFormNotFound
        case EOLResponseNotFound
    }
    
    func fetchLifeForms(matching query: String) async throws -> [LifeForm] {
        
        let urlQuery = query.replacingOccurrences(of: " ", with: "%20")
        
        let urlComponents = URLComponents(string: "https://eol.org/api/search/1.0.json?q=\(urlQuery)")!
        
        let (data, response) = try await URLSession.shared.data(from: urlComponents.url!)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw error.lifeFormNotFound
        }
        
        print(String(data: data, encoding: .utf8) ?? "failed")
        
        let decoder = JSONDecoder()
        let searchResponse = try decoder.decode(LifeFormSearchResponse.self, from: data)
        
        return searchResponse.results
    }
    
    func fetchEOLImageURL(taxonID: String, completion: @escaping (String?) -> Void) {
        let endpoint = "https://eol.org/api/pages/1.0.json?id=\(taxonID)&images=1&details=true"

        guard let url = URL(string: endpoint) else {
            print("Invalid API URL.")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data else {
                print("No data received.")
                completion(nil)
                return
            }

            do {
                // Parse JSON response
                if let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let dataObjects = json["dataObjects"] as? [[String: Any]],
                   let firstObject = dataObjects.first,
                   let imageUrl = firstObject["mediaURL"] as? String {
                    completion(imageUrl) // Return the media URL
                } else {
                    print("Failed to parse JSON or find image URL.")
                    completion(nil)
                }
            } catch {
                print("JSON parsing error: \(error.localizedDescription)")
                completion(nil)
            }
        }

        task.resume()
    }

    func fetchImage(from url: String, completion: @escaping (UIImage?) -> Void) {
        guard let imageUrl = URL(string: url) else {
            print("Invalid URL.")
            completion(nil)
            return
        }

        let task = URLSession.shared.dataTask(with: imageUrl) { data, response, error in
            if let error = error {
                print("Error fetching image: \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to load image data.")
                completion(nil)
                return
            }

            completion(image) // Return the image
        }

        task.resume()
    }

    
    func displayEOLImage(taxonID: String, imageView: UIImageView) {
        fetchEOLImageURL(taxonID: taxonID) { [self] imageUrl in
            guard let imageUrl = imageUrl else {
                print("Failed to get image URL.")
                return
            }

            fetchImage(from: imageUrl) { image in
                DispatchQueue.main.async {
                    imageView.image = image // Update the UI on the main thread
                }
            }
        }
    }



}
