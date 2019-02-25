//
//  RestAPIServices.swift
//  MyItunesApp
//
//  Created by DRNavarez on 23/02/2019.
//  Copyright © 2019 Dan Navarez. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireObjectMapper
import RealmSwift
import ObjectMapper

// Constant and Enums used by this RestAPIServices
//--------------------------------------------------------------------------------
fileprivate let BASE_URL    = "https://itunes.apple.com"
fileprivate let HEADERS     = ["Content-Type":"application/json", "Accept":"application/json"]

// List of all api available
enum APICommon: String {
    case Search                 = "search"
}
//--------------------------------------------------------------------------------


// This is the class file to access api server
//--------------------------------------------------------------------------------
class RestAPIServices {
    
    // Singleton instance
    static let sharedInstance = RestAPIServices()
    
    private let sessionManager = SessionManager()
    
    private init() {
        let retrier = Retrier.sharedInstance
        sessionManager.retrier = retrier
    }
    
    /// Get iTunes Search API with default params
    func GETiTunesSearch(completion: @escaping (_ response: ResponseModel?, _ error: Error?) -> Void) {
        
        let params: [String: Any] = [
            "term": "star",
            "country": "au",
            "media": "movie"
        ]
        
        BaseAPIServices.getMethod(sessionManager: sessionManager, api: .Search, params: params, completion: completion)
    }
}
//--------------------------------------------------------------------------------


// This is the base services for api
fileprivate struct BaseAPIServices {
    
    // Common Base GET Method protocol
    static func getMethod<T: Mappable>(sessionManager: SessionManager, api: APICommon, params: [String: Any]? = nil, completion: @escaping (_ response: T?, _ error: Error?) -> Void) {
        
        var baseUrl = BASE_URL
        
        // TODO: Get which base url does an api belong
        switch api {
            case .Search:
                baseUrl = BASE_URL
        }
        
        let url = "\(baseUrl)/\(api.rawValue)"
        
        sessionManager.request(url,
                               method: .get,
                               parameters: params,
                               encoding: URLEncoding.default,
                               headers: HEADERS)
            .downloadProgress(queue: DispatchQueue.global(qos: .utility)) { progress in
                print("Progress: \(progress.fractionCompleted)")
            }
            .validate { request, response, data in
                // Custom evaluation closure now includes data (allows you to parse data to dig out error messages if necessary)
                return .success
            }
            .responseJSON(completionHandler: { (response) in
                switch response.result {
                case .success:
                    let obj = Mapper<T>().map(JSONObject: response.result.value)
                    completion(obj, nil)
                case .failure(let error):
                    print("\n====================\nERROR: \(error)\n====================\n")
                    completion(nil, error)
                }
            })
        
    }
}


// This class is used to retry a request for number of times
//--------------------------------------------------------------------------------
fileprivate class Retrier: RequestRetrier {
    
    static let sharedInstance = Retrier()
    
    private typealias RefreshCompletion = (_ succeeded: Bool, _ accessToken: String?, _ refreshToken: String?) -> Void
    private var requestsToRetry: [RequestRetryCompletion] = []
    
    public func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        let err = error as NSError
        print("Error Code: \(err.code)")
        
        if err.code == -1009 { // -1009: No internet code
            print("No internet connection")
        }
        
        if request.retryCount == 3 {
            completion(false, 0.0) // don't retry
        } else {
            if err.code == -1001 { // The request timed out.
                completion(true, 5.0) // retry after 5 second
            } else if let response = request.task?.response as? HTTPURLResponse {
                if response.statusCode == 401 || response.statusCode == 408 {
                    completion(true, 1.0) // retry after 1 second
                }
            } else {
                completion(false, 0.0) // don't retry
            }
        }
    }
}
//--------------------------------------------------------------------------------
