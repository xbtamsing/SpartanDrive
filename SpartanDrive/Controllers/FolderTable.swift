//
//  FolderTable.swift
//  SpartanDrive
//
//  Created by Brian Tamsing on 5/4/20.
//  Copyright © 2020 Spencer. All rights reserved.
//

import UIKit
import Firebase
import FirebaseFirestore
import MobileCoreServices
import MessageUI

class FolderTable: UIViewController {
    
    // FolderTable Properties
    public let tableView = UITableView()
    public var folderName = String()
    public var singleFolderTitle = String()
    private var files = [File]()
    private var folders = [Folder]()
    private var folderNames = [String]()
    private var storageUsed = Int64()
    private var indexOfFileToViewDescriptionOf: IndexPath!
    public var backToPrevious: String = String()
    
    // current user info
    public var currentUserUIDPath: String!
    
    // navigation buttons
    private var createFolderButton = UIButton(type: .system)
    private var uploadFileButton = UIButton(type: .system)
    
    
    // FolderTable Methods
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
        self.fetchData()
        if UserDefaults.standard.bool(forKey: "\(self.folderName) containsFolders") {
            self.fetchFolders()
        }
        self.configureNavigationButtons()
        self.configureTableView()
        title = self.singleFolderTitle
    }
    
    /**
    * Configures this View's Navigation Buttons.
    */
    func configureNavigationButtons() {
        let backButton = UIBarButtonItem(title: self.singleFolderTitle, style: UIBarButtonItem.Style.plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = backButton
        self.navigationItem.backBarButtonItem?.tintColor = UIColor.black
        
        // recognizers
        let uploadRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleUploadFileTapGesture))
        self.uploadFileButton.addGestureRecognizer(uploadRecognizer)
        
        let createFolderRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleCreateFolderTapGesture))
        createFolderButton.addGestureRecognizer(createFolderRecognizer)
        
        // upload button and create folder button config & assignment
        let uploadConfigSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        
        self.uploadFileButton.setBackgroundImage(UIImage(systemName: "arrow.up.doc", withConfiguration: uploadConfigSize), for: .normal)
        self.uploadFileButton.tintColor = .black
        self.uploadFileButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        let createFolderConfigSize = UIImage.SymbolConfiguration(pointSize: 20, weight: .regular, scale: .large)
        
        self.createFolderButton.setBackgroundImage(UIImage(systemName: "folder.badge.plus", withConfiguration: createFolderConfigSize), for: .normal)
        self.createFolderButton.tintColor = .black
        self.createFolderButton.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(customView: self.uploadFileButton), UIBarButtonItem(customView: self.createFolderButton)]
        
    }
    
    func configureTableView() {
        // add the subview
        self.view.addSubview(self.tableView)
        
        // delegation and datasource
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        // register the data table cells
        self.tableView.register(FileCell.self, forCellReuseIdentifier: BaseAppHome.Cells.fileIdentifier)
        self.tableView.register(FolderCell.self, forCellReuseIdentifier: BaseAppHome.Cells.folderIdentifier)
        
        // set row height
        self.tableView.rowHeight = 91
        
        // add constraints
        self.tableView.pin(to: self.view)
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
                
                UserDefaults.standard.set(self.folderNames, forKey: "\(self.folderName)/folderSet")
                UserDefaults.standard.set(true, forKey: "\(self.folderName) containsFolders")
                
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
    
    /**
     * Shares a file resource with another registered SpartanDrive user.
     */
    func shareFile(recipientEmail: String, fileIndexPath: IndexPath) {
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
                        alert.addAction(UIAlertAction(title: "Okay!", style: .default, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                        
                        UserDefaults.standard.set(true, forKey: "\(self.folderName)/" + "\(self.files[fileIndexPath.row].name) has been shared")
                        UserDefaults.standard.set(recipientEmail, forKey: "\(self.folderName)/" + "\(self.files[fileIndexPath.row].name) shared with")
                    })
                }
                else {
                    print("Could not retrieve the recipient's userID. Error: \(String(describing: error))")
                }
            })
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
            let storageRef = fileStorage.storageRef.child("users/" + "\(self.currentUserUIDPath!)/" + "\(self.folderName)/" + "\(self.folders[fileIndexPath.row].name)")
            
            var recipientUID: String!
            docRef.getDocument(completion: { (document, error) in
                if let document = document {
                    recipientUID = (document.get("uid") as? String)
                    print(recipientUID!)
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
                                UserDefaults.standard.set(true, forKey: "\(self.folderName)/" + "\(nameOfFileToBeShared) has been shared")
                                UserDefaults.standard.set(recipientEmail, forKey: "\(self.folderName)/" + "\(nameOfFileToBeShared) shared with")
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
        if indexPath.section == 0 {
            let fileStorage = FileStorage()
            let recipient = UserDefaults.standard.value(forKey: "\(self.folderName)/" + "\(self.files[indexPath.row].name) shared with")
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
                            alert.addAction(action)
                            self.present(alert, animated: true, completion: nil)
                            UserDefaults.standard.set(false, forKey: "\(self.folderName)/" + "\(self.files[indexPath.row].name) has been shared")
                            UserDefaults.standard.removeObject(forKey: "\(self.folderName)/" + "\(self.files[indexPath.row].name) shared with")
                        }
                    })
                }
            })
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDescription" {
            guard let destination = segue.destination as? FileDescription else { return }
            if self.indexOfFileToViewDescriptionOf.section == 0 {
                destination.name = self.folderName + "/" + self.files[self.indexOfFileToViewDescriptionOf.row].name
            }
            else {
                destination.name = self.folderName + "/" + self.folders[self.indexOfFileToViewDescriptionOf.row].name
            }
        }
    }
}


// ---- DOCUMENT PICKER -----
extension FolderTable: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        let fileStorage = FileStorage()
        fileStorage.setLocalFileUrl(urls[0])
        print(urls[0])
        let uploadRef = fileStorage.storageRef.child("users/" + "\(self.currentUserUIDPath!)" + "/" + "\(self.folderName)" + "/" + "\(fileStorage.lastPathComponent!)")
        
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
extension FolderTable: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return BaseAppHome.Cells.fileHeader
        }
        else {
            return BaseAppHome.Cells.folderHeader
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return self.files.count
        }
        else {
            return self.folders.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: BaseAppHome.Cells.fileIdentifier) as? FileCell
            let file: File = self.files[indexPath.row]
            cell?.setFileProperties(file: file)
            return cell!
        }
        else {
            let cell = self.tableView.dequeueReusableCell(withIdentifier: BaseAppHome.Cells.folderIdentifier) as? FolderCell
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
            print(indexPath.row)
            let fileRef = fileStorage.storageRef.child("users/" + "\(self.currentUserUIDPath!)" + "/" + "\(self.folderName)" + "/" + self.files[indexPath.row].name)
            
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
            destination.folderName = self.folderName + "/" + self.folders[indexPath.row].name // infinite concatenation
            destination.backToPrevious = self.folderName
            destination.singleFolderTitle = self.folders[indexPath.row].name
            destination.currentUserUIDPath = self.currentUserUIDPath
            self.navigationController?.pushViewController(destination, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let viewFileInfo = UIContextualAction(style: .normal, title: "Info", handler: { (action, view, completion) in
            self.indexOfFileToViewDescriptionOf = indexPath
            self.performSegue(withIdentifier: "showDescription", sender: self)
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
                
                self.deleteFileFromStorage(filePath: self.files[indexPath.row].name, fileSizeAtIndex: indexPath.row, section: indexPath.section)
                
                // reset the file's description in the event that it is deleted (and maybe even re-uploaded). the desc won't reset properly, however, for some weird reason w/o this key being hardcoded in. removing the object from UserDefaults does not work either.
                UserDefaults.standard.set("Enter a file description here.", forKey: self.files[indexPath.row].name)
                UserDefaults.standard.set(false, forKey: "\(String(describing: self.files[indexPath.row])) has changed desc")
                
                
                self.files.remove(at: indexPath.row)
                self.tableView.deleteRows(at: [indexPath], with: .fade)
                completion(true)
            }
            else if indexPath.section == 1 {
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
                if UserDefaults.standard.bool(forKey: "\(self.folderName)/" + "\(self.files[indexPath.row].name) has been shared") {
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

extension FolderTable {
    /**
    * Fetches data  (in this case, file uploads) located within Firebase Storage.
    */
    func fetchData() {
        let storageRef = FileStorage().storageRef.child("users/" + "\(self.currentUserUIDPath!)" + "/" + "\(self.folderName)")
        print(storageRef)
               
        storageRef.listAll(completion: { (result, error) in
            if let error = error {
                print(error)
            }
           for item in result.items {
               // obtaining for use in the file/filecell instantiation
               let fileName = item.name
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
    * Fetches User created Folders.
    */
    func fetchFolders() {
        let folderNames = UserDefaults.standard.value(forKey: "\(self.folderName)/folderSet") as? [String]
        
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
    func deleteFileFromStorage(filePath: String, fileSizeAtIndex: Int, section: Int) {
        let fileStorage = FileStorage()
        
        // ...
        
        if section == 0 {
            let removalRef = fileStorage.storageRef.child("users/" + "\(self.currentUserUIDPath!)" + "/" + "\(self.folderName)" + "/" + "\(filePath)")
            
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
        else {
            // cannot delete contents by folder. no API support for this task.
        }
    }
}

extension FolderTable: MFMailComposeViewControllerDelegate {
    
    /**
     * Presents an email composer within the app.
     *
     * Comes prefilled with data, including the download link to the selected File.
     */
    func composeEmail(indexPath: IndexPath) {
        let fileStorage = FileStorage()
        let fileRef = fileStorage.storageRef.child("users/" + "\(self.currentUserUIDPath!)"  + "/" + "\(self.folderName)" + "/" + self.files[indexPath.row].name)
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
