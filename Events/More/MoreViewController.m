//
//  MoreViewController.m
//  Events
//
//  Created by Souvick Ghosh on 2/25/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreCustomCell.h"
#import "MoreDetailsViewController.h"

@interface MoreViewController ()
{
    NSArray * arrayCellTitle;
}

@end

@implementation MoreViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"More";
    arrayCellTitle = [NSArray arrayWithObjects:@"Help Center",@"Privacy",@"Terms & Conditions", nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [arrayCellTitle count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MoreCustomCell";
    MoreCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    if(!cell)
    {
        cell = [[MoreCustomCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    cell.lblTitle.text = [arrayCellTitle objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Navigation
// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    NSIndexPath *selectedRowIndex = [self.tableView indexPathForSelectedRow];
    MoreDetailsViewController * moreDetailVC = [segue destinationViewController];

    if (selectedRowIndex.row == 0) {
        moreDetailVC.strDetailContent = @"CONTENT_HELPCENTRE";
        moreDetailVC.strTitle = @"Help Center";
    }
    else if (selectedRowIndex.row == 1) {
        moreDetailVC.strDetailContent = @"CONTENT_PRIVACY";
        moreDetailVC.strTitle = @"Privacy";
    }
    else if (selectedRowIndex.row == 2) {
        moreDetailVC.strDetailContent = @"CONTENT_TERMS&CONDITIONS";
        moreDetailVC.strTitle = @"Terms & Conditions";
    }
}

@end