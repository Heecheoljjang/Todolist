//
//  ViewController.swift
//  todolist1
//
//  Created by 희철 on 2021/10/27.
//

import UIKit

class TodoListViewController: UIViewController{
    
    @IBOutlet weak var todoListCollectionView: UICollectionView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    
    var tasks = [TodoList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
    }

    @IBAction func tapAddButton(_ sender: Any) {
        guard let detail = textField.text else { return }
        
        let item: TodoList = TodoList(title: detail, isCheck: false)
        tasks.append(item)
        todoListCollectionView.reloadData()
        textField.text = ""
        
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "TodoListHeaderView", for: indexPath) as? TodoListHeaderView else { return UICollectionReusableView() }
        return header
    }
    
    @IBAction func tapBG(_ sender: Any) {
        textField.resignFirstResponder()
    }

    
}

extension TodoListViewController: UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        let width: CGFloat = collectionView.bounds.width
        let height: CGFloat = 50
        
        return CGSize(width: width, height: height)
    }
    
    
}

extension TodoListViewController: UICollectionViewDelegate {
    
}

extension TodoListViewController: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
     
        return tasks.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? TodoListCell else { return UICollectionViewCell() }
        cell.backgroundColor = .systemGray5
        cell.listLabel.text = tasks[indexPath.row].title
        cell.lineView.backgroundColor = .clear
        cell.bottomSpace.constant = 0
        cell.deleteButton.isHidden = true
        cell.checkMark.isSelected = false
        
        return cell
    }

}

extension TodoListViewController {
    @objc private func adjustInputView(noti: Notification){
        guard let userInfo = noti.userInfo else { return }
        
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
        } else {
            inputViewBottom.constant = 0
        }
    }
}

class TodoListHeaderView: UICollectionReusableView {
    
    @IBOutlet weak var headerLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

class TodoListCell: UICollectionViewCell {
    @IBOutlet weak var listLabel: UILabel!
    @IBOutlet weak var checkMark: UIButton!
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var bottomSpace: NSLayoutConstraint!
    @IBOutlet weak var deleteButton: UIButton!
    
    @IBAction func checkBtnTap(_ sender: Any){
        
        if checkMark.isSelected == true {
            bottomSpace.constant = 0
            lineView.backgroundColor = .clear
            listLabel.textColor = .black
            deleteButton.isHidden = true
            checkMark.isSelected = !checkMark.isSelected
            
        } else {

            bottomSpace.constant = 14
            lineView.backgroundColor = .lightGray
            listLabel.textColor = .lightGray
            deleteButton.isHidden = false
            checkMark.isSelected = !checkMark.isSelected
        }
    }
    
    @IBAction func deleteList(_ sender: Any){
        
    }
    
}

struct TodoList {
    var title: String = ""
    var isCheck: Bool = false
    
    
    init(title: String, isCheck: Bool){
        self.title = title
        self.isCheck = isCheck
    }
}
