//
//  ActionViewController.m
//  jalnetPassEx
//
//  Created by Seiji Mitsuda on 2017/03/09.
//  Copyright © 2017年 Another Sky. All rights reserved.
//

#import "ActionViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>



@implementation ActionViewController
{
    NSString *origPage;
    NSString *userID, *password;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    userID = [UICKeyChainStore stringForKey:@"userID" service:@"com.micchann.jalnetPassTest"];
    password = [UICKeyChainStore stringForKey:@"password" service:@"com.micchann.jalnetPassTest"];
    origPage = @"";

    if (userID == nil) {
        _upperLabel.text = @"IDとPassが登録されていません";
        _lowerLabel.text = @"jalnetPassTestアプリで登録してください";
        return;
    }
    
    
    NSItemProvider *itemProvider = ((NSExtensionItem *)self.extensionContext.inputItems.firstObject).attachments.firstObject;
    
    if([itemProvider hasItemConformingToTypeIdentifier:(NSString *)kUTTypePropertyList]) {
                
        [itemProvider loadItemForTypeIdentifier:(NSString *)kUTTypePropertyList options:nil completionHandler:^(NSDictionary *item, NSError *error) {
            
            if (error) {
                return;
            }
            
            NSString *title = @"";
            NSString *upperText = @"";
            NSString *lowerText = @"";
            
            BOOL requireTouchID = YES;
            
            NSDictionary *results = [(NSDictionary *)item objectForKey:NSExtensionJavaScriptPreprocessingResultsKey];


            if ([results[@"URL"] hasPrefix:@"http://www.bric.jalnet/BRIC/Comm/COMM_S_AD_LOGIN.aspx"] ||
                [results[@"URL"] hasPrefix:@"https://www.bric.jalnet/BRIC/Comm/COMM_S_AD_LOGIN.aspx"]) {
                self->origPage = @"BRIC";
                title = @"BRIC";
            } else if ([results[@"URL"] hasPrefix:@"http://insptl.ework.jalnet/cgi-bin/login_index.cgi"] ||
                       [results[@"URL"] hasPrefix:@"https://insptl.ework.jalnet/cgi-bin/login_index.cgi"]) {
                self->origPage = @"Intranet";
                title = @"JAL Intranet";
            } else if ([results[@"URL"] hasPrefix:@"http://www.fomax.jalnet/restricted/FOMA_CREW/pages/Login.aspx"] ||
                       [results[@"URL"] hasPrefix:@"https://www.fomax.jalnet/restricted/FOMA_CREW/pages/Login.aspx"]) {
                self->origPage = @"Album";
                title = @"Crew Album";
            } else if ([results[@"URL"] hasPrefix:@"http://insptl.ework.jalnet/cgi-bin/custom/windows_sso/simple_login.cgi"] ||
                       [results[@"URL"] hasPrefix:@"https://insptl.ework.jalnet/cgi-bin/custom/windows_sso/simple_login.cgi"]) {
                self->origPage = @"IntraDog";
                title = @"JAL Intranet";
            } else if ([results[@"URL"] hasPrefix:@"http://www.micchann.com/loginTest/"] ||
                       [results[@"URL"] hasPrefix:@"https://www.micchann.com/loginTest/"]) {
                self->origPage = @"LoginTest";
                title = @"LoginTest";
            } else if ([results[@"URL"] hasPrefix:@"http://insptl.ework.jalnet/cgi-bin/"] ||
                                  [results[@"URL"] hasPrefix:@"https://insptl.ework.jalnet/cgi-bin/"]) {
                self->origPage = @"IntraDoc";
                title = @"Intranet Document";
            } else {
                title = @"Unknown Site";
                upperText = @"サイトを特定できませんでした";
                lowerText = @"";
                requireTouchID = NO;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                self->_navBar.topItem.title = title;
                self->_upperLabel.text = upperText;
                self->_lowerLabel.text = lowerText;
                
                if (requireTouchID) {
                    [self touchID];
                }
            });
            
            
        }];
        
    }

}


-(void)touchID {
    
    // Touch ID API が利用できるかをチェック
    
    __block LAContext *context = [[LAContext alloc]init];
    
    NSError *authError = nil;
    [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                         error:&authError];
    
    if (authError) {
        
        _upperLabel.text = @"指紋認証が使用できません。";
        _lowerLabel.text = @"TouchIDの設定をご確認ください。";
        
        return;
    }


    context.localizedFallbackTitle = @"";

    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
            localizedReason:@"指紋認証してください"
                      reply:^(BOOL success, NSError *error) {
                          
                              
                              if (success) {
                                  // 認証成功時の処理
                                  NSExtensionItem *extensionItem = [[NSExtensionItem alloc] init];
                                  extensionItem.attachments = @[[[NSItemProvider alloc] initWithItem:@{NSExtensionJavaScriptFinalizeArgumentKey: @{@"userID":self->userID,@"password":self->password,@"origPage":self->origPage}}
                                                                                      typeIdentifier:(NSString *)kUTTypePropertyList]];
                                  [self.extensionContext completeRequestReturningItems:@[extensionItem] completionHandler:nil];
                                  
                              } else {
                                  // 認証失敗時の処理
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      self->_upperLabel.text = @"指紋認証に失敗しました";
                                      self->_lowerLabel.text = @"";
                                  });

                              }
                              
    }];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)done {
    // Return any edited content to the host app.
    // This template doesn't do anything, so we just echo the passed in items.
    
}

- (IBAction)cancel {

    NSError *unavailableError = [NSError errorWithDomain:NSItemProviderErrorDomain
                                                    code:NSItemProviderItemUnavailableError
                                                userInfo:nil];
    [self.extensionContext cancelRequestWithError:unavailableError];

}

@end
