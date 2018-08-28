//
//  ReveiceVC.swift
//  TomoWallet
//
//  Created by TomoChain on 8/23/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit
import MBProgressHUD

class ReveiceVC: UIViewController {
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var accountnameLable: UILabel!
    @IBOutlet weak var qrCodeImage: UIImageView!
    @IBOutlet weak var accountAddressLable: UILabel!

    let viewModel: ReveiceVideModel
    
    init(viewModel:ReveiceVideModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setInfoToken()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.closeAction(_:)))
        self.containerView.addGestureRecognizer(tapGesture)
    }
    func setInfoToken() {
        self.accountnameLable.text = viewModel.title
        self.accountAddressLable.text = viewModel.address
        DispatchQueue.global(qos: .userInteractive).async {
            let image = QRGenerator.generate(from: self.viewModel.address)
            DispatchQueue.main.async {
                self.qrCodeImage.image = image
            }
        }
    }
// Action
    @IBAction func closeAction(_ sender: Any) {
        self.willMove(toParentViewController: nil)
        self.beginAppearanceTransition(false, animated: true)
        UIView.animate(withDuration: 0.3, animations: {
            self.view.alpha = 0
            self.view.frame.origin.y = self.view.frame.size.height
        }, completion: { _ in
            self.view.removeFromSuperview()
            self.endAppearanceTransition()
            self.removeFromParentViewController()
        })
    }
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
}

