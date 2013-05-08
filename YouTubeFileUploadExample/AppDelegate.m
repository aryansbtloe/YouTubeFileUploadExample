//
//  AppDelegate.m
//  YouTubeFileUploadExample
//
//  Created by Alok on 08/05/13.
//  Copyright (c) 2013 Konstant Info Private Limited. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    [self.window setRootViewController:[[UINavigationController alloc]initWithRootViewController:[[ViewController alloc]initWithNibName:@"ViewController" bundle:nil]]];
    return YES;
}


@end
