//
//  movie.swift
//  QueSerie
//
//  Created by Rosane Girão on 24/02/2018.
//  Copyright © 2018 Eddie Saboia. All rights reserved.
//
import UIKit
import Foundation

class ESMovieJson:Decodable {
    let id:Int
    let title:String
    let overview:String
    let vote_average:Float
    let vote_count:Int
    let poster_path:String
    
    init(id:Int, title:String, overview:String, vote_average:Float, vote_count:Int, poster_path:String) {
        self.id = id
        self.title = title
        self.overview = overview
        self.vote_average = vote_average
        self.vote_count = vote_count
        self.poster_path = poster_path
    }

}
