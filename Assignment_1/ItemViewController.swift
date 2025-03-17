import UIKit
import CoreData

class ItemViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var selectedListItem: String?
    var tableView: UITableView!
    var button2: UIButton!
    
    var items: [String] = [] // Stores item names

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white

        setupUI()
        fetchItems()  // Load items from Core Data
    }

    func setupUI() {
        title = "Items"

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        button2 = UIButton(type: .system)
        button2.setTitle("", for: .normal)
        if let buttonImage2 = UIImage(named: "icons8-plus-50.png") {
            button2.setImage(buttonImage2, for: .normal)
        }
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.addTarget(self, action: #selector(addItem), for: .touchUpInside)
        self.view.addSubview(button2)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: button2.topAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            button2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            button2.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button2.widthAnchor.constraint(equalToConstant: 100),
            button2.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Core Data Operations

    func fetchItems() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Item")
        
        do {
            let fetchedItems = try context.fetch(fetchRequest)
            self.items = fetchedItems.compactMap { $0.value(forKey: "name") as? String }
            self.tableView.reloadData()
        } catch {
            print("Failed to fetch items: \(error.localizedDescription)")
        }
    }

    @objc func addItem() {
        let alert = UIAlertController(title: "New Item", message: "Enter item name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Item name"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let itemName = alert.textFields?.first?.text, !itemName.isEmpty {
                self.saveItem(name: itemName)
            }
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(addAction)
        alert.addAction(cancelAction)

        present(alert, animated: true)
    }

    func saveItem(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let entity = NSEntityDescription.entity(forEntityName: "Item", in: context)!
        let newItem = NSManagedObject(entity: entity, insertInto: context)
        newItem.setValue(name, forKey: "name")

        do {
            try context.save()
            self.items.append(name)
            self.tableView.reloadData()
        } catch {
            print("Failed to save item: \(error.localizedDescription)")
        }
    }

    // MARK: - TableView Methods

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = items[indexPath.row]
        return cell
    }
}

