
import UIKit

class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var selectedGroup: String?

    var listItems = ["ListItem 1", "ListItem 2", "ListItem 3", "ListItem 4", "ListItem 5", "ListItem 6", "ListItem 7", "ListItem 8", "ListItem 9", "ListItem 10", "ListItem 11"]
    

    var tableView: UITableView!

    var titleLabel: UILabel!

    var button1: UIButton!
    var button2: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white

        titleLabel = UILabel()
        titleLabel.text = selectedGroup
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
                titleLabel.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 20),
                titleLabel.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -20),
                titleLabel.heightAnchor.constraint(equalToConstant: 50) // Adjusted the height for visibility
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
        itemViewController.selectedListItem = selectedListItem 
            
        navigationController?.pushViewController(itemViewController, animated: true)
    }

}



