import UIKit

/**
 * Represents a File.
 */
class File {
    
    // File Properties
    public var icon: UIImage
    public var name: String
    public var size: String
    public var sizeInBytes: Int
    public var fullPath: String
    lazy public var description: String! = String()
    public var isShared: Bool? = false
    public var sharedWith: String?
    
    // Initialization
    init(icon: UIImage, name: String, size: String, sizeInBytes: Int, fullPath: String) {
        self.icon = icon
        self.name = name
        self.size = size
        self.sizeInBytes = sizeInBytes
        self.fullPath = fullPath
    }
    
}
