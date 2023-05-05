import UIKit

class ToDoListTableViewController: UITableViewController {
    
    var toDoListArray = [ToDoList]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addButtonTapped))
        navigationItem.rightBarButtonItem = addButton
    }

    @objc func addButtonTapped() {
        showAddListAlert()
    }


    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return toDoListArray.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoListID", for: indexPath)
                
        let toDoList = toDoListArray[indexPath.row]
        
        cell.textLabel?.text = toDoList.title
        cell.detailTextLabel?.text = "\(toDoList.items?.count ?? 0) items"

        return cell
    }
    
    func showAddListAlert() {
        // Create a UIAlertController with an alert style
        let alertController = UIAlertController(title: "Add New List", message: "Enter the title for the new ToDo list", preferredStyle: .alert)

        // Add a UITextField to the UIAlertController
        alertController.addTextField { textField in
            textField.placeholder = "List title"
        }

        // Create a cancel UIAlertAction and add it to the UIAlertController
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)

        // Create a save UIAlertAction and add it to the UIAlertController
        let saveAction = UIAlertAction(title: "Save", style: .default) { [weak self, weak alertController] _ in
            guard let self = self, let alertController = alertController, let textField = alertController.textFields?.first, let listTitle = textField.text, !listTitle.isEmpty else {
                return
            }

            // Call the function to create a new ToDo list with the entered title
            self.createNewList(withTitle: listTitle)
        }
        alertController.addAction(saveAction)

        // Present the UIAlertController
        present(alertController, animated: true)
    }

    func createNewList(withTitle title: String) {
        
        let context = PersistenceController.shared.viewContext
        
        // Implement the functionality to create a new ToDo list with the given title
        let newlist = ToDoList(context: context)
        newlist.title = title
        
        toDoListArray.append(newlist)
        
        do {
            try context.save()
        } catch let error as NSError {
            print("error")
        }
        
        tableView.reloadData()
    }
}
