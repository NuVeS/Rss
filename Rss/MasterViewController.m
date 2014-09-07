//
//  MasterViewController.m
//  Rss
//
//  Created by Admin on 06.09.14.
//  Copyright (c) 2014 Amitim. All rights reserved.
//

#import "MasterViewController.h"

#import "DetailViewController.h"

@interface MasterViewController () {
    NSMutableArray *_objects;
}
@end

@implementation MasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
        
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(updateList:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Pull to refresh."];
    [refresh addTarget:self action:@selector(refresh:) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refresh;
    
    self.title = @"News";
    
    rssData = [[NSMutableData alloc] init];
    [self updateList:self];
}

-(void)updateList:(id)sender
{
    [rssData setData:nil];
    NSURL *rssLink = [NSURL URLWithString:@"https://www.apple.com/main/rss/hotnews/hotnews.rss"];
    NSURLRequest *req = [NSURLRequest requestWithURL:rssLink cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:req delegate:self];
}

-(void)refresh:(UIRefreshControl*)refresh
{
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:@"Refreshing data."];
    
    
    [self updateList:self];
//    
//    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"MMM d, h:mm a"];
    NSString* lastUpdated = [NSString stringWithFormat:@"Refreshing date..."];
    
    refresh.attributedTitle = [[NSAttributedString alloc] initWithString:lastUpdated];
    
    [refresh endRefreshing];
}

#pragma mark - Connection

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [rssData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [rssData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(!([rssData length] == 0))
    
    titles = [[NSMutableArray alloc] init];
    parser = [[NSXMLParser alloc] initWithData:rssData];
    [parser setDelegate:self];
    
    BOOL res = [parser parse];
    NSLog(@"%i", res);
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Connection failed. Please check your connection and try again."] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Parsing

- (void)parser:(NSXMLParser *)parser
didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qualifiedName
    attributes:(NSDictionary *)attributeDict  {
    
    curElement = elementName;
    if ([elementName isEqualToString:@"item"]) {
        curTitle = [NSMutableString string];
        curDate = [NSMutableString string];
        curDescription = [NSMutableString string];
    }
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    if ([curElement isEqualToString:@"title"]) {
		[curTitle appendString:string];
	} else if ([curElement isEqualToString:@"description"]) {
		[curDescription appendString:string];
    } else if ([curElement isEqualToString:@"pubDate"]) {
        [curDate appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser
 didEndElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName {
    if ([elementName isEqualToString:@"item"]) {
        NSMutableDictionary *newsItem = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                  curTitle, @"title",
                                  curDate, @"pubDate",
                                  curDescription, @"description", nil];
        [titles addObject:newsItem];
        curTitle = nil;
        curDate = nil;
        curElement = nil;
        curDescription = nil;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    [self.tableView reloadData];
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    NSLog(@"%@", parseError);
}
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];

    NSDictionary *dict = [titles objectAtIndex:indexPath.row];
    cell.textLabel.text = [dict objectForKey:@"title"];
    cell.detailTextLabel.text = [dict objectForKey:@"pubDate"];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDictionary *dict = [titles objectAtIndex:indexPath.row];
        [[segue destinationViewController] setDetailItem:dict];
    }
}

@end
