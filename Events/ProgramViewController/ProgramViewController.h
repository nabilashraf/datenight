//
//  ProgramViewController.h
//  Events
//
//  Created by Shabbir Hasan Zaheb on 22/02/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgramViewController : UITableViewController

@property (nonatomic) NSMutableArray * categoryFilter;
@property (nonatomic) NSString * dateFilter;
@property (nonatomic) int menuIsAllowed;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightMenuButton;
@property (nonatomic) int sliderIsAllowed;
@property (weak, nonatomic) IBOutlet UINavigationItem *sliderButton;

@end
