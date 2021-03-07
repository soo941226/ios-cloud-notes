import UIKit

protocol TableViewListManagable: class {
    func updateTableViewList()
    func deleteCell()
    func moveCellToTop()
    func changeEnrollButtonStatus(textViewIsEmpty: Bool)
}

class MemoListTableViewController: UITableViewController {
    lazy var enrollButton = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(createMemo))
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNavigationBar()
        UserDefaults.standard.set(false, forKey: UserDefaultsKeys.isCellSelected.rawValue)
        tableView.register(MemoListTableViewCell.self, forCellReuseIdentifier: "MemoCell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        deleteEmptyMemo()
    }
    
    private func configureNavigationBar() {
        navigationItem.title = "메모"
        navigationItem.rightBarButtonItem = enrollButton
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CoreDataSingleton.shared.memoData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let memo = CoreDataSingleton.shared.memoData[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MemoCell") as? MemoListTableViewCell else {
            return UITableViewCell()
        }

        cell.receiveLabelsText(memo: memo)
        return cell
    }
    
    @objc func createMemo(sender: UIButton) {
        do {
            try CoreDataSingleton.shared.save(content: "")
            showContentsViewController(index: 0)
            tableView.reloadData()
            UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isCellSelected.rawValue)
            sender.isEnabled = false
        } catch {
            print(MemoAppSystemError.saveFailed.message)
        }
    }
    
    private func showContentsViewController(index: Int) {
        let memoContentsViewController = MemoContentsViewController()
        let memoContentsNavigationViewController = UINavigationController(rootViewController: memoContentsViewController)
        memoContentsViewController.receiveText(memo: CoreDataSingleton.shared.memoData[index])
        memoContentsViewController.delegate = self
        
        self.splitViewController?.showDetailViewController(memoContentsNavigationViewController, sender: nil)
    }
    
    private func deleteEmptyMemo() -> Bool {
        let firstMemo = CoreDataSingleton.shared.memoData[0]
        let firstIndexPath = IndexPath(row: 0, section: 0)
        
        if firstMemo.value(forKey: "content") as? String == "" {
            do  {
                try CoreDataSingleton.shared.delete(object: firstMemo)
                CoreDataSingleton.shared.memoData.remove(at: 0)
                tableView.deleteRows(at: [firstIndexPath], with: .fade)
                enrollButton.isEnabled = true
                return true
            } catch {
                print(MemoAppSystemError.deleteFailed.message)
                return false
            }
        }
        
        return false
    }
}

// MARK: UITableViewDelegate
extension MemoListTableViewController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var indexPathRow = indexPath.row
        
        if indexPath.row != 0 {
            if deleteEmptyMemo() {
                indexPathRow = indexPath.row - 1
            }
        }
        
        showContentsViewController(index: indexPathRow)
        UserDefaults.standard.set(indexPathRow, forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
        UserDefaults.standard.set(true, forKey: UserDefaultsKeys.isCellSelected.rawValue)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let memoContentsView = MemoContentsViewController()
        if editingStyle == .delete {
            let selectedMemoIndexPathRow = UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
            
            do {
                try CoreDataSingleton.shared.delete(object: CoreDataSingleton.shared.memoData[selectedMemoIndexPathRow])
                CoreDataSingleton.shared.memoData.remove(at: selectedMemoIndexPathRow)
                UserDefaults.standard.set(0, forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
                tableView.deleteRows(at: [indexPath], with: .fade)
                
                if splitViewController?.traitCollection.horizontalSizeClass == .regular {
                    switch CoreDataSingleton.shared.memoData.isEmpty {
                    case false:
                        memoContentsView.receiveText(memo: CoreDataSingleton.shared.memoData[0])
                        self.splitViewController?.showDetailViewController(memoContentsView, sender: nil)
                    case true:
                        splitViewController?.viewControllers.removeLast()
                    }
                }
            } catch {
                print(MemoAppSystemError.deleteFailed.message)
            }
        }
    }
}

// MARK: Alert
extension MemoListTableViewController {
    private func showAlertMessage(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
}

// MARK: TableViewListManagable
extension MemoListTableViewController: TableViewListManagable {
    func updateTableViewList() {
        tableView.reloadData()
    }
    
    func deleteCell() {
        let selectedMemoIndexPathRow = UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
        let indexPath = IndexPath(row: selectedMemoIndexPathRow, section: 0)
        
        tableView.deleteRows(at: [indexPath], with: .fade)
        tableView.reloadData()
        UserDefaults.standard.set(0, forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
    }
    
    func moveCellToTop() {
        if UserDefaults.standard.value(forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue) as? Int == 0 {
            return
        }
        
        let selectedMemoIndexPathRow = UserDefaults.standard.integer(forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
        let indexPath = IndexPath(row: selectedMemoIndexPathRow, section: 0)
        let firstIndexPath = IndexPath(item: 0, section: 0)
        
        let memo = CoreDataSingleton.shared.memoData.remove(at: selectedMemoIndexPathRow)
        CoreDataSingleton.shared.memoData.insert(memo, at: 0)
        
        self.tableView.moveRow(at: indexPath, to: firstIndexPath)
        UserDefaults.standard.set(0, forKey: UserDefaultsKeys.selectedMemoIndexPathRow.rawValue)
    }
    
    func changeEnrollButtonStatus(textViewIsEmpty: Bool) {
        enrollButton.isEnabled = !textViewIsEmpty
    }
}