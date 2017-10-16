//
//  ProgramViewController.m
//  Events
//
//  Created by Shabbir Hasan Zaheb on 22/02/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "ProgramViewController.h"
#import "ProgramCustomCell.h"
#import "EventList.h"
#import "MyEventTickets.h"
#import "AboutViewController.h"
#import "UIImageView+WebCache.h"
#import "Events-Swift.h"

@interface ProgramViewController (){
    
    NSMutableArray *arrayEventList;
    NSIndexPath * selectedRow;
}

@end

@implementation ProgramViewController
@synthesize categoryFilter;
@synthesize menuIsAllowed;
@synthesize dateFilter;
@synthesize sliderIsAllowed;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.dateFilter = @"";
//    if(sliderIsAllowed == NULL)
//    {
//        self.sliderIsAllowed = 0;
//    }
}


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }

    [Utility afterDelay:0.01 withCompletion:^{
        [DSBezelActivityView newActivityViewForView:self.view.window];
        [self getEventListFromServer];
    }];
    
    if(menuIsAllowed == 1)
    {
        [self createFilterButton];
    }
//    if(sliderIsAllowed == 0)
//    {
//        
//    }
}

- (IBAction)showFilterPagePress:(id)sender {
    [self performSegueWithIdentifier:@"showFilterResults" sender:self];
}

//SHOW THE SLIDER BUTTON
//- (IBAction)sliderButtonPress:(id)sender {
//    [self toggleSideMenuView];
//}



-(void) createFilterButton
{
    UIButton * btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImage * image = [UIImage imageNamed:@"heart_filter"];
    [btn1 setImage:image forState:UIControlStateNormal];
    [btn1 setUserInteractionEnabled:YES];
    [btn1 addTarget:self action:@selector(pressFilterButton:) forControlEvents:UIControlEventTouchDown];
    
    UIBarButtonItem * item = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    item.tintColor = UIColor.whiteColor;
    
    [self.navigationItem setRightBarButtonItem:item];
}

-(void) pressFilterButton:(id)sender
{
    [self performSegueWithIdentifier:@"showFilterResults" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  getEventListFromServer
 *
 *  @return This method will get events data from server and store all data in EventList modal class.
 */

#pragma mark - Get All Event's from server
-(void)getEventListFromServer
{
    self.tableView.tableFooterView = [[UIView alloc] init];
    if(categoryFilter == NULL)
    {
        [categoryFilter addObject:@"NONE"];
    }
    NSString* userId = [Utility getNSUserDefaultValue:KUSERID];
    int num = userId.intValue;
    userId = [[NSString alloc] initWithFormat:@"%i", num];
    NSDictionary *dictOfEventRequestParameter = [[NSDictionary alloc] initWithObjectsAndKeys: userId, @"user_id", nil];

    NSString* URL = [NSLocalizedString(@"GETEVENTS_METHOD", @"GETEVENTS_METHOD") stringByAppendingString:@"?user_id="];
    URL = [URL stringByAppendingString:userId];
    
    [Utility GetDataForMethod:URL parameters:dictOfEventRequestParameter key:@"" withCompletion:^(id response){
        
        [DSBezelActivityView removeViewAnimated:NO];
        arrayEventList  =   [[NSMutableArray alloc] init];
        
        if ([response isKindOfClass:[NSArray class]]) {
            if ([[[response objectAtIndex:0] allKeys] containsObject:@"status"]) {
                if ([[[response objectAtIndex:0] objectForKey:@"status"] intValue] == 0) {
                    [Utility alertNotice:@"" withMSG:[[response objectAtIndex:0] objectForKey:@"message"] cancleButtonTitle:@"OK" otherButtonTitle:nil];
                    gArrayEvents = [[NSMutableArray alloc] initWithArray:arrayEventList];
                    [self.tableView reloadData];
                    return ;
                    
                }
            }
            
            NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"event_start_date"  ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
            NSArray *sortedArrayEventList = [response sortedArrayUsingDescriptors:@[descriptor]];
            
            for (NSDictionary *dict in sortedArrayEventList) {
                EventList *eventObj = [[EventList alloc] init];
                eventObj.eventID                =   [NSNumber numberWithInt:[[dict objectForKey:@"event_id"] intValue]];
                eventObj.eventName              =   [dict objectForKey:@"event_name"];
                eventObj.eventImageURL          =   [dict objectForKey:@"event_image_url"];
                eventObj.eventDescription       =   [dict objectForKey:@"event_content"];
                eventObj.eventLink              =   [dict objectForKey:@"event_link"];
                eventObj.isFav              =   [dict objectForKey:@"is_favorite"];
                
                eventObj.eventCategories = [[NSMutableArray alloc] init];
                eventObj.eventComments = [[NSMutableArray alloc] init];
                
                if([[dict objectForKey:@"terms"] count] > 0)
                {
                    NSArray* categories = [dict objectForKey:@"terms"]; //[[NSArray alloc] initWithObjects:, nil];
                    
                    for(NSDictionary * cat in categories)
                    {
                        [eventObj.eventCategories addObject:[cat objectForKey:@"name"]];
                    }
                }
                
                if([categoryFilter containsObject:@"NONE"] == NO) // && [eventObj.eventCategories containsObject: categoryFilter] == NO)
                {
                    int there = 0;
                    for (NSString* currentString in categoryFilter)
                    {
                        if([eventObj.eventCategories containsObject: currentString] == NO)
                        {
                            
                        }
                        else
                        {
                            there = there + 1;
                            break;
                        }
                    }
                    if(there == 0)
                    {
                        continue;
                    }
                }
                
                if([[dict objectForKey:@"comments"] count] > 0)
                {
                    NSArray* comments = [dict objectForKey:@"comments"]; //[[NSArray alloc] initWithObjects:, nil];
                    
                    for(NSDictionary * comment in comments)
                    {
                        [eventObj.eventComments addObject:[comment objectForKey:@"comment_content"]];
                    }
                }
                
                
                //12.15pm 4 June '14
                eventObj.eventStartDateTime     =   [Utility getFormatedDateString:[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"event_start_date"],[dict objectForKey:@"event_start_time"]] dateFormatString:@"yyyy-MM-dd HH:mm:ss" dateFormatterString:@"HH:mm a - dd MMM yyyy"];
                
                eventObj.eventEndDateTime       =   [Utility getFormatedDateString:[NSString stringWithFormat:@"%@ %@",[dict objectForKey:@"event_end_date"],[dict objectForKey:@"event_end_time"]] dateFormatString:@"yyyy-MM-dd HH:mm:ss" dateFormatterString:@"HH:mm a - dd MMM yyyy"];
                
                eventObj.eventLocationName      =   [dict objectForKey:@"location_name"];
                eventObj.eventLocationAddress   =   [dict objectForKey:@"location_address"];
                eventObj.eventLocationTown      =   [dict objectForKey:@"location_town"];
                eventObj.eventLocationState     =   [dict objectForKey:@"location_state"];
                eventObj.eventLocationCountry   =   [dict objectForKey:@"location_country"];
                
                NSLog(@"%@", eventObj.eventStartDateTime);
                
                if(![self.dateFilter isEqualToString:@""])
                {
                    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
                    dateFormatter.dateFormat = @"HH:mm a - dd MMM yyyy";
                    
                    NSDate * startDate = [dateFormatter dateFromString: eventObj.eventStartDateTime];
                    NSDate * endDate = [dateFormatter dateFromString: eventObj.eventEndDateTime];
                    
                    dateFormatter.dateFormat = @"dd MMM yyyy";
                    NSDate * filterDate = [dateFormatter dateFromString: self.dateFilter];
                    
                    if(![self date:filterDate isBetweenDate:startDate andDate:endDate])
                    {
                        continue;
                    }
                }
                
                if ([dict objectForKey:@"location_latitude"] != (id)[NSNull null]){
                if ([[dict objectForKey:@"location_latitude"] length]>0){
                    
                        eventObj.eventLocationLatitude  =   [NSNumber numberWithFloat:[[dict objectForKey:@"location_latitude"] floatValue]];
                        eventObj.eventLocationLongitude =   [NSNumber numberWithFloat:[[dict objectForKey:@"location_longitude"] floatValue]];
                    
                    }
                    
                }
//                
                
                if ([[dict objectForKey:@"ticket"] count]>0) {
                    
                    if([[dict objectForKey:@"ticket"] isKindOfClass:[NSArray class]]){
                        
                        
                    }
                    
                else    {
                    NSDictionary *dictOfTicket  =   [[NSDictionary alloc] initWithDictionary:[dict objectForKey:@"ticket"]];
                    eventObj.eventTicketName            =   [dictOfTicket objectForKey:@"ticket_name"];
                    eventObj.eventTicketDescription     =   [dictOfTicket objectForKey:@"ticket_description"];
                    eventObj.eventTicketPrice           =   [dictOfTicket objectForKey:@"ticket_price"];
                    eventObj.eventTicketStart           =   [dictOfTicket objectForKey:@"ticket_start"];
                    eventObj.eventTicketEnd             =   [dictOfTicket objectForKey:@"ticket_end"];
                    eventObj.eventTicketMembers         =   [dictOfTicket objectForKey:@"ticket_members_roles"];
                    eventObj.eventTicketGuests          =   [dictOfTicket objectForKey:@"ticket_guests"];
                    eventObj.eventTicketRequired        =   [dictOfTicket objectForKey:@"ticket_required"];
                    eventObj.eventTicketAvailSpaces     =   [NSNumber numberWithInt:[[dictOfTicket objectForKey:@"avail_spaces"] intValue]];
                    eventObj.eventTicketBookedSpaces    =   [NSNumber numberWithInt:[[dictOfTicket objectForKey:@"booked_spaces"] intValue]];
                    eventObj.eventTicketTotalSpaces     =   [NSNumber numberWithInt:[[dictOfTicket objectForKey:@"total_spaces"] intValue]];
                }
                }
                [arrayEventList addObject:eventObj];
                
                
            }
        }
        
        /**
         *  global array for events data.
         */
        gArrayEvents = [[NSMutableArray alloc] initWithArray:arrayEventList];
        
        [self.tableView reloadData];
        
    }WithFailure:^(NSString *error)
     {
         [DSBezelActivityView removeViewAnimated:NO];
         NSLog(@"%@",error);
     }];
}

#pragma mark - Date is between dates
- (BOOL)date:(NSDate*)date isBetweenDate:(NSDate*)beginDate andDate:(NSDate*)endDate
{
    if ([date compare:beginDate] == NSOrderedAscending)
        return NO;
    
    if ([date compare:endDate] == NSOrderedDescending)
        return NO;
    
    return YES;
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
     return [arrayEventList count];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProgramCustomCell";
    ProgramCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell)
    {
        cell = [[ProgramCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    EventList *obj = [arrayEventList objectAtIndex:indexPath.row];

//    cell.lblDateTime.text   =   [Utility compareDates:obj.eventStartDateTime date:[NSDate date]];
    cell.lblEventName.text  =   obj.eventName;
    cell.lblEventDesc.text  =   [obj.eventDescription stringByConvertingHTMLToPlainText];
    cell.lblEventDesc.text  =   [Utility TrimString:cell.lblEventDesc.text];
    cell.lblAddress.text = obj.eventLocationAddress;
    NSString *priceText = [NSString stringWithFormat:@"£ %@", obj.eventTicketPrice];
    cell.lblDateTime.text = priceText;
    
    NSNumber* num = [[NSNumber alloc] initWithInt:1];
    
    if([obj.isFav isEqualToNumber:num])
    {
        cell.saveStatusImage.image = [UIImage imageNamed:@"star_filled"];
    }
    else
    {
        cell.saveStatusImage.image = [UIImage imageNamed:@"star_unfilled"];
    }
    
    if ([obj.eventImageURL length]>0) {
        [cell.imgEventImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",obj.eventImageURL]] placeholderImage:nil];
//        [cell.imgEventImage setContentMode:UIViewContentModeScaleAspectFit];
        [cell.imgEventImage setClipsToBounds:YES];
    }
//    
   // cell.imgEventImage.contentMode = UIViewContentModeScaleAspectFill;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedRow = indexPath;
    [self performSegueWithIdentifier:@"toDetailPage" sender:self];
}

#pragma mark - Navigation
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqual: @"toDetailPage"])
    {
        EventDetailsViewController * vc = [segue destinationViewController];
        EventList *obj  =   [arrayEventList objectAtIndex:selectedRow.row];
        [vc setMyEvent:obj];
    }
    else if([segue.identifier isEqual: @"showFilterResults"])
    {
        FilterByResultViewController * vc = [segue destinationViewController];
        vc.selectedCategories = categoryFilter;
        vc.programVC = self;
        vc.dateString = self.dateFilter;
    }
    
}

@end



