//
//  NewsViewModel.swift
//  SeSACWeek1617
//
//  Created by 이중원 on 2022/10/20.
//

import Foundation
import RxSwift

class NewsViewModel {
    
    //var pageNumber: CObservable<String> = CObservable("3000")
    var pageNumber = BehaviorSubject<String>(value: "3,000")
    
    //var sample: CObservable<[News.NewsItem]> = CObservable(News.items)
    var sample = BehaviorSubject(value: News.items)
    
    func changeFormatPageNumberFormat(text: String) {
        
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        let text = text.replacingOccurrences(of: ",", with: "")
        guard let number = Int(text) else { return }
        let result = numberFormatter.string(for: number)!
        
        //pageNumber.value = result
        pageNumber.onNext(result)
        
    }
    
    func resetSample() {
        //sample.value = []
        sample.onNext([])
    }
    
    func loadSample() {
        //sample.value = News.items
        sample.onNext(News.items)
    }
}
