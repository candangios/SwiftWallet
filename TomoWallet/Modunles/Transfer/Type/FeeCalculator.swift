

import UIKit
import Foundation
struct FeeCalculator {
    
    static func estimate(fee: String, with price: String) -> Double? {
        guard let feeInDouble = Double(fee) else {
            return nil
        }
        guard let price = Double(price) else {
            return nil
        }
        return price * feeInDouble
    }
    
    static func format(fee: Double, formatter: NumberFormatter = CurrencyFormatter.formatter) -> String? {
        return formatter.string(from: NSNumber(value: fee))
    }
    
}
final class CurrencyFormatter {
    static var formatter: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        formatter.currencyCode = Config().currency.rawValue
        formatter.numberStyle = .currency
        return formatter
    }
    
    static var plainFormatter: EtherNumberFormatter {
        let formatter = EtherNumberFormatter.full
        formatter.groupingSeparator = ""
        return formatter
    }
}

