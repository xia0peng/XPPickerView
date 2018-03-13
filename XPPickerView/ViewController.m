//
//  ViewController.m
//  XPPickerView
//
//  Created by 王小朋 on 2018/3/13.
//  Copyright © 2018年 王小朋. All rights reserved.
//

#import "ViewController.h"
#import "XPPickerView.h"

#define UIColorFromRGB(argbValue) [UIColor colorWithRed:((float)((argbValue & 0x00FF0000) >> 16))/255.0 green:((float)((argbValue & 0x0000FF00) >> 8))/255.0 blue:((float)(argbValue & 0x000000FF))/255.0 alpha:((float)((argbValue & 0xFF000000) >> 24))/255.0]

@interface ViewController ()<PickerViewOneDelegate>

@property (strong, nonatomic)XPPickerView *PickerOne;

@property (strong, nonatomic)NSMutableArray *midArry;

@property (strong, nonatomic)UIButton *button;

@end

@implementation ViewController

#pragma mark - lify cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    for (NSInteger j = 0; j < 30; j++) {
        [self.midArry addObject:[NSString stringWithFormat:@"我爱你❤️%2ld遍",(long)j+1]];
    }
    
    [self.view addSubview:self.button];
    
    [self.view addSubview:self.PickerOne ];
}

#pragma mark - CustomDelegate
//确认按钮
- (void)PickerViewRightButtonOncleck:(NSInteger)index{
    
    NSLog(@"%ld---%@",(long)index,self.midArry[index]);
    
    [self.PickerOne close];
}

//实时选择
- (void)PickerViewOneDelegateOncleck:(NSInteger)index{
    
    NSLog(@"%ld---%@",(long)index,self.midArry[index]);
}

#pragma mark - even resopnse
- (void)selectAlert{
    
    [self.PickerOne show];
}


#pragma mark - setters and getters
- (XPPickerView *)PickerOne{
    if (!_PickerOne) {
        //这里的frame为假数据  不起作用(自己不喜欢的话可以另写方法不要frame参数)
        self.PickerOne = [[XPPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 150, self.view.frame.size.width, 150) midArry:_midArry];
        self.PickerOne.delegate = self;
        self.PickerOne.rightBtnTitle = @"确认";
        self.PickerOne.title = @"这是标题";
        self.PickerOne.isTitle = @"1";
        self.PickerOne.backgroundColor = [UIColor whiteColor];
    }
    return _PickerOne;
}

- (UIButton *)button{
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        [_button setTitle:@"button" forState:UIControlStateNormal];
        [_button setBackgroundColor:[UIColor redColor]];
        [_button setFrame:CGRectMake(0, 20, self.view.frame.size.width, 40)];
        [_button addTarget:self action:@selector(selectAlert) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (NSMutableArray *)midArry{
    if (!_midArry) {
        _midArry = [NSMutableArray arrayWithCapacity:0];
    }
    return _midArry;
}

@end
