import UIKit

class GroupViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var groups = ["Group 1", "Group 2", "Group 3", "Group 4", "Group 5", "Group 6", "Group 7", "Group 8", "Group 9", "Group 10", "Group 11"]

    var tableView: UITableView!

    var titleLabel: UILabel!

    var button1: UIButton!
    var button2: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        titleLabel = UILabel()
        titleLabel.text = "Groups List:"
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
        button2.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(button2)
 
        setupConstraints()
    }

    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 40)
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return groups.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)

        cell.textLabel?.text = groups[indexPath.row]
        
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedGroup = groups[indexPath.row]

            let listViewController = ListViewController()
            listViewController.selectedGroup = selectedGroup

            navigationController?.pushViewController(listViewController, animated: true)
        }

}

