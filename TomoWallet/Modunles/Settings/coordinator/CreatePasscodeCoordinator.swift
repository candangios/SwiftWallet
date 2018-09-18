//
//  CreatePasscodeCoordinator.swift
//  TomoWallet
//
//  Created by TomoChain on 9/18/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
enum PasscodeType{
    case create
    case edit
}
protocol CreatePasscodeCoordinator_Delegate: class {
    func didCancel(in coordinator: CreatePasscodeCoordinator)
}

final class CreatePasscodeCoordinator: Coordinator{
    var childCoordinators = [Coordinator]()
    
    var lock = Lock()
    
    var navigationController: NavigationController
    weak var delegate: CreatePasscodeCoordinator_Delegate?
   
    init(navigationController: NavigationController = NavigationController(isHiddenNavigationBar: false)) {
        self.navigationController = navigationController
    }
    func start() {
        if lock.isPasscodeSet(){
            let createPasscodeVC = CreatePasscodeVC()
            self.navigationController.viewControllers = [createPasscodeVC]
        }else{
            let createPasscodeVC = CreatePasscodeVC()
            createPasscodeVC.delegate = self
            self.navigationController.viewControllers = [createPasscodeVC]
            
        }
        
    }
    
    
}
extension CreatePasscodeCoordinator: CreatePasscodeVC_Delegate{
    func didCloseAction() {
        self.navigationController.dismiss(animated: true) {
            self.delegate?.didCancel(in: self)
        }
    }
}
