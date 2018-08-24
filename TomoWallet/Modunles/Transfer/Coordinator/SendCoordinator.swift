// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import BigInt
import TrustCore
import TrustKeystore
import Result
import Moya

protocol SendCoordinatorDelegate: class {
//    func didFinish(_ result: Result<ConfirmResult, AnyError>, in coordinator: SendCoordinator)
}

final class SendCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    
    var navigationController: NavigationController
    
 
    
    let transfer: Transfer
    let session: WalletSession
    let account: Account
    let keystore: Keystore
    var coordinators: [Coordinator] = []
    weak var delegate: SendCoordinatorDelegate?


    private lazy var sendViewController: SendViewController = {
        let viewModel = SendViewModel(transfer: self.transfer)
        let controller = SendViewController(viewModel: viewModel)
        return controller
    }()

    lazy var chainState: ChainState = {
        let state = ChainState(server: transfer.server, provider:ApiProviderFactory.makeBalanceProvider() )
        state.fetch()
        return state
    }()

    init(
        transfer: Transfer,
        navigationController: NavigationController,
        session: WalletSession,
        keystore: Keystore,
        account: Account
    ) {
        self.transfer = transfer
        self.navigationController = navigationController
        self.navigationController.modalPresentationStyle = .formSheet
        self.session = session
        self.account = account
        self.keystore = keystore
       
    }
    
    func start() {
        self.navigationController.show(sendViewController, sender: self)
    }
}

extension SendCoordinator: SendViewController_Delegate {
    func didPressConfirm(toAddress: EthereumAddress, data: Data, in viewController: SendViewController) {
//        print( toAddress)
    }
    
 
    
//    func didPressConfirm(transaction: UnconfirmedTransaction, transfer: Transfer, in viewController: SendViewController) {
//        let configurator = TransactionConfigurator(
//            session: session,
//            account: account,
//            transaction: transaction,
//            server: transfer.server,
//            chainState: ChainState(server: transfer.server)
//        )
//
//        let coordinator = ConfirmCoordinator(
//            navigationController: navigationController,
//            session: session,
//            configurator: configurator,
//            keystore: keystore,
//            account: account,
//            type: .signThenSend,
//            server: transfer.server
//        )
//        coordinator.didCompleted = { [weak self] result in
//            guard let `self` = self else { return }
//            self.delegate?.didFinish(result, in: self)
//        }
//        addCoordinator(coordinator)
//        navigationController.pushCoordinator(coordinator: coordinator, animated: true)
//    }
}
