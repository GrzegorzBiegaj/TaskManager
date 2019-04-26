//
//  EditTaskViewController.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import UIKit

class EditTaskViewController: UIViewController {

    lazy var viewModel = EditTaskViewModel(keywords: task?.keywords)

    var task: Task?

    weak var taskDetailsViewController: TaskDetailsViewController? {
        didSet {
            taskDetailsViewController?.delegate = self
        }
    }

    var selectedFile: File? {
        didSet {
            taskDetailsViewController?.fileNameLabel.text = selectedFile?.name ?? "Select file"
            taskDetailsViewController?.fileNameLabel.textColor = selectedFile?.name == nil ? .gray : .black
        }
    }

    // MARK: View controller outlets

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.isEditing = true
            tableView.tableFooterView = UIView()
        }
    }

    // MARK: View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        selectedFile = task?.file
    }

    // MARK: View controller actions

    @IBAction func onSaveButtonTap(_ sender: UIBarButtonItem) {

        guard let name = taskDetailsViewController?.nameTextField.text, !name.isEmpty, let file = selectedFile else {
            showAlertView()
            return
        }
        saveData(name: name, description: taskDetailsViewController?.descriptionTextField.text, file: file)
        performSegue(withIdentifier: "DismissEditVC", sender: self)
    }

    @IBAction func dismissFileListVC(segue: UIStoryboardSegue) {
        guard let fileListVC = segue.source as? FileListViewController else { return }
        selectedFile = fileListVC.selectedFile
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let taskDetailsViewController = segue.destination as? TaskDetailsViewController, segue.identifier == "taskDetails" {
            self.taskDetailsViewController = taskDetailsViewController
            guard let task = task else { return }
            self.taskDetailsViewController?.taskName = task.name
            self.taskDetailsViewController?.taskDescription = task.description
        }
    }

    // MARK: - Private methods

    fileprivate func showFileSelector() {
        let alertController = UIAlertController(title: nil, message: "Please select file source", preferredStyle: .actionSheet)
        let sharedAction = UIAlertAction(title: "Shared Files", style: .default) { [unowned self] _ in
            let pickerVC = UIDocumentPickerViewController(documentTypes: ["public.data"], in: .import)
            pickerVC.delegate = self
            self.navigationController?.present(pickerVC, animated: true, completion: nil)
        }
        let documentsAction = UIAlertAction(title: "Documents folder", style: .default) { [unowned self] _ in
            self.performSegue(withIdentifier: "FileListVC", sender: self)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(documentsAction)
        alertController.addAction(sharedAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true)
    }

    fileprivate func saveData(name: String, description: String?, file: File) {
        for index in 0...tableView.numberOfRows(inSection: 0) {
            guard let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0)) as? KeywordTableViewCell else { continue }
            viewModel.updateKeyword(index: index, keyword: cell.textField.text)
        }
        if var task = task {
            task.name = name
            task.description = description
            task.file = file
            viewModel.saveData(task: task)
        } else {
            viewModel.saveData(task: Task(name: name, description: description, file: file))
        }
    }

    fileprivate func inserRow() {
        viewModel.addKeyword()
        tableView.beginUpdates()
        tableView.insertRows(at: [IndexPath(row: viewModel.keywordsData.count - 2, section: 0)], with: .fade)
        tableView.endUpdates()
    }

    fileprivate func deleteRow(index: Int) {
        viewModel.deleteKeyword(index: index)
        tableView.beginUpdates()
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .fade)
        tableView.endUpdates()
    }

    fileprivate func showAlertView() {
        let alert = UIAlertController(title: "Error", message: "Name and file fields can not be empty!", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

}

// MARK: TaskDetailsViewControllerDelegate methods

extension EditTaskViewController: TaskDetailsViewControllerDelegate {

    func didSelectFile() {
        showFileSelector()
    }
}

// MARK: UITableViewDataSource methods

extension EditTaskViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.keywordsData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == viewModel.keywordsData.count - 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "addKeywordCellRI") else { return UITableViewCell() }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "keywordCellRI") as? KeywordTableViewCell else { return UITableViewCell() }
            cell.textField.text = viewModel.keywordsData[indexPath.row].keyword
            return cell
        }
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteRow(index: indexPath.row)
        } else if editingStyle == .insert {
            inserRow()
        }
    }

}

// MARK: UITableViewDelegate methods

extension EditTaskViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        guard indexPath.row == viewModel.keywordsData.count - 1 else { return .delete }
        return .insert
    }

}

// MARK: UIDocumentPickerDelegate methods

extension EditTaskViewController: UIDocumentPickerDelegate {

    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else { selectedFile = nil; return }

        // Apple documentation:
        // The URLs refer to a copy of the selected documents.
        // These documents are temporary files. They remain available only until your application terminates.
        // To keep a permanent copy, move these files to a permanent location inside your sandbox.

        selectedFile = File(path: url)
    }
}
