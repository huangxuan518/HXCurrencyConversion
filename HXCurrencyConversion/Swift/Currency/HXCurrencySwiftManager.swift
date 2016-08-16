//
//  HXCurrencySwiftManager.swift
//  HXCurrencyConversion
//
//  Created by 黄轩 on 16/8/15.
//  Copyright © 2016年 黄轩. All rights reserved.
//

import UIKit

private let sharedKraken = HXCurrencySwiftManager()

class HXCurrencySwiftManager: NSObject {
    
    var _data:NSDictionary?
    let kfromCurrency = "fromCurrency"
    let ktoCurrency = "toCurrency"

    class var sharedInstance: HXCurrencySwiftManager {
        return sharedKraken
    }
    
    func data() -> NSDictionary
    {
        if (_data == nil)
        {
            let plistPath = NSBundle.mainBundle().pathForResource("currencycodetable", ofType: "plist")
            _data = NSMutableDictionary(contentsOfFile: plistPath!)
        }
        return _data!;
    }
    
    func allCurrencies() -> NSArray
    {
        return self.data().allKeys;
    }
    
    func toCurrencyName(currency:String) -> String
    {
        return self.data()[currency] as! String;
    }
    
    //保存当前待转换币种
    func saveFromCurrency(fromCurrency:String)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(fromCurrency, forKey: kfromCurrency)
        defaults.synchronize()
    }
    
    //保存目标货币
    func saveToCurrency(toCurrency:String)
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setValue(toCurrency, forKey: ktoCurrency)
        defaults.synchronize()
    }

    //获取当前待转换币种
    func currentFromCurrency() ->String
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let fromCurrency = defaults.objectForKey(kfromCurrency) as? String

        if (fromCurrency!.isEmpty) {
            return "USD";
        }
        return fromCurrency!;
    }
    
    //获取目标货币
    func currentToCurrency() ->String
    {
        let defaults = NSUserDefaults.standardUserDefaults()
        let toCurrency = defaults.objectForKey(ktoCurrency) as? String
        
        if (toCurrency!.isEmpty) {
            return "CNY";
        }
        return toCurrency!;
    }
}


