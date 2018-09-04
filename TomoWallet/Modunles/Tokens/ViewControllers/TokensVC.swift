//
//  TokensVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/15/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import MBProgressHUD
protocol TokensVC_Delegate: class {
    func didPressAddToken( in viewController: UIViewController)
    // select a token
    func didSelect(token: TokenObject, in viewController: UIViewController)
    

}


class TokensVC: UIViewController {
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var walletNameLable: UILabel!
    @IBOutlet weak var walletAddressLable: UILabel!
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
    
    lazy var tokensFooterView: UIButton = {
        let footer = UIButton(type: .custom)
        footer.frame =  CGRect(x: 0, y: 0, width: self.view.bounds.width, height: 60)
        footer.setTitle("   Add other token", for: .normal)
        footer.setTitleColor(UIColor(hex: "006DF0"), for: .normal)
        footer.setImage(#imageLiteral(resourceName: "Create").imageWithColor(color1: UIColor(hex: "006DF0")), for: .normal)
        footer.tintColor = UIColor.green
        footer.addTarget(self, action: #selector(self.addOtherToken), for: .touchUpInside)
        return footer
        
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        createNavigator()
        setHeaderView()
        viewModel.fetch()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = tokensFooterView
        tableView.register(UINib(nibName: TokenViewCell.identifier, bundle: nil), forCellReuseIdentifier: TokenViewCell.identifier)
        
    }
    
    func createNavigator() {
        let menuBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Menu"), style: .plain, target: self, action: nil)
        let notifiBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Notification"), style: .plain, target: self, action: nil)
        let scanBarItem = UIBarButtonItem(image: #imageLiteral(resourceName: "ScanQR"), style: .plain, target: self, action: nil)
        
        self.navigationItem.leftBarButtonItems = [menuBarItem]
        self.navigationItem.rightBarButtonItems = [scanBarItem, notifiBarItem]
    }
    
    func setHeaderView() {
        walletNameLable.text = viewModel.title
        walletAddressLable.text = viewModel.address
        walletAddressLable.sizeToFit()
        DispatchQueue.global(qos: .userInteractive).async {
            let image = QRGenerator.generate(from: self.viewModel.address)
            DispatchQueue.main.async {
                self.qrCodeImage.image = image
            }
        }
    }
    
    // Action
    @IBAction func copyAddressAction(_ sender: Any) {
        UIPasteboard.general.string = viewModel.address
        let hup = MBProgressHUD.showAdded(to: self.view, animated: true)
        hup.label.text = "Address copied"
        hup.hide(animated: true, afterDelay: 1.5)
    }
    @IBAction func shareAddressAction(_ sender: Any) {
        let someText:String = self.viewModel.address
        let objectsToShare:UIImage = self.qrCodeImage.image!
        let sharedObjects:[AnyObject] = [objectsToShare,someText as AnyObject]
        let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        
        activityViewController.excludedActivityTypes = [ UIActivityType.airDrop, .postToFacebook,.postToTwitter, .message,.saveToCameraRoll]
        
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func addOtherToken() {
        delegate?.didPressAddToken(in: self)
    }
    
    @IBAction func zoomOutQRCodeAction(_ sender: Any) {
        
        
    }
    
}

extension TokensVC: UITableViewDelegate{

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        if indexPath.row%2 == 0{
            tokenViewCell.backgroundColor = UIColor(hex: "F8F8F8")
        }else{
            tokenViewCell.backgroundColor = UIColor.white
        }
        tokenViewCell.configure(viewModel: viewModel.cellViewModel(for: indexPath))
    }
    
}
extension TokensVC: TokensViewModel_Delegate{
    func refresh() {
        self.tableView.reloadData()
    }
}
