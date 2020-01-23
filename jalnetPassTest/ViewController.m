//
//  ViewController.m
//  jalnetPassTest
//
//  Created by Seiji Mitsuda on 2017/03/09.
//  Copyright © 2017年 Another Sky. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UITextField *IDTextField;
@property (weak, nonatomic) IBOutlet UITextField *PassTextField;
@property (weak, nonatomic) IBOutlet UIButton *regButton;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)registerButton:(id)sender {
    
    UICKeyChainStore *kcs = [UICKeyChainStore keyChainStore];
    
    kcs.accessibility = UICKeyChainStoreAccessibilityWhenUnlockedThisDeviceOnly;
    
    [kcs setString:_IDTextField.text forKey:@"userID"];
    [kcs setString:_PassTextField.text forKey:@"password"];

    _IDTextField.text = @"";
    _PassTextField.text = @"";
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"registered"
                                                                             message:@"登録しました。アプリを終了します"
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                        style:UIAlertActionStyleDefault
                                                      handler:^(UIAlertAction *action) {exit(1);}]];
    
    [self presentViewController:alertController
                       animated:YES
                     completion:^{}];
    
}

@end
