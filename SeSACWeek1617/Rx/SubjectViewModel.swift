//
//  SubjectViewModel.swift
//  SeSACWeek1617
//
//  Created by 이중원 on 2022/10/25.
//

import Foundation
import RxSwift

struct Contact {
    var name: String
    var age: Int
    var number: String
}

class SubjectViewModel {
    
    var contactData = [
        Contact(name: "Joong", age: 23, number: "010-4401-0159"),
        Contact(name: "Bbororo", age: 3, number: "010-1234-5678"),
        Contact(name: "Dully", age: 12345, number: "019-2837-465")
    ]
    
    var list = PublishSubject<[Contact]>()
    
    func fetchData() {
        list.onNext(contactData)
    }
    
    func resetData() {
        list.onNext([])
    }
    
    func newData() {
        let new = Contact(name: "고래밥", age: Int.random(in: 10...50), number: "손이가요 손이가")
        self.contactData.append(new)
        
        list.onNext(contactData)
    }
    
    func filterData(query: String) {
//        var filterList: [Contact] = []
//        contactData.forEach { element in
//            if element.name == query {
//                filterList.append(element)
//            }
//        }
//
//        list.onNext(filterList)
        
        let result = query != "" ? contactData.filter { $0.name.contains(query) } : contactData
        list.onNext(result)
    }
}
