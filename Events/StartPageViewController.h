//
//  StartPageViewController.h
//  Events
//
//  Created by Muhammad Shabbir on 7/8/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface StartPageViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableVIew;
-(void) takeToTopPicks;
@end
