//
//  DetailViewController.m
//  Rss
//
//  Created by Admin on 06.09.14.
//  Copyright (c) 2014 Amitim. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        self.navigationItem.title = [newDetailItem objectForKey:@"title"];
        _detailItem = [newDetailItem objectForKey:@"description"];
        NSLog(@"%@", _detailItem);
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        //self.detailDescriptionLabel.text = self.detailItem;
        self.textView.text = self.detailItem;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
