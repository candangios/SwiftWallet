//
//  CreatePasscodeVC.swift
//  TomoWallet
//
//  Created by TomoChain on 9/18/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
protocol CreatePasscodeVC_Delegate: class {
    func didCloseAction()
}

enum CreatePasscodeType{
    case edit
    case initial
}

class CreatePasscodeVC: BaseViewController {
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var numberPageBackgroundView: UIView!
    weak var delegate: CreatePasscodeVC_Delegate?
    var type: CreatePasscodeType
    let charCount = 6
    
    private var firstPasscode: String?
    lazy var numberPageView: NumberPageView = {
        let view = Bundle.main.loadNibNamed("NumberPageView", owner: self, options: nil)?.first as! NumberPageView
        return view
    }()
    let viewModel: CreatePasscodeViewModel
    var willFinishWithResult: ((_ success: Bool) -> Void)?
    init(_ viewModel: CreatePasscodeViewModel, type: CreatePasscodeType) {
        self.viewModel = viewModel
        self.type = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var lockView: LockView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createNavigation()
        self.numberPageBackgroundView.addSubview(numberPageView)
        self.initLockView()
        if type == .initial {
            self.showFirstPasscodeView()
        }else{
            showVerifyPasscodeView()
        }
     
        numberPageView.onchange = {(type,value) in
            switch type {
            case .clear:
                self.viewModel.clear()
                self.lockView.shake()
            case .dropLast:
                self.viewModel.dropLast()
            default:
                self.viewModel.appendPasscode(code: String(value!))
                if self.viewModel.newLenght() == self.charCount{
                    self.perform(#selector(self.enteredPasscode), with: self.viewModel.getPasscode(), afterDelay: 0.3)
                }
                
            }
            for characterView in self.lockView.characters {
                let index: Int = self.lockView.characters.index(of: characterView)!
                characterView.setEmpty(index >= self.viewModel.newLenght())
            }
        }
    }
    
    func initLockView() {
        lockView = LockView(charCount)
        lockView.backgroundColor = .clear
        lockView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(lockView)
        lockView.trailingAnchor.constraint(equalTo: self.headerView.trailingAnchor).isActive = true
        lockView.leadingAnchor.constraint(equalTo: self.headerView.leadingAnchor).isActive = true
        lockView.bottomAnchor.constraint(equalTo: self.headerView.bottomAnchor).isActive = true
        lockView.topAnchor.constraint(equalTo: self.headerView.topAnchor).isActive = true
        
    }
    
    override func viewWillLayoutSubviews() {
        numberPageView.frame = CGRect(x: 0, y: 0, width: self.numberPageBackgroundView.bounds.width, height: self.numberPageBackgroundView.bounds.height)
    }
    func createNavigation() {
        let closeButton = UIBarButtonItem(image: #imageLiteral(resourceName: "Close"), style: .plain, target: self, action: #selector(self.closeAction))
        self.navigationItem.rightBarButtonItem = closeButton
    }
    
    @objc func enteredPasscode(_ passcode: String) {
        switch type {
        case .initial:
            if let first = firstPasscode {
                if passcode == first {
                    self.viewModel.savePasscode(passcode: passcode)
                    self.willFinishWithResult?(true)
                } else {
                    self.lockView.shake()
                    self.clearPasscode()
                }
            } else {
                self.firstPasscode = passcode
                self.clearPasscode()
                self.showConfirmPasscodeView()
            }
        case .edit:
            if viewModel.isPasscodeValid(passcode: passcode){
                self.showFirstPasscodeView()
                self.type = .initial
            }else{
                self.lockView.shake()
            }
            self.clearPasscode()
        }
    }
    func clearPasscode() {
        self.viewModel.clear()
        for characterView in self.lockView.characters {
            let index: Int = self.lockView.characters.index(of: characterView)!
            characterView.setEmpty(index >= self.viewModel.newLenght())
        }
    }
 
    
    
    private func showVerifyPasscodeView() {
        self.lockView.lockTitle.text = "Enter Old Passcode"
    }
    private func showFirstPasscodeView() {
        self.lockView.lockTitle.text = "Enter New Passcode"
    }
    private func showConfirmPasscodeView() {
        self.lockView.lockTitle.text = "Re-Enter New Passcode"
    }
    
    @objc func closeAction() {
        self.delegate?.didCloseAction()
    }
}
