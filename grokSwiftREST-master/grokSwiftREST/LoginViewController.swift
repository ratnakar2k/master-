//
//  LoginViewController.swift
//  grokSwiftREST
//
//  Created by Christina Moulton on 2015-09-11.
//  Copyright © 2015 Teak Mobile Inc. All rights reserved.
//

import UIKit

protocol LoginViewDelegate: class {
  func didTapLoginButton()
}

class LoginViewController: UIViewController {
  weak var delegate: LoginViewDelegate?
  
  @IBAction func tappedLoginButton() {
    if let delegate = self.delegate {
      delegate.didTapLoginButton()
    }
  }
}