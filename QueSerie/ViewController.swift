//
//  ViewController.swift
//  QueSerie
//
//  Created by Rosane Girão on 24/02/2018.
//  Copyright © 2018 Eddie Saboia. All rights reserved.
//

import UIKit
import Alamofire

struct tempMovie: Decodable{
    let id:Int
    let title:String
    let overview:String
    let vote_average:Float
    let vote_count:Int
    let poster_path:String
    let runtime:Int
}

class ViewController: UITableViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        request(link: "https://api.themoviedb.org/3/movie/tt2395427?api_key=f2f67cadf46e3bede42d6aae34920b38&language=pt-BR")
        navigationItem.title = "Catalogo"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath)
        
        cell.textLabel?.text = "Achou Errado!"
        cell.detailTextLabel?.text = "Otario"
        
        return cell
    }
    
    
    
    func request(link: String!){
        let url = URL(string: link)
        URLSession.shared.dataTask(with: url!){ (data,response, err) in
            guard let data = data else { return }
            
            do{

                let json = try JSONDecoder().decode(tempMovie.self, from: data)
                
                print("Titulo " ,json.title as Any)
                
            }catch let jsonErr {
                print("ERRO JSON : ", jsonErr)
            }
            
        }.resume()
    }
}

