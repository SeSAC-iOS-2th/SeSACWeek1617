//
//  SimpleCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by 이중원 on 2022/10/18.
//

import UIKit

class User {
    let name: String
    let age: Int
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class SimpleCollectionViewController: UICollectionViewController {
    
    //var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메 치킨"]
    var list = [
        User(name: "이중원", age: 23),
        User(name: "뽀로로", age: 3),
        User(name: "해리포터", age: 333),
        User(name: "음바페", age: 23)
    ]
    
    //https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration
    //cellForItemAt 전에 생성되어야 한다. => register 코드와 유사한 역할
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //iOS 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능(List Configuration)
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .lightGray
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        
        collectionView.collectionViewLayout = layout
        
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell() //cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .darkGray
            
            content.secondaryText = "\(itemIdentifier.age)"
            content.prefersSideBySideTextAndSecondaryText = false
            //content.textToSecondaryTextVerticalPadding = 20
            
            content.image = indexPath.item < 3 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star")
            content.imageProperties.tintColor = .orange
            
            cell.contentConfiguration = content
        }

    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return list.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = list[indexPath.item]
        let cell = collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        
        return cell
    }

}
