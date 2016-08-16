//
//  HXCurrencySelectionSwiftViewController.swift
//  HXCurrencyConversion
//
//  Created by 黄轩 on 16/8/15.
//  Copyright © 2016年 黄轩. All rights reserved.
//

import UIKit

class HXCurrencySelectionSwiftViewController: UIViewController,UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate {

    var currentCurrency:String? //当前货币码
    var completion: (HXCurrencySelectionSwiftViewController, String) -> () = {vc, currency in }

    var _tableView:UITableView?
    var _dataAry:NSMutableArray?
    var _searchText:String? //搜索词

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "货币选择"
        
        let item = UIBarButtonItem(title: "取消", style: UIBarButtonItemStyle.Done, target: self, action: "cancleButtonAction")
        self.navigationItem.leftBarButtonItem = item;
        
        _dataAry = NSMutableArray();
        
        self.addSearchBar()
    }
    
    func addSearchBar()
    {
        let searchBar = UISearchBar(frame:CGRectMake(0, 0, self.tableView().frame.size.width, 44));
        searchBar.placeholder = "搜索";
        searchBar.delegate = self;
        self.tableView().tableHeaderView = searchBar;
        self.view.addSubview(self.tableView())
    }

    //所有币种
    func currencyAry() -> NSArray
    {
        return HXCurrencySwiftManager.sharedInstance.allCurrencies();
    }
    
    func dataAry() -> NSArray
    {
        if _searchText != nil && !_searchText!.isEmpty
        {
            //搜索则返回搜索数据
            return _dataAry!;
        }
        else
        {
            //反之返回所有数据
            return self.currencyAry();
        }
    }
    
    //行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.dataAry().count;
    }
    
    //cell
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier("CellID")
        if ((cell == nil)) {
            cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier:"CellID")
        }
        
        let str = self.dataAry()[indexPath.row] as! String
        
        //货币代码
        let currency = str;
        //货币名称
        let currencyName = HXCurrencySwiftManager.sharedInstance.toCurrencyName(str)
        
        cell!.textLabel!.text = currency;
        cell!.detailTextLabel?.text = currencyName;
        
        if currentCurrency != nil && !currentCurrency!.isEmpty
        {
            if(currentCurrency?.rangeOfString(currency) != nil)
            {
                cell!.accessoryType = UITableViewCellAccessoryType.Checkmark;
            }
            else
            {
                cell!.accessoryType = UITableViewCellAccessoryType.None;
            }
        }
        else
        {
            cell!.accessoryType = UITableViewCellAccessoryType.None;
        }
    
        return cell!;
    }
    
    //高度
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat
    {
        return 45;
    }
    
    //点击事件方法
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    
        self.completion(self,(self.dataAry()[indexPath.row] as! String))

        self.cancleButtonAction()
    }
    
    //已经开始编辑时的回调
    func searchBarTextDidBeginEditing(searchBar:UISearchBar)
    {
        searchBar.showsCancelButton = true;
        self.tableView().frame = CGRectMake(self.tableView().frame.origin.x, self.tableView().frame.origin.y, UIScreen.mainScreen().bounds.size.width, UIScreen.mainScreen().bounds.size.height - 252)
    }
    
    //编辑文字改变的回调
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String)
    {
        _searchText = searchText;
        
        self.ittemSearchResultsDataAryWithSearchText(searchText)
        self.tableView().reloadData()
    }
    
    //取消按钮点击的回调
    func searchBarCancelButtonClicked(searchBar:UISearchBar)
    {
        searchBar.showsCancelButton = false;
        _searchText = nil;
        searchBar.text = nil;
        self.view.endEditing(true)
        self.tableView().frame = UIScreen.mainScreen().bounds;
        self.tableView().reloadData()
    }
    
    //搜索结果按钮点击的回调
    func searchBarResultsListButtonClicked(searchBar:UISearchBar)
    {
        self.cancleButtonAction()
    }
    
    //根据搜索词来查找符合的数据
    func ittemSearchResultsDataAryWithSearchText(searchText:String)
    {
        _dataAry?.removeAllObjects()
        
        weak var weakSelf = self
        self.currencyAry().enumerateObjectsUsingBlock { (str, idx, stop) -> Void in

            //货币代码
            let currency = str as! String;
            //货币名称
            let currencyName = HXCurrencySwiftManager.sharedInstance.toCurrencyName(currency)
            
            
            if (!currency.isEmpty) && (!currencyName.isEmpty)
            {
                if((currency.rangeOfString(self._searchText!, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil) || (currencyName.rangeOfString(self._searchText!, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil)) {
                    weakSelf!._dataAry!.addObject(str)
                }
            } else {
                if (!currency.isEmpty) {
                    if(currency.rangeOfString(self._searchText!, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil) {
                        weakSelf!._dataAry!.addObject(str)
                    }
                }
                else if (!currencyName.isEmpty)
                {
                    if(currencyName.rangeOfString(self._searchText!, options: NSStringCompareOptions.CaseInsensitiveSearch) != nil) {
                        weakSelf!._dataAry!.addObject(str)
                    }
                }
            }
        }
    }
    
    //取消按钮
    func cancleButtonAction()
    {
        self.view.endEditing(true)
        self.navigationController?.dismissViewControllerAnimated(true, completion: { () -> Void in
            
        })
    }
    
    func tableView() -> UITableView
    {
        if (_tableView == nil)
        {
            _tableView = UITableView(frame: UIScreen.mainScreen().bounds, style:UITableViewStyle.Plain)
            _tableView!.dataSource = self
            _tableView!.delegate = self
            _tableView!.backgroundColor = UIColor.clearColor()
        }
        return _tableView!;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
