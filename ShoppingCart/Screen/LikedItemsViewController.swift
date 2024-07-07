//
//  LikedItemsViewController.swift
//  ShoppingCart
//
//  Created by 여성은 on 7/8/24.
//

import UIKit
import RealmSwift

class LikedItemsViewController: UIViewController {
    lazy var totalLabel = {
        let view = UILabel()
        view.textColor = Color.mainColor
        view.font = Font.bold14
        view.text = "\(likedItemList.count)개의 좋아요"

        return view
    }()
    lazy var likedCollectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewlayout())
    
    let repository = LikedItemRepository()
    var likedItemList: Results<LikedItem>!{
        didSet{
            likedCollectionView.reloadData()
            totalLabel.text = "\(likedItemList.count)개의 좋아요"
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        print(#function)
        super.viewWillAppear(animated)
        likedItemList = repository.fetchAll()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        repository.getFileURL()
        likedItemList = repository.fetchAll()
        
        configureHierarchy()
        configureLayout()
        configureUI()
    }
    func configureHierarchy() {
        view.addSubview(totalLabel)
        view.addSubview(likedCollectionView)
    }
    func configureLayout() {
        totalLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(32)
        }
        likedCollectionView.snp.makeConstraints { make in
            make.top.equalTo(totalLabel.snp.bottom).offset(20)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
            
        }
    }
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "좋아요"
        likedCollectionView.delegate = self
        likedCollectionView.dataSource = self
        likedCollectionView.register(ResultCollectionViewCell.self, forCellWithReuseIdentifier: ResultCollectionViewCell.id)
        likedCollectionView.backgroundColor = .white
    }
    func collectionViewlayout() -> UICollectionViewLayout {
        let width = UIScreen.main.bounds.width - 50
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: width/2, height: (width/2)*1.6)
        
        return layout
    }
    @objc func likeButtontoggled(sender: UIButton) {
        let item = likedItemList[sender.tag]
        let itemId = item.id
        let likedItem = LikedItem(id: item.id, title: item.title, link: item.link, image: item.image, lprice: item.lprice, mallName: item.mallName)
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
        totalLabel.text = "\(likedItemList.count)개의 좋아요"
        likedCollectionView.reloadData()
    }
    
}

extension LikedItemsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return likedItemList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ResultCollectionViewCell.id, for: indexPath) as? ResultCollectionViewCell else { return UICollectionViewCell() }
        let data = likedItemList[indexPath.item]
        cell.likeButton.tag = indexPath.item
        cell.likeButton.addTarget(self, action: #selector(likeButtontoggled), for: .touchUpInside)
        if let url = URL(string: data.image){
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
        if let price = Int(data.lprice) {
            cell.lpriceLabel.text = "\(price.formatted())원"
        }
        let likeList = UserDefaults.standard.array(forKey: UserDefaultsKey.likeList) as? [String] ?? []
        
        if likeList.contains(data.id) {
            cell.likeButton.configuration = .cellSelectedStyle()
        } else {
            cell.likeButton.configuration = .cellUnselectedStyle()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let url = likedItemList[indexPath.item].link
        let vc = DetailViewController()
        vc.itemName = likedItemList[indexPath.item].title
        vc.itemId = likedItemList[indexPath.item].id
        vc.itemURLString = url
        
        navigationController?.pushViewController(vc, animated: true)
    }
}
