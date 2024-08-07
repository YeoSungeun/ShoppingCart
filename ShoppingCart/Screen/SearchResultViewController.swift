//
//  SearchResultViewController.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/14/24.
//

import UIKit
import Kingfisher

enum TotalCount {
    case none
    case exist
}

class SearchResultViewController: UIViewController {
    
    let totalLabel = UILabel()
    let devider = UIView()
    var sortStackView = UIStackView()
    let simButton = UIButton()
    let dateButton = UIButton()
    let ascButton = UIButton()
    let dscButton = UIButton()
    lazy var buttons: [UIButton] = [simButton, dateButton, dscButton, ascButton]
    
    lazy var resultCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout())
    
    var totalCount = TotalCount.none
    var sort = Sort.sim
    let sortList = Sort.allCases
    var query = ""
    let display = 30
    var start = 1
    var total = 0
    var resultList = Result(total: 0, start: 1, display: 0, items: [Item(title: "", link: "", image: "", lprice: "", mallName: "", productId: "")])
    
    let repository = LikedItemRepository()
    
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
        view.addSubview(devider)
        
        view.addSubview(sortStackView)
        sortStackView.addArrangedSubview(simButton)
        sortStackView.addArrangedSubview(dateButton)
        sortStackView.addArrangedSubview(dscButton)
        sortStackView.addArrangedSubview(ascButton)
        view.addSubview(resultCollectionView)
        
    }
    func configureLayout() {
        let safeArea = view.safeAreaLayoutGuide
        devider.snp.makeConstraints { make in
            make.top.equalTo(safeArea)
            make.horizontalEdges.equalTo(safeArea).inset(20)
            make.height.equalTo(0.5)
        }
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(devider.snp.bottom).offset(16)
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
        resultCollectionView.backgroundColor = .white
        view.backgroundColor = .white
        navigationItem.title = query
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        backButton.tintColor = Color.darkgray
        navigationItem.leftBarButtonItem = backButton
        
        devider.backgroundColor = Color.lightgray.withAlphaComponent(0.5)
        totalLabel.textColor = Color.mainColor
        totalLabel.font = Font.bold14
        
        configureStackView(stackView: sortStackView)
        simButton.configuration = .selectedStyle(title: sortList[0].sortString)
        simButton.tag = 0
        dateButton.configuration = .unselectedStyle(title: sortList[1].sortString)
        dateButton.tag = 1
        dscButton.configuration = .unselectedStyle(title: sortList[2].sortString)
        dscButton.tag = 2
        ascButton.configuration = .unselectedStyle(title: sortList[3].sortString)
        ascButton.tag = 3
        
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
        
//        NetworkManager.shared.getResult(query: query, sort: sort, start: start) { value in
//            self.totalLabel.text = value.totalString
//            if value.total == 0 {
//                self.totalCount = .none
//                self.sortStackView.isHidden = true
//                // 여기에 알럿
//            } else {
//                self.totalCount = .exist
//                self.sortStackView.isHidden = false
//            }
//            
//            if self.start == 1 {
//                self.resultList = value
//            } else {
//                self.resultList.items.append(contentsOf: value.items)
//            }
//            self.resultCollectionView.reloadData()
//            
//            if self.start == 1 {
//                guard value.total != 0 else { return }
//                self.resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
//            }
//        }
        NetworkManager.shared.callRequest(query: query, sort: sort, start: start) { value, error in
            if error == nil {
                guard let value = value else { return }
                self.totalLabel.text = value.totalString
                if value.total == 0 {
                    self.totalCount = .none
                    self.sortStackView.isHidden = true
                    // 여기에 알럿
                } else {
                    self.totalCount = .exist
                    self.sortStackView.isHidden = false
                }
                
                if self.start == 1 {
                    self.resultList = value
                } else {
                    self.resultList.items.append(contentsOf: value.items)
                }
                self.resultCollectionView.reloadData()
                
                if self.start == 1 {
                    guard value.total != 0 else { return }
                    self.resultCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: false)
                }
            } else {
                print(error)
            }
            
        }
        
    }
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    @objc func sortButtonClicked(sender: UIButton) {
        for button in buttons {
            let buttonSortValue = sortList[button.tag]
            if button.tag == sender.tag {
                button.configuration = .selectedStyle(title: buttonSortValue.sortString)
                start = 1
                sort = buttonSortValue
                request(query: query)
            } else {
                button.configuration = .unselectedStyle(title: buttonSortValue.sortString)
            }
        }
    }
    @objc func likeButtontoggled(sender: UIButton) {
        let item = resultList.items[sender.tag]
        let itemId = item.productId
        let likedItem = LikedItem(id: item.productId, title: item.title, link: item.link, image: item.image, lprice: item.lprice, mallName: item.mallName)
        var likeList = UserDefaults.standard.array(forKey: UserDefaultsKey.likeList) as? [String] ?? []
        if likeList.contains(itemId) {
            repository.deleteItem(likedItem, id: itemId)
            guard let index = likeList.firstIndex(of: itemId) else { return }
            likeList.remove(at: index)
            
        } else {
            repository.createItem(likedItem)
            likeList.append(itemId)
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
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.id, for: indexPath) as? ResultCollectionViewCell else { return UICollectionViewCell() }
//        cell.configureCell(data: resultList.items[indexPath.item])
        let data = resultList.items[indexPath.item]
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtontoggled), for: .touchUpInside)
        if let url = data.imageURL {
            DispatchQueue.global().async {
                do {
                    let image = try Data(contentsOf: url)
                    DispatchQueue.main.async {
                        cell.itemImageView.image = UIImage(data: image)
                    }
                } catch {
                    cell.itemImageView.image = UIImage(systemName: "star")
                }
            }
        }
        cell.mallNameLabel.text = data.mallName
        cell.titleLabel.attributedText = data.title.htmlToAttributedString
        cell.lpriceLabel.text = data.lpriceformat
        
        let likeList = UserDefaults.standard.array(forKey: UserDefaultsKey.likeList) as? [String] ?? []
        
        if likeList.contains(data.productId) {
            cell.likeButton.configuration = .cellSelectedStyle()
        } else {
            cell.likeButton.configuration = .cellUnselectedStyle()
        }
        
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
