import UIKit
import CoreData

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedGroup: String?
    var tableView: UITableView!
    var titleLabel: UILabel!
    var button1: UIButton!
    var button2: UIButton!

    // Store list items as an array of strings
    var listItems: [String] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        setupUI()
        fetchListItems()
    }

    // MARK: - Setup UI
    func setupUI() {
        titleLabel = UILabel()
        titleLabel.text = "List Items"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(titleLabel)

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(tableView)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        button1 = UIButton(type: .system)
        button1.setTitle("", for: .normal)
        if let buttonImage1 = UIImage(named: "icons8-minus-50.png") {
            button1.setImage(buttonImage1, for: .normal)
        }
        button1.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button1)

        button2 = UIButton(type: .system)
        button2.setTitle("", for: .normal)
        if let buttonImage2 = UIImage(named: "icons8-plus-50.png") {
            button2.setImage(buttonImage2, for: .normal)
        }
        button2.addTarget(self, action: #selector(addListItem), for: .touchUpInside) // Add action for plus button
        button2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button2)
        
        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            titleLabel.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: button1.topAnchor, constant: -20)
        ])

        NSLayoutConstraint.activate([
            button1.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
            button1.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button1.widthAnchor.constraint(equalToConstant: 100),
            button1.heightAnchor.constraint(equalToConstant: 50)
        ])

        NSLayoutConstraint.activate([
            button2.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
            button2.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button2.widthAnchor.constraint(equalToConstant: 100),
            button2.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listItems.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = listItems[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedListItem = listItems[indexPath.row]

        let itemViewController = ItemViewController()
        itemViewController.selectedListItem = selectedListItem  // Pass selected list item

        navigationController?.pushViewController(itemViewController, animated: true)
    }


    // MARK: - Core Data: Save List Item
    @objc func addListItem() {
        let alert = UIAlertController(title: "New List Item", message: "Enter item name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Item name"
        }
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self, let itemName = alert.textFields?.first?.text, !itemName.isEmpty else { return }
            self.saveListItem(name: itemName)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }

    func saveListItem(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let newItem = NSEntityDescription.insertNewObject(forEntityName: "ListItem", into: context)
        newItem.setValue(name, forKey: "name")

        do {
            try context.save()
            listItems.append(name)
            tableView.reloadData()
        } catch {
            print("Failed to save item: \(error)")
        }
    }

    // MARK: - Core Data: Fetch List Items
    func fetchListItems() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext

        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ListItem")

        do {
            let results = try context.fetch(fetchRequest)
            listItems = results.compactMap { $0.value(forKey: "name") as? String }
            tableView.reloadData()
        } catch {
            print("Failed to fetch list items: \(error)")
        }
    }
}

