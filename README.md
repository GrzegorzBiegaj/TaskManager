# Task Manager - file uploader

Created by Grzegorz Biegaj (3 days demo project)

## Project description

Task Manager is just an iOS demo app presenting clean code and application architecture.
The main feature of the app is uploading the files to the Dropbox cloud.

How it works: User creates tasks with files. Files are taken from local iPhone storage, or shared storage (e.g. iCloud). In the next step user can perorm tasks, it means upload file to the Dropbox cloud. File can be uploaded immediately, or postponed about 1 minute.
Swiping left and right shows buttons to send and delete tasks. User can also edit existing tasks.

When user is tying to access first time to the Dropbox, the login screen appears. User shoud use his own Dropbox credentials.
To upload the files to the local iPhone storage in simulator please follow path from the app log "Documents Directory"

NOTE: How to update Carthage dependecies:
1. Install brew: brew update
2. Install carthage: brew install carthage
3. Update carthage dependecies in project folder: carthage update --platform iOS

NOTE: How to store the files on the simulator:
1. During the app start documents directory path is shown on the output 
2. Copy the files to that folder

## Architecture

### Modified MVC
Because of usage storyboards introduction of pure MVVM is not so easy, because view is integrated with ViewControllers. Instead of it View Controller is separated by ViewModel and Controller

### Storyboards
For that simple app storyboards are good solution. Storyboards are split to possible small scenes accordingly to the ViewControllers

### Unit tests
Most of possible unit tests exists

### Dependency injection
Because of usage unit tests it was necessary to introduce dependecy injection to separate components. See ViewModels

### Dependencies
Carthage is used as a dependency manager. Advantage in comparison to Cocoapods is to don't introduce additional .xcworkspace file. The project has a minimal number of dependencies

* [SwiftyDropbox](https://github.com/dropbox/SwiftyDropbox) - Dropbox SDK

### Programming tools
Xcode 10.2.1, swift 5.0
