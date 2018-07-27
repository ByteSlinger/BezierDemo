//
//  AppDelegate.h
//  BezierDemo
//
//  Created by Michael S. Hearn on 7/27/18.
//  Copyright © 2018 ByteSlinger. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

