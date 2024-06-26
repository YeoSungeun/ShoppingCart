//
//  SearchMainViewController.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/14/24.
//

import UIKit
import Alamofire
import SnapKit
import Kingfisher

class SearchMainViewController: UIViewController {
    
    let searchBar = UISearchBar()
    
    let noSearchImageView = UIImageView()
    let noSearchLabel = UILabel()
    
    let recentSearchLabel = UILabel()
    let removeAllSearch = UIButton()
    let recentSearchTableView = UITableView()
    
    var searchList: [String] = [] {
        didSet {
            recentSearchTableView.reloadData()
        }
    }
    lazy var count = searchList.count
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let recentSearch = UserDefaults.standard.array(forKey: UserDefaultsKey.recentSearch) as? [String] ?? []
        searchList = recentSearch
        count = searchList.count
        
        configureHierarchy()
        configureLayout()
        configureUI()
        configureView()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaultsKey.UserNickname) else { return }
        navigationItem.title = "\(nickname)'s MEANING OUT"
        
    }
    func configureHierarchy() {
        view.addSubview(searchBar)
        
        view.addSubview(noSearchImageView)
        view.addSubview(noSearchLabel)
        
        view.addSubview(recentSearchLabel)
        view.addSubview(removeAllSearch)
        view.addSubview(recentSearchTableView)
    }
    func configureLayout() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        noSearchImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            
        }
        noSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(noSearchImageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.height.equalTo(20)
        }
        
        recentSearchLabel.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(8)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
            make.height.equalTo(20)
        }
        removeAllSearch.snp.makeConstraints { make in
            make.bottom.equalTo(recentSearchLabel.snp.bottom)
            make.trailing.equalTo(view.safeAreaLayoutGuide).offset(-20)
            make.height.equalTo(20)
        }
        recentSearchTableView.snp.makeConstraints { make in
            make.top.equalTo(recentSearchLabel.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        
    }
    func configureUI() {
        view.backgroundColor = Color.white
        guard let nickname = UserDefaults.standard.string(forKey: UserDefaultsKey.UserNickname) else { return }
        navigationItem.title = "\(nickname)'s MEANING OUT"
        
        searchBar.placeholder = "브랜드, 상품 등을 입력하세요"
        
        noSearchImageView.image = UIImage.empty
        noSearchLabel.contentMode = .scaleAspectFill
        noSearchLabel.text = "최근 검색어가 없어요"
        noSearchLabel.font = Font.bold14
        noSearchLabel.textAlignment = .center
        
        recentSearchLabel.text = "최근 검색"
        recentSearchLabel.textColor = Color.black
        recentSearchLabel.font = Font.bold14
        
        removeAllSearch.setTitle("전체 삭제", for: .normal)
        removeAllSearch.setTitleColor(Color.mainColor, for: .normal)
        removeAllSearch.titleLabel?.font = Font.regular13
        removeAllSearch.addTarget(self, action: #selector(removeAllButtonClicked), for: .touchUpInside)
        if searchList.count == 0 {
            recentSearchLabel.isHidden = true
            removeAllSearch.isHidden = true
            recentSearchTableView.isHidden = true
            noSearchImageView.isHidden = false
            noSearchLabel.isHidden = false
        } else {
            recentSearchLabel.isHidden = false
            removeAllSearch.isHidden = false
            recentSearchTableView.isHidden = false
            noSearchImageView.isHidden = true
            noSearchLabel.isHidden = true
        }
        
        
        
    }
    func configureView() {
        searchBar.delegate = self
        
        recentSearchTableView.delegate = self
        recentSearchTableView.dataSource = self
        recentSearchTableView.register(RecentSearchTableViewCell.self, forCellReuseIdentifier: RecentSearchTableViewCell.id)
        
        recentSearchTableView.rowHeight = 40
    }
    
    @objc func removeAllButtonClicked() {
        UserDefaults.standard.removeObject(forKey: UserDefaultsKey.recentSearch)
        searchList = []
        recentSearchLabel.isHidden = true
        removeAllSearch.isHidden = true
        recentSearchTableView.isHidden = true
        noSearchImageView.isHidden = false
        noSearchLabel.isHidden = false
        
     
    }
}

extension SearchMainViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 최근검색어 저장
        var udSearchList = UserDefaults.standard.array(forKey: UserDefaultsKey.recentSearch) as? [String] ?? []
        guard let text = searchBar.text else { return }
        if udSearchList.contains(text) {
            guard let index = udSearchList.firstIndex(of: text) else { return }
            udSearchList.remove(at: index)
        }
        udSearchList.insert(text, at: 0)
        searchList = udSearchList
        UserDefaults.standard.set(searchList, forKey: UserDefaultsKey.recentSearch)
        
        if searchList.count == 1 {

            noSearchImageView.isHidden = true
            noSearchLabel.isHidden = true
            recentSearchLabel.isHidden = false
            removeAllSearch.isHidden = false
            recentSearchTableView.isHidden = false
            
        }
        recentSearchTableView.reloadData()
        
        let vc = SearchResultViewController()
        vc.query = text
        navigationController?.pushViewController(vc, animated: true)
        
        searchBar.text = ""
        
        view.endEditing(true)
    }
}

extension SearchMainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // MARK: 강제언래핑 바꿔줌 보셈!!! []<-확인란
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RecentSearchTableViewCell.id, for: indexPath) as? RecentSearchTableViewCell else { return UITableViewCell() }
        
        let data = searchList[indexPath.row]
        cell.deleteButton.tag = indexPath.row
        cell.deleteButton.addTarget(self, action: #selector(deleteButtonClicked), for: .touchUpInside)
        cell.configureCell(data: data)
        
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = SearchResultViewController()
        vc.query = searchList[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
        var udSearchList = UserDefaults.standard.array(forKey: UserDefaultsKey.recentSearch) as? [String] ?? []
        let text = searchList[indexPath.row]
        searchBar.text = text
        guard let index = udSearchList.firstIndex(of: text) else { return }
        udSearchList.remove(at: index)
        udSearchList.insert(text, at: 0)
        searchList = udSearchList
        UserDefaults.standard.set(searchList, forKey: UserDefaultsKey.recentSearch)
        
        tableView.reloadData()
        
        searchBar.text = ""
        
    }
    @objc func deleteButtonClicked(sender: UIButton) {
        searchList.remove(at: sender.tag)
        UserDefaults.standard.set(searchList, forKey: UserDefaultsKey.recentSearch)
        
        if searchList.count == 0 {
            noSearchImageView.isHidden = false
            noSearchLabel.isHidden = false
            recentSearchLabel.isHidden = true
            removeAllSearch.isHidden = true
            recentSearchTableView.isHidden = true
        } else {
            recentSearchTableView.reloadData()
        }
    }
    
    
}


#if DEBUG
@available (iOS 17, *)
#Preview {
    SearchMainViewController()
}
#endif
