//
//  ESListMovies.swift
//  QueSerie
//
//  Created by Rosane Girão on 25/02/2018.
//  Copyright © 2018 Eddie Saboia. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD

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
    var favoritos:[ESMovieJson] = []
    var statusfv:[Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "Carregando dados...")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=f2f67cadf46e3bede42d6aae34920b38&language=en-US&page=1")
        
        Alamofire.request(url!).responseJSON { (response) in
            
            let data = response.data
            do{
                self.results = try JSONDecoder().decode(pages.self, from: data!)
                self.numberofrow = self.results.results.count
                for a in self.results.results{
                    if let url = URL(string: "https://image.tmdb.org/t/p/w500\(a.poster_path)") {
                        self.downloadImage(url: url)
                        self.statusfv.append(false)
                        
                    }
                    
                }
                
            }catch let jsonErr {
                print("ERRO JSON : ", jsonErr)
            }
        }
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
        
        
        cell.delegate = self
        return cell
        
    }
    
    func btnCloseTapped(cell: ESMoviewCell) {
        var i:Int = 0
        //Get the indexpath of cell where button was tapped
        let indexPath = self.tableView.indexPath(for: cell)
        btnrowselected = indexPath!.row
        
        if(statusfv[indexPath!.row] == false){
        let movie = ESMovieJson(id: self.results.results[indexPath!.row].id,
                                title: self.results.results[indexPath!.row].title,
                                overview: self.results.results[indexPath!.row].overview,
                                vote_average: self.results.results[indexPath!.row].vote_average,
                                vote_count: self.results.results[indexPath!.row].vote_count,
                                poster_path: self.results.results[indexPath!.row].poster_path,
                                favorito: true)
            
        print("Filme de titulo \(movie.title) Adicionado")
        favoritos.append(movie)
        self.statusfv[indexPath!.row] = true
        cell.btnfavorited.setImage(#imageLiteral(resourceName: "star-2"), for: .normal)
        }else{
            
            cell.btnfavorited.setImage(#imageLiteral(resourceName: "star"), for: .normal)
            
            for a in favoritos{
                if(a.id == self.results.results[indexPath!.row].id){
                    print("Filme de titulo \(favoritos[i].title) Removido")
                    self.statusfv[indexPath!.row] = false
                    favoritos.remove(at: i)
                }else{
                     i = i + 1
                }
             
            }
        }
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
            SVProgressHUD.dismiss()
        }
        
    }
    
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let nextViewController = segue.destination as? ESDetalhemovie{
                
                nextViewController.image = self.images[rowselected]
                nextViewController.titles = self.results.results[rowselected].title
                nextViewController.votes = self.results.results[rowselected].vote_count
                nextViewController.overview = self.results.results[rowselected].overview
                nextViewController.idmovie = self.results.results[rowselected].id
            
        }
    }
    
}

