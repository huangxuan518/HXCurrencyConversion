//
//  HXRequestSwiftManager.swift
//  HXCurrencyConversion
//
//  Created by 黄轩 on 16/8/5.
//  Copyright © 2016年 黄轩. All rights reserved.
//

import UIKit

class HXRequestSwiftManager: NSObject {
    
    func getCurrencySupportListRequest(completionHandler success: (NSArray?, String?) -> (), faileHandler failure: (String?) -> ())
    {
        let httpUrl = "http://apis.baidu.com/apistore/currencyservice/type"
        let httpArg = ""
        
        let req = NSMutableURLRequest(URL: NSURL(string: httpUrl + "?" + httpArg)!)
        req.timeoutInterval = 6
        req.HTTPMethod = "GET"
        req.addValue("fd0a97bd4bcb79b91c50b47c7fa8246d", forHTTPHeaderField: "apikey")
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) {
            (response, data, error) -> Void in

            if (error != nil) {
                failure(error!.localizedDescription)
            } else {
                let dic = self.toArrayOrNSDictionary(data) as! NSDictionary;
                let errMsg = dic["errMsg"] as! String
                let responseAry = dic["retData"] as? NSArray;
                success(responseAry, errMsg);
            }
        }
    }
        
    func getExchangeRateConversionReuqestWithFromCurrency(fromCurrency: String, toCurrency: String, amount: String, completionHandler success: (NSDictionary?, String?) -> (), faileHandler failure: (String?) -> ())
    {
        let httpUrl = "http://apis.baidu.com/apistore/currencyservice/currency"
        let httpArg = "fromCurrency=" + (fromCurrency as String) + "&toCurrency=" + (toCurrency as String) + "&amount=" + (amount as String)
        
        let req = NSMutableURLRequest(URL: NSURL(string: httpUrl + "?" + httpArg)!)
        req.timeoutInterval = 6
        req.HTTPMethod = "GET"
        req.addValue("fd0a97bd4bcb79b91c50b47c7fa8246d", forHTTPHeaderField: "apikey")
        NSURLConnection.sendAsynchronousRequest(req, queue: NSOperationQueue.mainQueue()) {
            (response, data, error) -> Void in
            
            if (error != nil) {
                failure(error!.localizedDescription)
            } else {
                let dic = self.toArrayOrNSDictionary(data) as! NSDictionary;
                let errMsg = dic["errMsg"] as! String
                let responseDic = dic["retData"] as? NSDictionary;
                success(responseDic, errMsg);
            }
        }
    }
    
    func toArrayOrNSDictionary(jsonData:NSData!)-> AnyObject {
        let data = try! NSJSONSerialization.JSONObjectWithData(jsonData!, options: NSJSONReadingOptions.AllowFragments)
        return data
    }
}
