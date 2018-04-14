//
//  TaskListViewController.swift
//  TasksManager
//
//  Created by Grzegorz Biegaj on 13.04.18.
//  Copyright © 2018 Grzegorz Biegaj. All rights reserved.
//

import UIKit

class TaskListViewController: UIViewController {

    lazy var viewModel = TaskListViewModel()
    lazy var dropboxController = DropboxController()

    var showMode: ShowMode {
        switch segmentedControl.selectedSegmentIndex {
        case 0: return .pending
        case 1: return .completed
        default: return .pending
        }
    }

    // MARK: View controller outlets

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.dataSource = self
            tableView.delegate = self
            tableView.tableFooterView = UIView()
        }
    }

    @IBOutlet weak var segmentedControl: UISegmentedControl!

    // MARK: View controller life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let notificationsController = NotificationsController.shared
        notificationsController.delegate = self
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navController = segue.destination as? UINavigationController, let viewController = navController.topViewController as? EditTaskViewController, segue.identifier == "EditSegue"  else { return }
        viewController.task = sender as? Task ?? nil
    }

    // MARK: View controller actions

    @IBAction func onsegmentedControlTap(_ sender: UISegmentedControl) {
        tableView.reloadData()
    }

    @IBAction func dismissEditVC(segue: UIStoryboardSegue) {
        tableView.reloadData()
    }
}

// MARK: UITableViewDataSource methods

extension TaskListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTasks(showMode: showMode).count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "cellRI") else { return UITableViewCell() }
        cell.textLabel?.text = viewModel.getTaskName(task: getTaskAtIndexPath(indexPath), showMode: self.showMode)
        cell.imageView?.image = getTaskAtIndexPath(indexPath).file.type.icon
        cell.backgroundColor = viewModel.getTaskColor(task: getTaskAtIndexPath(indexPath))
        return cell
    }

    func tableView(_ tableView: UITableView,
                   leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let startAction = UIContextualAction(style: .normal, title:  "Start", handler: { [unowned self] (ac: UIContextualAction, view: UIView, success:@escaping (Bool) -> Void) in
            self.dropboxController.taskProcessing(task: self.getTaskAtIndexPath(indexPath), closure: { [unowned self] task in
                self.refreshCell(task: task, indexPath: indexPath)
            })
            success(true)
        })
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { [unowned self] (ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
            self.deleteTask(indexPath: indexPath)
            success(true)
        })
        let pendingAction = UIContextualAction(style: .normal, title:  "set Pending", handler: { [unowned self] (ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
            self.changeTaskStatus(indexPath: indexPath, status: .pending)
            success(false)
        })
        startAction.backgroundColor = .green
        deleteAction.backgroundColor = .red
        pendingAction.backgroundColor = .brown

        var actions: [UIContextualAction] = []
        if case .pending = self.showMode {
            if self.getTaskAtIndexPath(indexPath).status != .postponed {
                actions += [startAction, deleteAction]
            }
        } else {
            actions += [pendingAction]
        }

        return UISwipeActionsConfiguration(actions: actions)
    }

    func tableView(_ tableView: UITableView,
                   trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let postponeAction = UIContextualAction(style: .normal, title:  "Pospone", handler: { [unowned self] (ac: UIContextualAction, view: UIView, success:(Bool) -> Void) in
            self.dropboxController.postponeTaskProcessing(task: self.getTaskAtIndexPath(indexPath), closure: { [unowned self] task in
                self.refreshCell(task: task, indexPath: indexPath)
            })
            success(true)
        })
        postponeAction.backgroundColor = .blue
        var actions: [UIContextualAction] = []
        if case .pending = self.showMode {
            if self.getTaskAtIndexPath(indexPath).status != .postponed {
                actions += [postponeAction]
            }
        }
        return UISwipeActionsConfiguration(actions: actions)
    }

    // MARK: Private mathods

    fileprivate func refreshCell(task: Task, indexPath: IndexPath) {
        if task.status == .processing || task.status == .postponed || task.status == .fileError {
            let cell = tableView.cellForRow(at: indexPath)
            cell?.textLabel?.text = self.viewModel.getTaskName(task: self.getTaskAtIndexPath(indexPath), showMode: self.showMode)
            cell?.backgroundColor = self.viewModel.getTaskColor(task: self.getTaskAtIndexPath(indexPath))
        } else if task.status == .completed {
            tableView.reloadData()
        }
        viewModel.sendLocalNotification(task: task)
    }

    fileprivate func getTaskAtIndexPath(_ indexPath: IndexPath) -> Task {
        return viewModel.getTasks(showMode: showMode)[indexPath.row]
    }

    fileprivate func deleteTask(indexPath: IndexPath) {
        viewModel.deleteTask(task: getTaskAtIndexPath(indexPath))
        deleteCell(indexPath: indexPath)
    }

    fileprivate func changeTaskStatus(indexPath: IndexPath, status: TaskStatus) {
        viewModel.changeTaskStatus(task: getTaskAtIndexPath(indexPath), status: status)
        if case .postponed = status { return }
        deleteCell(indexPath: indexPath)
    }

    fileprivate func deleteCell(indexPath: IndexPath) {
        tableView.beginUpdates()
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }

}

// MARK: UITableViewDelegate methods

extension TaskListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "EditSegue", sender: getTaskAtIndexPath(indexPath))
    }

}

// MARK: NotificationsControllerProtocol methods

extension TaskListViewController: NotificationsControllerFeedbackProtocol {

    func notificationDefault() {
        // Notification tap
        // Dissmiss VC above TaskListViewController
        guard let _ = navigationController?.visibleViewController as? EditTaskViewController else { return }
        dismiss(animated: true, completion: nil)
    }

    func notificationNew() {
        // Notification "New" button tap
        // Go to the new task VC (if it's not already shown)
        guard let _ = navigationController?.visibleViewController as? EditTaskViewController else {
            performSegue(withIdentifier: "EditSegue", sender: self)
            return
        }
    }
}
