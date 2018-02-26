//
//  ESDetalhemovie.swift
//  QueSerie
//
//  Created by Rosane Girão on 26/02/2018.
//  Copyright © 2018 Eddie Saboia. All rights reserved.
//

import Foundation
import UIKit


class ESDetalhemovie: UIViewController{
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageviewposter: UIImageView!
    @IBOutlet weak var labelvotes: UILabel!
    @IBOutlet weak var textviewoverview: UITextView!
    
    @IBAction func playYoutube(_ sender: Any) {
        openYoutube(idkey: "\(idmovie!)")
    }
    
    var overview:String?
    var idmovie:Int?
    var votes:Int?
    var titles:String?
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(String(describing: overview))")
        print("\(String(describing: votes))")
        print("\(String(describing: titles))")
        print("\(String(describing: image))")
        
        labelTitle.text = titles!
        labelvotes.text = "\(votes!)"
        imageviewposter.image = image!
        textviewoverview.text = overview!
        
    }
    
    func openYoutube(idkey:String)
    {
        var youtubeUrl = NSURL(string:"youtube://\(idkey)")!
        if UIApplication.shared.canOpenURL(youtubeUrl as URL){
            UIApplication.shared.canOpenURL(youtubeUrl as URL)
        } else{
            youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(idkey)")!
            UIApplication.shared.canOpenURL(youtubeUrl as URL)
        }
    }
    
    
    
    
}
