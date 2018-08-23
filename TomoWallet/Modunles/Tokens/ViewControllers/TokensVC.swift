//
//  TokensVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
protocol TokensVC_Delegate: class {
    // disable or enable token on main View
    func didPressAddToggleEnableToken( in viewController: UIViewController)
    // select a token
    func didSelect(token: TokenObject, in viewController: UIViewController)
    // request add more a token
    func didRequest(token: TokenObject, in viewController: UIViewController)
}


class TokensVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    fileprivate var viewModel: TokensViewModel
    weak var delegate: TokensVC_Delegate?
    init(viewModel: TokensViewModel) {
        self.viewModel = viewModel
       
        super.init(nibName: nil, bundle: nil)
        self.viewModel.delegate = self
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.fetch()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UINib(nibName: TokenViewCell.identifier, bundle: nil), forCellReuseIdentifier: TokenViewCell.identifier)
      
    }

}

extension TokensVC: UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.delegate?.didSelect(token: viewModel.item(for: indexPath), in: self)
        
    }
    
}
extension TokensVC: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfItems(for: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TokenViewCell.identifier, for: indexPath) as! TokenViewCell
        cell.isExclusiveTouch = true
        return cell
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let tokenViewCell = cell as? TokenViewCell else { return }
        tokenViewCell.configure(viewModel: viewModel.cellViewModel(for: indexPath))
    }
    
}
extension TokensVC: TokensViewModel_Delegate{
    func refresh() {
        self.tableView.reloadData()
    }
}
