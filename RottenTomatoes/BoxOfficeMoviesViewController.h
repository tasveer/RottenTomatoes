//
//  BoxOfficeMoviesViewController.h
//  RottenTomatoes
//
//  Created by Hunaid Hussain on 6/5/14.
//  Copyright (c) 2014 kolekse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"


@interface BoxOfficeMoviesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) NSString *urlString;

-(IBAction)refreshTable:(id)sender;

@end
