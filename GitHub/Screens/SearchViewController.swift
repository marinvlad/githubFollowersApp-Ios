//
//  SearchViewController.swift
//  GitHub
//
//  Created by Vlad on 7/22/20.
//  Copyright © 2020 Vlad. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    let logoImageView = UIImageView()
    let userTextField = GFTextField()
    let callToActionButton = GFButton(color: .systemGreen, title: "Get Followers")
    
    var isUserNameEntered: Bool {
        return !userTextField.text!.isEmpty
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureLogoImageView()
        configureTextField()
        configureCallToActionButton()
        createDismissKeyboardTapGesture()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func createDismissKeyboardTapGesture() {
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
    }
    
    @objc func pushFollowerListVC() {
        guard isUserNameEntered else {
            presentGFAlertOnMainThread(title: "Empty username", message: "Please enter a username. We need to know who to search for 😌", buttonTitle: "OK")
            return }
        
        userTextField.resignFirstResponder()
        
        let followerListVC = FollowersViewController()
        followerListVC.title = userTextField.text
        followerListVC.username = userTextField.text
        navigationController?.pushViewController(followerListVC, animated: true)
    }
    
    //MARK: - Configure subviews methods
    func configureLogoImageView() {
        view.addSubview(logoImageView)
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "gh-logo")!
        let topConstraintConstant: CGFloat = DeviceTypes.isiPhoneSE || DeviceTypes.isiPhone8Zoomed ? 20 : 80
        NSLayoutConstraint.activate([
            logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: topConstraintConstant),
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.heightAnchor.constraint(equalToConstant: 200),
            logoImageView.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
    
    func configureTextField() {
        view.addSubview(userTextField)
        userTextField.delegate = self
        
        NSLayoutConstraint.activate([
            userTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 48),
            userTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            userTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            userTextField.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    func configureCallToActionButton() {
        view.addSubview(callToActionButton)
        callToActionButton.addTarget(self, action: #selector(pushFollowerListVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            callToActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            callToActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            callToActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
            callToActionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
}
//MARK: - SearchField delegate methods
extension SearchViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        pushFollowerListVC()
        return true
    }
}
