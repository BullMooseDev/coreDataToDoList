import Foundation

extension ToDoList {
    var itemArray: [Item] {
        guard let items = items else { return [] }
        
        return items.allObjects as! [Item]
    }
}
