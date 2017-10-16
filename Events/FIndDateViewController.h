//
//  FIndDateViewController.h
//  Events
//
//  Created by Muhammad Shabbir on 9/8/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FIndDateViewController : UITableViewController



@property (nonatomic) NSMutableArray * categoryFilter;
@property (nonatomic) NSString * dateFilter;
@property (nonatomic) int menuIsAllowed;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightMenuButton;

@end
