//
//  SpotifyAPIClient.swift
//  Music-Hole
//
//  Created by Betty Fung on 9/20/16.
//  Copyright © 2016 Lloyd W. Sykes. All rights reserved.
//

import Foundation

class SpotifyAPIClient {
    
    static let baseURLString = "https://api.spotify.com/v1/"
    static let store = ArtistDataStore.sharedArtistData
    
    class func getArtistIDWithCompletion(artistName: String, completion: @escaping (String) ->()) {
        
        let formattedArtistName = ArtistInfo.formatArtistName(selectedArtistName: artistName)
        let formattedArtistForURL = formattedArtistName.replacingOccurrences(of: " ", with: "+")
        
        let artistURLString = "https://api.spotify.com/v1/search?q=\(formattedArtistForURL)&type=artist"
        guard let artistURL = URL(string: artistURLString) else {
            print("could not unwrap artist url string")
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: artistURL, completionHandler: { (data, response, error) in
            
            if let data = data {
                if let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    
                    
                    
                    if let responseDictionary = responseDictionary {
                        print("blah")
                    } else {
                        print("There was problem unwrapping the responseDictionary in the API Client.")
                    }
                } else {
                    print("There was a problem converting JSON to NSDictionary in API Client.")
                }
            } else if let error = error {
                print("There was a problem unwrapping the data in the API Client or a general networking error: \(error.localizedDescription)")
            }
        })
        
        task.resume()
        
    }
    
    class func getArtistDiscographyWithCompletion(artistName: String, completion: @escaping (NSDictionary) ->() ) {
        
        let urlString = "https://api.spotify.com/v1/artists/\(Secrets.spotifyAPIClientID)/albums?album_type=album"
        guard let url = URL(string: urlString) else {
            fatalError("There was a problem unwrapping the URL when trying to get the artist discography from Spotify")
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url, completionHandler: { (data, response, error) in
            
            if let data = data {
                if let responseDictionary = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    if let responseDictionary = responseDictionary {
                        OperationQueue.main.addOperation({
                            completion(responseDictionary)
                            print("RESPONSE: \(responseDictionary)")
                        })
                    } else {
                        print("There was problem unwrapping the responseDictionary in the API Client.")
                    }
                } else {
                    print("There was a problem converting JSON to NSDictionary in API Client.")
                }
            } else if let error = error {
                print("There was a problem unwrapping the data in the API Client or a general networking error: \(error.localizedDescription)")
            }
        })
        
        task.resume()

    }
}
