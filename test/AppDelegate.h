//
//  AppDelegate.h
//  test
//
//  Created by wdwk on 2016/12/30.
//  Copyright © 2016年 wksc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;
@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundUpdateTask;

- (void)saveContext;


@end

