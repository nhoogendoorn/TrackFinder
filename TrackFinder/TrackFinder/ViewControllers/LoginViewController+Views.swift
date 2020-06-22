//
//  LoginViewController+Views.swift
//  TrackFinder
//
//  Created by Niels Hoogendoorn on 22/06/2020.
//  Copyright © 2020 Nihoo. All rights reserved.
//

import Foundation

extension LoginViewController {
    func setViews() {
        setContentStack()
        setLogoView()
        setLoginButton()
        setLoginExplanationLabel()
        
        contentStack.addArrangedSubview(logoImageView)
        contentStack.addArrangedSubview(loginButton)
        contentStack.addArrangedSubview(loginExplanationLabel)
    }
    
    func setLoginButton() {
        loginButton.backgroundColor = .mainColor
        loginButton.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        loginButton.titleEdgeInsets = UIEdgeInsets(top: Spacing.large.rawValue,
                                              left: Spacing.large.rawValue,
                                              bottom: Spacing.large.rawValue,
                                              right: Spacing.large.rawValue)
        loginButton.setTitle(.loginAction, for: .normal)
        loginButton.setTitleColor(.white, for: .normal)
        loginButton.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
    }
    
    func setLogoView() {
        logoImageView.snp.makeConstraints {
            $0.width.height.equalTo(150)
        }
        logoImageView.contentMode = .scaleAspectFit
    }
    
    func setLoginExplanationLabel() {
        loginExplanationLabel.text = .loginExplanation
        loginExplanationLabel.textColor = .gray
        loginExplanationLabel.numberOfLines = .zero
        loginExplanationLabel.lineBreakMode = .byWordWrapping
        loginExplanationLabel.textAlignment = .center
    }
    
    func setContentStack() {
        view.addSubview(contentStack)
        contentStack.axis = .vertical
        contentStack.spacing = Spacing.mediumLarge.rawValue
        contentStack.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(Spacing.mediumLarge.rawValue)
            $0.trailing.equalToSuperview().offset(-Spacing.mediumLarge.rawValue)
        }
    }
}
