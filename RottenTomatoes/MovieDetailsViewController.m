//
//  MovieDetailsViewController.m
//  RottenTomatoes
//
//  Created by Hunaid Hussain on 6/7/14.
//  Copyright (c) 2014 kolekse. All rights reserved.
//

#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"

@interface MovieDetailsViewController ()

@end

@implementation MovieDetailsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        //NSLog(@"init with nib");
        
        float contentHeight = self.view.frame.size.height - self.navigationController.toolbar.frame.size.height - self.navigationController.navigationBar.frame.size.height;
        

        NSLog(@"frame size height: %f content height: %f", self.view.frame.size.height, contentHeight);
        
        [self.synopsisScroll setContentSize: CGSizeMake(320, contentHeight)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //NSLog(@"view did load");
}

- (void) viewDidAppear:(BOOL)animated {

    //NSLog(@"view did appear");
    
    self.title = [ self.movie title ];

    NSDictionary* posterImages = [ self.movie posterImages ];
    

    
    [self.synopsisScroll flashScrollIndicators ];
    

    // This piece of commented code is working, it demonstrated how two AFNetworking calls can be embedded
    // within each other to first pick up the low res image from cache and later do an asynchronous
    // high resolution image download
    
    /*
    __weak UIImageView *weakBg = self.moviePosterImage;
    
    //get the placeholder - note the placeholderImage parameter is nil (I don't need a placeholder to the placeholder
    [self.moviePosterImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:posterImages[self.posterImageType]]]
              placeholderImage: nil
                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
     
                           
                           //__weak UIImageView *weakBg.image = image;
                           
                           //Get the original bg with the low quality bg as placeholder
                           [self.moviePosterImage setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:posterImages[@"original"]]]
                                           placeholderImage:image
                                                    success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                                        
                                                        weakBg.image = image;
                                                        
                                                        [ weakBg setNeedsLayout];
                                                        
                                                    } failure:NULL];
                       } failure:NULL];
    */
    
    
    
    NSURL *url = [NSURL URLWithString:posterImages[@"original"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __weak UIImageView *weakImageView = self.moviePosterImage;
    
    [self.moviePosterImage setImageWithURLRequest:request
                                 placeholderImage:nil
                                         success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                             
                                             weakImageView.image = image;
                                             [weakImageView setNeedsLayout];
                                             
                                         } failure:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
