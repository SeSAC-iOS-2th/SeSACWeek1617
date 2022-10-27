//
//  ValidationViewController.swift
//  SeSACWeek1617
//
//  Created by 이중원 on 2022/10/27.
//

import UIKit
import RxSwift
import RxCocoa

class ValidationViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var validationLabel: UILabel!
    @IBOutlet weak var stepButton: UIButton!
    
    let disposeBag = DisposeBag()
    let viewModel = ValidationViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        bind()
        
    }
    
    func bind() {
        
        viewModel.validText
            .asDriver()
            .drive(validationLabel.rx.text)
            .disposed(by: disposeBag)
        
        let validation = nameTextField.rx.text //String?
            .orEmpty //String (옵셔널 해제)
            .map { $0.count >= 8 } //Bool
            .share() //Subject, Relay

        validation
//            .subscribe { value in
//                self.stepButton.isEnabled = value
//                self.validationLabel.isHidden = value
//            } //밑줄 코드와 동일한 동작
            .bind(to: stepButton.rx.isEnabled, validationLabel.rx.isHidden)
            //bind를 쓰는 경우: error와 complete가 절대 날 일이 없을때
            .disposed(by: disposeBag)


        validation
            .withUnretained(self)
            .bind { (vc, value) in
                let color: UIColor = value ? .systemPink : .lightGray
                vc.stepButton.backgroundColor = color
            }
            .disposed(by: disposeBag)
        
        
        stepButton.rx.tap
            .subscribe { _ in
                print("SHOW ALERT")
            } onError: { error in
                print("error")
            } onCompleted: {
                print("complete")
            } onDisposed: {
                print("dispose")
            }
            .disposed(by: disposeBag)
        //by: DisposeBag()일 때, 바로 dispose되므로 dispose만 print되고 그 후엔 버튼 tap이 되지 x
        // .disposed(by: disposeBag()) == .dispose()
        
    }
    
    
    func observableVSSubject() {
        
        let sampleInt = Observable<Int>.create { observer in
            observer.onNext(Int.random(in: 1...100))
            return Disposables.create()
        }
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        sampleInt.subscribe { value in
            print("sampleInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        
        let subjectInt = BehaviorSubject(value: 0)
        subjectInt.onNext(Int.random(in: 1...100))
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)

        subjectInt.subscribe { value in
            print("subjectInt: \(value)")
        }
        .disposed(by: disposeBag)
        
//        let testA = stepButton.rx.tap
//            .map { "안녕하세요" }
//            .asDriver(onErrorJustReturn: "")
//
//        testA
//            .bind(to: validationLabel.rx.text)
//            .disposed(by: disposeBag)
//
//        testA
//            .bind(to: nameTextField.rx.text)
//            .disposed(by: disposeBag)
//
//        testA
//            .bind(to: stepButton.rx.title())
//            .disposed(by: disposeBag)


    }

}
