//
//  ListViewModel.swift
//  MVVM
//
//  Created by Palanichamy Padmanabhan on 18/07/18.
//  Copyright © 2018 Palanichamy Padmanabhan. All rights reserved.
//

import UIKit
class ListViewModel {
    
    // Closure use for notification
    var reloadList = {() -> () in }
    var errorMessage = {(message:String) -> () in }
    
    //Array of List Model class
    var arrayOfList: [List] = [] {
        //Reload data when data set
        didSet{
            reloadList()
        }
    }
    
    // get data from api
    func getListData() {
        guard let listURL = URL(string:"https://jsonplaceholder.typicode.com/posts/") else {
            return
        }
        URLSession.shared.dataTask(with: listURL) {
            (data,response,error) in
            guard let jsonData = data else { return }
            do {
                //Using Decodable data parse
                let decoder = JSONDecoder()
                self.arrayOfList = try decoder.decode([List].self, from: jsonData)
            }
            catch let error {
                print("Error -> \(error.localizedDescription)")
                self.errorMessage(error.localizedDescription)
            }
        }.resume()
    }
}
