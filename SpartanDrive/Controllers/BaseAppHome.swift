//
//  BaseAppHome.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 4/27/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorage
import MobileCoreServices

class BaseAppHome: UIViewController {
    
    // BaseAppHome Properties --------------------------------------------------------------------------------------------------
    private var userProfileButton: UIButton! = UIButton(type: .system)
    private var uploadFileButton: UIButton! = UIButton(type: .system)
    private var createFolderButton: UIButton! = UIButton(type: .system)
    public var currentUser: UserProfile = UserProfile()
    private var currentUserUIDPath: String = String()
    
    let tableView = UITableView()
    // array of files to be shown within the table view cells. 
    private var files: [File] = [File]()
    private var storageUsed = [Int64]()
    
    struct Cells {
        static let identifier = "FileCell"
    }
    // search bar related
    private var filteredFiles: [File] = [File]()
    
    // END PROPERTIES ----------------------------------------------------------------------------------------------------------
    
    
    
    // BaseAppHome Methods ------------------------------------------------------------------------------------------------------------
    
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
        self.configureNavigationButtons()
        self.configureSearchController()
        self.configureTableView()
        title = "Home"
    }
    
    /**
     * Configures the Home's Profile button.
     */
    func configureNavigationButtons() {
        // the navigation's back button
        let backButton = UIBarButtonItem(title: "", style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
        // gesture recognizers
        let profileRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleProfileTapGesture))
        self.userProfileButton.addGestureRecognizer(profileRecognizer)
        
        let uploadRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleUploadFileTapGesture))
        self.uploadFileButton.addGestureRecognizer(uploadRecognizer)
        
        // TODO: still need to add one for the create folder button
        
        // profile button image config & assignment
        let userConfigSize = UIImage.SymbolConfiguration(pointSize: 26, weight: .light, scale: .large)
        let profileButtonImage = UIImage(systemName: "person.circle", withConfiguration: userConfigSize)
        
        self.userProfileButton.setImage(profileButtonImage, for: .normal)
        self.userProfileButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        self.userProfileButton.tintColor = UIColor.black
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: userProfileButton)
        
        // upload button and create folder button config & assignment
        let uploadConfigSize = UIImage.SymbolConfiguration(pointSize: 22, weight: .regular, scale: .large)
        
        self.uploadFileButton.setBackgroundImage(UIImage(systemName: "arrow.up.doc", withConfiguration: uploadConfigSize), for: .normal)
        self.uploadFileButton.tintColor = .black
        self.uploadFileButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        let createFolderConfigSize = UIImage.SymbolConfiguration(pointSize: 24, weight: .regular, scale: .large)
        
        self.createFolderButton.setBackgroundImage(UIImage(systemName: "folder.badge.plus", withConfiguration: createFolderConfigSize), for: .normal)
        self.createFolderButton.tintColor = .black
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
        self.tableView.rowHeight = 80
        
        // register the tableview cells
        self.tableView.register(FileCell.self, forCellReuseIdentifier: Cells.identifier)
        
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
            self.currentUser.storageUsed = self.storageUsed
            destination.currentUser = self.currentUser
        }
    }
    
    /**
    * Handles a tap on the Upload File button by uploading the file to Firebase Storage.
    */
    @objc func handleUploadFileTapGesture() {
        if self.uploadFileButton.gestureRecognizers![0].state ==
            .ended {
            // allows documents to be selected outside of the app's sandbox
            let documentPicker = UIDocumentPickerViewController(documentTypes: [kUTTypePlainText as String, kUTTypePDF as String, kUTTypeSpreadsheet as String], in: .import)
            documentPicker.delegate = self
            // will help with only retrieving one document at a time. multiple
            // document selections can be implemented
            // further with a simple for-loop later on in or within the process.
            documentPicker.allowsMultipleSelection = false
            present(documentPicker, animated: true, completion: nil)
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
    
}

extension BaseAppHome: UIDocumentPickerDelegate {
    
    /**
     * Called after a file has been selected from the iPhone's File System.
     */
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        let fileStorage = FileStorage()
        fileStorage.setLocalFileUrl(urls[0])
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

extension BaseAppHome: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !(self.navigationItem.searchController?.searchBar.text!.isEmpty)! {
            return self.filteredFiles.count
        }
        else {
            return self.files.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // also to be filled in later on.
        let cell = self.tableView.dequeueReusableCell(withIdentifier: Cells.identifier) as? FileCell
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
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            self.deleteFileFromStorage(filePath: self.files[indexPath.row].name, fileSizeAtIndex: indexPath.row)
            self.files.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let fileStorage = FileStorage()
        let fileRef = fileStorage.storageRef.child("users/" + "\(self.currentUserUIDPath)" + "/" + self.files[indexPath.row].name)
        fileRef.downloadURL(completion: { (url, error) in
            if let error = error {
                print(error)
            }
            else {
                guard let destination = self.storyboard?.instantiateViewController(withIdentifier: "WebViewVC") as? WebView else { return }
                destination.fileURL = url!
                destination.fileTitle = self.files[indexPath.row].name
                self.navigationController?.pushViewController(destination, animated: true)
            }
        })
    }
    
    
}

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
                // obtaining for use in the filecell instantiation
                let fileName = item.name
                print(fileName)
                var stringOfFileSize = String()
                
                item.getMetadata(completion: { (metadata, error) in
                    if let error = error {
                        print(error)
                    }
                    else {
                        if let fileSizeInBytes = metadata?.size {
                            self.storageUsed.append(fileSizeInBytes)
                            stringOfFileSize = String("Size: \(fileSizeInBytes) bytes")
                            print(stringOfFileSize)
                        }
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
            }
        })
    }
    
    /**
     * Deletes a file from Firebase Storage.
     *
     * Called when a table row is deleted.
     */
    func deleteFileFromStorage(filePath: String, fileSizeAtIndex: Int) {
        let fileStorage = FileStorage()
        self.storageUsed.remove(at: fileSizeAtIndex)
        let removalRef = fileStorage.storageRef.child("users/" + "\(self.currentUserUIDPath)" + "/" + "\(filePath)")
        
        removalRef.delete(completion: { (error) in
            if let error = error {
                print(error)
            }
            else {
                // alert on file delete completed
                let alert = UIAlertController(title: "Status", message: "File deleted successfully.", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay!", style: .cancel, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
            }
        })
    }
}

/**
 * Updates search results as the user interacts with the search bar.
 */
extension BaseAppHome: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, !text.isEmpty {
            self.filteredFiles = self.files.filter({ (file) -> Bool in
                return file.name.lowercased().contains(text.lowercased())
            })}
        else {
            self.filteredFiles = []
        }
        self.tableView.reloadData()
    }
}
