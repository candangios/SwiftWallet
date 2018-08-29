//
//  TokenVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/23/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import StatefulViewController
import MXParallaxHeader

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
        view.delegate = self
        return view
    }()
    var scrollView: MXScrollView!
    var containerView = UIView()


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
        scrollView = MXScrollView()
        scrollView.parallaxHeader.delegate = self
        scrollView.parallaxHeader.view = header;
        scrollView.parallaxHeader.height = 260;
        scrollView.parallaxHeader.mode = .fill;
        scrollView.parallaxHeader.minimumHeight = 110;
        view.addSubview(scrollView)
        self.createNavigator()     
        


    }
    func createNavigator() {
        let menuBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu"), style: .plain, target: self, action: nil)
        let notifiBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Notification"), style: .plain, target: self, action: nil)
        let scanBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ScanQR"), style: .plain, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItems = [menuBarItem]
        self.navigationItem.rightBarButtonItems = [scanBarItem, notifiBarItem]
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
              var frame = view.frame
        
        scrollView.frame = frame
        scrollView.contentSize = frame.size
        
        frame.size.height -= scrollView.parallaxHeader.minimumHeight
        containerView.frame = frame
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
        self.header?.coinNameLable.text = viewModel.token.name
        
    }
}
// MARK: - MXParallaxHeaderDelegate
extension TokenVC: MXParallaxHeaderDelegate{
    func parallaxHeaderDidScroll(_ parallaxHeader: MXParallaxHeader) {
        print(parallaxHeader.progress)

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

