//
//  ESVIdeoDetail.swift
//  QueSerie
//
//  Created by Rosane Girão on 26/02/2018.
//  Copyright © 2018 Eddie Saboia. All rights reserved.
//

import Foundation

class ESVideoDetail: Decodable{
    let page:String
    let key:String
   
    init(page:String, key:String) {
        self.page = page
        self.key = key
    }
}
