//
//  TabMyViewCommentsViewController.swift
//  RankBaam
//
//  Created by 황재욱 on 2018. 1. 31..
//  Copyright © 2018년 김정원. All rights reserved.
//

import UIKit

enum SettingActions: Int {
    case NicknameReset
    case PasswordReset
    case GetNotification
    case LibraryInfo
    case LogOut
    case MemberLeave
}

class TabMyViewProfileViewController: UIViewController {
    
    private weak var tabMyViewProfileNicknameStackView: UIStackView?
    private weak var tabMyViewProfileNicknameResetImageView: UIImageView?
    private weak var tabMyViewProfileNicknameResetButton: UIButton?
    private weak var tabMyViewProfileNicknameLabel: UILabel?
    private weak var tabMyViewProfileNicknameTextField: UITextField?
    private weak var tabMyViewProfileEmailLabel: UILabel?
    private weak var tabMyViewProfileCellDisclosureImageView: UIImageView?
    private weak var tabMyViewProfileCellNotificationSwitch: UISwitch?
    private weak var tabMyViewProfileSettingTableView: UITableView?
    
    var tabMyViewProfileCellTitleArray: [String] = ["닉네임 변경","비밀번호 변경", "알림받기", "라이브러리 정보", "로그아웃", "회원탈퇴"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewInitConfigure()
        nicknameDataFetch()
    }
    
    fileprivate func nicknameDataFetch(){
        UserService.getNickname {
            switch $0.result {
            case .success(let sResultNickname):
                if sResultNickname.succ {
                    guard let nickname = sResultNickname.nickname  else { return }
                    DispatchQueue.main.async {
                        self.tabMyViewProfileNicknameLabel?.text = nickname
                    }
                    
                } else {
                    
                }
            case .failure(let error):
                if let error = error as? SolutionProcessableProtocol {
                    error.handle(self)
                } else {
                    
                }
            }
        }
        
    }
    
    fileprivate func viewInitConfigure() {
        
        self.view.backgroundColor = UIColor.rankbaamGray
        let tabMyViewProfileNicknameStackView = UIStackView()
        self.tabMyViewProfileNicknameStackView = tabMyViewProfileNicknameStackView
        tabMyViewProfileNicknameStackView.axis = .vertical
        
        self.view.addSubview(tabMyViewProfileNicknameStackView)
        tabMyViewProfileNicknameStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(height667(123, forX: 146))
            $0.leading.equalToSuperview().offset(width375(20))
            $0.width.equalTo(width375(343))
            $0.height.equalTo(height667(66))
        }
        
        /*tabMyViewProfileNicknameStackView.layoutIfNeeded()
        let layer = CALayer()
        layer.frame = tabMyViewProfileNicknameStackView.bounds
        layer.borderColor = UIColor.black.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 3
        tabMyViewProfileNicknameStackView.layer.addSublayer(layer)*/
        
        let tabMyViewProfileNicknameLabel = UILabel()
        self.tabMyViewProfileNicknameLabel = tabMyViewProfileNicknameLabel
        tabMyViewProfileNicknameStackView.addArrangedSubview(tabMyViewProfileNicknameLabel)
        tabMyViewProfileNicknameLabel.text = "닉네임 입니다!!"
        tabMyViewProfileNicknameLabel.textColor = UIColor.rankbaamDeepBlack
        tabMyViewProfileNicknameLabel.textAlignment = .left
        tabMyViewProfileNicknameLabel.isHidden = false
        tabMyViewProfileNicknameLabel.font = UIFont(name: "NanumSquareB", size: width375(16))
        tabMyViewProfileNicknameLabel.isUserInteractionEnabled = true
        // MARK: TODO //
//        let string = "닉네임입니다"
//        let nicknameWidth = string.widthForHeight(height667(16), font: UIFont(name: "NanumSquareB", size: 16)!)
        // MARK: TODO //
        
        /*let tabMyViewProfileNicknameTextField = UITextField()
        self.tabMyViewProfileNicknameTextField = tabMyViewProfileNicknameTextField
        tabMyViewProfileNicknameStackView
            .addArrangedSubview(tabMyViewProfileNicknameTextField)
        tabMyViewProfileNicknameTextField.placeholder = "닉네임"
        tabMyViewProfileNicknameTextField.isHidden = true
        tabMyViewProfileNicknameTextField.textAlignment = .center*/
        
        let tabMyViewProfileEmailLabel = UILabel()
        self.tabMyViewProfileEmailLabel = tabMyViewProfileEmailLabel
        tabMyViewProfileNicknameStackView.addArrangedSubview(tabMyViewProfileEmailLabel)
        tabMyViewProfileEmailLabel.text = "rankbaamUser@rankbaam.com"
        tabMyViewProfileEmailLabel.textColor = UIColor.rankbaamDarkgray
        tabMyViewProfileEmailLabel.font = UIFont(name: "NanumSquareR", size: 14)
        
        /*let tabMyViewProfileNicknameReviseImageView = UIImageView()
        self.tabMyViewProfileNicknameResetImageView = tabMyViewProfileNicknameReviseImageView
        tabMyViewProfileNicknameReviseImageView.image = UIImage(named: "icEdit")
        tabMyViewProfileNicknameReviseImageView.contentMode = .scaleAspectFit
        tabMyViewProfileNicknameLabel.addSubview(tabMyViewProfileNicknameReviseImageView)
        tabMyViewProfileNicknameReviseImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(width375(nicknameWidth + 15))
            $0.width.height.equalTo(width375(16))
            $0.centerY.equalToSuperview()
        }
 
        let tabMyViewProfileNicknameReviseButton = UIButton()
        self.tabMyViewProfileNicknameResetButton = tabMyViewProfileNicknameReviseButton
        tabMyViewProfileNicknameLabel.addSubview(tabMyViewProfileNicknameReviseButton)
        tabMyViewProfileNicknameReviseButton.snp.makeConstraints {
            $0.top.bottom.trailing.equalToSuperview()
            $0.leading.equalToSuperview().offset(nicknameWidth)
        }
        
        tabMyViewProfileNicknameReviseButton.addTarget(self, action: #selector(tabMyViewProfileNicknameReviseButtonTapped), for: .touchUpInside)*/
 
        let tabMyViewProfileSettingTableView = UITableView()
        self.tabMyViewProfileSettingTableView = tabMyViewProfileSettingTableView
        self.view.addSubview(tabMyViewProfileSettingTableView)
        tabMyViewProfileSettingTableView.delegate = self
        tabMyViewProfileSettingTableView.dataSource = self
        tabMyViewProfileSettingTableView.backgroundColor = UIColor.white
        tabMyViewProfileSettingTableView.register(UITableViewCell.self, forCellReuseIdentifier: String(describing: UITableViewCell.self))
        tabMyViewProfileSettingTableView.snp.makeConstraints {
            $0.top.equalTo(tabMyViewProfileNicknameStackView.snp.bottom).offset(height667(20))
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(height667(70) * CGFloat(tabMyViewProfileCellTitleArray.count))
        }
    }
}

extension TabMyViewProfileViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let settingCell = tableView.dequeueReusableCell(withIdentifier: String(describing: UITableViewCell.self), for: indexPath)
        settingCell.textLabel?.text = tabMyViewProfileCellTitleArray[indexPath.row]
        settingCell.textLabel?.font = UIFont(name: "NanumSquareB", size: width375(16))
        settingCell.selectionStyle = .none
        
        guard indexPath.row < 2
            , let setting = SettingActions(rawValue: indexPath.row) else { return settingCell }
        
        switch setting {
            case .NicknameReset:
                let disclosureImageView = UIImageView()
                settingCell.accessoryView = disclosureImageView
                disclosureImageView.image = UIImage(named: "chevronDownIcn")
                disclosureImageView.contentMode = .center
            case .PasswordReset:
                let disclosureImageView = UIImageView()
                settingCell.accessoryView = disclosureImageView
                disclosureImageView.image = UIImage(named: "chevronDownIcn")
                disclosureImageView.contentMode = .center
            case .GetNotification:
                let tabMyViewProfileCellNotificationSwitch = UISwitch()
                self.tabMyViewProfileCellNotificationSwitch = tabMyViewProfileCellNotificationSwitch
                settingCell.accessoryView = tabMyViewProfileCellNotificationSwitch
                tabMyViewProfileCellNotificationSwitch.isOn = false
            case .LogOut, .MemberLeave, .LibraryInfo:
                return settingCell
        }
        
        
        return settingCell
    }
    
    func tabMyViewSettingsActionHandler(kind settings: SettingActions) {
        
        // TODO: ADD ACTION
        
        switch settings {
            case .NicknameReset:
                let tabMyViewProfileResetNicknameViewController = TabMyViewProfileResetNicknameViewController()
                self.navigationController?.pushViewController(tabMyViewProfileResetNicknameViewController, animated: true)
            case .PasswordReset:
                let tabMyViewProfileResetPasswordController = TabMyViewProfileResetPasswordViewController()
                self.navigationController?
                    .pushViewController(tabMyViewProfileResetPasswordController, animated: true)
            case .GetNotification:
                break
            case .LibraryInfo:
                break
            case .LogOut:
                UserService.signOut()
                //TODO
                break
            case .MemberLeave:
                break
        }
    }
    
    /*@objc func tabMyViewProfileNicknameReviseButtonTapped() {
        tabMyViewProfileNicknameLabel?.isHidden = true
        tabMyViewProfileNicknameTextField?.isHidden = false
        tabMyViewProfileNicknameTextField?.text = tabMyViewProfileNicknameLabel?.text
        tabMyViewProfileNicknameTextField?.becomeFirstResponder()
    }*/
}

extension TabMyViewProfileViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return height667(70)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        guard let setting = SettingActions(rawValue: indexPath.row) else { return }
        tabMyViewSettingsActionHandler(kind: setting)
    }
}
