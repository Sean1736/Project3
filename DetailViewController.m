//
//  DetailViewController.m
//  Project3
//
//  Created by Cindy Barnsdale on 5/19/16.
//  Copyright © 2016 Dr Tech PC. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;


@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Using the outlet above from the text field in storyboard, we will set the custom text the user will provide for the textView. This will transfer the title to the header (navigation controller) of the new window and description below it in the main viewing area (text view).
    self.textView.text = self.descriptionString;
    self.title = self.titleString;
}


@end
