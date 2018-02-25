//
//  ESMovieModel.swift
//  QueSerie
//
//  Created by Rosane Girão on 25/02/2018.
//  Copyright © 2018 Eddie Saboia. All rights reserved.
//

import Foundation
import RealmSwift
import Realm

class ESMovieModel: Object {
   @objc dynamic var id:Int = 0
   @objc dynamic var idmovie:Int = 0
   @objc dynamic var title:String = ""
   @objc dynamic var overview:String = ""
   @objc dynamic var vote_average:Float = 0.0
   @objc dynamic var vote_count:Int = 0
   @objc dynamic var poster_path:String = ""
   @objc dynamic var image:UIImage = UIImage()
   @objc dynamic var favorite:Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}
