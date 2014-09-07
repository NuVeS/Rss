//
//  MasterViewController.h
//  Rss
//
//  Created by Admin on 06.09.14.
//  Copyright (c) 2014 Amitim. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MasterViewController : UITableViewController <NSXMLParserDelegate>
{
    NSXMLParser* parser;
    NSMutableData *rssData;
    NSMutableArray *titles;
    
    NSMutableString *curDescription;
    NSString *curElement;
    NSMutableString *curTitle;
    NSMutableString *curDate;
    
}
-(void)updateList:(id)sender;

//@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
