//
//  TokenVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/23/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import StatefulViewController

protocol TokenVC_Delegate: class {
    func didPressRequest(for token: TokenObject, in controller: UIViewController)
    func didPressSend(for token: TokenObject, in controller: UIViewController)
    func didPressInfo(for token: TokenObject, in controller: UIViewController)
    func didPress(viewModel: TokenViewModel, transaction: Transaction, in controller: UIViewController)
}

class TokenVC: UIViewController {
    
    private lazy var header: TokenHeaderView? = {
        guard let view: TokenHeaderView = Bundle.main.loadNibNamed("TokenHeaderView", owner: self, options: nil)?.first as? TokenHeaderView else{
            return .none
        }
        view.delegate = self as? TokenHeaderView_Delegate
        return view
    }()

    @IBOutlet weak var tableView: UITableView!
    let viewModel: TokenViewModel
    weak var delegate: TokenVC_Delegate?
    init(viewModel: TokenViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = viewModel.title
        self.tableView.tableHeaderView = header
        self.tableView.tableHeaderView?.frame.size = CGSize(width: self.view.bounds.width, height: 315)
        self.tableView.delegate = self
        self.tableView.dataSource = self

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupInitialViewState()
        self.viewModel.fetch()
        self.updateHeaderView()
    }
    
    private func updateHeaderView(){
        self.header?.iconImage.kf.setImage(with: viewModel.imageURL, placeholder: viewModel.imagePlaceholder)
        self.header?.balancelable.text = viewModel.token.valueBalance.amountFull
    }
    
    
    
}
extension TokenVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: TransactionViewCell.identifier, for: indexPath) as! TransactionViewCell
//        cell.configure(viewModel: viewModel.cellViewModel(for: indexPath))
//        return cell
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems(for: section)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return SectionHeader(
//            title: viewModel.titleForHeader(in: section)
//        )
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 0.1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        delegate?.didPress(viewModel: viewModel, transaction: viewModel.item(for: indexPath.row, section: indexPath.section), in: self)
//        tableView.deselectRow(at: indexPath, animated: true)
    }
}
extension TokenVC: TokenHeaderView_Delegate{
    func didPressSend() {
        self.delegate?.didPressSend(for: viewModel.token, in: self)
        
    }
    
    func didPressReveice() {
        self.delegate?.didPressRequest(for: viewModel.token, in: self)
        
    }
    
    
}
extension TokenVC: StatefulViewController {
    func hasContent() -> Bool {
        return viewModel.hasContent()
    }
}

