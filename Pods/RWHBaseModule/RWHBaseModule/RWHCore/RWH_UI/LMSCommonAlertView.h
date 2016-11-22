//
//  LMSCommonAlertView.h
//  LetMeSpend
//
//  Created by liuhongmei on 15/12/28.
//  Copyright © 2015年 __defaultyuan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^commonAlertViewBlock)(void);

@interface LMSCommonAlertView : UIView

//+ (instancetype)alertViewWithTitleDes:(NSString *)titleDes
//                              message:(NSString *)message
//                           messageDes:(NSString *)messageDes
//                          buttonTitle:(NSString *)buttonTitle
//                  buttonTouchedAction:(commonAlertViewBlock)buttonBlock
//                        dismissAction:(commonAlertViewBlock)dismissBlock;

+(instancetype)alertViewwithTitle:(NSString *)title
                          message:(NSString *)message
                   cancelBtnTitle:(NSString *)cancelTitle
                       okBtnTitle:(NSString *)okBtnTittle
              buttonTouchedAction:(commonAlertViewBlock)buttonBlock
                    dismissAction:(commonAlertViewBlock)dismissBlock;

+ (instancetype)alertViewwithTitle:(NSString *)title
                           message:(NSString *)message
                    cancelBtnTitle:(NSString *)cancelTitle
                     okBtnRedTitle:(NSString *)okBtnRedTittle
               buttonTouchedAction:(commonAlertViewBlock)buttonBlock
                     dismissAction:(commonAlertViewBlock)dismissBlock;

+ (instancetype)alertViewWithChangeTitle:(NSString *)title
                                 message:(NSString *)message
                          cancelBtnTitle:(NSString *)cancelTitle
                              okBtnTitle:(NSString *)okBtnTittle
                     buttonTouchedAction:(commonAlertViewBlock)buttonBlock
                           dismissAction:(commonAlertViewBlock)dismissBlock;

- (void)show;
- (void)dismiss;

@property (nonatomic, copy) commonAlertViewBlock buttonBlock;

@end
