//
//  SimpleCollectionViewController.swift
//  SeSACWeek1617
//
//  Created by 이중원 on 2022/10/18.
//

import UIKit

struct User: Hashable {
    let id = UUID().uuidString //Hashable
    let name: String //고유
    let age: Int //고유
    
    init(name: String, age: Int) {
        self.name = name
        self.age = age
    }
}

class SimpleCollectionViewController: UICollectionViewController {
    
    //var list = ["닭곰탕", "삼계탕", "들기름김", "삼분카레", "콘소메 치킨"]
    var list = [
        User(name: "이중원", age: 23),
        User(name: "이중원", age: 23),
        User(name: "해리포터", age: 333),
        User(name: "음바페", age: 23),
        User(name: "홀란", age: 23),
        User(name: "필 포든", age: 23)
    ]
    
    //https://developer.apple.com/documentation/uikit/uicollectionview/cellregistration
    //cellForItemAt 전에 생성되어야 한다. => register 코드와 유사한 역할
    var cellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, User>!
    
    var dataSource: UICollectionViewDiffableDataSource<Int, User>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.collectionViewLayout = createLayout()
                
        cellRegistration = UICollectionView.CellRegistration { cell, indexPath, itemIdentifier in
            
            var content = UIListContentConfiguration.valueCell() //cell.defaultContentConfiguration()
            
            content.text = itemIdentifier.name
            content.textProperties.color = .darkGray
            
            content.secondaryText = "\(itemIdentifier.age)"
            content.prefersSideBySideTextAndSecondaryText = false
            //content.textToSecondaryTextVerticalPadding = 20
            
            content.image = indexPath.item < 3 ? UIImage(systemName: "person.fill") : UIImage(systemName: "star")
            content.imageProperties.tintColor = .orange
            
            print("setup")
            cell.contentConfiguration = content
            
            var backgroundConfig = UIBackgroundConfiguration.listPlainCell()
            backgroundConfig.backgroundColor = .yellow
            backgroundConfig.cornerRadius = 10
            backgroundConfig.strokeWidth = 2
            backgroundConfig.strokeColor = .systemPink
            
            cell.backgroundConfiguration = backgroundConfig
        }
        
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.cellRegistration, for: indexPath, item: itemIdentifier)

            return cell
        })
        
        var snapshot = NSDiffableDataSourceSnapshot<Int, User>()
        snapshot.appendSections([0])
        snapshot.appendItems(list)
        dataSource.apply(snapshot)

    }

}

extension SimpleCollectionViewController {
    
    private func createLayout() -> UICollectionViewLayout {
        //iOS 14+ 컬렉션뷰를 테이블뷰 스타일처럼 사용 가능(List Configuration)
        //컬렉션뷰 스타일 (컬렉션뷰 셀 X)
        var configuration = UICollectionLayoutListConfiguration(appearance: .insetGrouped)
        configuration.showsSeparators = false
        configuration.backgroundColor = .lightGray
        
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        return layout
    }
}
