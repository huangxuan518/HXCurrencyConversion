//
//  HXCurrencySelectionViewController.m
//  https://github.com/huangxuan518/HXInternationalizationDemo
//
//  Created by 黄轩 on 16/7/29.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import "HXCurrencySelectionViewController.h"
#import "HXCurrencyManager.h"

@interface HXCurrencySelectionViewController () <UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataAry;
@property (nonatomic,copy) NSString *searchText;//搜索词

@end

@implementation HXCurrencySelectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"货币选择";
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancleButtonAction:)];
    self.navigationItem.leftBarButtonItem = item;
    
    _dataAry = [NSMutableArray new];
    
    [self addSearchBar];
}

- (void)addSearchBar {
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 44)];
    searchBar.placeholder = @"搜索";
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
    [self.view addSubview:self.tableView];
}

#pragma mark - data

//所有币种
- (NSArray *)currencyAry {
    return kCurrencyManager.allCurrencies;
}

- (NSArray *)dataAry {
    if (_searchText.length > 0) {
        //搜索则返回搜索数据
        return _dataAry;
    }
    else
    {
        //反之返回所有数据
        return self.currencyAry;
    }
}

#pragma mark UITableViewDataSource/UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"CellID"];
    }
    
    NSString *str = self.dataAry[indexPath.row];
    
    //货币代码
    NSString *currency = str;
    //货币名称
    NSString *currencyName = [kCurrencyManager toCurrencyName:str];
    
    if (_searchText.length > 0) {
        cell.textLabel.attributedText = [self searchTitle:currency key:_searchText keyColor:[UIColor redColor]];
        cell.detailTextLabel.attributedText = [self searchTitle:currencyName key:_searchText keyColor:[UIColor redColor]];
    } else {
        cell.textLabel.text = currency;
        cell.detailTextLabel.text = currencyName;
    }
    
    if (_currentCurrency.length > 0) {
        if([_currentCurrency rangeOfString:currency].location != NSNotFound)
        {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_completion) {
        _completion(self,self.dataAry[indexPath.row]);
    }
    
    [self cancleButtonAction:nil];
}

#pragma mark - UISearchBar Delegate

//已经开始编辑时的回调
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
    self.tableView.frame = CGRectMake(self.tableView.frame.origin.x, self.tableView.frame.origin.y, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 252);
}

//编辑文字改变的回调
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"searchText:%@",searchText);
    _searchText = searchText;
    
    [self ittemSearchResultsDataAryWithSearchText:searchText];
    
    [self.tableView reloadData];
}

//取消按钮点击的回调
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = NO;
    _searchText = nil;
    searchBar.text = nil;
    [self.view endEditing:YES];
    self.tableView.frame = [UIScreen mainScreen].bounds;
    [self.tableView reloadData];
}

//搜索结果按钮点击的回调
- (void)searchBarResultsListButtonClicked:(UISearchBar *)searchBar {
    NSLog(@"%@",searchBar.text);
    [self cancleButtonAction:nil];
}

#pragma mark - 自定义方法

//根据搜索词来查找符合的数据
- (void)ittemSearchResultsDataAryWithSearchText:(NSString *)searchText {
    [_dataAry removeAllObjects];
    
    [self.currencyAry enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
        //货币代码
        NSString *currency = str;
        //货币名称
        NSString *currencyName = [kCurrencyManager toCurrencyName:str];
        
    
        if (currency.length > 0 && currencyName.length > 0) {
            if([currency rangeOfString:_searchText options:NSCaseInsensitiveSearch].location != NSNotFound || [currencyName rangeOfString:_searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                [_dataAry addObject:str];
            }
        } else {
            if (currency.length > 0) {
                if([currency rangeOfString:_searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    [_dataAry addObject:str];
                }
            } else if (currencyName.length > 0) {
                if([currencyName rangeOfString:_searchText options:NSCaseInsensitiveSearch].location != NSNotFound) {
                    [_dataAry addObject:str];
                }
            }
        }
    }];
}

// 设置文字中关键字高亮
- (NSMutableAttributedString *)searchTitle:(NSString *)title key:(NSString *)key keyColor:(UIColor *)keyColor {
    
    if (title.length == 0) {
        title = @"";
    }
    
    NSMutableAttributedString *titleStr = [[NSMutableAttributedString alloc] initWithString:title];
    NSString *copyStr = title;
    
    NSMutableString *xxstr = [NSMutableString new];
    for (int i = 0; i < key.length; i++) {
        [xxstr appendString:@"*"];
    }
    
    while ([copyStr rangeOfString:key options:NSCaseInsensitiveSearch].location != NSNotFound) {
        
        NSRange range = [copyStr rangeOfString:key options:NSCaseInsensitiveSearch];
        
        [titleStr addAttribute:NSForegroundColorAttributeName value:keyColor range:range];
        copyStr = [copyStr stringByReplacingCharactersInRange:NSMakeRange(range.location, range.length) withString:xxstr];
    }
    return titleStr;
}

#pragma mark - Action

//取消按钮
- (void)cancleButtonAction:(UIButton *)button {
    [self.view endEditing:YES];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - 懒加载

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStylePlain];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
