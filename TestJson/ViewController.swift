//
//  ViewController.swift
//  TestJson
//
//  Created by Phạm Quý Thịnh on 24/08/2023.
//

import UIKit
import RealmSwift
import Foundation

class Item:Object {
    
    @objc dynamic var word: String = ""
    @objc dynamic var spell:String = ""
    
    override static func primaryKey() -> String? {
        return "word"
    }
    
    convenience init(word: String, spell: String) {
        self.init()
        self.word = word
        self.spell = spell
    }
}

extension Results {
    func toArray<T>(ofType: T.Type) -> [T] {
        var array = [T]()
        for i in 0 ..< count {
            if let result = self[i] as? T {
                array.append(result)
            }
        }
        return array
    }
}

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var datas:[String] = []
    
    var viewModel = MainViewModel()
    
    
    let insetsSession = UIEdgeInsets(top: 50, left: 20, bottom: 50, right: 20)
    let itemPerRow: CGFloat = 1.0
    
    
    @IBOutlet weak var textInput: UITextField!
    
    @IBOutlet weak var labelPhonetic: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        viewModel.listPhonetices.subscribe { (list) in
            self.datas = list
            self.collectionView.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return datas.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MyCell", for: indexPath) as! TestCollectionViewCell
        
        cell.label.text = datas[indexPath.item]
        cell.backgroundColor = .orange
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let padding = CGFloat((itemPerRow + 1)) * insetsSession.left
        let availabelWidth = view.frame.width - padding
        let width = availabelWidth / itemPerRow
        
        return CGSize(width: width, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        insetsSession
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        insetsSession.left
    }
    
    
    @IBAction func insertText(_ sender: UITextField) {
        
    }
    
    @IBAction func textChange(_ sender: UITextField) {
        
        if let textes = sender.text{
            
            viewModel.queryPhonetics(text: textes)
        }
    }
}


