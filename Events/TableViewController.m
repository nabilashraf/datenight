//
//  TableViewController.m
//  Events
//
//  Created by Muhammad Shabbir on 7/8/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

#import "TableViewController.h"

@interface TableViewController ()

@property (strong, nonatomic) NSArray *titlesArray;

@end

@implementation TableViewController

- (id)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"LGSideMenuController";
        
        self.titlesArray = @[@"Style \"Scale From Big\"",
                             @"Style \"Slide Above\"",
                             @"Style \"Slide Below\"",
                             @"Style \"Scale From Little\"",
                             @"Blurred root view cover",
                             @"Blurred side views covers",
                             @"Blurred side views backgrounds",
                             @"Landscape always visible",
                             @"Status bar always visible",
                             @"Gesture area full screen",
                             @"Editable table view",
                             @"Custom style"];
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titlesArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.text = self.titlesArray[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44.0;
}

@end
