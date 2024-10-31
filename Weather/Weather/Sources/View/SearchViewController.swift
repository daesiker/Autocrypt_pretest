//
//  SearchViewController.swift
//  Weather
//
//  Created by Daesik Jun on 10/31/24.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa
import Then

protocol SearchViewControllerDelegate: AnyObject {
    func didSelectCity(city: String)
}

class SearchViewController: UIViewController {
    weak var delegate: SearchViewControllerDelegate?
    
    private let viewModel = SearchViewModel()
    private let disposeBag = DisposeBag()
    
    private lazy var tableView = UITableView().then {
        $0.backgroundColor = UIColor(red: 114/255, green: 145/255, blue: 192/255, alpha: 1.0)
        $0.delegate = self
        $0.register(CityTableViewCell.self, forCellReuseIdentifier: "DefaultCell")
        $0.isHidden = true
    }
    private lazy var recentTableView = UITableView().then {
        $0.backgroundColor = UIColor(red: 114/255, green: 145/255, blue: 192/255, alpha: 1.0)
        $0.delegate = self
        $0.register(CityTableViewCell.self, forCellReuseIdentifier: "RecentCell")
        $0.isHidden = true
    }
    private let searchController = UISearchController(searchResultsController: nil).then {
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.placeholder = "Search"
        $0.searchBar.tintColor = .white
        $0.hidesNavigationBarDuringPresentation = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 114/255, green: 145/255, blue: 192/255, alpha: 1.0)
        title = "Search City"
        
        // dismiss 버튼 추가
        let dismissImage = UIImage(systemName: "chevron.left")?.withRenderingMode(.alwaysTemplate)
        let dismissButton = UIBarButtonItem(image: dismissImage, style: .plain, target: self, action: #selector(dismissViewController))
        dismissButton.tintColor = .white
        navigationItem.leftBarButtonItem = dismissButton
        navigationItem.searchController = searchController
        
    }
    
    private func setupBindings() {
        // 검색어 입력에 따라 ViewModel에 전달
        searchController.searchBar.rx.text.orEmpty
            .bind(to: viewModel.searchText)
            .disposed(by: disposeBag)
        
        // 검색어와 최근 검색어 상태에 따라 테이블 뷰 표시
        viewModel.searchText
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] searchText in
                guard let self = self else { return }
                
                if searchText.isEmpty {
                    // 검색어가 없고, recentTableView가 없으면 추가
                    
                    if self.viewModel.recentSearches.value.isEmpty {
                        self.showTableView()
                    } else {
                        self.showRecentTableView()
                    }
                } else {
                    // 검색어가 있으면 tableView를 표시하고 recentTableView는 제거
                    self.showTableView()
                }
            })
            .disposed(by: disposeBag)
        
        // 필터링된 도시 목록과 tableView 바인딩
        viewModel.filteredCityList
            .bind(to: tableView.rx.items(cellIdentifier: "DefaultCell", cellType: CityTableViewCell.self)) { row, city, cell in
                cell.configure(city: city)
            }
            .disposed(by: disposeBag)
        
        // 최근 검색어 목록과 recentTableView 바인딩
        viewModel.recentSearches
            .bind(to: recentTableView.rx.items(cellIdentifier: "RecentCell", cellType: CityTableViewCell.self)) { row, city, cell in
                cell.configure(city: city)
            }
            .disposed(by: disposeBag)
        
        // recentTableView의 셀 선택 시 이벤트 처리
        recentTableView.rx.modelSelected(City.self)
            .subscribe(onNext: { [weak self] city in
                self?.viewModel.selectCity(city: city)
                self?.delegate?.didSelectCity(city: city.name)
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        
        // tableView의 셀 선택 시 이벤트 처리
        tableView.rx.modelSelected(City.self)
            .subscribe(onNext: { [weak self] city in
                self?.viewModel.selectCity(city: city)
                self?.delegate?.didSelectCity(city: city.name)
                self?.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func showTableView() {
        recentTableView.removeFromSuperview()
        view.addSubview(tableView)
        tableView.isHidden = false
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    private func showRecentTableView() {
        tableView.removeFromSuperview()
        view.addSubview(recentTableView)
        recentTableView.isHidden = false
        recentTableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    
    @objc private func dismissViewController() {
        dismiss(animated: true, completion: nil)
    }
    
}

// MARK: - UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerView = UIView()
        headerView.backgroundColor = UIColor(red: 114/255, green: 145/255, blue: 192/255, alpha: 1.0)
        
        let label = UILabel()
        label.text = tableView == recentTableView ? "Recent Searches" : "City List"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .left
        label.textColor = .white
        
        headerView.addSubview(label)
        
        label.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        if tableView == recentTableView {
            let clearButton = UIButton(type: .system)
            clearButton.setTitle("Clear", for: .normal)
            clearButton.setTitleColor(.white, for: .normal)
            clearButton.titleLabel?.font = .pretendard(size: 16)
            clearButton.addTarget(self, action: #selector(clearRecentSearches), for: .touchUpInside)
            headerView.addSubview(clearButton)
            
            clearButton.snp.makeConstraints {
                $0.trailing.equalToSuperview().offset(-16)
                $0.centerY.equalToSuperview()
            }
        }
        
        return headerView
        
    }
    
    // 전체 삭제 버튼의 액션
    @objc private func clearRecentSearches() {
        // recentSearches 초기화 및 UserDefaults 업데이트
        viewModel.recentSearches.accept([])
        UserDefaults.standard.removeObject(forKey: "recentSearches")
        showTableView()
    }
    
    // 스와이프해서 삭제 기능 추가
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard tableView == recentTableView else { return nil }
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completionHandler in
            guard let self = self else { return }
            
            // 최근 검색어 배열에서 항목 삭제
            var recentSearches = self.viewModel.recentSearches.value
            recentSearches.remove(at: indexPath.row)
            self.viewModel.recentSearches.accept(recentSearches)
            
            // UserDefaults 업데이트
            if let encodedData = try? JSONEncoder().encode(recentSearches) {
                UserDefaults.standard.set(encodedData, forKey: "recentSearches")
            }
            
            if recentSearches.isEmpty {
                self.showTableView()
            }
            
            completionHandler(true)
        }
        
        deleteAction.backgroundColor = .red
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }
}
