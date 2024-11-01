//
//  SearchViewModel.swift
//  Weather
//
//  Created by Daesik Jun on 10/31/24.
//

import Foundation
import RxSwift
import RxCocoa

class SearchViewModel {
    
    //검색어 input
    let searchText = BehaviorRelay<String>(value: "")
    
    //도시목록 view에 output
    var filteredCityList: Observable<[City]> {
        return searchText
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] query in
                self.filterCities(query)
            }
    }
    
    //최근 검색어
    var recentSearches: BehaviorRelay<[City]> = BehaviorRelay(value: [])
    
    //JSON에 저장된 CityList
    private var cityList: [City] = City.cityList
    private let disposeBag = DisposeBag()
    
    init() {
        loadRecentSearches()
    }
    
    
    ///최근 검색어가 있으면 데이터 로드
    private func loadRecentSearches() {
        guard let data = UserDefaults.standard.data(forKey: "recentSearches") else { return }
        do {
            let recentCities = try JSONDecoder().decode([City].self, from: data)
            recentSearches.accept(recentCities)
        } catch {
            recentSearches.accept([])
        }
    }
    
    /**
     Cell을 클릭했을 때 최근 검색어로 저장
     - Parameters:
        - city: 도시이름
     */
    func saveRecentSearch(city: City) {
        var currentSearches = recentSearches.value
        if let index = currentSearches.firstIndex(where: { $0.id == city.id }) {
            // 기존에 검색된 도시가 있다면 배열에서 제거하여 중복을 방지
            currentSearches.remove(at: index)
        }
        // 최신 검색어를 맨 앞에 추가
        currentSearches.insert(city, at: 0)
        
        // 최근 검색어는 최대 10개까지만 유지
        if currentSearches.count > 10 {
            currentSearches.removeLast()
        }
        
        recentSearches.accept(currentSearches)
        
        if let encodedData = try? JSONEncoder().encode(currentSearches) {
            UserDefaults.standard.set(encodedData, forKey: "recentSearches")
        }
    }
    
    /**
     검색어에 따라 CityList 필터링
     - Parameters:
        - query: 검색어
     */
    private func filterCities(_ query: String) -> Observable<[City]> {
        if query.isEmpty {
            return .just(cityList)
        }
        let filtered = cityList.filter { $0.name.lowercased().contains(query.lowercased()) }
        return .just(filtered)
    }
    
    
}
