//
//  SufileResolve.h
//  XSufileResolving
//
//  Created by 黄盼青 on 16/5/30.
//  Copyright © 2016年 docee. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cocoa/Cocoa.h>

@interface SufileResolve : NSObject

+(instancetype)shared;

/**
 *  @brief 获取验证码图像
 *
 *  @param block 回调块
 */
-(void)requestCaptchaImage:(void(^)(NSImage *image,NSError *error)) block;


/**
 *  @brief 校验验证码
 *
 *  @param captchaText 验证码
 *  @param fileID      文件ID
 *  @param block       回调块
 */
-(void)captchaVerify:(NSString *)captchaText
          withFileID:(NSString *)fileID
           withBlock:(void(^)(BOOL isOK,NSError *error)) block;


/**
 *  @brief 请求下载地址
 *
 *  @param fileID 文件ID
 *  @param block  回调块
 */
-(void)requestDownloadURLWithFileID:(NSString *)fileID
                          withBlock:(void(^)(NSString *url,NSError *error)) block;

@end
