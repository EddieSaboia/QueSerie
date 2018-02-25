//
//  ESMoviewCell.swift
//  QueSerie
//
//  Created by Rosane Girão on 25/02/2018.
//  Copyright © 2018 Eddie Saboia. All rights reserved.
//

import UIKit
import Alamofire

protocol MyCellDelegate {
    func btnCloseTapped(cell: ESMoviewCell)
}

class ESMoviewCell: UITableViewCell {
    var delegate: MyCellDelegate?

    @IBOutlet weak var imagemovie: UIImageView!
    @IBOutlet weak var titlemovie: UILabel!
    
    @IBOutlet weak var btnfavorited: UIButton!
    @IBAction func favoritedMovie(_ sender: Bool) {
        if let _ = delegate {
            delegate?.btnCloseTapped(cell: self)
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }
}
