// Copyright DApps Platform Inc. All rights reserved.

import Foundation
import UIKit
import BigInt

struct TokenViewCellViewModel {
    private let shortFormatter = EtherNumberFormatter.short
    let viewModel: TokenObjectViewModel
    private let ticker: CoinTicker?
    let store: TransactionsStorage
    let config: Config = Config()
    

    init(
        viewModel: TokenObjectViewModel,
        ticker: CoinTicker?,
        store: TransactionsStorage
    ) {
        self.viewModel = viewModel
        self.ticker = ticker
        self.store = store
    }

    var title: String {
        return viewModel.name
    }
    var symbol: String {
        return viewModel.symbol
    }


    var amount: String {
        return shortFormatter.string(from: BigInt(viewModel.token.value) ?? BigInt(), decimals: viewModel.token.decimals)
    }

    var currencyAmount: String? {
        let amount = viewModel.token.balance
        guard amount > 0 else { return nil }
        return CurrencyFormatter.formatter.string(from: NSNumber(value: amount))! + " \(config.currency.rawValue)"
    }




    // Percent change

    var percentChange: String? {
        guard let ticker = ticker, let price = Double(ticker.price), price > 0 else { return nil }
        let percent_change_24h = ticker.percent_change_24h
        guard !percent_change_24h.isEmpty else { return nil }
        return "" + percent_change_24h + "%"

    }

    var placeholderImage: UIImage? {
        return viewModel.placeholder
    }

    // Market Price

    var marketPrice: String? {
        guard let ticker = ticker, let price = Double(ticker.price), price > 0 else { return nil }
        return String(price)
//        return CurrencyFormatter.formatter.string(from: NSNumber(value: price))
//        return TokensLayout.cell.marketPrice(for: ticker)
    }

    var imageURL: URL? {
        return viewModel.imageURL
    }
}
