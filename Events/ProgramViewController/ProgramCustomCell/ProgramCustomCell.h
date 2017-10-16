//
//  ProgramCustomCell.h
//  Events
//
//  Created by Shabbir Hasan Zaheb on 22/02/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgramCustomCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *images;
@property (strong, nonatomic) IBOutlet UILabel *lblDateTime;
@property (strong, nonatomic) IBOutlet UILabel *lblEventName;
@property (strong, nonatomic) IBOutlet UILabel *lblEventDesc;
@property (weak, nonatomic) IBOutlet UILabel *lblAddress;

@property (strong, nonatomic) IBOutlet UIImageView *imgEventImage;
@property (weak, nonatomic) IBOutlet UIImageView *saveStatusImage;


@end
