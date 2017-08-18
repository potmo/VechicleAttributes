//
//  APIHelper.swift
//  VehicleAttributes
//
//  Created by Tom Dowding on 15/08/2017.
//
//

import Foundation

typealias JSONDictionary = [String: Any]

class APIHelper {
    
    typealias APIResultCompletion = (JSONDictionary?, String) -> ()
    
    // MARK: - Functions
    
    // Gets data from API for a given vin
    static func GetData(vin: String, completion: @escaping APIResultCompletion) {
   
        // NOTE: Using fixed url for test only, we would usually use the vin value to form path of GET request
        GetData(urlPath: "https://gist.githubusercontent.com/sommestad/e38c1acf2aed495edf2d/raw/cdb6dfb85101eedad60853c44266249a3f4ac5df/vehicle-attributes.json", completion: completion)
    }
    
    // Gets data from API for a given url path
    static func GetData(urlPath: String, completion: @escaping APIResultCompletion) {
        
        let defaultSession = URLSession(configuration: .default)
        var dataTask: URLSessionDataTask?
        var receivedJson: JSONDictionary?
        var errorMessage = ""
   
        if var urlComponents = URLComponents(string: urlPath) {
            
            guard let url = urlComponents.url else {
                return
            }

            // Create a data task with the url formed from our path
            dataTask = defaultSession.dataTask(with: url) { data, response, error in
                
                // Always invoke the completion function and clean up before leaving this scope
                defer {
                    DispatchQueue.main.async {
                        completion(receivedJson, errorMessage)
                    }
                    dataTask = nil
                }
           
                // Check for an error
                if let error = error {
                    errorMessage = error.localizedDescription
                    
                    // Check specific case of no internet connection
                    if let err = error as? URLError, err.code  == URLError.Code.notConnectedToInternet {
                        errorMessage += " \(NSLocalizedString("no_internet_suggestion", comment: "Suggestion for checking device internet connection"))"
                    }
                  
                    return
                }
                
                // Try and use the data
                if let data = data,
                    let response = response as? HTTPURLResponse,
                    response.statusCode == 200 {
                    
                    do {
                        receivedJson = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                    }
                    catch let parseError as NSError {
                        errorMessage = parseError.localizedDescription
                        return
                    }
                }
                else {
                    errorMessage = NSLocalizedString("api_helper_error", comment: "Error message for when response is not ok")
                }
            }
       
            // Run the data task
            dataTask?.resume()
        }
    }
    
    // For testing different JSON files only
    static func getLocalTestData(filename: String, completion: @escaping APIResultCompletion) {
       
        if let path = Bundle.main.path(forResource: filename, ofType: "json") {
            
            var receivedJson: JSONDictionary?
            var errorMessage = ""
            
            defer {
                DispatchQueue.main.async {
                    completion(receivedJson, errorMessage)
                }
            }
            
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .alwaysMapped)
                
                do {
                    receivedJson = try JSONSerialization.jsonObject(with: data, options: []) as? JSONDictionary
                }
                catch let parseError as NSError {
                    errorMessage = parseError.localizedDescription
                    return
                }
            }
            catch let error {
                errorMessage = error.localizedDescription
            }
        }
    }
}
