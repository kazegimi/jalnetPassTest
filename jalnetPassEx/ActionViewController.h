//
//  ActionViewController.h
//  jalnetPassEx
//
//  Created by Seiji Mitsuda on 2017/03/09.
//  Copyright © 2017年 Another Sky. All rights reserved.
//

#import <UIKit/UIKit.h>

@import UICKeyChain;
@import LocalAuthentication;

@interface ActionViewController : UIViewController

@property(weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property(weak, nonatomic) IBOutlet UILabel *upperLabel;
@property(weak, nonatomic) IBOutlet UILabel *lowerLabel;

@end
