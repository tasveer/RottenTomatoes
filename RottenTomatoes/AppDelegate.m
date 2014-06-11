//
//  AppDelegate.m
//  RottenTomatoes
//
//  Created by Hunaid Hussain on 6/5/14.
//  Copyright (c) 2014 kolekse. All rights reserved.
//

#import "AppDelegate.h"
#import "BoxOfficeMoviesViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    
    // Setup a shared cache of 10 Mb
    NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:10 * 1024 * 1024
                                                            diskCapacity:100 * 1024 * 1024
                                                                diskPath:nil];
    [NSURLCache setSharedURLCache:sharedCache];
    
    // Create the two view controllers, each within a navigation controller
    BoxOfficeMoviesViewController *boMvc = [[BoxOfficeMoviesViewController alloc] init];
    boMvc.urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=82frezr4edh95nruytatnkjd";
    boMvc.title = @"Box Office Movies";
    
    UINavigationController *boxOfficeNvc = [[UINavigationController alloc] initWithRootViewController:boMvc];
    boxOfficeNvc.tabBarItem.title = @"Box Office";
    boxOfficeNvc.tabBarItem.image = [UIImage imageNamed:@"movie_ticket"];
    
    BoxOfficeMoviesViewController *topRvc = [[BoxOfficeMoviesViewController alloc] init];
    topRvc.urlString = @"http://hapi.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=82frezr4edh95nruytatnkjd";
    topRvc.title = @"Top Rentals Movies";
    
    UINavigationController *topRentalsNvc = [[UINavigationController alloc] initWithRootViewController:topRvc];
    topRentalsNvc.tabBarItem.title = @"Top DVDs";
    topRentalsNvc.tabBarItem.image = [UIImage imageNamed:@"dvd_rental"];
    
    // Configure the tab bar controller with the two navigation controllers
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[boxOfficeNvc, topRentalsNvc];
    
    self.window.rootViewController = tabBarController;

    
    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
