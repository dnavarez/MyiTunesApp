//
//  DataModel.swift
//  MyItunesApp
//
//  Created by DRNavarez on 23/02/2019.
//  Copyright © 2019 Dan Navarez. All rights reserved.
//
//  Purpose: This is the model that will hold some of the datas resulted from iTunes Search API

import Foundation
import RealmSwift
import ObjectMapper
import ObjectMapper_Realm

class ResponseModel: Object, Mappable {
    @objc dynamic var resultCount = 0
    var results: List<ResultsModel> = List<ResultsModel>()
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    func mapping(map: Map) {
        resultCount <- map["resultCount"]
        results     <- (map["results"], ListTransform<ResultsModel>())
    }
}

class ResultsModel: Object, Mappable {
    @objc dynamic var trackId = 0
    @objc dynamic var trackName: String? = nil
    @objc dynamic var artworkUrl100: String? = nil
    @objc dynamic var trackHdPrice = 0.00
    @objc dynamic var primaryGenreName: String? = nil
    @objc dynamic var longDescription: String? = nil
    
    required convenience init?(map: Map) {
        self.init()
    }
    
    override class func primaryKey() -> String? {
        return "trackId"
    }
    
    func mapping(map: Map) {
        trackId             <- map["trackId"]
        trackName           <- map["trackName"]
        artworkUrl100       <- map["artworkUrl100"]
        trackHdPrice        <- map["trackHdPrice"]
        primaryGenreName    <- map["primaryGenreName"]
        longDescription     <- map["longDescription"]
    }
}
