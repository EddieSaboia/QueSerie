//
//  ESVideo.swift
//  QueSerie
//
//  Created by Rosane Girão on 26/02/2018.
//  Copyright © 2018 Eddie Saboia. All rights reserved.
//

import Foundation

class ESVideo: Decodable{
    let page:Int
    let results:[ESVideoDetail]
    
    init(page:Int, results:[ESVideoDetail]) {
        self.page = page
        self.results = results
    }
}

