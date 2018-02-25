//
//  ESListMovies.swift
//  QueSerie
//
//  Created by Rosane Girão on 25/02/2018.
//  Copyright © 2018 Eddie Saboia. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

struct pages: Decodable{
    let page:Int
    let total_results:Int
    let total_pages:Int
    let results:[ESMovieJson]
    
    init(page:Int, total_results:Int, total_pages:Int, results:[ESMovieJson]) {
        self.page = page
        self.total_results = total_results
        self.total_pages = total_pages
        self.results = results
    }
}

class ESListMovies: UITableViewController,MyCellDelegate {
    var rowselected = 0
    var btnrowselected = 0
    var numberofrow = 0
    var results:pages = pages.init(page: 0, total_results: 0, total_pages: 0, results: [])
    var images:[UIImage] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=f2f67cadf46e3bede42d6aae34920b38&language=en-US&page=1")
        
        Alamofire.request(url!).responseJSON { (response) in
            
            let data = response.data
            do{
                self.results = try JSONDecoder().decode(pages.self, from: data!)
                self.numberofrow = self.results.results.count
                for a in self.results.results{
                    if let url = URL(string: "https://image.tmdb.org/t/p/w500\(a.poster_path)") {
                        self.downloadImage(url: url)
                    }
                }
                
            }catch let jsonErr {
                print("ERRO JSON : ", jsonErr)
            }
        }
        
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
        return self.numberofrow
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellid", for: indexPath) as! ESMoviewCell
        
        cell.titlemovie.text = "\(self.results.results[indexPath.row].title)"
        cell.imagemovie.image = self.images[indexPath.row]
        //cell.btnfavorited.addTarget(self, action: #selector(ESListMovies.favorited), for: .touchUpInside)
        cell.delegate = self
        return cell
        
    }
    
    func btnCloseTapped(cell: ESMoviewCell) {
        //Get the indexpath of cell where button was tapped
        let indexPath = self.tableView.indexPath(for: cell)
        btnrowselected = indexPath!.row
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        rowselected = indexPath.row
        print(rowselected)
    }
    
    func downloadImage(url: URL) {
        print("Download Started")
        getDataFromUrl(url: url) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.images.append(UIImage(data: data)!)
            }
            self.tableView.reloadData();
        }
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
}

