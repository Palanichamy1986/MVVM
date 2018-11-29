//
//  ViewController.swift
//  MVVM
//
//  Created by Palanichamy Padmanabhan on 18/07/18.
//  Copyright © 2018 Palanichamy Padmanabhan. All rights reserved.
//

import UIKit

class ListViewController: UIViewController {

    @IBOutlet weak var tabelView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // view model object
    var viewModel = ListViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.pageSetup()
    }
    
    //initial page settings
    func pageSetup() {
        activityIndicator.startAnimating()
        tableviewSetup()
        //API calling from viewmodel class
        viewModel.getListData()
        closureSetUp()
    }
    
    // closure initialize
    func closureSetUp() {
        viewModel.reloadList = { [weak self] () in
            //UI changes in main thread
            DispatchQueue.main.async {
                self?.tabelView.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
        viewModel.errorMessage = { [weak self] (message) in
            DispatchQueue.main.async {
                print(message)
                self?.activityIndicator.stopAnimating()
            }
        }
    }
}

//UITableview Delegate methods

extension ListViewController : UITableViewDelegate,UITableViewDataSource {
    // tablev view settings
    func tableviewSetup() {
        tabelView.delegate = self
        tabelView.dataSource = self
        tabelView.tableFooterView = UIView()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.arrayOfList.count
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 63
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ListTableViewCell.self)) as! ListTableViewCell
        let listObj = viewModel.arrayOfList[indexPath.row]
        // Cell data settings
        cell.labelTitle.text = listObj.title
        cell.labelDescription.text = listObj.body
        
        if ((indexPath.row % 2) != 0) {
            cell.contentView.backgroundColor = UIColor.lightGray
        }
        else {
            cell.contentView.backgroundColor = UIColor.clear
        }
        return cell
    }
}

