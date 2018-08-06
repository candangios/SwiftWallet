//
//  WalletAddress.swift
//  TomoWallet
//
//  Created by TomoChain on 8/6/18.
//  Copyright © 2018 TomoChain. All rights reserved.
//

import Foundation
import TrustCore
import RealmSwift
final class WalletAddress: Object {
    @objc dynamic var id: String = UUID().uuidString;
    @objc dynamic var addressString: String = "";
    @objc private dynamic var rawCoin = -1
    public var coin: Coin {
        get { return self.coin }
        set { self.coin = Coin(coinType: rawCoin)}
    }
    
    convenience init(
        coin: Coin,
        address: Address
        ) {
        self.init()
        self.addressString = address.description
        self.coin = coin
    }
    
    var address: EthereumAddress? {
        return EthereumAddress(string: addressString)
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    override static func ignoredProperties() -> [String] {
        return ["coin"]
    }
    
    override func isEqual(_ object: Any?) -> Bool {
        guard let object = object as? WalletAddress else { return false }
        return object.address == address //&& object.coin == address?.coin
    }
    
    
}

