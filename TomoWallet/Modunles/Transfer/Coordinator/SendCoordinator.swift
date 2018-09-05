// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import BigInt
import TrustCore
import TrustKeystore
import Result
import Moya

protocol SendCoordinatorDelegate: class {
    func didFinish(_ result: Result<ConfirmResult, AnyError>, in coordinator: SendCoordinator)
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


    private lazy var sendViewController: SendAddressVC = {
        let viewModel = SendViewModel(transfer: self.transfer)
        let controller = SendAddressVC(viewModel: viewModel)
   
        return controller
    }()

    lazy var chainState: ChainState = {
        let state = ChainState(server: transfer.server, provider:ApiProviderFactory.makeRPCNetworkProvider() )
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
        sendViewController.delegate = self
        self.navigationController.show(sendViewController, sender: self)
    }
}

extension SendCoordinator: SendViewController_Delegate {
    func didPressConfirm(toAddress: EthereumAddress, data: Data, in viewController: SendAddressVC) {
        
        let sendAmountVC = SendAmountVC(session: self.session, storage: self.session.tokensStorage, account: self.account, transfer: self.transfer, chainState: self.chainState, toAddress: toAddress, data: data)
        sendAmountVC.delegate = self
        self.navigationController.pushViewController(sendAmountVC, animated: true)
        
    }
}
extension SendCoordinator: SendAmountVC_Delegate{
    func didPressConfirm(transaction: UnconfirmedTransaction, transfer: Transfer, in viewController: SendAmountVC) {
        let configurator = TransactionConfigurator(
            session: session,
            account: account,
            transaction: transaction,
            server: transfer.server,
            chainState: ChainState(server: transfer.server, provider: ApiProviderFactory.makeRPCNetworkProvider())
        )
        let confirmPayment = ConfirmPaymentVC(session: session, keystore: keystore, configurator: configurator, confirmType: .signThenSend, server: transfer.server)
        confirmPayment.didCompleted = { [weak self] result in
            guard let `self` = self else { return }
            self.delegate?.didFinish(result, in: self)
        }
        self.navigationController.pushViewController(confirmPayment, animated: true)
        
    }
    
    
}
