//
//  RxCocoaExampleViewController.swift
//  SeSACWeek1617
//
//  Created by 이중원 on 2022/10/24.
//

import UIKit
import RxCocoa
import RxSwift

class RxCocoaExampleViewController: UIViewController {

    @IBOutlet weak var simpleTableView: UITableView!
    @IBOutlet weak var simplePickerView: UIPickerView!
    @IBOutlet weak var simpleLabel: UILabel!
    @IBOutlet weak var simpleSwitch: UISwitch!
    
    @IBOutlet weak var signName: UITextField!
    @IBOutlet weak var signEmail: UITextField!
    @IBOutlet weak var signButton: UIButton!
    
    @IBOutlet weak var nicknameLabel: UILabel!
    
    var disposeBag = DisposeBag()
    
    var nickname = Observable.just("Joong")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Subject: Observable과 Observer의 역할을 둘 다 수행 가능
        
        nickname
            .bind(to: nicknameLabel.rx.text)
            .disposed(by: disposeBag)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.nickname = Observable.just("HELLO")
        }

        setTableView()
        setPickerView()
        setSwitch()
        setSign()
        setOperator()
    }
    
    deinit {
        print("RxCocoaExampleViewController")
    }
    
    func setOperator() {
        
        Observable.repeatElement("Joong")
            .take(5)
            .subscribe { value in
                print("repeat - \(value)")
            } onError: { error in
                print("repeat - \(error)")
            } onCompleted: {
                print("repeat completed")
            } onDisposed: {
                print("repeat disposed")
            }
            .disposed(by: disposeBag)

                
        let intervalObservable1 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
        let intervalObservable2 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
        let intervalObservable3 = Observable<Int>.interval(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe { value in
                print("interval - \(value)")
            } onError: { error in
                print("interval - \(error)")
            } onCompleted: {
                print("interval completed")
            } onDisposed: {
                print("interval disposed")
            }
            .disposed(by: disposeBag)
        
        //DisposeBag: 리소스 해제 관리 -
            //1. 시퀀스 끝날 때
            //2. class deinit 자동 해제 (bind)
            //3. dispose 직접 호출 -> dispose() 구독하는 것마다 별도로 관리!
            //4. DisposeBag을 새롭게 할당하거나, nil 전달
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.disposeBag = DisposeBag() //DisposeBag 4. 한 번에 리소스 정리
        }

        
        let itemsA = [3.3, 4.0, 5.0, 2.0, 3.6, 4.8]
        let itemsB = [2.3, 2.0, 1.3]
        
        Observable.just(itemsA)
            .subscribe { value in
                print("just - \(value)")
            } onError: { error in
                print("just - \(error)")
            } onCompleted: {
                print("just completed")
            } onDisposed: {
                print("just disposed")
            }
            .disposed(by: disposeBag)
        
        
        Observable.of(itemsA, itemsB) //just와의 차이: 여러 배열 가능
            .subscribe { value in
                print("of - \(value)")
            } onError: { error in
                print("of - \(error)")
            } onCompleted: {
                print("of completed")
            } onDisposed: {
                print("of disposed")
            }
            .disposed(by: disposeBag)
        
        
        Observable.from(itemsA)
            .subscribe { value in
                print("from - \(value)")
            } onError: { error in
                print("from - \(error)")
            } onCompleted: {
                print("from completed")
            } onDisposed: {
                print("from disposed")
            }
            .disposed(by: disposeBag)


    }
    
    func setSign() {
        
        //ex. 택1(Observable), 택2(Observable) > 레이블(Observer, bind)
        Observable.combineLatest(signName.rx.text.orEmpty, signEmail.rx.text.orEmpty) { value1, value2 in
            "name은 \(value1)이고, email은 \(value2)입니다"
        }
        .bind(to: simpleLabel.rx.text)
        .disposed(by: disposeBag)
        
        signName //UITextField
            .rx //Reactive
            .text //String?
            .orEmpty //String
            .map { $0.count < 4 } //Bool
            .bind(to: signEmail.rx.isHidden, signButton.rx.isHidden)
            .disposed(by: disposeBag)
        
        signEmail
            .rx
            .text
            .orEmpty
            .map { $0.count > 4 }
            .bind(to: signButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        signButton
            .rx
            .tap
            .subscribe { _ in
                self.showAlert()
            }
            .disposed(by: disposeBag)
    }
    
    func showAlert() {
        let alert = UIAlertController(title: "배고파요", message: nil , preferredStyle: .alert)
        let ok = UIAlertAction(title: "네", style: .default)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    func setSwitch() {
        Observable.of(false).bind(to: simpleSwitch.rx.isOn).disposed(by: disposeBag)
    }
    
    func setTableView() {
        
        simpleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
        let items = Observable.just([
            "First Item",
            "Second Item",
            "Third Item"
        ])

        items
        .bind(to: simpleTableView.rx.items) { (tableView, row, element) in
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")!
            cell.textLabel?.text = "\(element) @ row \(row)"
            return cell
        }
        .disposed(by: disposeBag)
        
        simpleTableView.rx.modelSelected(String.self)
            .map({ data in
            "\(data)를 클릭했습니다."
        })
            .bind(to: simpleLabel.rx.text)
            .disposed(by: disposeBag)

    }
    
    func setPickerView() {
        
        let items = Observable.just([
               "영화",
               "애니메이션",
               "드라마",
               "기타"
           ])
        
        items
           .bind(to: simplePickerView.rx.itemTitles) { (row, element) in
               return element
           }
           .disposed(by: disposeBag)
        
        
        simplePickerView.rx.modelSelected(String.self).map { $0.description }.bind(to: simpleLabel.rx.text)
//        .subscribe(onNext: { value in
//            print(value)
//        })
        .disposed(by: disposeBag)
    }
        
}
