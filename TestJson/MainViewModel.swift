//
//  MainViewModel.swift
//  TestJson
//
//  Created by Phạm Quý Thịnh on 12/09/2023.
//

import Foundation
import RealmSwift
import RxSwift
import RxCocoa


class MainViewModel{
    
    
    var listPhonetices = PublishSubject<[String]>()
    
    
    init(){
        
        syncPhonetics()
    }
    
    
    func queryPhonetics(text:String){
        
        let realm = try! Realm()
        
        let sentents = text.lowercased().split(separator: ".")
        
        var listResult: [String] = []
        
        for i in sentents{
            
            let word = i.split(separator: " ")
            
            var label = ""
            
            for j in word {
                
                let items = realm.objects(Item.self).filter("word == %@", String(j))
                
                if(items.count > 0){
                    
                    label += items[0].spell + " "
                }
                else{ label += j }
            }
            
            listResult.append(label)
        }
        
        listPhonetices.onNext(listResult)
    }
    
    
    func syncPhonetics() {
        
        //Tạo chuỗi
        let urlString = "https://raw.githubusercontent.com/hoanganhtuan95ptit/ipa-dict/master/data/en_UK.txt"
        
        //URL(): Hàm khởi tạo lớp URL, đại diện cho 1 địa chỉ URL
        let url = URL(string: urlString)!
        
        //URLSession.shared.dataTask: Tạo nhiệm vụ tải dữ liệu từ 1 URL
        //URLSession: Dùng để gửi yêu cầu đến máy chủ và nhận phản hồi từ máy chủ. Cung cấp các phương thức tải dữ liệu, tải tệp tin, nội dung trang web
        //dataTask: Tải dữ liệu từ một URL
        let task = URLSession.shared.dataTask(with: url) {data, res, err in
            
            if let data = data {
                
                let content = String(data:data, encoding:.utf8)!
                
                var dictionary = self.listLine(dataString: content.lowercased())
                
                DispatchQueue.global().async {
                    
                    print(dictionary.count,"start")
                    
                    let  realm = try! Realm()
                    
                    try! realm.write {
                        
                        for (key, value) in dictionary{
                            
                            let object = Item(word: key, spell: value)
                            
                            realm.add(object, update: .modified)
                        }
                    }
                    
                    print("end")
                }
            }
        }
        
        task.resume()
    }
    
    
    func listLine(dataString: String)->[String:String]{
        
        var dictionary:[String:String] = [:]
        
        for line in dataString.split(separator: "\n") {
            
            let components = line.split(separator: "\t")
            
            if components.count == 2 {
                
                let key = String(components[0])
                
                let value = String(components[1])
                
                dictionary[key] = value
            }
        }
        
        return dictionary
    }
}
