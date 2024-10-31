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
    
    // Input
    let searchText = BehaviorRelay<String>(value: "")
    
    // Output
    var filteredCityList: Observable<[City]> {
        return searchText
            .distinctUntilChanged()
            .flatMapLatest { [unowned self] query in
                self.filterCities(with: query)
            }
    }
    
    var recentSearches: BehaviorRelay<[City]> = BehaviorRelay(value: [])
    
    private var cityList: [City] = City.cityList
    private let disposeBag = DisposeBag()
    
    init() {
        loadRecentSearches()
    }
    
    private func loadRecentSearches() {
        guard let data = UserDefaults.standard.data(forKey: "recentSearches") else { return }
        do {
            let recentCities = try JSONDecoder().decode([City].self, from: data)
            recentSearches.accept(recentCities)
        } catch {
            print("Error decoding recent searches: \(error)")
        }
    }
    
    private func saveRecentSearch(city: City) {
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
    
    private func filterCities(with query: String) -> Observable<[City]> {
        if query.isEmpty {
            return .just(cityList)
        }
        let filtered = cityList.filter { $0.name.lowercased().contains(query.lowercased()) }
        return .just(filtered)
    }
    
    func selectCity(city: City) {
        saveRecentSearch(city: city)
    }
}
