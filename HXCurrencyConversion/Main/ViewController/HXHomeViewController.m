//
//  HXHomeViewController.m
//  HXCurrencyConversion https://github.com/huangxuan518/HXCurrencyConversion
//  博客地址 http://blog.libuqing.com/
//
//  Created by 黄轩 on 16/8/3.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import "HXHomeViewController.h"
#import "HXCurrencySelectionViewController.h"

#import "HXRequestManager.h"
#import "HXCurrencyManager.h"

@interface HXHomeViewController ()

@property (weak, nonatomic) IBOutlet UILabel *exchangeRateLabel; //汇率
@property (weak, nonatomic) IBOutlet UILabel *displayLabel; //显示Label 1人民币 = 5.2555泰铢
@property (weak, nonatomic) IBOutlet UILabel *fromCurrencyLabel; //待转换币种Label
@property (weak, nonatomic) IBOutlet UILabel *toCurrencyLabel; //转换后币种Label
@property (weak, nonatomic) IBOutlet UILabel *updateTimeLabel; //更新时间

@property (nonatomic,copy) NSString *fromCurrency; //待转化的币种
@property (nonatomic,copy) NSString *toCurrency; //转化后的币种
@property (nonatomic,copy) NSString *amount; //转化金额

@property (nonatomic,strong) HXRequestManager *request;

@end

@implementation HXHomeViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _fromCurrency = [kCurrencyManager currentFromCurrency];
        _toCurrency = [kCurrencyManager currentToCurrency];
        _amount = @"1";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"货币转换";
    
    [self exchangeRateConversionReuqest];
}

#pragma mark - request

//转换
- (void)exchangeRateConversionReuqest {
    [self.request getExchangeRateConversionReuqestWithFromCurrency:_fromCurrency toCurrency:_toCurrency amount:_amount success:^(NSDictionary *responseDic, NSInteger responseCode) {
        
        [self refreshData:responseDic];
        
    } failure:^(NSString *localizedDescription, NSInteger code) {
        NSLog(@"Httperror: %@%ld", localizedDescription, code);
    }];
}


#pragma mark - Action

//输入金额改变
- (IBAction)textFieldEditingChange:(UITextField *)sender {
    _amount = sender.text;
}

- (IBAction)exchangeButtonAction:(UIButton *)sender {
    NSString *str = _fromCurrency;
    _fromCurrency = _toCurrency;
    _toCurrency = str;
    
    [self initUI];
}

//转换
- (IBAction)transformationButtonAction:(UIButton *)sender {
    [self.view endEditing:YES];
    
    [self exchangeRateConversionReuqest];
}

- (void)refreshData:(NSDictionary *)dataDic {

    NSString *date = dataDic[@"date"];
    NSString *time = dataDic[@"time"];
    NSString *fromCurrency = dataDic[@"fromCurrency"];
    NSString *toCurrency = dataDic[@"toCurrency"];
    NSString *amount = dataDic[@"amount"];
    float currency = [dataDic[@"currency"] floatValue];
    float convertedamount = [dataDic[@"convertedamount"] floatValue];
    
    _exchangeRateLabel.text = [NSString stringWithFormat:@"当前汇率:%.4f",currency];
    [self initUI];
    _updateTimeLabel.text = [NSString stringWithFormat:@"数据仅供参考，交易时以银行柜台成交价为准 更新时间:%@ %@",date,time];
    _displayLabel.text = [NSString stringWithFormat:@"%@%@=%.4f%@",[self stringDisposeWithFloatString:amount],[kCurrencyManager toCurrencyName:fromCurrency],convertedamount,[kCurrencyManager toCurrencyName:toCurrency]];
}

- (void)initUI {
    [kCurrencyManager saveFromCurrency:_fromCurrency];
    [kCurrencyManager saveToCurrency:_toCurrency];
    
    _fromCurrencyLabel.text = [NSString stringWithFormat:@"原始币种类型:%@ %@",[kCurrencyManager toCurrencyName:_fromCurrency],_fromCurrency];
    _toCurrencyLabel.text = [NSString stringWithFormat:@"目标币种类型:%@ %@",[kCurrencyManager toCurrencyName:_toCurrency],_toCurrency];
}

//币种选择
- (IBAction)currencySelectionButtonAction:(UIButton *)sender {
    HXCurrencySelectionViewController *vc = [HXCurrencySelectionViewController new];
    if (sender.tag == 10) {
        //待转换货币码
        vc.currentCurrency = _fromCurrency;
    } else if (sender.tag == 11) {
        //转换后货币码
        vc.currentCurrency = _toCurrency;
    }
    vc.completion = ^(HXCurrencySelectionViewController *vc, NSString *currency) {
        if (sender.tag == 10) {
            //待转换货币码
            if (_fromCurrency != currency) {
                _fromCurrency = currency;
            }
        } else if (sender.tag == 11) {
            //转换后货币码
            if (_toCurrency != currency) {
                _toCurrency = currency;
            }
        }

        [self initUI];
    };
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self.navigationController presentViewController:nav animated:YES completion:nil];
}

- (NSString *)stringDisposeWithFloatString:(NSString *)floatStr {
    NSString *str = [NSString stringWithFormat:@"%.4f",floatStr.floatValue];
    NSUInteger len = str.length;
    for (int i = 0; i < len; i++)
    {
        if (![str  hasSuffix:@"0"])
            break;
        else
            str = [str substringToIndex:[str length]-1];
    }
    if ([str hasSuffix:@"."])//避免像2.0000这样的被解析成2.
    {
        return [str substringToIndex:[str length]-1];//s.substring(0, len - i - 1);
    }
    else
    {
        return str;
    }
}

#pragma mark - 懒加载

- (HXRequestManager *)request {
    if (!_request) {
        _request = [HXRequestManager new];
    }
    return _request;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
