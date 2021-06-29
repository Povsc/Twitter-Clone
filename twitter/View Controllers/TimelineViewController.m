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

@interface TimelineViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *arrayOfTweets;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation TimelineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath {
    TweetCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TweetCell"];
    Tweet *tweet = self.arrayOfTweets[indexPath.row];
    cell.tweet = tweet;    User *user = tweet.user;
    
    // Set labels
    cell.authorLabel.text = user.name;
    cell.tweetLabel.text = tweet.text;
    cell.likesLabel.text = [NSString stringWithFormat:@"%d",
                            tweet.favoriteCount];
    cell.retweetsLabel.text = [NSString stringWithFormat:@"%d",
                            tweet.retweetCount];
    cell.repliesLabel.text = [NSString stringWithFormat:@"%d",
                            tweet.replyCount];
    cell.dateLabel.text = tweet.createdAtString;
    cell.usernameLabel.text = user.screenName;
    
    // Set profile picture
    NSString *URLString = user.profilePicture;
    
    // Get higher resolution image
    URLString = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    cell.profilePicture.image = [UIImage imageWithData:urlData];
    
    // Set liked/retweeted images
    if (tweet.favorited) {
        cell.likesImage.image = [UIImage imageNamed:@"favor-icon-red"];
    }
    
    if (tweet.retweeted) {
        cell.retweetsImage.image = [UIImage imageNamed:@"retweet-icon-green"];
    }
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfTweets.count;
}

@end
