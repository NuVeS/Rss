//
//  DetailViewController.h
//  Rss
//
//  Created by Admin on 06.09.14.
//  Copyright (c) 2014 Amitim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;


@property (weak, nonatomic) IBOutlet UITextView *textView;
@end
