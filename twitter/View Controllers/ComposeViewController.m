//
//  ComposeViewController.m
//  twitter
//
//  Created by felipeccm on 6/29/21.
//  Copyright © 2021 Emerson Malca. All rights reserved.
//

#import "ComposeViewController.h"
#import "APIManager.h"
#import "Tweet.h"

@interface ComposeViewController ()
@property (weak, nonatomic) IBOutlet UITextView *tweetView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *closeButton;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ComposeViewController

// Dismisses view
- (IBAction)closeView:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view bringSubviewToFront:self.textView];
    [self.textView becomeFirstResponder];
    self.textView.layer.cornerRadius = 10;
    self.textView.layer.masksToBounds = true;
}

// Publishes tweet
- (IBAction)sendTweet:(id)sender {
    APIManager *manager = [APIManager new];
    [manager postStatusWithText:self.textView.text
                     completion:^(Tweet *tweet, NSError *error) {
        if (error){
            NSLog(@"ERROR: Failed to post tweet");
        }
        else {
            NSLog(@"Tweet posted successfully");
            tweet.text = self.textView.text;
            [self.delegate didTweet:tweet];
            [self dismissViewControllerAnimated:true completion:nil];
        }
    }];
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
