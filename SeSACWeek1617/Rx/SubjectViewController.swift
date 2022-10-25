//
//  SubjectViewController.swift
//  SeSACWeek1617
//
//  Created by 이중원 on 2022/10/25.
//

import UIKit
import RxCocoa
import RxSwift

class SubjectViewController: UIViewController {
    
    @IBOutlet weak var newButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    @IBOutlet weak var resetButton: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    let publish = PublishSubject<Int>() //초기값이 없는 빈 상태
    let behavior = BehaviorSubject(value: 100) //초기값 필수
    let replay = ReplaySubject<Int>.create(bufferSize: 3) //bufferSize 작성된 이벤트 갯수 만큼 메모리에서 이벤트를 가지고 있다가, subscribe 직후 한 번에 이벤트 전달
    let async = AsyncSubject<Int>()
    //*Variable - 지금은 사용하지 않는 키워드
    let disposeBag = DisposeBag()
    let viewModel = SubjectViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ContactCell")

        viewModel.list
            .bind(to: tableView.rx.items(cellIdentifier: "ContactCell", cellType: UITableViewCell.self)) { (row, element, cell) in
                cell.textLabel?.text = "\(element.name): \(element.age)세 (\(element.number))"
            }
            .disposed(by: disposeBag)
        
        addButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.fetchData()
            }
            .disposed(by: disposeBag)
        
        resetButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.resetData()
            }
            .disposed(by: disposeBag)
        
        newButton.rx.tap
            .withUnretained(self)
            .subscribe { (vc, _) in
                vc.viewModel.newData()
            }
            .disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .distinctUntilChanged() //같은 값을 받지 않음
            .withUnretained(self)
            .debounce(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) //wait
            .subscribe { (vc, value) in
                print("=====\(value)")
                vc.viewModel.filterData(query: value)
            }
            .disposed(by: disposeBag)
        
    }
    
}

extension SubjectViewController {
    
    func asyncSubject() {
        //complete event가 일어날때만 전달
        //complete 일어나기 직전의 값만 emit
        
        async.onNext(1)
        async.onNext(2) //publish와 다르게 print가 찍힘
        
        async
            .subscribe { value in
                print("async - \(value)")
            } onError: { error in
                print("async - \(error)")
            } onCompleted: {
                print("async completed")
            } onDisposed: {
                print("async disposed")
            }
            .disposed(by: disposeBag)
        
        async.onNext(3)
        async.onNext(4) //complete 된 직전의 값 print
        
        async.onCompleted()
        
        async.onNext(5)
        async.onNext(6)
    }
    
    func replaySubject() {
        //bufferSize 메모리에 저장 -> array, 이미지 등과 같이 대용량 타입은..? 조심
        
        replay.onNext(100)
        replay.onNext(200)
        replay.onNext(300)
        replay.onNext(400)
        replay.onNext(500)
        //bufferSize = 3이므로, 구독 전 3개의 값을 emit
        
        replay
            .subscribe { value in
                print("replay - \(value)")
            } onError: { error in
                print("replay - \(error)")
            } onCompleted: {
                print("replay completed")
            } onDisposed: {
                print("replay disposed")
            }
            .disposed(by: disposeBag)
        
        replay.onNext(3)
        replay.onNext(4)
        
        replay.onCompleted()
        
        replay.onNext(5)
        replay.onNext(6)

    }
    
    func behaviorSubject() {
        //구독 전에 가장 최근 값을 같이 emit : behavior가 초기값을 가지는 이유
        
        behavior.onNext(1)
        behavior.onNext(2) //publish와 다르게 print가 찍힘
        
        behavior
            .subscribe { value in
                print("behavior - \(value)")
            } onError: { error in
                print("behavior - \(error)")
            } onCompleted: {
                print("behavior completed")
            } onDisposed: {
                print("behavior disposed")
            }
            .disposed(by: disposeBag)
        
        behavior.onNext(3)
        behavior.onNext(4)
        
        behavior.onCompleted()
        
        behavior.onNext(5)
        behavior.onNext(6)
    }

    
    func publishSubject() {
        //초기값이 없는 빈 상태, subscribe 전/error/completed notification 이후 이벤트 무시
        //subscribe 후에 대한 이벤트는 다 처리
        
        publish.onNext(1)
        publish.onNext(2)
        //구독을 안 한 상태라 print 찍히지 x
        
        publish
            .subscribe { value in
                print("publish - \(value)")
            } onError: { error in
                print("publish - \(error)")
            } onCompleted: {
                print("publish completed")
            } onDisposed: {
                print("publish disposed")
            }
            .disposed(by: disposeBag)
        
        publish.onNext(3)
        publish.onNext(4)
        
        publish.onCompleted()
        
        publish.onNext(5)
        publish.onNext(6)
        //complete 해준 상태라 print 찍히지 x

    }
}
