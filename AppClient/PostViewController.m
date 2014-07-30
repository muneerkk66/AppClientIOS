//
//  ViewController.m
//  AppClient
//
//  Created by Muneer on 7/30/14.
//  Copyright (c) 2014 Muneer. All rights reserved.
//

#import "PostViewController.h"
#import "PostCell.h"
#import "AFNetworking.h"
#import "PostObjects.h"
#import "UIImageView+AFNetworking.h"

@interface PostViewController ()
/**
 * PTR manager
 */
@property (nonatomic, readwrite, strong) MNMPullToRefreshManager *pullToRefreshManager;

/**
 * Reloads (for testing purposes)
 */
@property (nonatomic, readwrite, strong) NSMutableArray *postersDataCollection;
@property (nonatomic, readwrite, assign) NSUInteger reloads;

/**
 * Loads the table and restores the PTR view to its initial state
 *
 * @private
 */
- (void)loadTable;
@end

@implementation PostViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    //CustomCell setup
    
    self.postCellNib =[UINib nibWithNibName:@"PostCell" bundle:nil];
    [self.tableView registerNib:self.postCellNib forCellReuseIdentifier:@"postcell"];
    [self.tableView reloadData];
    self.pullToRefreshManager = [[MNMPullToRefreshManager alloc] initWithPullToRefreshViewHeight:60.0f
                                                                                   tableView:self.tableView
                                                                                  withClient:self];
    
    self.postersDataCollection = [[NSMutableArray alloc]init];
    
    // Get data from server using Afnetworking
    [self getpostersDataFromServer];

}
- (void)getpostersDataFromServer
{
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"https://alpha-api.app.net/stream/0/posts/stream/global"]];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        
    NSMutableArray *tempArray =[[NSMutableArray alloc]init];
       
     
       
    for (NSDictionary *jsonObjects  in [JSON objectForKey:@"data"])
    {
            
        PostObjects *objects =[[PostObjects alloc]init];
           
        NSString *avatarUrl = [[[jsonObjects objectForKey:@"user"]objectForKey:@"avatar_image"] objectForKey:@"url"];
            
        NSString *name = [[jsonObjects objectForKey:@"user"]objectForKey:@"name"] ;
        NSString *descriptionHtml = [jsonObjects objectForKey:@"html"];
        NSDate *date = [jsonObjects objectForKey:@"created_at"];
            
        if (name != nil)
        {
                objects.postersName = name;
        }
        else
        {
            objects.postersName = @"Unknown";
        }
        objects.imageurl = avatarUrl;
        objects.description = descriptionHtml;
        objects.createdAt = date;
        [tempArray addObject:objects];
           
            
    }
        
    [self.postersDataCollection removeAllObjects];
        
        // filter all data using nsdate
    tempArray = (NSMutableArray*)[self filterAllobjectswithDateFrom:tempArray];
    
    self.postersDataCollection = [tempArray mutableCopy];
    [self loadTable];
       
        
       
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"Request Failed with Error: %@, %@", error, error.userInfo);
        UIAlertView *alert =[[UIAlertView alloc]initWithTitle:@"Request Failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] ;
        [alert show];
    }];
    
    [operation start];
}
- (UITableViewCell *)tableView:(UITableView *)theTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *MyCellIdentifier;
    
    PostObjects *objects =[self.postersDataCollection objectAtIndex:indexPath.row];
    
    MyCellIdentifier = @"postcell";
            
    
            
    PostCell *cell = (PostCell *)[theTableView dequeueReusableCellWithIdentifier:MyCellIdentifier];
    if (cell == nil) {
            cell = [[PostCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyCellIdentifier];
    }
    cell.postersNameLabel.text = objects.postersName;
    [cell.profileimageView setImageWithURL:[NSURL URLWithString:objects.imageurl] placeholderImage:nil];
    [cell.webView loadHTMLString:objects.description baseURL:nil];
    
  return cell;
            
            
}
-(NSArray*)filterAllobjectswithDateFrom:(NSMutableArray*)collectionDataArray
{
    NSArray *sortedArray;
    sortedArray = [collectionDataArray sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
        NSDate *first = [(PostObjects*)a createdAt];
        NSDate *second = [(PostObjects*)b createdAt];
        return [second compare:first];
    }];
    
    return sortedArray;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    return 150;
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
   
    return [self.postersDataCollection count];
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath

{
   
    
    
    
    
}
- (void)loadTable {
    
    [self.tableView reloadData];
    
    [self.pullToRefreshManager tableViewReloadFinishedAnimated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    [self.pullToRefreshManager tableViewScrolled];
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    
    [self.pullToRefreshManager tableViewReleased];
}


 /* Tells client that refresh has been triggered*/
- (void)pullToRefreshTriggered:(MNMPullToRefreshManager *)manager {
    
    self.reloads++;
    
    [self getpostersDataFromServer];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
