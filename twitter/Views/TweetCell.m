//
//  TweetCell.m
//  twitter
//
//  Created by felipeccm on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "TweetCell.h"
#import "APIManager.h"

@implementation TweetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
    self.tweetLabel.text = self.tweet.text;
    self.likesLabel.text = [NSString stringWithFormat:@"%d",
                            self.tweet.favoriteCount];
    self.retweetsLabel.text = [NSString stringWithFormat:@"%d",
                               self.tweet.retweetCount];
    self.repliesLabel.text = [NSString stringWithFormat:@"%d",
                              self.tweet.replyCount];
    self.dateLabel.text = self.tweet.createdAtString;
    self.usernameLabel.text = user.screenName;
    
    // Make sure labels are in the front
    [self.contentView bringSubviewToFront:self.retweetsLabel];
    [self.contentView bringSubviewToFront:self.likesLabel];
    [self.contentView bringSubviewToFront:self.repliesLabel];
    
    
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

@end
