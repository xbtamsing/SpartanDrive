//
//  BaseAppHome.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/27/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit
import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestore
import MobileCoreServices
import MessageUI
<<<<<<< HEAD
=======
import UserNotifications
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0

class BaseAppHome: UIViewController {
    
    // BaseAppHome Properties --------------------------------------------------------------------------------------------------
    private var userProfileButton: UIButton! = UIButton(type: .system)
    private var uploadFileButton: UIButton! = UIButton(type: .system)
    private var createFolderButton: UIButton! = UIButton(type: .system)
    public var currentUser: UserProfile = UserProfile()
<<<<<<< HEAD
    private var totalBytesUsed: Int = 0
=======
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
    private var currentUserUIDPath: String = String()
    private var indexOfFileToViewDescriptionOf: IndexPath!
    
    let tableView = UITableView()
    
    private var files: [File] = [File]()
    private var storageUsed = Int64()
    private var folders: [Folder] = [Folder]()
    private var folderNames: [String] = [String]()
    
    public struct Cells {
        static let fileIdentifier = "FileCell"
        static let folderIdentifier = "FolderCell"
        static let fileHeader = "Files"
        static let folderHeader = "Folders"
    }
    
    // search bar related
    private var filteredFiles: [File] = [File]()
    
    
    // BaseAppHome Methods ------------------------------------------------------------------------------------------------------------
    
    /**
     * Used here to deselect the currently selected uitablecell/row when the WebView is popped off of the navigation stack.
     */
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedRow = self.tableView.indexPathForSelectedRow {
            self.tableView.deselectRow(at: selectedRow, animated: true)
        }
    }
    
    
    /**
    * Prepares the View elements as the app is loaded into memory.
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.currentUserUIDPath = self.getCurrentUserUID()
        // once the app load into memory, fetch the data from within firebase storage.
        self.fetchData()
        if UserDefaults.standard.bool(forKey: "containsFolders") {
            self.fetchFolders() // a new one
        }
        self.configureNavigationButtons()
        self.configureSearchController()
        self.configureTableView()
        title = "Home"
    }
    
    
    /**
     * Configures the Home's Navigation Buttons.
     */
    func configureNavigationButtons() {
        // the navigation's back button
        let backButton = UIBarButtonItem(title: "Home", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
<<<<<<< HEAD
        self.navigationItem.backBarButtonItem?.tintColor = UIColor { tc in
            switch tc.userInterfaceStyle {
            case .dark:
                return UIColor.white
            default:
                return UIColor.black
            }
        }
=======
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
        
        // gesture recognizers
        let profileRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileTapGesture))
        self.userProfileButton.addGestureRecognizer(profileRecognizer)
        
        let uploadRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleUploadFileTapGesture))
        self.uploadFileButton.addGestureRecognizer(uploadRecognizer)
        
        let createFolderRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleCreateFolderTapGesture))
        createFolderButton.addGestureRecognizer(createFolderRecognizer)
        
        // profile button image config & assignment
        let userConfigSize = UIImage.SymbolConfiguration(pointSize: 23, weight: .light, scale: .large)
        let profileButtonImage = UIImage(systemName: "person.circle", withConfiguration: userConfigSize)
        
        self.userProfileButton.setImage(profileButtonImage, for: .normal)
        self.userProfileButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
<<<<<<< HEAD
        self.userProfileButton.tintColor = UIColor { tc in
            switch tc.userInterfaceStyle {
            case .dark:
                return UIColor.white
            default:
                return UIColor.black
            }
        }
=======
        self.userProfileButton.tintColor = UIColor.black
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userProfileButton)
        
        // upload button and create folder button config & assignment
        let uploadConfigSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        
        self.uploadFileButton.setBackgroundImage(UIImage(systemName: "arrow.up.doc", withConfiguration: uploadConfigSize), for: .normal)
<<<<<<< HEAD
        self.uploadFileButton.tintColor = UIColor { tc in
            switch tc.userInterfaceStyle {
            case .dark:
                return UIColor.white
            default:
                return UIColor.black
            }
        }
=======
        self.uploadFileButton.tintColor = .black
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
        self.uploadFileButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        let createFolderConfigSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        
        self.createFolderButton.setBackgroundImage(UIImage(systemName: "folder.badge.plus", withConfiguration: createFolderConfigSize), for: .normal)
<<<<<<< HEAD
        self.createFolderButton.tintColor = UIColor { tc in
            switch tc.userInterfaceStyle {
            case .dark:
                return UIColor.white
            default:
                return UIColor.black
            }
        }
=======
        self.createFolderButton.tintColor = .black
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
        self.createFolderButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: self.uploadFileButton), UIBarButtonItem(customView: self.createFolderButton)]
    }
    
    
    /**
     * Configures this View's UISearchController.
     */
    func configureSearchController() {
        let search = UISearchController(searchResultsController: nil)
        search.searchBar.placeholder = "Search Files"
        search.obscuresBackgroundDuringPresentation = false
        self.navigationItem.searchController = search
        search.searchResultsUpdater = self
    }
    
    
    /**
     * Configures this View's TableView.
     */
    func configureTableView() {
        // first, make sure to add the tableview subview.
        self.view.addSubview(self.tableView)
        
        // set the tableview delegates
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // set the tableview rows and row heights
        self.tableView.rowHeight = 91
        
        // register the tableview cells
        self.tableView.register(FileCell.self, forCellReuseIdentifier: Cells.fileIdentifier)
        self.tableView.register(FolderCell.self, forCellReuseIdentifier: Cells.folderIdentifier)
        
        // set the tableview constraints
        self.tableView.pin(to: self.view)
    }
    
    
    /**
     * Handles a tap on the Profile button by segueing to the User's Profile Page.
     */
    @objc func handleProfileTapGesture() {
        if self.userProfileButton.gestureRecognizers![0].state ==
            .ended {
            performSegue(withIdentifier: "showProfile", sender: self)
        }
    }
    
    
    /**
     * Used to pass the current user's data from BaseAppHome to the Profile View Controller's UserProfile instance.
     */
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showProfile" {
            guard let destination = segue.destination as? Profile else { return }
            self.currentUser.filesOwned = self.files.count
            self.currentUser.foldersOwned = self.folders.count
            self.currentUser.storageUsed = self.storageUsed
            destination.currentUser = self.currentUser
        }
        else if segue.identifier == "showFileDescription" {
            guard let destination = segue.destination as? FileDescription else { return }
            if self.indexOfFileToViewDescriptionOf.section == 0 {
                destination.name = self.files[self.indexOfFileToViewDescriptionOf.row].name
            }
            else {
                destination.name = self.folders[self.indexOfFileToViewDescriptionOf.row].name
            }
        }
    }
    
    
    /**
    * Handles a tap on the Upload File button by uploading the file to Firebase Storage.
    */
    @objc func handleUploadFileTapGesture() {
        if self.uploadFileButton.gestureRecognizers![0].state ==
            .ended {
            // allows documents to be selected outside of the app's sandbox
            let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePlainText as String, kUTTypePDF as String, kUTTypeSpreadsheet as String, kUTTypePresentation as String], in: .import)
            documentPicker.delegate = self
            
            documentPicker.allowsMultipleSelection = false
            present(documentPicker, animated: true, completion: nil)
        }
    }
    
    @objc func handleCreateFolderTapGesture() {
        if self.createFolderButton.gestureRecognizers![0].state
            == .ended
        {
            var folderName: String! // the folder title
            
            // prompt for a folder title
            let promptFolderTitle = UIAlertController(title: "Folder Title", message: "Please enter a title for your folder", preferredStyle: .alert)
            promptFolderTitle.addTextField(configurationHandler: nil)
            promptFolderTitle.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak promptFolderTitle] (_) in
                
                // save the folder to the array of folders
                folderName = promptFolderTitle?.textFields![0].text
                let folder = Folder(icon: Images.folder, name: folderName!)
                self.folders.append(folder)
                self.folderNames.append(folderName)
                
                UserDefaults.standard.set(self.folderNames, forKey: "folderSet")
                UserDefaults.standard.set(true, forKey: "containsFolders")
                
                // save the folder to the app's folder to allow for persisting
                let fileManager = FileManager.default
                var filePath: URL
                if let documentDir = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
                    filePath = documentDir.appendingPathComponent(folderName!)
                    if !fileManager.fileExists(atPath: filePath.path) {
                        do {
                            print(filePath.path)
                            try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: false, attributes: nil)
                            print("Folder successfully created.")
                        }
                        catch let error {
                            print("The directory you wished to create could not be created: \(error)")
                        }
                    }
                }
                
                self.tableView.reloadData()
            }))
            promptFolderTitle.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
                //self.dismiss(animated: true, completion: nil)
            }))
            
            present(promptFolderTitle, animated: true, completion: nil)
        }
    }
    
    /**
     * Retrieves the uid of the currently signed User for use within the file upload path.
     */
    func getCurrentUserUID() -> String {
        if let user = Auth.auth().currentUser {
            return user.uid
        }
        else {
            return ""
        }
    }
    
    /**
     * Shares a file resource with another registered SpartanDrive user.
     */
    func shareFile(recipientEmail: String, fileIndexPath: IndexPath) {
        
<<<<<<< HEAD
        if fileIndexPath.section == 0 {
            let nameOfFileToBeShared = self.files[fileIndexPath.row].name
            let pathOfFile = self.files[fileIndexPath.row].fullPath
            
            let storageRef = FileStorage().storageRef.child(pathOfFile)
            storageRef.getData(maxSize: 999999999) { [weak self] (data, error) in
                if let error = error {
                    print(error.localizedDescription)
                    return
                }
                
                let docRef = Firestore.firestore().collection("users").document(recipientEmail)
                docRef.getDocument { (snapshot, error) in
                    guard let snapshot = snapshot else {
                        print(error?.localizedDescription)
                        return
                    }
                    
                    let recipientUID = snapshot.data()!["uid"] as! String
                    let uploadRef = FileStorage().storageRef.child("users/\(recipientUID)/\(nameOfFileToBeShared)")
                    uploadRef.putData(data!, metadata: nil) { (metaData, error) in
                        guard let metaData = metaData else {
                            print(error?.localizedDescription)
                            return
                        }
                        
                        let alert = UIAlertController(title: "Status", message: "File successfully shared with \(recipientEmail)!", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                        self?.present(alert, animated: true, completion: nil)

                        UserDefaults.standard.set(true, forKey: "\(self!.files[fileIndexPath.row].name) has been shared")
                        UserDefaults.standard.set(recipientEmail, forKey: "\(self!.files[fileIndexPath.row].name) shared with")
                    }
                }
                
            }
            
=======
        let content = UNMutableNotificationContent()
        content.body = "\(recipientEmail)"
        content.sound = UNNotificationSound.default
                
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "sharedFile", content: content, trigger: trigger)
        

        if fileIndexPath.section == 0 {
            let nameOfFileToBeShared = self.files[fileIndexPath.row].name
            
            let appBundleID = Bundle.main.bundleIdentifier!
            let temp = NSTemporaryDirectory()
            let appPath = "file://" + temp + appBundleID + "-Inbox"
            
            let localFileURL = URL(string: appPath + "/" + nameOfFileToBeShared)!
            
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(recipientEmail)
            
            docRef.getDocument(completion: { (document, error) in
                if let document = document {
                    let recipientUID = (document.get("uid") as? String)!
                    let fileStorage = FileStorage()
                    let uploadRef = fileStorage.storageRef.child("users/" + "\(recipientUID)" + "/" + nameOfFileToBeShared)
                    uploadRef.putFile(from: localFileURL, metadata: nil, completion: { (metadata, error) in
                        guard metadata != nil else {
                            print("File upload error!!")
                            return
                        }
                        let alert = UIAlertController(title: "Status", message: "File successfully shared with \(recipientEmail)!", preferredStyle: .alert)
                        content.title = "File Shared"
                        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)

                        alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        UserDefaults.standard.set(true, forKey: "\(self.files[fileIndexPath.row].name) has been shared")
                        UserDefaults.standard.set(recipientEmail, forKey: "\(self.files[fileIndexPath.row].name) shared with")
                    })
                }
                else {
                    print("Could not retrieve the recipient's userID. Error: \(String(describing: error))")
                }
            })
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
        }
        else {
            
            // establish parts of the final path
            let appBundleID = Bundle.main.bundleIdentifier!
            let temp = NSTemporaryDirectory()
            let appPath = "file://" + temp + appBundleID + "-Inbox"
            
            // retrieve the recipient's UID from the user provided email
            let db = Firestore.firestore()
            let docRef = db.collection("users").document(recipientEmail)
            
            // for folders, we must first get the name of each file from Firebase since the files in a folder only exist upon instantiation of the FolderTable
            // view controller.
            let fileStorage = FileStorage()
            let storageRef = fileStorage.storageRef.child("users/" + "\(self.currentUserUIDPath)/" + "\(self.folders[fileIndexPath.row].name)")
            
            var recipientUID: String!
            docRef.getDocument(completion: { (document, error) in
                if let document = document {
                    recipientUID = (document.get("uid") as? String)
<<<<<<< HEAD
                    print(recipientUID!)
=======
//                    print(recipientUID!)
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
                    storageRef.listAll(completion: { (result, error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            for item in result.items {
                                let nameOfFileToBeShared = item.name
                                let localFileURL = URL(string: appPath + "/" + nameOfFileToBeShared)!
                                let uploadRef = fileStorage.storageRef.child("users/" + "\(recipientUID!)" + "/" + nameOfFileToBeShared)
                                
                                uploadRef.putFile(from: localFileURL, metadata: nil, completion: { ( metadata, error) in
                                    if let error = error {
                                        print(error)
                                    }
                                    else {
                                        print("A file was sent.")
                                    }
                                    
                                })
                                UserDefaults.standard.set(true, forKey: "\(self.folders[fileIndexPath.row].name)/" + "\(nameOfFileToBeShared) has been shared")
                                UserDefaults.standard.set(recipientEmail, forKey: "\(self.folders[fileIndexPath.row].name)/" + "\(nameOfFileToBeShared) shared with")
                            }
                        }
                    })
                }
                let alert = UIAlertController(title: "Status", message: "Folder contents successfully shared with \(recipientEmail)!", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            })
        }
    }
    
    /**
     * Unshares a file resource with another registered SpartanDrive user.
     */
    func unshareFile(fileName: String, indexPath: IndexPath) {
<<<<<<< HEAD
=======
        let content = UNMutableNotificationContent()
        content.body = "\(fileName)"
        content.sound = UNNotificationSound.default
                
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        let request = UNNotificationRequest(identifier: "sharedFile", content: content, trigger: trigger)
        
        
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
        if indexPath.section == 0 {
            let fileStorage = FileStorage()
            let recipient = UserDefaults.standard.value(forKey: "\(self.files[indexPath.row].name) shared with")
            
            let db = Firestore.firestore()
            let docRef = db.collection("users").document((recipient as? String)!)
            
            docRef.getDocument(completion: { (document, error) in
                if let document = document {
                   let recipientUID = (document.get("uid") as? String)!
                    let removalRef = fileStorage.storageRef.child("users/" + "\(recipientUID)" + "/" + "\(fileName)")
                    
                    removalRef.delete(completion: { (error) in
                        if let error = error {
                            print(error)
                        }
                        else {
                            // alert on file successfully unshared
                            let alert = UIAlertController(title: "Status", message: "File has been unshared.", preferredStyle: .alert)
                            let action = UIAlertAction(title: "Okay!", style: .cancel, handler: nil)
<<<<<<< HEAD
=======
                            content.title = "File Unshared"
                            UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            UserDefaults.standard.set(false, forKey: "\(self.files[indexPath.row].name) has been shared")
                            UserDefaults.standard.removeObject(forKey: "\(self.files[indexPath.row].name) shared with")
                        }
                    })
                }
            })
        }
    }
    
    
}

// ---- DOCUMENT PICKER -----
extension BaseAppHome: UIDocumentPickerDelegate {
    /**
     * Called after a file has been selected from the iPhone's File System.
     */
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        let fileStorage = FileStorage()
        fileStorage.setLocalFileUrl(urls[0])
        print(urls[0])
        let uploadRef = fileStorage.storageRef.child("users/" + "\(self.currentUserUIDPath)" + "/" + "\(fileStorage.lastPathComponent!)")
        
        uploadRef.putFile(from: fileStorage.localFileURL!, metadata: nil, completion: { (metadata, error) in
            guard metadata != nil else {
                print("File upload error!!")
                return
            }
            // alert on file upload completed
            let alert = UIAlertController(title: "Status", message: "File upload completed.", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay!", style: .cancel, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            self.fetchData()
        })
    }
}

// ---- UITABLE DELEGATE & DATASOURCE -----
extension BaseAppHome: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    /**
     * Called by this UITableView to determine the number of sections to display.
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(self.navigationItem.searchController?.searchBar.text!.isEmpty)!, section == 0 {
            return self.filteredFiles.count
        }
        else if section == 0 {
            return self.files.count
        }
        else {
            return self.folders.count
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return Cells.fileHeader
        }
        else {
            return Cells.folderHeader
        }
    }
    
    /**
    * Called by this UITableView to determine what FileCell to use when populating the UITableView's cells.
    */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: Cells.fileIdentifier) as? FileCell
            let file: File
            if self.filteredFiles.count != 0 {
                file = self.filteredFiles[indexPath.row]
            }
            else {
                file = self.files[indexPath.row]
            }
            cell?.setFileProperties(file: file)
            
            return cell!
        }
        else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: Cells.folderIdentifier) as? FolderCell
            let folder: Folder = self.folders[indexPath.row]
            cell?.setFolderProperties(folder: folder)
            return cell!
        }
    }
    
    /**
     * Called by this UITableView to determine what row (and thus, what File) has been selected.
     *
     * Proceeds to push the WebView loading the URL request  of the File onto this Navigation stack.
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            let fileStorage = FileStorage()
            let fileRef = fileStorage.storageRef.child("users/" + "\(self.currentUserUIDPath)" + "/" + self.files[indexPath.row].name)
            fileRef.downloadURL(completion: { (url, error) in
                if let error = error {
                    print(error)
                }
                else {
                    guard let destination = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebView else { return }
                    destination.fileURL = url!
                    // currently unused
                    destination.fileTitle = self.files[indexPath.row].name
                    self.navigationController?.pushViewController(destination, animated: true)
                }
            })
        }
        else if indexPath.section == 1 {
            guard let destination = self.storyboard?.instantiateViewController(withIdentifier: "FolderTableVC") as? FolderTable else { return }
            // assign some of the properties of the destination's view
            destination.folderName = self.folders[indexPath.row].name
            destination.singleFolderTitle = self.folders[indexPath.row].name
            destination.currentUserUIDPath = self.currentUserUIDPath
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let viewFileInfo = UIContextualAction(style: .normal, title: "Info", handler: { (action, view, completion) in
            self.indexOfFileToViewDescriptionOf = indexPath
            self.performSegue(withIdentifier: "showFileDescription", sender: self)
            completion(true)
        })
        viewFileInfo.backgroundColor = #colorLiteral(red: 0, green: 0.3333333333, blue: 0.6352941176, alpha: 1)
        viewFileInfo.image = UIImage(systemName: "info.circle")
        
        let composeEmail = UIContextualAction(style: .normal, title: "Email", handler: { (action, view, completion) in
            self.composeEmail(indexPath: indexPath)
            completion(true)
        })
        composeEmail.backgroundColor = #colorLiteral(red: 0.8980392157, green: 0.6588235294, blue: 0.137254902, alpha: 1)
        composeEmail.image = UIImage(systemName: "paperplane")
        
        return UISwipeActionsConfiguration(actions: [composeEmail, viewFileInfo])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteRow = UIContextualAction(style: .normal, title: "Delete", handler: { (action, view, completion) in
            if indexPath.section == 0 {
                
<<<<<<< HEAD
                let file = self.files[indexPath.row]
                self.deleteFileFromStorage(filePath: file.name, fileSizeInBytes: file.sizeInBytes, section: indexPath.section)
=======
                self.deleteFileFromStorage(filePath: self.files[indexPath.row].name, fileSizeAtIndex: indexPath.row, section: indexPath.section)
                
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
                // reset the file's description in the event that it is deleted (and maybe even re-uploaded). the desc won't reset properly, however, for some weird reason w/o this key being hardcoded in. removing the object from UserDefaults does not work either.
                UserDefaults.standard.set("Enter a file description here.", forKey: self.files[indexPath.row].name)
                UserDefaults.standard.set(false, forKey: "\(String(describing: self.files[indexPath.row])) has changed desc")
                
                self.files.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                completion(true)
            }
            else if indexPath.section == 1 {
                // self.deleteFileFromStorage(filePath: self.folders[indexPath.row].name, fileSizeAtIndex: indexPath.row, section: indexPath.section)
                self.folders.remove(at: indexPath.row)
                UserDefaults.standard.set(self.folders, forKey: "folderSet")
                if self.folders.count == 0 {
                    UserDefaults.standard.set(false, forKey: "containsFolders")
                }
                self.tableView.reloadData()
                completion(true)
            }
        })
        
        deleteRow.backgroundColor = #colorLiteral(red: 0.7834706764, green: 0, blue: 0, alpha: 1)
        deleteRow.image = UIImage(systemName: "trash")
        
        let shareFile = UIContextualAction(style: .normal, title: "Share", handler: { (action, view, completion) in
            if indexPath.section == 0 {
                let promptRecipient = UIAlertController(title: "Share File", message: "Please provide the recipient's SpartanDrive registered email.", preferredStyle: .alert)
                promptRecipient.addTextField(configurationHandler: nil)
                promptRecipient.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak promptRecipient] (_) in
                    let recipientEmail = promptRecipient!.textFields![0].text!
                    self.shareFile(recipientEmail: recipientEmail, fileIndexPath: indexPath)
                }))
                promptRecipient.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
                    //self.dismiss(animated: true, completion: nil)
                } ))
                self.present(promptRecipient, animated: true, completion: nil)
            }
            else {
                let promptRecipient = UIAlertController(title: "Share Folder", message: "Please provide the recipient's SpartanDrive registered email.", preferredStyle: .alert)
                promptRecipient.addTextField(configurationHandler: nil)
                promptRecipient.addAction(UIAlertAction(title: "Send", style: .default, handler: { [weak promptRecipient] (_) in
                    let recipientEmail = promptRecipient!.textFields![0].text!
                    self.shareFile(recipientEmail: recipientEmail, fileIndexPath: indexPath)
                }))
                promptRecipient.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: { (_) in
                    //self.dismiss(animated: true, completion: nil)
                } ))
                self.present(promptRecipient, animated: true, completion: nil)
            }
            completion(true)
        })
        
        shareFile.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
        shareFile.image = UIImage(systemName: "arrowshape.turn.up.right")
        
        let unshareFile = UIContextualAction(style: .normal, title: "Unshare", handler: { (action, view, completion) in
            if indexPath.section == 0 {
                if UserDefaults.standard.bool(forKey: "\(self.files[indexPath.row].name) has been shared") {
                    self.unshareFile(fileName: self.files[indexPath.row].name, indexPath: indexPath)
                }
                else {
                    let alert = UIAlertController(title: "Error", message: "Cannot unshare a file that was never shared.", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
                        //self.dismiss(animated: true, completion: nil)
                    }))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            else {
                let alert = UIAlertController(title: "Error", message: "Cannot unshare a folder.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (_) in
                    //self.dismiss(animated: true, completion: nil)
                }))
                self.present(alert, animated: true, completion: nil)
            }
            completion(true)
        })
        unshareFile.backgroundColor = #colorLiteral(red: 0.2196078449, green: 0.007843137719, blue: 0.8549019694, alpha: 1)
        unshareFile.image = UIImage(systemName: "arrowshape.turn.up.left")
        
        return UISwipeActionsConfiguration(actions: [deleteRow, shareFile, unshareFile])
    }
}

// ---- FETCH DATA FROM FIREBASE STORAGE / PREPARE DOWNLOAD LINK-----
extension BaseAppHome {
    /**
     * Fetches data  (in this case, file uploads) located within Firebase Storage.
     */
    func fetchData() {
        
        let storageRef = FileStorage().storageRef.child("users/" + "\(self.currentUserUIDPath)")
        print(storageRef)
        
        storageRef.listAll(completion: { (result, error) in
            if let error = error {
                print(error)
            }
            for item in result.items {
                // obtaining for use in the file/filecell instantiation
                let fileName = item.name
<<<<<<< HEAD
                let filePath = item.fullPath
=======
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
                var stringOfFileSize = String()
                
                
                var fileSizeInBytes: Int64? = Int64()
                item.getMetadata(completion: { (metadata, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        if metadata?.size != nil {
                            fileSizeInBytes = metadata?.size
                            self.storageUsed += fileSizeInBytes!
                            stringOfFileSize = String("Size: \(fileSizeInBytes) bytes")
                        }
<<<<<<< HEAD
                        
                        let icon: UIImage = {
                            let fileSubstrings = fileName.split(separator: ".")
                            let fileExtension = fileSubstrings[fileSubstrings.count - 1]
                            switch fileExtension {
                            case "txt":     return Images.doc
                            case "docx":    return Images.doc
                            case "xlsx":    return Images.xls
                            case "pptx":    return Images.ppt
                            case "pdf":     return Images.pdf
                            default: return UIImage()
                            }
                        }()
                        // construct an instance of a File for this current file
                        let file = File(icon: icon, name: fileName, size: stringOfFileSize, sizeInBytes: Int(fileSizeInBytes!), fullPath:  filePath)
                        
                        let containsDuplicate = self.files.contains(where: { (file) -> Bool in
                            file.name == fileName
                        })
                        
                        if !containsDuplicate {
                            self.files.append(file)
                        }
                        
                        self.tableView.reloadData()
                    }
                })
                
=======
                    }
                })
                
                
                let icon: UIImage = {
                    let fileSubstrings = fileName.split(separator: ".")
                    let fileExtension = fileSubstrings[fileSubstrings.count - 1]
                    switch fileExtension {
                    case "txt":     return Images.doc
                    case "docx":    return Images.doc
                    case "xlsx":    return Images.xls
                    case "pptx":    return Images.ppt
                    case "pdf":     return Images.pdf
                    default: return UIImage()
                    }
                }()
                // construct an instance of a File for this current file
                let file = File(icon: icon, name: fileName, size: stringOfFileSize)
                
                let containsDuplicate = self.files.contains(where: { (file) -> Bool in
                    file.name == fileName
                })
                
                if !containsDuplicate {
                    self.files.append(file)
                }
                
                self.tableView.reloadData()
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
            }
        })
    }
    
    /**
     * Fetches User created Folders.
     */
    func fetchFolders() {
        
        // get the names of all folders created
        let folderNames = UserDefaults.standard.value(forKey: "folderSet") as? [String]
        
        // populate the folders array with new instances of folders
        for index in 0..<folderNames!.count {
            let folder = Folder(icon: Images.folder, name: folderNames![index])
            self.folders.append(folder)
        }
    }
    
    
    /**
     * Deletes a file from Firebase Storage.
     *
     * Called when a table row is deleted.
     */
<<<<<<< HEAD
    func deleteFileFromStorage(filePath: String, fileSizeInBytes: Int, section: Int) {
=======
    func deleteFileFromStorage(filePath: String, fileSizeAtIndex: Int, section: Int) {
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
        let fileStorage = FileStorage()
        
        // ...
        
        if section == 0 {
            let removalRef = fileStorage.storageRef.child("users/" + "\(self.currentUserUIDPath)" + "/" + "\(filePath)")
<<<<<<< HEAD
                        
            removalRef.delete(completion: { [unowned self] (error) in
=======
            
            removalRef.delete(completion: { (error) in
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
                if let error = error {
                    print(error)
                }
                else {
                    // alert on file delete completed
                    let alert = UIAlertController(title: "Status", message: "File deleted successfully.", preferredStyle: .alert)
<<<<<<< HEAD
                    self.storageUsed -= Int64(fileSizeInBytes)
=======
>>>>>>> 68ff8320d4f01097fbb7c506dac314760266eef0
                    let action = UIAlertAction(title: "Okay!", style: .cancel, handler: nil)
                    alert.addAction(action)
                    self.present(alert, animated: true, completion: nil)
                }
            })
        }
        else {
            // the deletion of an entire directory will not work because, currently, the Firebase API does not support it.
            // superficially, the folder can be deleted from the table. this will not, however, delete the actual contents of
            // that folder within Firebase Storage.
        }
    }
}

// ---- SEARCH RESULTS -----
/**
 * Updates search results as the user interacts with the search bar.
 */
extension BaseAppHome: UISearchResultsUpdating {
    /**
     * Filters the Files array to display those which satisfy the given (searchBar.text) predicate.
     *
     * Filters by file name and/or description.
     */
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            let filteredByName: [File] = self.files.filter({ (file) -> Bool in
                return file.name.lowercased().contains(text.lowercased())
            })
            for file in 0..<self.files.count {
                if (UserDefaults.standard.value(forKey: self.files[file].name) as? String?)! != nil {
                    self.files[file].description = (UserDefaults.standard.value(forKey: self.files[file].name) as? String)!
                }
            }
            var filteredByDescription: [File] = self.files.filter({ (file) -> Bool in
                return file.description.lowercased().contains(text.lowercased())
            })
            for index in 0..<filteredByName.count {
                if filteredByDescription.contains(where: { (file) -> Bool in
                    file.name == filteredByName[index].name
                }) {
                    filteredByDescription.remove(at: index)
                }
            }
            self.filteredFiles = filteredByName + filteredByDescription
        }
        else {
            self.filteredFiles = []
        }
        self.tableView.reloadData()
    }
}

extension BaseAppHome: MFMailComposeViewControllerDelegate {
    
    /**
     * Presents an email composer within the app.
     *
     * Comes prefilled with data, including the download link to the selected File.
     */
    func composeEmail(indexPath: IndexPath) {
        let fileStorage = FileStorage()
        let fileRef = fileStorage.storageRef.child("users/" + "\(self.currentUserUIDPath)" + "/" + self.files[indexPath.row].name)
        fileRef.downloadURL(completion: { (url, error) in
            if let error = error {
                print(error)
            }
            else {
                guard MFMailComposeViewController.canSendMail() else { return }
                let composer = MFMailComposeViewController()
                let downloadURL = url!
                composer.mailComposeDelegate = self
                composer.setSubject("Sharing a file!")
                composer.setMessageBody("Here's the download link: \(downloadURL) ", isHTML: false)
                
                self.present(composer, animated: true, completion: nil)
            }
        })
    }
    
    /**
     * Dismisses the email composer after some action is completed (the email is sent, cancelled, etc.).
     */
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        if let error = error {
            print(error)
            controller.dismiss(animated: true, completion: nil)
            return
        }
        
        controller.dismiss(animated: true, completion: nil)
    }
}
