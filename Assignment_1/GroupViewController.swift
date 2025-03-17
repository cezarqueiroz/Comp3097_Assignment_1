
import UIKit
import CoreData

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var groups: [Group] = [] // Core Data entity
    var tableView: UITableView!
    var titleLabel: UILabel!
    var button1: UIButton!
    var button2: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        fetchGroups()
    }

    // MARK: - UI Setup
    func setupUI() {
        view.backgroundColor = .white
        
        titleLabel = UILabel()
        titleLabel.text = "Groups List:"
        titleLabel.font = UIFont.boldSystemFont(ofSize: 28)
        titleLabel.textAlignment = .left
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(titleLabel)

        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")

        button1 = UIButton(type: .system)
        button1.setTitle("", for: .normal)
        if let buttonImage1 = UIImage(named: "icons8-minus-50.png") {
            button1.setImage(buttonImage1, for: .normal)
        }
        button1.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(button1)

        button2 = UIButton(type: .system)
        button2.setTitle("", for: .normal)
        if let buttonImage2 = UIImage(named: "icons8-plus-50.png") {
            button2.setImage(buttonImage2, for: .normal)
        }
        button2.translatesAutoresizingMaskIntoConstraints = false
        button2.addTarget(self, action: #selector(addGroupTapped), for: .touchUpInside)
        view.addSubview(button2)

        setupConstraints()
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40),

            tableView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: button1.topAnchor, constant: -20),

            button1.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            button1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button1.widthAnchor.constraint(equalToConstant: 100),
            button1.heightAnchor.constraint(equalToConstant: 50),

            button2.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            button2.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            button2.widthAnchor.constraint(equalToConstant: 100),
            button2.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // MARK: - Core Data Operations
    func fetchGroups() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<Group> = Group.fetchRequest()

        do {
            groups = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Failed to fetch groups: \(error)")
        }
    }

    func saveGroup(name: String) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let newGroup = Group(context: context)
        newGroup.name = name

        do {
            try context.save()
            groups.append(newGroup)
            tableView.reloadData()
        } catch {
            print("Failed to save group: \(error)")
        }
    }

    // MARK: - Add Group Button Action
    @objc func addGroupTapped() {
        let alert = UIAlertController(title: "New Group", message: "Enter group name", preferredStyle: .alert)
        alert.addTextField { textField in
            textField.placeholder = "Group Name"
        }

        let addAction = UIAlertAction(title: "Add", style: .default) { _ in
            if let groupName = alert.textFields?.first?.text, !groupName.isEmpty {
                self.saveGroup(name: groupName)
            }
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        present(alert, animated: true)
    }

    // MARK: - TableView DataSource & Delegate
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = groups[indexPath.row].name
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGroup = groups[indexPath.row].name ?? ""
        let listViewController = ListViewController()
        listViewController.selectedGroup = selectedGroup
        navigationController?.pushViewController(listViewController, animated: true)
    }
}
