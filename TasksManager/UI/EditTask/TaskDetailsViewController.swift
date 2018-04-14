//
//  TaskDetailsViewController.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import UIKit

protocol TaskDetailsViewControllerDelegate: class {

    func didSelectFile()
}

class TaskDetailsViewController: UITableViewController {

    var taskName: String?
    var taskDescription: String?

    weak var delegate: TaskDetailsViewControllerDelegate?

    // MARK: View controller outlets

    @IBOutlet weak var nameTextField: UITextField! {
        didSet {
            guard let taskName = taskName else { return }
            nameTextField.text = taskName
        }
    }

    @IBOutlet weak var descriptionTextField: UITextField! {
        didSet {
            guard let taskDescription = taskDescription else { return }
            descriptionTextField.text = taskDescription
        }
    }

    @IBOutlet weak var fileNameLabel: UILabel!

    // MARK: UITableViewDataSource methods

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cell = tableView.cellForRow(at: indexPath), cell.reuseIdentifier == "fileRI" else { return }
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.didSelectFile()
    }

}
