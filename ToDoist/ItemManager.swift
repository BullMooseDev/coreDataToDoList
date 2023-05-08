import Foundation
import CoreData

class ItemManager {
    static let shared = ItemManager()

    // Funcs
    
    func createNewItem(with title: String) {
        let newItem = Item(context: PersistenceController.shared.viewContext)
        
        newItem.id = UUID().uuidString
        newItem.title = title
        newItem.createdAt = Date()
        newItem.completedAt = nil
        
        PersistenceController.shared.saveContext()
        
        // does delete all include the immediatly below line?
        // allItems.append(newItem)
    }
    
    func fetchIncompleteItems() -> [Item] {
        // Create the fetch request
        let fetchRequest = Item.fetchRequest()
        // Add the predicate for either incomplete or complete
        fetchRequest.predicate = NSPredicate(format: "completedAt == nil")
        let context = PersistenceController.shared.viewContext
        // Execute the fetch request on a context (view context)
        let fetchedItems = try? context.fetch(fetchRequest)
        // If the fetch request fails, return an empty array of Items
        return fetchedItems ?? []
    }
    
    func fetchCompletedItems() -> [Item] {
        // Create the fetch request
        let fetchRequest = Item.fetchRequest()
        // Add the predicate for either incomplete or complete
        fetchRequest.predicate = NSPredicate(format: "completedAt != nil")

        // Create a sort descriptor for "completedAt", descending
        let sortDescriptor = NSSortDescriptor(key: "completedAt", ascending: false)

        // Assign the sort descriptor to the fetch request
        fetchRequest.sortDescriptors = [sortDescriptor]

        let context = PersistenceController.shared.viewContext
        // Execute the fetch request on a context (view context)
        let fetchedItems = try? context.fetch(fetchRequest)
        
        // If the fetch request fails, return an empty array of Items
        return fetchedItems ?? []
    }

    
    func toggleItemCompletion(_ item: Item) {
        item.completedAt = item.isCompleted ? nil : Date()
        PersistenceController.shared.saveContext()
      }
    
    func delete(at indexPath: IndexPath) {
       remove(item(at: indexPath))
    }
    
    func remove(_ item: Item) {
          let context = PersistenceController.shared.viewContext
          context.delete(item)
          PersistenceController.shared.saveContext()
      }
    
    private func item(at indexPath: IndexPath) -> Item {
            let incompleteItems = self.fetchIncompleteItems()
            let completedItems = self.fetchCompletedItems()
            let items = indexPath.section == 0 ? incompleteItems : completedItems
            return items[indexPath.row]
        }
    
}

class ToDoListManager {
    static let shared = ToDoListManager()
    
    func createNewList(with title: String) {
        let newList = ToDoList(context: PersistenceController.shared.viewContext)
        
        newList.title = title
        // newList.items = to do list item count
        
        PersistenceController.shared.saveContext()
    }
    
    func fetchLists() -> [ToDoList] {
        let fetchRequest = ToDoList.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "modifiedAt", ascending: true)
        
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        let context = PersistenceController.shared.viewContext
        
        let fetchedLists = try? context.fetch(fetchRequest)
        
        return fetchedLists ?? []
    }
    
    func deleteList(at indexPath: IndexPath) {
        removeList(toDoList(at: indexPath))
    }
    
    func removeList(_ list: ToDoList) {
          let context = PersistenceController.shared.viewContext
          context.delete(list)
          PersistenceController.shared.saveContext()
      }
    
    private func toDoList(at indexPath: IndexPath) -> ToDoList {
        let lists = self.fetchLists()
        return lists[indexPath.row]
    }

}
