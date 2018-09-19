//
//  SettingsVC.swift
//  TomoWallet
//
//  Created by TomoChain on 9/17/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import UIKit

enum SettingsAction {
    case passcode
}
protocol SettingsVC_Delegate: class {
    func didAction(action: SettingsAction, in viewController: SettingsVC)
}

class SettingsVC: BaseViewController {
    let session: WalletSession
    let lock: Lock
    weak var delegate: SettingsVC_Delegate?
    var isSetPasscode = false
    
    @IBOutlet weak var tableView: UITableView!
    lazy var viewModel: SettingsViewModel = {
        return SettingsViewModel()
    }()
    init(session: WalletSession, lock: Lock) {
        self.session = session
        self.lock = lock
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = viewModel.title
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.register(UINib(nibName: "SwitchRowCell", bundle: nil), forCellReuseIdentifier: SwitchRowCell.identifier)
        self.tableView.register(UINib(nibName: "PushRowCell", bundle: nil), forCellReuseIdentifier: PushRowCell.identifier)
        self.tableView.register(UINib(nibName: "DeleteWalletCell", bundle: nil), forCellReuseIdentifier: DeleteWalletCell.identifier)
        
        let appVersion = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 40))
        appVersion.text = "2.2.2"
        appVersion.textAlignment = .center
        appVersion.center.x = tableView.center.x
        self.tableView.tableFooterView = appVersion
        
    }
    override func viewWillAppear(_ animated: Bool) {
        self.isSetPasscode = lock.isPasscodeSet()
        self.tableView.reloadData()
    }
    
    func reload() {
        self.isSetPasscode = lock.isPasscodeSet()
        self.tableView.reloadData()
    }
    
    
}
extension SettingsVC : UITableViewDataSource, UITableViewDelegate{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:return 3
        case 1:return 1
        case 2: return isSetPasscode == true ? 1 : 0
        case 3: return isSetPasscode == true ? 2 : 0
        case 4: return 2
        case 5: return 1
        default:return 0
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch indexPath.section {
        case 0:
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: SwitchRowCell.identifier, for: indexPath) as? SwitchRowCell
                cell?.setCell(title: "Enable Notificaiton", image: #imageLiteral(resourceName: "SettingNotification"), value: viewModel.enableNotification)
                cell?.onChange = {value in
                    self.viewModel.setNotification(value: value)
                }
                cell?.selectionStyle = .none
                return cell!
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: PushRowCell.identifier, for: indexPath) as? PushRowCell
                cell?.setCell(title: "Contacts", image:#imageLiteral(resourceName: "SettingContracts"), isHighlight: false)
                cell?.onPush = {
                    print("contrac")
                }
                cell?.selectionStyle = .none
                return cell!
            case 2:
                let cell = tableView.dequeueReusableCell(withIdentifier: PushRowCell.identifier, for: indexPath) as? PushRowCell
                cell?.setCell(title: "Backup Wallet", image:#imageLiteral(resourceName: "SettingBackupWallet"), isHighlight: true)
                cell?.onPush = {
                    print("Backup Wallet")
                }
                cell?.selectionStyle = .none
                return cell!
            default:
                break
            }
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: PushRowCell.identifier, for: indexPath) as? PushRowCell
            cell?.setCell(title: isSetPasscode == true ? "Update Passcode" : "Create Passcode", image:#imageLiteral(resourceName: "SettingCreatePasscode"), isHighlight: !isSetPasscode)
            cell?.onPush = {
                self.delegate?.didAction(action: SettingsAction.passcode, in: self)
            }
            cell?.selectionStyle = .none
            return cell!
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: SwitchRowCell.identifier, for: indexPath) as? SwitchRowCell
            cell?.setCell(title: "Touch ID", image: #imageLiteral(resourceName: "SettingTouchID"), value: viewModel.enableTouchID)
            cell?.onChange = {value in
                self.viewModel.setTouchID(value: value)
            }
            cell?.selectionStyle = .none
            return cell!
        case 3:
            switch indexPath.row{
            case 0:
                let cell = tableView.dequeueReusableCell(withIdentifier: SwitchRowCell.identifier, for: indexPath) as? SwitchRowCell
                cell?.setCell(title: "Unlock Wallet", image:#imageLiteral(resourceName: "SettingUnlockWallet"), value: viewModel.enableTouchID)
                cell?.onChange = {value in
                    self.viewModel.setTouchID(value: value)
                }
                cell?.selectionStyle = .none
                return cell!
            case 1:
                let cell = tableView.dequeueReusableCell(withIdentifier: SwitchRowCell.identifier, for: indexPath) as? SwitchRowCell
                cell?.setCell(title: "Accept Transfer", image: #imageLiteral(resourceName: "SettingAcceptTransfer"), value: viewModel.enableTouchID)
                cell?.onChange = {value in
                    self.viewModel.setTouchID(value: value)
                }
                cell?.selectionStyle = .none
                return cell!
            default:
                break
            }
        case 4:
            break
        case 5:
            let cell = tableView.dequeueReusableCell(withIdentifier: DeleteWalletCell.identifier, for: indexPath) as? DeleteWalletCell
            cell?.setCell(title: "Delete Wallet", image:#imageLiteral(resourceName: "SettingDeleteWallet"))
            cell?.onPush = {
//                self.delegate?.didAction(action: SettingsAction.passcode, in: self)
            }
            cell?.selectionStyle = .none
            return cell!
        default:
            break
        }
        return UITableViewCell()
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0,1,4:return 50
        case 2: return 0.1
        case 3: return isSetPasscode == true ? 50 : 0.1
        default:return 0
        }
    }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        
        switch section {
        case 1: return 45
        case 2: return isSetPasscode == true ?  45 :  0.1
        default:return 0.1
        }
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor(hex: "333333")
        header.textLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 18)
        header.textLabel?.frame = CGRect(x: 16, y: 15, width: 320, height: 18)
        header.textLabel?.textAlignment = .left
        switch section {
        case 0,1,4:
             header.textLabel?.text = viewModel.titleForSection(section: section)
        case 3:
            header.textLabel?.text = isSetPasscode == true ? viewModel.titleForSection(section: section) : ""
        default:
            header.textLabel?.text = ""
        }
        view.backgroundColor = UIColor(hex: "F4F4F4")
    }
    func tableView(_ tableView: UITableView, willDisplayFooterView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor(hex: "838383")
        header.textLabel?.font = UIFont(name: "Helvetica Neue", size: 14)
        header.textLabel?.frame = CGRect(x: 16, y: 5, width: 320, height: 40)
        header.textLabel?.textAlignment = .left
        switch section {
        case 1,2:
            header.textLabel?.text = isSetPasscode == true ? viewModel.footerForSection(section: section) : ""
        default:
            header.textLabel?.text = ""
        }
        view.backgroundColor = UIColor(hex: "F4F4F4")
    }
    
    
}
