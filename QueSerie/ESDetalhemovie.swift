//
//  ESDetalhemovie.swift
//  QueSerie
//
//  Created by Rosane Girão on 26/02/2018.
//  Copyright © 2018 Eddie Saboia. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import Alamofire


class VideoPlayerView: UIView{
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
        
        
    }
    
    init(frame: CGRect, url: String) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
        if let urls = URL(string: url){
            let player = AVPlayer(url: urls)
            
            let playerLayer = AVPlayerLayer(player: player)
            playerLayer.frame = self.frame
            
            player.play()
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



class ESDetalhemovie: UIViewController{
    
    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageviewposter: UIImageView!
    @IBOutlet weak var textviewoverview: UITextView!
    
    @IBAction func playYoutube(_ sender: Any) {
        requestyoutube(url: "\(idmovie!)")
        
    }
    
    var overview:String?
    var idmovie:Int?
    var titles:String?
    var image:UIImage?
    var results:ESVideo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("\(String(describing: overview))")
        print("\(String(describing: titles))")
        print("\(String(describing: image))")
        
        labelTitle.text = titles!
        imageviewposter.image = image!
        textviewoverview.text = overview!
        
       
        
    }
    
    func openYoutube(idkey:String)
    {
         let urlstring = "https://www.youtube.com/watch?v=\(idkey)"
        
        if let keyWindow = UIApplication.shared.keyWindow {
            let view = UIView(frame: keyWindow.frame)
            view.backgroundColor = UIColor.red
            view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
            
            
            
            let height = keyWindow.frame.width * 9 / 16
            let videoframe = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
            let videoplayer = VideoPlayerView(frame: videoframe, url: urlstring)
            
            view.addSubview(videoplayer)
            
            keyWindow.addSubview(view)
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseIn, animations: {
                view.frame = keyWindow.frame
            }, completion: {
                (completeAnimation) in
            })
        }
    }
    
    
    func requestyoutube(url:String){
        
        let urlcomplete = "http://api.themoviedb.org/3/movie/\(url)/videos?api_key=f2f67cadf46e3bede42d6aae34920b38"
        
        let ulrrequest = URL(string: urlcomplete)
        
        Alamofire.request(ulrrequest!).responseJSON { (response) in
            
            let data = response.data
            do{
                
                self.results = try JSONDecoder().decode(ESVideo.self, from: data!)
                print(self.results?.results[0].key)
                self.openYoutube(idkey: (self.results?.results[0].key)!)
                
            }catch let jsonErr {
                print("ERRO JSON : ", jsonErr)
            }
        }
        
        
    }
    
    
    
    
}
