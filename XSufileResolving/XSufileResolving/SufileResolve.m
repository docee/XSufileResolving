//
//  SufileResolve.m
//  XSufileResolving
//
//  Created by 黄盼青 on 16/5/30.
//  Copyright © 2016年 docee. All rights reserved.
//

#import "SufileResolve.h"
#import "TFHpple.h"

@implementation SufileResolve

+(instancetype)shared {
    
    static SufileResolve *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        instance = [[SufileResolve alloc]init];
        
    });
    
    return instance;
    
}

-(void)requestCaptchaImage:(void(^)(NSImage *image,NSError *error)) block{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        
        [request setURL:[NSURL URLWithString:@"http://sufile.com/downcode.php"]];
        [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        [request setTimeoutInterval:5.0f];
        
        NSError *error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if(nil != data) {
            
            NSImage *image = [[NSImage alloc]initWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                block(image,nil);
            });
            
            return;

        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(nil,error);
        });
        
    });
    
}

-(void)captchaVerify:(NSString *)captchaText
          withFileID:(NSString *)fileID
           withBlock:(void(^)(BOOL isOK,NSError *error)) block {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        
        [request setURL:[NSURL URLWithString:@"http://sufile.com/downcode.php"]];
        [request setHTTPMethod:@"POST"];
        
        [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
        
        NSString *paramStr = [NSString stringWithFormat:@"action=yz&id=%@&code=%@",fileID,captchaText];
        [request setHTTPBody:[paramStr dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSError *error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        
        if(nil != data) {
            
            NSString *respStr = [NSString stringWithUTF8String:[data bytes]];
            
            BOOL isOK = NO;
            
            if([@"1" isEqualToString:respStr]) {
                isOK = YES;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
               
                block(isOK,nil);
                
            });
            
            return;
            
            
        }
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            block(NO,error);
            
        });
        
        
        
    });
    
}

-(void)requestDownloadURLWithFileID:(NSString *)fileID
                          withBlock:(void(^)(NSString *url,NSError *error)) block {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
       
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]init];
        
        [request setURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://sufile.com/dd.php?file_key=%@&p=1",fileID]]];
        [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
        [request setTimeoutInterval:5.0f];
        
        NSError *error = nil;
        
        NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
        if(nil != data) {
            
            TFHpple *doc = [[TFHpple alloc]initWithHTMLData:data];
            NSArray *elements = [doc searchWithXPathQuery:@"//a[@id='downs']"];
            TFHppleElement *element = [elements objectAtIndex:0];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *down_url = [element objectForKey:@"href"];
                
                block(down_url,nil);
                
            });
            
            return;
            
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            block(nil,error);
        });
        
        
    });
    
}

@end
