//
//  HXRequestManager.m
//  HXCurrencyConversion https://github.com/huangxuan518/HXCurrencyConversion
//  博客地址 http://blog.libuqing.com/
//  Created by 黄轩 on 16/8/4.
//  Copyright © 2016年 黄轩. All rights reserved.
//

#import "HXRequestManager.h"

@implementation HXRequestManager

#pragma mark - Request

/**
 *  支持的币种查询 http://apis.baidu.com/apistore/currencyservice/type
 *
 *  @param success <#success description#>
 *  @param failure <#failure description#>
 */
- (void)getCurrencySupportListRequest:(void(^)(NSArray *responseAry, NSInteger responseCode))success
                              failure:(void(^)(NSString *localizedDescription))failure {
    
    NSString *httpUrl = @"http://apis.baidu.com/apistore/currencyservice/type";
    NSString *httpArg = @"";
    
    NSString *urlStr = [[NSString alloc] initWithFormat: @"%@?%@",httpUrl,httpArg];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:apikey forHTTPHeaderField:@"apikey"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   failure(error.localizedDescription);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSDictionary *dic = [self toArrayOrNSDictionary:data];
                                   NSArray *ary = dic[@"retData"];
                                   success(ary,responseCode);
                               }
                           }];
}

/**
 *  汇率转换 http://apis.baidu.com/apistore/currencyservice/currency?fromCurrency=%@&toCurrency=%@&amount=%@
 *
 *  @param fromCurrency 待转化的币种
 *  @param toCurrency   转化后的币种
 *  @param amount       转化金额
 *  @param success      <#success description#>
 *  @param failure      <#failure description#>
 */
- (void)getExchangeRateConversionReuqestWithFromCurrency:(NSString *)fromCurrency
                                              toCurrency:(NSString *)toCurrency
                                                  amount:(NSString *)amount
                                                 success:(void(^)(NSDictionary *responseDic, NSInteger responseCode))success
                                                 failure:(void(^)(NSString *localizedDescription))failure {
    NSString *httpUrl = @"http://apis.baidu.com/apistore/currencyservice/currency";
    NSString *httpArg = [NSString stringWithFormat:@"fromCurrency=%@&toCurrency=%@&amount=%@",fromCurrency,toCurrency,amount];
    
    NSString *urlStr = [[NSString alloc] initWithFormat: @"%@?%@",httpUrl,httpArg];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy: NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    [request addValue:apikey forHTTPHeaderField:@"apikey"];
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
                               if (error) {
                                   failure(error.localizedDescription);
                               } else {
                                   NSInteger responseCode = [(NSHTTPURLResponse *)response statusCode];
                                   NSDictionary *dic = [self toArrayOrNSDictionary:data];
                                   NSDictionary *responseDic = dic[@"retData"];

                                   success(responseDic,responseCode);
                               }
                           }];
}

// 将JSON串转化为字典或者数组
- (id)toArrayOrNSDictionary:(NSData *)jsonData {
    NSError *error = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingAllowFragments
                                                      error:&error];
    if (jsonObject != nil && error == nil) {
        return jsonObject;
    } else {
        // 解析错误
        return nil;
    }
}

@end
