//
//  DetailsViewController.m
//  twitter
//
//  Created by felipeccm on 7/1/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "DetailsViewController.h"
#import "APIManager.h"
#import "TweetCell.h"

@interface DetailsViewController ()

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self refreshData];
}


- (IBAction)didTapLike:(id)sender {
    if (!self.tweet.favorited){
        self.tweet.favorited = YES;
        self.tweet.favoriteCount += 1;
        [self refreshData];
        [[APIManager shared] favorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error favoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully favorited the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        self.tweet.favorited = NO;
        self.tweet.favoriteCount -= 1;
        [self refreshData];
        [[APIManager shared] unfavorite:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unfavoriting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unfavorited the following Tweet: %@", tweet.text);
            }
        }];
    }
}
- (IBAction)didTapRetweet:(id)sender {
    if (!self.tweet.retweeted){
        self.tweet.retweeted = YES;
        self.tweet.retweetCount += 1;
        [self refreshData];
        [[APIManager shared] retweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error retweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully retweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
    else{
        self.tweet.retweeted = NO;
        self.tweet.retweetCount -= 1;
        [self refreshData];
        [[APIManager shared] unretweet:self.tweet completion:^(Tweet *tweet, NSError *error) {
            if(error){
                NSLog(@"Error unretweeting tweet: %@", error.localizedDescription);
            }
            else{
                NSLog(@"Successfully unretweeted the following Tweet: %@", tweet.text);
            }
        }];
    }
}

- (void)refreshData {
    // Set labels
    User *user = self.tweet.user;
    self.authorLabel.text = user.name;
    self.textView.text = self.tweet.text;
    
    // Make sure labels are in the front
    [self.view bringSubviewToFront:self.retweetsLabel];
    [self.view bringSubviewToFront:self.likesLabel];
    
    // Set number of likes
    if (self.tweet.favoriteCount < 1000){
        self.likesLabel.text = [NSString stringWithFormat:@"%d",
                                self.tweet.favoriteCount];
    }
    else if (self.tweet.favoriteCount < 1000000){
        self.likesLabel.text = [NSString stringWithFormat:@"%.1fk",
                                self.tweet.favoriteCount / 1000.0];
    }
    else {
        self.likesLabel.text = [NSString stringWithFormat:@"%.1fM",
                                self.tweet.favoriteCount / 1000000.0];
    }
    
    // Set the number of retweets
    if (self.tweet.retweetCount < 1000){
        self.retweetsLabel.text = [NSString stringWithFormat:@"%d",
                                self.tweet.retweetCount];
    }
    else if (self.tweet.retweetCount < 1000000){
        self.retweetsLabel.text = [NSString stringWithFormat:@"%.1fk",
                                self.tweet.retweetCount / 1000.0];
    }
    else {
        self.retweetsLabel.text = [NSString stringWithFormat:@"%.1fM",
                                self.tweet.retweetCount / 1000000.0];
    }
    
    //Se date and username
    self.dateLabel.text = self.tweet.createdAtString;
    self.usernameLabel.text = user.screenName;
    
    // Set profile picture
    NSString *URLString = user.profilePicture;
    
    // Get higher resolution image
    URLString = [URLString stringByReplacingOccurrencesOfString:@"_normal" withString:@""];
    NSURL *url = [NSURL URLWithString:URLString];
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    self.profilePicture.image = [UIImage imageWithData:urlData];
    
    // Set liked/retweeted images
    if (self.tweet.favorited) {
        self.likesImage.image = [UIImage imageNamed:@"favor-icon-red"];
    }
    else{
        self.likesImage.image = [UIImage imageNamed:@"favor-icon"];
    }
    
    if (self.tweet.retweeted) {
        self.retweetsImage.image = [UIImage imageNamed:@"retweet-icon-green"];
    }
    else {
        self.retweetsImage.image = [UIImage imageNamed:@"retweet-icon"];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
