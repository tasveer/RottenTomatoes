//
//  BoxOfficeMoviesViewController.m
//  RottenTomatoes
//
//  Created by Hunaid Hussain on 6/5/14.
//  Copyright (c) 2014 kolekse. All rights reserved.
//

#import "BoxOfficeMoviesViewController.h"
#import "MovieCell.h"
#import "Movie.h"
#import "MovieDetailsViewController.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperation.h"
#import "MBProgressHUD.h"



static  NSUInteger rowHeight = 130;

@interface BoxOfficeMoviesViewController ()
@property (weak, nonatomic)   IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray* movies;
@property (nonatomic, strong) NSArray* movieList;
@property (weak, nonatomic)   IBOutlet UIView *errorView;
@property (nonatomic, strong) UIRefreshControl *refreshControl;
@property (nonatomic, strong) MBProgressHUD* HUD;
@property (strong, nonatomic) UIBarButtonItem *refreshButton;


@end

@implementation BoxOfficeMoviesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Movies" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;

    // Add the refresh button when a Network error shows up
    self.refreshButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refreshTable:) ];
    
    
    [ self.errorView setHidden:YES ];
    
    [ self addPullToRefresh ];
    [ self loadTable ];
    
    self.tableView.rowHeight = rowHeight;
    [ self.tableView registerNib:[ UINib nibWithNibName:@"MovieCell" bundle:nil] forCellReuseIdentifier:@"MovieCell" ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //return [ self.movies count];
    return [ self.movieList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MovieCell *movieCell = [ tableView dequeueReusableCellWithIdentifier:@"MovieCell" ];
    
    Movie *movie = self.movieList[indexPath.row];

    NSLog(@"movie title: %@", [movie title]);
    movieCell.titleLabel.text = [ movie title];
    movieCell.synopsisLabel.text = [ movie synopsis];
    
    NSDictionary* posterImages = [ movie posterImages ];

    
    NSURL *url = [NSURL URLWithString:posterImages[@"thumbnail"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    UIImage *placeholderImage = [UIImage imageNamed:@"filmPlaceholder.jpg"];
    
    // Lazy load images
    __weak MovieCell *weakCell = movieCell;
    
    [movieCell.posterView setImageWithURLRequest:request
                          placeholderImage:placeholderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

                                       [UIView transitionWithView:weakCell.posterView
                                                         duration:0.3
                                                          options:UIViewAnimationOptionTransitionCrossDissolve
                                                       animations:^{
                                                           weakCell.posterView.image = image;
                                                       }
                                                       completion:NULL];
                                       
                                       [weakCell setNeedsLayout];
                                       
                                   } failure:nil];
    return movieCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    MovieDetailsViewController *mDvc = [[MovieDetailsViewController alloc] initWithNibName:@"MovieDetailsViewController" bundle:nil];
    
    mDvc.hidesBottomBarWhenPushed = YES;
    
    Movie *movie = self.movieList[indexPath.row];
    
    // Initialized the MovieDetailsView controller with most of the data, so
    // that when this controller animates into the view, the the populated
    // screen slides up from right.
    
    mDvc.synopsisScroll.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0.0f];
    
    mDvc.detailedSynopsis.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
    
    mDvc.detailedSynopsis.text = [ NSString stringWithFormat:@"%@\n\n\n%@", [movie title], [movie synopsis]];
    
    [mDvc.detailedSynopsis sizeToFit];

    NSDictionary *posterImages = [ movie posterImages];
    
    NSURL *url = [NSURL URLWithString:posterImages[@"thumbnail"]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    // Pick up the low res thumbnail image from the cache
    // The hig res image would be lazily loaded when the MovieDetailsView controller shows up
    
    __weak UIImageView *weakImageView = mDvc.moviePosterImage;
    
    [mDvc.moviePosterImage setImageWithURLRequest:request
                                 placeholderImage:nil
                                          success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                              
                                              weakImageView.image = image;
                                              [weakImageView setNeedsLayout];
                                              
                                          } failure:nil];
        
    mDvc.movie  = movie;
    

    
    [self.navigationController pushViewController:mDvc animated:YES];
    
    [tableView  deselectRowAtIndexPath:indexPath  animated:YES];

    return;

}

-(void) loadTable
{
    //NSString *urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=82frezr4edh95nruytatnkjd";
    //NSString *urlString = @"http://api.rottentomatoes.com/api/public/v1.0/lists/movies/box_office.json?apikey=82frezr4edh95nruytatnkjd";
    //NSString *urlString = @"http://pastebin.com/raw.php?i=XC6FcQFG";
    
    NSURL *url = [NSURL URLWithString:self.urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        self.movieList = [ Movie moviesWithArray:responseObject[@"movies"] ];
        
        //NSLog(@"movie list size %d", [ self.movieList count]);
        
        self.movies = responseObject[@"movies"];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        [ self.errorView setHidden:YES];
        [ self.view sendSubviewToBack:self.errorView ];
        [ self.errorView removeFromSuperview ];
        [ self.tableView setHidden:NO];

        self.navigationItem.rightBarButtonItem = nil;
        
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //NSLog(@"Going to display error view");
        
        [ self.view bringSubviewToFront:self.errorView];

        [ self.errorView setHidden:NO ];
        [ self.errorView setAlpha:1.0];
        [ self.tableView setHidden:YES];

        self.navigationItem.rightBarButtonItem = self.refreshButton;

        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
    }];
    
    [operation start];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];

}

-(void)reloadData
{
    //update table
    //NSLog(@"Reloading after refresh...");
    
    [ self loadTable ];
    
    [self.refreshControl endRefreshing];
}

-(IBAction)refreshTable:(id)sender
{
 
    [ self reloadData ];
    
}

-(void) addPullToRefresh {
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.tintColor = [UIColor grayColor];
    
    [self.tableView addSubview:self.refreshControl];
    
    /*
    NSMutableAttributedString *refreshString = [[NSMutableAttributedString alloc] initWithString:@"Pull To Refresh"];
    [refreshString addAttributes:@{NSForegroundColorAttributeName : [UIColor grayColor]} range:NSMakeRange(0, refreshString.length)];
    
    self.refreshControl.attributedTitle = refreshString;
     */
    
    [self.refreshControl addTarget:self action:@selector(reloadData) forControlEvents:UIControlEventValueChanged];


    return;
}

@end
