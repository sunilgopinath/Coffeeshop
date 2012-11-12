//
//  MasterViewController.m
//  Coffeeshop
//
//  Created by Sunil Gopinath on 11/11/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MasterViewController.h"

#define kCLIENTID "IKH4UVNASIX0S5TVNXJFXRACTLYUIAVJATUD2BQ3MWWEZR5S"
#define kCLIENTSECRET "H5NXV1OTB51TX2ZWNKAKGGGJMNWGOM5BSWSMJIK1E0WA2DI4"

@interface MasterViewController ()

@property (strong, nonatomic) NSArray *data;

@end

@implementation MasterViewController
@synthesize data;


- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    RKURL *baseURL = [RKURL URLWithBaseURLString:@"https://api.Foursquare.com/v2"];
    RKObjectManager *objectManager = [RKObjectManager objectManagerWithBaseURL:baseURL];
    objectManager.client.baseURL = baseURL;
    
    RKObjectMapping *venueMapping = [RKObjectMapping mappingForClass:[Venue class]];
    [venueMapping mapKeyPathsToAttributes:@"name", @"name", nil];
    [objectManager.mappingProvider setMapping:venueMapping forKeyPath:@"response.venues"];
    
    RKObjectMapping *locationMapping = [RKObjectMapping mappingForClass:[Location class]];
    [locationMapping mapKeyPathsToAttributes:@"address", @"address", @"city", @"city", @"country", @"country", @"crossStreet", @"crossStreet", @"postalCode", @"postalCode", @"state", @"state", @"distance", @"distance", @"lat", @"lat", @"lng", @"lng", nil];
    
    [venueMapping mapRelationship:@"location" withMapping:locationMapping];
    [objectManager.mappingProvider setMapping:locationMapping forKeyPath:@"location"];
    
    [self sendRequest];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

/*
- (void)insertNewObject:(id)sender
{
    if (!_objects) {
        _objects = [[NSMutableArray alloc] init];
    }
    [_objects insertObject:[NSDate date] atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}
*/
#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    Venue *venue = [data objectAtIndex:indexPath.row];
    cell.textLabel.text = [venue.name length] > 24 ? [venue.name substringToIndex:24] : venue.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%.0fm", [venue.location.distance floatValue]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
/*
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [data removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}
*/
- (void)sendRequest
{
    NSString *latLon = @"37.33,-122.03";
    NSString *clientID = [NSString stringWithUTF8String:kCLIENTID];
    NSString *clientSecret = [NSString stringWithUTF8String:kCLIENTSECRET];
    
    NSDictionary *queryParams;
    queryParams = [NSDictionary dictionaryWithObjectsAndKeys:latLon, @"ll", clientID, @"client_id", clientSecret, @"client_secret", @"coffee", @"query", @"20120602", @"v", nil];
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
    RKURL *URL = [RKURL URLWithBaseURL:[objectManager baseURL] resourcePath:@"/venues/search" queryParameters:queryParams];
    [objectManager loadObjectsAtResourcePath:[NSString stringWithFormat:@"%@?%@", [URL resourcePath], [URL query]] delegate:self];    
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", [error localizedDescription]);
}

- (void)request:(RKRequest*)request didLoadResponse:(RKResponse*)response {
    NSLog(@"response code: %d", [response statusCode]);
}

- (void)objectLoader:(RKObjectLoader *)objectLoader didLoadObjects:(NSArray *)objects
{
    NSLog(@"objects[%d]", [objects count]);
    data = objects;
    
    [self.tableView reloadData];
}

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


@end
