//
//  movie.swift
//  QueSerie
//
//  Created by Rosane Girão on 24/02/2018.
//  Copyright © 2018 Eddie Saboia. All rights reserved.
//
import UIKit


class movie: Decodable {
    var name: String
    var video: String
    var descripiton: String
    var image: String
    var rate:Int
    var favorite:Bool
    
    init(name:String, video:String, descripiton:String, image:String, rate:Int, favorite:Bool) {
        self.name = name
        self.video = video
        self.descripiton = descripiton
        self.image = image
        self.rate = rate
        self.favorite = favorite
    }
    
}
