//
//  MovieDetailsViewController.h
//  RottenTomatoes
//
//  Created by Hunaid Hussain on 6/7/14.
//  Copyright (c) 2014 kolekse. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Movie.h"
//#import "UIImageView+AFNetworking.h"


@interface MovieDetailsViewController : UIViewController <UIScrollViewDelegate>

@property (weak, nonatomic)   IBOutlet UIImageView *moviePosterImage;
@property (strong, nonatomic) IBOutlet UILabel *detailedSynopsis;
@property (weak, nonatomic)   Movie    *movie;
@property (strong, nonatomic) IBOutlet UIScrollView *synopsisScroll;

@end
