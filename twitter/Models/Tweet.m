//
//  Tweet.m
//  twitter
//
//  Created by felipeccm on 6/28/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "Tweet.h"
#import "User.h"


@implementation Tweet

- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
     self = [super init];
     if (self) {

         // Is this a re-tweet?
         NSDictionary *originalTweet = dictionary[@"retweeted_status"];
         if(originalTweet != nil){
             NSDictionary *userDictionary = dictionary[@"user"];
             self.retweetedByUser = [[User alloc] initWithDictionary:userDictionary];

             // Change tweet to original tweet
             dictionary = originalTweet;
         }
         self.idStr = dictionary[@"id_str"];
         self.text = dictionary[@"full_text"];
         self.favoriteCount = [dictionary[@"favorite_count"] intValue];
         self.favorited = [dictionary[@"favorited"] boolValue];
         self.retweetCount = [dictionary[@"retweet_count"] intValue];
         self.retweeted = [dictionary[@"retweeted"] boolValue];
         self.replyCount = [dictionary[@"reply_count"] intValue];
         
         // Initializes user
         NSDictionary *user = dictionary[@"user"];
         self.user = [[User alloc] initWithDictionary:user];

         // Format createdAt date string
         NSString *createdAtOriginalString = dictionary[@"created_at"];
         NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
         // Configure the input format to parse the date string
         formatter.dateFormat = @"E MMM d HH:mm:ss Z y";
         // Convert String to Date
         NSDate *date = [formatter dateFromString:createdAtOriginalString];
         // Configure output format
         formatter.dateStyle = NSDateFormatterShortStyle;
         formatter.timeStyle = NSDateFormatterNoStyle;
         // Compute how much time has passed
         NSTimeInterval secondsSince = [date timeIntervalSinceNow];
         int seconds = secondsSince * (-1);
         int minutes = seconds / 60;
         int hours = minutes / 60;
         int days = hours / 24;
         // Convert Date to String
         if (minutes < 1){
             self.createdAtString = [NSString stringWithFormat:@"%ds ago", seconds];
         }
         else if (hours < 1){
             self.createdAtString = [NSString stringWithFormat:@"%dm ago", minutes];
         }
         else if (days < 7){
             self.createdAtString = [NSString stringWithFormat:@"%dd ago", days];
         }
         else {
             self.createdAtString = [formatter stringFromDate:date];
         }
     }
     return self;
 }

+ (NSMutableArray *)tweetsWithArray:(NSArray *)dictionaries {
    NSMutableArray *tweets = [NSMutableArray array];
    for (NSDictionary *dictionary in dictionaries) {
        Tweet *tweet = [[Tweet alloc] initWithDictionary:dictionary];
        [tweets addObject:tweet];
    }
    return tweets;
}

@end
