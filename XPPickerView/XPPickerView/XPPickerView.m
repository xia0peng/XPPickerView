//
//  PickerView.m
//  Hu8huWorker
//
//  Created by xiaopeng on 2017/4/24.
//  Copyright © 2017年 王小朋. All rights reserved.
//

#import "XPPickerView.h"

#define onePickerH 50
#define midPickerH 50

#define Screen_Width [[UIScreen mainScreen] bounds].size.width
#define Screen_Height [[UIScreen mainScreen] bounds].size.height

#define LTColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]

#define UIColorFromRGB(argbValue) [UIColor colorWithRed:((float)((argbValue & 0x00FF0000) >> 16))/255.0 green:((float)((argbValue & 0x0000FF00) >> 8))/255.0 blue:((float)(argbValue & 0x000000FF))/255.0 alpha:((float)((argbValue & 0xFF000000) >> 24))/255.0]

@interface XPPickerView ()<UIScrollViewDelegate>{
    UIWindow *_window;
    UITapGestureRecognizer *_gesture;
    UIView *_view;
    
    int _seleNum;
}

@property (strong, nonatomic) UIView * select;
@property (strong, nonatomic) UIScrollView * startTime;
@property (strong, nonatomic) UIView  * all;
@property (strong, nonatomic) UILabel * allText;
@property (strong, nonatomic) UISwitch * allSwithch;
@property (assign, nonatomic) NSInteger  num;
@property (strong, nonatomic) NSMutableArray * midNSArry;


@end

@implementation XPPickerView

#pragma mark - lify cycle
- (instancetype)initWithFrame:(CGRect)frame midArry:(NSMutableArray *)midArry{
    
    self = [super initWithFrame:frame];
    if (self) {
        _midNSArry = [NSMutableArray arrayWithArray:midArry];
        
        /**
         处理数组
         */
        [_midNSArry insertObject:@"数组第一位" atIndex:0];
        [_midNSArry insertObject:@" " atIndex:1];
        [_midNSArry addObject:@" "];
        [_midNSArry addObject:@"数组最后一位"];
    }
    return self;
}

#pragma mark - even resopnse
- (void)leftbtnOnclick{
    [self close];
}

- (void)rightBtnOnclick{
    if ([self.delegate respondsToSelector:NSSelectorFromString(@"PickerViewRightButtonOncleck:")]) {
        [self.delegate  PickerViewRightButtonOncleck:_seleNum];
    }
}

#pragma mark 打开与关闭方法
-(void)show{
    
    [self setUI];
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, Screen_Height - 300, Screen_Height, 300);
    }];
    
}

-(void)close{
    //移除点击手势
    [_window removeGestureRecognizer:_gesture];
    _gesture = nil;
    [UIView animateWithDuration:0.2 animations:^{
        self.frame = CGRectMake(0, Screen_Height, Screen_Width, 300);
    } completion:^(BOOL finished) {
        
        for(id subv in [self subviews])
        {
            [subv removeFromSuperview];
        }
        [_view removeFromSuperview];
    }];
}

#pragma mark - private resopnse
- (void)setUI{
    
    self.frame = CGRectMake(0, Screen_Height, Screen_Width, 300);
    
    _num = _midNSArry.count;
    
    UIView * topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
    [topView setBackgroundColor:UIColorFromRGB(0xff38acff)];
    [self addSubview:topView];
    
    UIButton *leftBtn = [[UIButton alloc]init];
    leftBtn.frame = CGRectMake(15, 0, 40, 50);
    [leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(leftbtnOnclick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:leftBtn];
    
    if ([_isTitle isEqualToString:@"1"]) {
        UILabel *titleLable = [[UILabel alloc]init];
        titleLable.frame = CGRectMake(Screen_Width/2-50, 0, 100, 50);
        titleLable.text = _title;
        titleLable.textAlignment = NSTextAlignmentCenter;
        titleLable.font = [UIFont systemFontOfSize:18];
        titleLable.textColor = [UIColor whiteColor];
        [topView addSubview:titleLable];
    }
    
    UIButton *rightBtn = [[UIButton alloc]init];
    rightBtn.frame = CGRectMake(Screen_Width-15-100, 0, 100, 50);
    [rightBtn setTitle:_rightBtnTitle forState:UIControlStateNormal];
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(rightBtnOnclick) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightBtn];
    
    self.select = [[UIView alloc] initWithFrame:CGRectMake(0, 50, self.frame.size.width, 250)];
    [self addSubview:self.select];
    
    self.startTime = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-50)];
    self.startTime.delegate = self;
    [self.startTime setShowsVerticalScrollIndicator:NO];
    [self.startTime setShowsHorizontalScrollIndicator:NO];
    [self.select addSubview:self.startTime];
    
    [self addStart:self.frame leftArry:_midNSArry];
    
    UIView * seleViewColor = [[UIView alloc] initWithFrame:CGRectMake(0, 100, self.frame.size.width, 50)];
    [seleViewColor setBackgroundColor:UIColorFromRGB(0xfff3faff)];
    [self.select addSubview:seleViewColor];
    
    [self.select bringSubviewToFront:self.startTime];
    
    UIView * line1 = [[UIView alloc] initWithFrame:CGRectMake(0, onePickerH, self.frame.size.width, 1)];
    [line1 setBackgroundColor:UIColorFromRGB(0xffc3e1f6)];
    [self addSubview:line1];
    
    UIView * line3 = [[UIView alloc] initWithFrame:CGRectMake(0, onePickerH*3, self.frame.size.width, 1)];
    [line3 setBackgroundColor:UIColorFromRGB(0xffc3e1f6)];
    [self addSubview:line3];
    
    UIView * line4 = [[UIView alloc] initWithFrame:CGRectMake(0, onePickerH*4, self.frame.size.width, 1)];
    [line4 setBackgroundColor:UIColorFromRGB(0xffc3e1f6)];
    [self addSubview:line4];
    
    _window = [UIApplication sharedApplication].keyWindow;
    [_window addSubview:self];
    _gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(close)];
    [_window addGestureRecognizer:_gesture];
    _view = [[UIView alloc]initWithFrame:_window.bounds];
    _view.backgroundColor = LTColor(0, 0, 0, 0.8);
    [_window addSubview:_view];
    [_view addSubview:self];
}

- (void)addStart:(CGRect)frame leftArry:(NSArray *)leftArry{
    
    for(NSInteger index = 0; index < leftArry.count; index++){
        
        NSString * title = @"";
        if(index != 0 && index != leftArry.count-1){
            
            title = [NSString stringWithFormat:@"%@",leftArry[index]];
        }
        UILabel *_startTime1 = [[UILabel alloc] initWithFrame:CGRectMake(0, index*onePickerH, frame.size.width,onePickerH)];
        [_startTime1 setText:title];
        _startTime1.tag = 10 + index;
        [_startTime1 setTextAlignment:NSTextAlignmentCenter];
        if (index == 2) {
            
            [_startTime1 setTextColor:UIColorFromRGB(0xff38acff)];
            [_startTime1 setFont:[UIFont systemFontOfSize:15]];
        }else{
            
            [_startTime1 setTextColor:UIColorFromRGB(0xff333333)];
            [_startTime1 setFont:[UIFont systemFontOfSize:13]];
        }
        
        [self.startTime addSubview:_startTime1];
        
    }
    
    [self.startTime setContentSize:CGSizeMake(frame.size.width/2,onePickerH*leftArry.count)];
}


//4、已经结束拖拽，手指刚离开view的那一刻
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
    if(!decelerate){
        int  pointY=scrollView.contentOffset.y;
        CGFloat f =  pointY %onePickerH;
        int s = pointY/onePickerH;
        int s1 = s;
        if(f>20){
            s1 = s+1;
            NSLog(@"%d",s1*onePickerH);
            [scrollView setContentOffset:CGPointMake(0, s1*onePickerH) animated:YES];
        }else{
            s1 = s;
            NSLog(@"%d",s1*onePickerH);
            [scrollView setContentOffset:CGPointMake(0, s1*onePickerH) animated:YES];
        }
        
        for (int i = 0; i < _num; i++) {
            if ( i == s1+2) {
                
                UILabel * textLabel = [self.startTime viewWithTag:i+10];
                NSLog(@"%@",textLabel.text);
                textLabel.textColor = UIColorFromRGB(0xff38acff);
                textLabel.font = [UIFont systemFontOfSize:15];
            }else{
                
                UILabel * textLabel = [self.startTime viewWithTag:i+10];
                textLabel.textColor = UIColorFromRGB(0xff333333);
                textLabel.font = [UIFont systemFontOfSize:13];
            }
        }
        
        _seleNum = s1;
        
        if ([self.delegate respondsToSelector:NSSelectorFromString(@"PickerViewOneDelegateOncleck:")]) {
            [self.delegate  PickerViewOneDelegateOncleck:s1];
        }
    }
}

//6、view已经停止滚动
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int pointY=scrollView.contentOffset.y;
    CGFloat f =  pointY %onePickerH;
    int s = pointY/onePickerH;
    int s1;
    if(f>20){
        s1 = s+1;
        NSLog(@"%d",s1*onePickerH);
        [scrollView setContentOffset:CGPointMake(0, s1*onePickerH) animated:YES];
        
    }else{
        s1 = s;
        NSLog(@"%d",s1*onePickerH);
        [scrollView setContentOffset:CGPointMake(0, s1*onePickerH) animated:YES];
    }
    
    for (int i = 0; i < _num; i++) {
        if ( i == s1+2) {
            
            UILabel * textLabel = [self.startTime viewWithTag:i+10];
            NSLog(@"%@",textLabel.text);
            textLabel.textColor = UIColorFromRGB(0xff38acff);
            textLabel.font = [UIFont systemFontOfSize:15];
        }else{
            
            UILabel * textLabel = [self.startTime viewWithTag:i+10];
            textLabel.textColor = UIColorFromRGB(0xff333333);
            textLabel.font = [UIFont systemFontOfSize:13];
        }
    }
    
    _seleNum = s1;
    
    if ([self.delegate respondsToSelector:NSSelectorFromString(@"PickerViewOneDelegateOncleck:")]) {
        [self.delegate  PickerViewOneDelegateOncleck:s1];
    }
}



@end
