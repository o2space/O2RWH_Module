//
//  AppDelegate.h
//  RWHModuleDemo
//
//  Created by wukexiu on 16/11/21.
//  Copyright © 2016年 com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

