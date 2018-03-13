//
//  PickerView.h
//  Hu8huWorker
//
//  Created by xiaopeng on 2017/4/24.
//  Copyright © 2017年 王小朋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PickerViewOneDelegate <NSObject>

@optional
- (void)PickerViewOneDelegateOncleck:(NSInteger)index;

- (void)PickerViewRightButtonOncleck:(NSInteger)index;

@end

@interface XPPickerView : UIView

- (instancetype)initWithFrame:(CGRect)frame midArry:(NSMutableArray *)midArry;

@property (nonatomic, assign) id<PickerViewOneDelegate>delegate;

-(void)show;
-(void)close;

@property (nonatomic, copy) NSString *isTitle;

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *rightBtnTitle;

@end
