//
//  TabBarController.m
//  EmptyTestProject
//
//  Created by WangShengFeng on 16/4/7.
//  Copyright © 2016年 loveuqian. All rights reserved.
//

#import "TabBarController.h"
#import "NavigationController.h"
#import "TableViewController.h"

@interface TabBarController ()

@end

@implementation TabBarController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self addChildViewController];
}

- (void)addChildViewController
{
    [self addOneChildViewController:[[TableViewController alloc] init] title:@"一"];
    
    [self addOneChildViewController:[[TableViewController alloc] init] title:@"二"];
    
    [self addOneChildViewController:[[TableViewController alloc] init] title:@"三"];
}

- (void)addOneChildViewController:(UIViewController *)vc title:(NSString *)title
{
    NavigationController *navVC = [[NavigationController alloc] initWithRootViewController:vc];
    vc.title = title;
    [self addChildViewController:navVC];
}

@end
