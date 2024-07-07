//
//  DetailViewController.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/14/24.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {

    let webView = WKWebView()
    
    var itemName = ""
    var itemId = ""
    var itemURLString = "https://www.naver.com"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureUI()
        configureNavigationButton()
    
        
    }
    
    func configureHierarchy() {
        view.addSubview(webView)
    }
    func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }
    func configureUI() {
        view.backgroundColor = .white
        let itemNameLabel = UILabel()
        itemNameLabel.attributedText = itemName.htmlToAttributedString
        navigationItem.title = itemNameLabel.text
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonClicked))
        backButton.tintColor = Color.darkgray
        navigationItem.leftBarButtonItem = backButton
        
        guard let url = URL(string: "\(itemURLString)") else { return }
        // url에 연산프로퍼티~
        let request = URLRequest(url: url)
        webView.load(request)
        
    }
    func configureNavigationButton() {
        let likeList = UserDefaults.standard.array(forKey: UserDefaultsKey.likeList) as? [String] ?? []
        
        if likeList.contains(itemId) {
            let likeButton = UIBarButtonItem(image: UIImage.likeSelected, style: .plain, target: self, action: #selector(likeButtontoggled))
            
            navigationItem.rightBarButtonItem = likeButton
        } else {
            let likeButton = UIBarButtonItem(image: UIImage.likeUnselected, style: .plain, target: self, action: #selector(likeButtontoggled))
            likeButton.tintColor = .clear
            navigationItem.rightBarButtonItem = likeButton
        }
    }
    @objc func backButtonClicked() {
        navigationController?.popViewController(animated: true)
    }
    @objc func likeButtontoggled() {
        var likeList = UserDefaults.standard.array(forKey: UserDefaultsKey.likeList) as? [String] ?? []
        if likeList.contains(itemId) {
            guard let index = likeList.firstIndex(of: itemId) else { return }
            likeList.remove(at: index)
        } else {
            likeList.append(itemId)
        }
        UserDefaults.standard.set(likeList, forKey: UserDefaultsKey.likeList)
        configureNavigationButton()
    }
}
