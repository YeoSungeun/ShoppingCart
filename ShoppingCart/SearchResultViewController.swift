//
//  SearchResultViewController.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/14/24.
//

import UIKit
import Alamofire
import Kingfisher

class SearchResultViewController: UIViewController {
    
    let totalLabel = UILabel()
    var sortStackView = UIStackView()
    let simButton = UIButton()
    let dateButton = UIButton()
    let ascButton = UIButton()
    let dscButton = UIButton()
    lazy var buttons: [UIButton] = [simButton, dateButton, ascButton, dscButton]
    lazy var resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    var sort = Sort.sim
    let sortList = Sort.allCases
    var query = ""
    let display = 30
    var start = 1
    var total = 0
    var resultList = Result(total: 0, start: 0, display: 0, items: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        request(query: query)
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        start = 1
        request(query: query)
        resultCollectionView.reloadData()
    }
    func configureHierarchy() {
        view.addSubview(totalLabel)
        view.addSubview(sortStackView)
        sortStackView.addArrangedSubview(simButton)
        sortStackView.addArrangedSubview(dateButton)
        sortStackView.addArrangedSubview(ascButton)
        sortStackView.addArrangedSubview(dscButton)
        view.addSubview(resultCollectionView)
    }
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(safeArea).offset(16)
            make.leading.equalTo(safeArea).offset(20)
            make.height.equalTo(32)
        }
        sortStackView.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(8)
            make.leading.equalTo(safeArea).offset(20)
            make.height.equalTo(32)
        }
        resultCollectionView.snp.makeConstraints { make in
            make.top.equalTo(sortStackView.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(safeArea)
            
        }
        
    }
    func configureUI() {
        resultCollectionView.delegate = self
        resultCollectionView.dataSource = self
        resultCollectionView.prefetchDataSource = self
        resultCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.id)
        
        view.backgroundColor = .white
        navigationItem.title = query
        configureStackView(stackView: sortStackView)
        
        totalLabel.textColor = Color.mainColor
        totalLabel.font = Font.bold14
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        backButton.tintColor = Color.darkgray
        navigationItem.leftBarButtonItem = backButton
        
        resultCollectionView.backgroundColor = .white
        
        simButton.configuration = .selectedStyle(title: sortList[0].sortString)
        simButton.tag = 0
        dateButton.configuration = .unselectedStyle(title: sortList[1].sortString)
        dateButton.tag = 1
        ascButton.configuration = .unselectedStyle(title: sortList[2].sortString)
        ascButton.tag = 2
        dscButton.configuration = .unselectedStyle(title: sortList[3].sortString)
        dscButton.tag = 3
        
        for button in buttons {
            button.addTarget(self, action: #selector(sortButtonClicked), for: .touchUpInside)
        }
    }
    func configureStackView(stackView: UIStackView){
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 8
    }
    func layout() -> UICollectionViewLayout {
        let width = UIScreen.main.bounds.width - 50
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: width/2, height: (width/2)*1.6)
        
        return layout
    }
    func request(query: String) {
        
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query)&display=\(display)&sort=\(sort.rawValue)&start=\(start)"
        let header: HTTPHeaders = ["X-Naver-Client-Id": APIKey.naverID,
                                   "X-Naver-Client-Secret": APIKey.naverSecret]
        
        AF.request(url, headers: header).responseDecodable(of: Result.self) { response in
            switch response.result {
            case .success(let value):
                self.totalLabel.text = self.resultList.totalString
                
                if self.start == 1 {
                    self.resultList = value
                } else {
                    self.resultList.items.append(contentsOf: value.items)
                }
                self.resultCollectionView.reloadData()
                
                if self.start == 1 {
                    self.resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
                
            case .failure(let error):
                print(error)
            }
        }
    }
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    @objc func sortButtonClicked(sender: UIButton) {
        for button in buttons {
            sort = sortList[button.tag]
            if button.tag == sender.tag {
                button.configuration = .selectedStyle(title: sort.sortString)
                request(query: query)
            } else {
                button.configuration = .unselectedStyle(title: sort.sortString)
            }
        }
    }
    @objc func likeButtontoggled(sender: UIButton) {
        let itemName = resultList.items[sender.tag].productId
        var likeList = UserDefaults.standard.array(forKey: UserDefaultsKey.likeList) as? [String] ?? []
        if likeList.contains(itemName) {
            guard let index = likeList.firstIndex(of: itemName) else { return }
            likeList.remove(at: index)
        } else {
            likeList.append(itemName)
        }
        UserDefaults.standard.set(likeList, forKey: UserDefaultsKey.likeList)
        
        resultCollectionView.reloadItems(at: [IndexPath(item: sender.tag, section: 0)])
    }
    
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return resultList.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.id, for: indexPath) as! ResultCollectionViewCell
        cell.configureCell(data: resultList.items[indexPath.item])
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtontoggled), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let url = resultList.items[indexPath.item].link
        let vc = DetailViewController()
        vc.itemName = resultList.items[indexPath.item].title
        vc.itemId = resultList.items[indexPath.item].productId
        vc.itemURLString = url
        
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for item in indexPaths {
            if resultList.items.count - 2 == item.item && resultList.total > (start + display) {
                start += display
                request(query: query)
            }
        }
    }
    
    
}
