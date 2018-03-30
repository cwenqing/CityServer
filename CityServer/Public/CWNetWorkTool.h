//
//  CWNetWorkTool.h
//  CityServer
//
//  Created by 陈文清 on 2017/12/18.
//  Copyright © 2017年 陈文清. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CWNetWorkTool : NSObject

/**
 Get请求
 
 @param path       路径
 @param parameters 参数
 @param Success    成功回调
 @param Fail       失败回调
 */
+(void)requestGetWithPath:(NSString*)path andParameters:(id)parameters andSuccess:(Callback)Success
                     Fail:(Callback)Fail;


+(void)requestPostWithPath:(NSString*)path andParameters:(id)parameters andSuccess:(Callback)Success
                      Fail:(Callback)Fail;



+(void)upLoadImgPostWithPath:(NSString*)path andParameters:(id)parameters andImageArr:(NSArray *)imageArr andName:(NSString *)name Progress:(Callback)Progress Success:(Callback)Success Fail:(Callback)Fail;

+(void)upLoadImgPostWithPath:(NSString*)path andParameters:(id)parameters andFileArr:(NSArray *)fileArr andName:(NSString *)name Progress:(Callback)Progress Success:(Callback)Success Fail:(Callback)Fail;

@end
