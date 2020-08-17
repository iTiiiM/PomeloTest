//
//  ViewController.swift
//  PomeloTest
//
//  Created by Piyatat  Thianboonsong on 17/8/2563 BE.
//  Copyright © 2563 Piyatat  Thianboonsong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var storeLocationTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        storeLocationTableView.register(UINib(nibName: StoreLocationCell.nibName, bundle: nil), forCellReuseIdentifier: StoreLocationCell.cellId)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: StoreLocationCell.cellId, for: indexPath) as! StoreLocationCell
        return cell
    }
}

