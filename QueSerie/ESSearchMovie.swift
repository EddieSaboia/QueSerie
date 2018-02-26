//
//  ESSearchMovie.swift
//  QueSerie
//
//  Created by Rosane Girão on 25/02/2018.
//  Copyright © 2018 Eddie Saboia. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SVProgressHUD

struct pagess: Decodable{
    let page:Int
    let total_results:Int
    let total_pages:Int
    var results:[ESMovieJson]
    
    init(page:Int, total_results:Int, total_pages:Int, results:[ESMovieJson]) {
        self.page = page
        self.total_results = total_results
        self.total_pages = total_pages
        self.results = results
    }
}


class ESSearchMovie: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var searchActive : Bool = false
    var movies:[ESMovieJson]?
    var datas:[String] = []
    var filtered:[String] = []
    
    var rowselected = 0
    var btnrowselected = 0
    var numberofrow = 0
    var results:pagess = pagess.init(page: 0, total_results: 0, total_pages: 0, results: [])
    var images:[UIImage] = []
    var favoritos:[ESMovieJson] = []
    var statusfv:[Bool] = []
    var i:Int = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        /* Setup delegates */
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        
        SVProgressHUD.setDefaultMaskType(.black)
        SVProgressHUD.show(withStatus: "Carregando dados...")
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/popular?api_key=f2f67cadf46e3bede42d6aae34920b38&language=en-US&page=1")
        
        Alamofire.request(url!).responseJSON { (response) in
            
            let data = response.data
            do{
                
                self.results = try JSONDecoder().decode(pagess.self, from: data!)
                self.numberofrow = self.results.results.count
                for _ in self.results.results{
                    self.datas.append(self.results.results[self.i].title)
                    print(self.datas[self.i])
                    self.i = self.i + 1
                }
                self.tableView.reloadData()
                 SVProgressHUD.dismiss()
            }catch let jsonErr {
                print("ERRO JSON : ", jsonErr)
            }
        }
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
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filtered = datas.filter({ (text) -> Bool in
            let tmp: NSString = text as NSString
            let range = tmp.range(of: searchText, options: NSString.CompareOptions.caseInsensitive)
            return range.location != NSNotFound
        })
        if(filtered.count == 0){
            searchActive = false;
            getNewmovies(text: searchBar.text!)
        } else {
            searchActive = true;
        }
        self.tableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive) {
            return filtered.count
        }
        return datas.count;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell");
        
        if(searchActive){
            cell?.textLabel?.text = filtered[indexPath.row]
        } else {
            cell?.textLabel?.text = datas[indexPath.row];
        }
        
        return cell!;
    }
    
    func getNewmovies(text:String){
        let textmodif:String
        if text.isEmpty {
            textmodif = text
        }else{
            textmodif = text.replacingOccurrences(of: " ", with: "+", options: .literal, range: nil)
        }
        let urlstring = "https://api.themoviedb.org/3/search/movie?api_key=f2f67cadf46e3bede42d6aae34920b38&query=\(textmodif)"
        let url = URL(string: urlstring)
        var newarray:pagess = pagess.init(page: 0, total_results: 0, total_pages: 0, results: [])
        self.i = 0
        Alamofire.request(url!).responseJSON { (response) in
            
            let data = response.data
            do{
                
                newarray = try JSONDecoder().decode(pagess.self, from: data!)
                self.numberofrow = self.results.results.count
                for _ in newarray.results{
                    self.results.results.append(newarray.results[self.i])
                    self.datas.append(newarray.results[self.i].title)
                    print(self.datas[self.i])
                    self.i = self.i + 1
                }
                self.tableView.reloadData()
                SVProgressHUD.dismiss()
            }catch let jsonErr {
                print("ERRO JSON : ", jsonErr)
            }
        }
        
    }
    
}
