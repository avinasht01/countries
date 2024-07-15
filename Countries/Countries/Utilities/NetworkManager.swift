//
//  NetworkManager.swift
//  Countries
//
//  Created by Avinash Thakur on 12/07/24.
//

import Foundation
import UIKit

class NetworkManager {
    
   /// imagCache used for caching flag image
   static let imageCache = NSCache<NSString, AnyObject>()
    
    /**
     Function request data from server for given url using URLSession
     - Parameter url: URL api url
     - Returns: completion  Returns completion handler with request data and error if any.
     */
    static func requestDataForUrl(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(
            with: request, completionHandler: { data, response, error in
                if error == nil {
                    guard let resultData = data else {
                        let error = NSError(domain: "Api Result Error", code: 101, userInfo: ["Desc" : "No data found"])
                        completion(nil, error)
                        return
                    }
                    if let resultData = data {
                                    let jsonString = String(data: resultData, encoding: .utf8)
                                    print("the result data string: \n\(jsonString)")
                                }
                    completion(resultData, nil)
                } else {
                    completion(nil, error)
                }
            })
        task.resume()
    }
    
    /**
     Function request image data from server for given url using URLSession, Also cache the image in case of new image, return cached image if already exists.
     - Parameter url: String  Sets location tracking on /off
     - Returns: completion  Returns completion handler with requested image data and error if any.
     */
    static func downloadImage(url: String, completion: @escaping (UIImage?) -> Void) {
        if let url = URL(string: url) {
            if let cachedImage = NetworkManager.imageCache.object(forKey: url.absoluteString as NSString) as? UIImage {
                completion(cachedImage)
                    }
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let imageData = data, error == nil else {
                   completion(nil)
                    return
                }
                let imageToCache = UIImage(data: imageData)
                NetworkManager.imageCache.setObject(imageToCache!, forKey: url.absoluteString as NSString)
                completion(imageToCache)
            }
            task.resume()
        }
    }
    
}
