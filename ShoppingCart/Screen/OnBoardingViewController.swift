//
//  OnBoardingViewController.swift
//  ShoppingCart
//
//  Created by 여성은 on 6/13/24.
//

import UIKit
import SnapKit
import SwiftUI

class OnBoardingViewController: UIViewController {
    
    let logo = UILabel()
    let logoImageView = UIImageView()
    let startButton = PointButton(title: "시작하기")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurHierachy()
        configureLayout()
        configureUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        startButton.layoutIfNeeded()
        startButton.layer.cornerRadius = startButton.frame.height / 2
    }
    func configurHierachy() {
        view.addSubview(logo)
        view.addSubview(logoImageView)
        view.addSubview(startButton)
    }
    func configureLayout() {
        logo.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(120)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(60)
        }
        logoImageView.snp.makeConstraints { make in
            make.top.equalTo(logo.snp.bottom).offset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.height.equalTo(logoImageView.snp.width).multipliedBy(0.8)
        }
        startButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).inset(50)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(40)
            make.height.equalTo(50)
        }
        
    }
    func configureUI() {
        view.backgroundColor = .white
        logo.text = "Meanigout"
        logo.textAlignment = .center
        logo.font = Font.logo
        logo.textColor = Color.mainColor
        
        logoImageView.clipsToBounds = true
        logoImageView.image = Image.launch
        logoImageView.contentMode = .scaleAspectFit
        
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
        
    }
    @objc func startButtonClicked() {
        let vc = ProfileNicknameSettingViewController()
        vc.viewType = .setting
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
}


#if DEBUG
@available (iOS 17, *)
#Preview {
    OnBoardingViewController()
}
#endif
