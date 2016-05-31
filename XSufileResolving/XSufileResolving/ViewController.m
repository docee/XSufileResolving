//
//  ViewController.m
//  XSufileResolving
//
//  Created by Docee on 16/5/30.
//  Copyright © 2016年 docee. All rights reserved.
//

#import "ViewController.h"
#import "SufileResolve.h"

@interface ViewController ()

@property (weak) IBOutlet NSButton *captchaImage;
@property (weak) IBOutlet NSTextField *captchaText;
@property (weak) IBOutlet NSTextField *fileidText;


@end

@implementation ViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view.
    
    [self updateCaptcha];
    
    
}

- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}

#pragma mark - Control
-(void)updateCaptcha{
    
    [[SufileResolve shared] requestCaptchaImage:^(NSImage *image, NSError *error) {
        
        if(nil != image) {
            
            [_captchaImage setImage:image];
            
        }else{
            
            NSLog(@"Error:%@",error.description);
            
        }
        
    }];
    
}

- (IBAction)didCaptchaClicked:(id)sender {
    
    [self updateCaptcha];
    
}
- (IBAction)didVerifyBtnClicked:(id)sender {
    
    NSAlert *alert = [[NSAlert alloc]init];
    [alert addButtonWithTitle:@"确定"];
    [alert setMessageText:@"提示"];
    
    if([@"" isEqualToString:_fileidText.stringValue]) {
        
        [alert setInformativeText:@"请输入文件ID"];
        
        [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:nil];
        return;
    }
    
    if([@"" isEqualToString:_captchaText.stringValue]) {
        
        [alert setInformativeText:@"请输入验证码"];
        
        [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:nil];
        return;
    }
    
    [[SufileResolve shared] captchaVerify:_captchaText.stringValue
                               withFileID:_fileidText.stringValue
                                withBlock:^(BOOL isOK, NSError *error) {
                                    
                                    if(isOK && nil == error){
                                        
                                        [[SufileResolve shared] requestDownloadURLWithFileID:_fileidText.stringValue
                                                                                   withBlock:^(NSString *url, NSError *error) {
                                                                                       
                                                                                       
                                                                                       if(nil != url && nil == error) {
                                                                                           
                                                                                           [alert setMessageText:@"下载地址"];
                                                                                           [alert setInformativeText:url];
                                                                                           
                                                                                       }else{
                                                                                           
                                                                                           [alert setInformativeText:@"地址获取失败!"];
                                                                                           
                                                                                       }
                                                                                       
                                                                                       [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:nil];
                                                                                       
                                                                                       [self updateCaptcha];
                                                                                       
                                                                                       
                                            
                                        }];
                                        
                                        
                                    }else {
                                        
                                        [alert setInformativeText:@"验证码错误"];
                                        
                                        [alert beginSheetModalForWindow:[NSApplication sharedApplication].keyWindow completionHandler:nil];
                                        
                                        [self updateCaptcha];
                                        
                                    }
                                    
            
                                    return;
                                    
        
    }];
    
    
    
}

@end
