//
//  FileListViewController.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import UIKit

class FileListViewController: UITableViewController {

    lazy var viewModel = FileListViewModel()
    private (set) var selectedFile: File?

    // MARK: View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
    }

    // MARK: UITableViewDataSource methods

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.files.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellRI") else { return UITableViewCell() }
        cell.textLabel?.text = viewModel.files[indexPath.row].name
        cell.imageView?.image = viewModel.files[indexPath.row].type.icon
        return cell
    }

    // MARK: UITableViewDelegate methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedFile = viewModel.getFileByIndex(indexPath.row)
        performSegue(withIdentifier: "DismissFileListVC", sender: self)
    }

}
