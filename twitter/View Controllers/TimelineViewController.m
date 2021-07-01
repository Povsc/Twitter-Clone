//
//  TimelineViewController.m
//  twitter
//
//  Created by emersonmalca on 5/28/18.
//  Copyright © 2018 Emerson Malca. All rights reserved.
//

#import "TimelineViewController.h"
#import "APIManager.h"
#import "AppDelegate.h"
#import "LoginViewController.h"
#import "TweetCell.h"
#import "Tweet.h"
#import "ComposeViewController.h"
#import "DetailsViewController.h"

@interface TimelineViewController () <ComposeViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *composeButtonView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    // Initialize a UIRefreshControl
        UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
        [refreshControl addTarget:self action:@selector(beginRefresh:) forControlEvents:UIControlEventValueChanged];
        [self.tableView insertSubview:refreshControl atIndex:0];
    
    [self beginRefresh:refreshControl];
    
    // Round edges of compose button
    self.composeButtonView.layer.cornerRadius = 25;
    self.composeButtonView.layer.masksToBounds = true;
    
    // Send it to the front
    [self.view bringSubviewToFront:self.composeButtonView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)logOut:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;

    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LoginViewController *loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    appDelegate.window.rootViewController = loginViewController;
    
    [[APIManager shared] logout];
}

- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    cell.tweet = tweet;
    
    [cell refreshData];
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

// Makes a network request to get updated data
// Updates the tableView with the new data
// Hides the RefreshControl
- (void)beginRefresh:(UIRefreshControl *)refreshControl {
    
        [refreshControl beginRefreshing];
          // Get timeline
        [[APIManager shared] getHomeTimelineWithCompletion:^(NSArray *tweets, NSError *error) {
            if (tweets) {
                NSMutableArray *tweetsArray = [Tweet tweetsWithArray:tweets];
                self.arrayOfTweets = tweetsArray;
                
            } else {
                NSLog(@"😫😫😫 Error getting home timeline: %@", error.localizedDescription);
            }
            self.tableView.rowHeight = UITableViewAutomaticDimension;
            [self.tableView reloadData];
        }];

        // Tell the refreshControl to stop spinning
        [refreshControl endRefreshing];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier  isEqual: @"toCompose"]){
        UINavigationController *navigationController = [segue destinationViewController];
        ComposeViewController *composeController = (ComposeViewController*)navigationController.topViewController;
        composeController.delegate = self;
    }
    else if ([segue.identifier  isEqual: @"toDetails"]){
        TweetCell *tappedCell = sender;
        DetailsViewController *detailsViewController = [segue destinationViewController];
        detailsViewController.tweet = tappedCell.tweet;
        tappedCell.highlighted = false;
    }
}

- (void)didTweet:(nonnull Tweet *)tweet {
    [self.arrayOfTweets insertObject:tweet atIndex:0];
    [self.tableView reloadData];
}

@end
