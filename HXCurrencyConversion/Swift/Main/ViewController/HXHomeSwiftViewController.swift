//
//  HXHomeSwiftViewController.swift
//  HXCurrencyConversion
//
//  Created by 黄轩 on 16/8/5.
//  Copyright © 2016年 黄轩. All rights reserved.
//

import UIKit

class HXHomeSwiftViewController : UIViewController {
    
    @IBOutlet weak var _displayLabel: UILabel! //显示Label 1人民币 = 5.2555泰铢
    @IBOutlet weak var _exchangeRateLabel: UILabel! //汇率
    @IBOutlet weak var _fromCurrencyLabel: UILabel! //待转换币种Label
    @IBOutlet weak var _toCurrencyLabel: UILabel! //转换后币种Label
    @IBOutlet weak var _updateTimeLabel: UILabel! //更新时间
    
    var _fromCurrency: String? //待转化的币种
    var _toCurrency: String? //转化后的币种
    var _amount: String? //转化金额
    
    var _request: HXRequestSwiftManager? //请求
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?){
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        _fromCurrency = HXCurrencySwiftManager.sharedInstance.currentFromCurrency();
        _toCurrency = HXCurrencySwiftManager.sharedInstance.currentToCurrency();
        _amount = "1";
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.title = "货币转换";
        
        self.exchangeRateConversionReuqest()
    }
    
    func exchangeRateConversionReuqest() {
        
        weak var weakSelf = self
        self.request().getExchangeRateConversionReuqestWithFromCurrency(_fromCurrency!, toCurrency: _toCurrency!, amount: _amount!, completionHandler: {(responseDic, msg) -> () in
            
                weakSelf!.refreshData(responseDic!)
            
            }, faileHandler: {(errMsg) -> () in
                print(errMsg)
        });
    }
    
    //输入金额改变
    @IBAction func textFieldEditingChange(sender: UITextField) {
        _amount = sender.text;
    }

    @IBAction func exchangeButtonAction(sender: UIButton) {
        let str = _fromCurrency;
        _fromCurrency = _toCurrency;
        _toCurrency = str;
        
        self.initUI();
    }
   
    //转换
    @IBAction func transformationButtonAction(sender: UIButton) {
        self.view.endEditing(true)
        
        self.exchangeRateConversionReuqest()
    }

    //币种选择
    @IBAction func currencySelectionButtonAction(sender: UIButton) {

        let vc = HXCurrencySelectionSwiftViewController()
        if (sender.tag == 10) {
            //待转换货币码
            vc.currentCurrency = _fromCurrency;
        } else if (sender.tag == 11) {
            //转换后货币码
            vc.currentCurrency = _toCurrency;
        }
        
        weak var weakSelf = self
        vc.completion = {
            (vc:HXCurrencySelectionSwiftViewController, currency:String) in

            if (sender.tag == 10) {
                //待转换货币码
                if (weakSelf!._fromCurrency != currency) {
                    weakSelf!._fromCurrency = currency;
                }
            } else if (sender.tag == 11) {
                //转换后货币码
                if (weakSelf!._toCurrency != currency) {
                    weakSelf!._toCurrency = currency;
                }
            }
            
            self.initUI();
        };

        let nav = UINavigationController(rootViewController: vc)
        self.navigationController?.presentViewController(nav, animated: true, completion: { () -> Void in
            
        })
    }
    
    func refreshData(dataDic:NSDictionary)
    {
        let date = dataDic["date"] as! String
        let time = dataDic["time"] as! String
        let fromCurrency = dataDic["fromCurrency"] as! String
        let fromCurrencyCompany = HXCurrencySwiftManager.sharedInstance.toCurrencyName(fromCurrency)
        let toCurrency = dataDic["toCurrency"] as! String
        let toCurrencyCompany = HXCurrencySwiftManager.sharedInstance.toCurrencyName(toCurrency)
        
        let amount:NSInteger = NSInteger(dataDic["amount"]!.integerValue)
        let currency:CGFloat = CGFloat(dataDic["currency"]!.floatValue)
        let convertedamount:CGFloat = CGFloat(dataDic["convertedamount"]!.floatValue)
        
        _displayLabel.text = "\(amount)\(fromCurrencyCompany)=\(String(format: "%.4f", convertedamount))\(toCurrencyCompany)"
        _exchangeRateLabel.text = String(format: "当前汇率:%.4f", currency)
        
        self.initUI()

        _updateTimeLabel.text = "数据仅供参考，交易时以银行柜台成交价为准 更新时间:\(date) \(time)"
    }
    
    func initUI()
    {
        HXCurrencySwiftManager().saveFromCurrency(_fromCurrency!)
        HXCurrencySwiftManager().saveToCurrency(_toCurrency!)
    
        _fromCurrencyLabel.text = "原始币种类型:\(HXCurrencySwiftManager.sharedInstance.toCurrencyName(_fromCurrency!))\(_fromCurrency!)"
        
        _toCurrencyLabel.text = "目标币种类型:\(HXCurrencySwiftManager.sharedInstance.toCurrencyName(_toCurrency!))\(_toCurrency!)"
    }
    
    func request() -> HXRequestSwiftManager
    {
        if (_request == nil)
        {
            _request = HXRequestSwiftManager()
        }
        return _request!;
    }
}

