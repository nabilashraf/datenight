//
//  StartPageViewController.m
//  Events
//
//  Created by Muhammad Shabbir on 7/8/17.
//  Copyright © 2017 Teknowledge Software. All rights reserved.
//

#import "StartPageViewController.h"
#import "ProgramViewController.h"
#import "Events-Swift.h"

@interface StartPageViewController (){

    NSArray* fullCellNames;
    NSArray* halfCellLeft;
    NSArray* halfCellRight;
    NSArray* catIDs;
    NSArray* fullImages;
    int index;
    NSMutableArray* catFilter;
}
@end

@implementation StartPageViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    index = 0;
    
    fullCellNames = [[NSArray alloc] initWithObjects: @"View All Suggestions", @"", @"Live Music", @"", @"Get Cultural", nil];
    halfCellLeft = [[NSArray alloc] initWithObjects: @"Top Picks", @"Top Picks", @"Find a Bar", @"Find a Bar", nil];
    halfCellRight = [[NSArray alloc] initWithObjects: @"Places To Eat", @"Places To Eat", @"Hints & Tips", @"Hints & Tips", nil];
    
//    myCategories = [[NSArray alloc] initWithObjects: @"View All Suggestions",@"Top Picks",@"Places To Eat",@"Live Music", @"Find a Bar", @"Hints & Tips", @"Get Cultural", nil];
    fullImages = [[NSArray alloc] initWithObjects: @"allsuggestions", @"placeholer", @"livemusic", @"livemusic", @"getcultural", nil];
    
    self.tableVIew.delegate = self;
    self.tableVIew.dataSource = self;
    
    UINib* nib1 = [UINib nibWithNibName:@"StartCategoryCell" bundle:nil];
    [self.tableVIew registerNib:nib1 forCellReuseIdentifier:@"StartCategoryCell"];
    
    UINib* nib2 = [UINib nibWithNibName:@"HalfCategoryCell" bundle:nil];
    [self.tableVIew registerNib:nib2 forCellReuseIdentifier:@"HalfCategoryCell"];
    
    self.tableVIew.rowHeight = UITableViewAutomaticDimension;
    self.tableVIew.estimatedRowHeight = 176;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation */
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier  isEqual: @"showEventResults"])
    {
        ProgramViewController * vc = segue.destinationViewController;
        vc.categoryFilter = catFilter;
        if([catFilter containsObject:@"NONE"])
        {
            vc.menuIsAllowed = 1;
        }
        else{
            vc.menuIsAllowed = 0;
        }
    }
    else if([segue.identifier isEqualToString:@"showHintsAndTipsCat"])
    {
        HintsAndTipsViewController * vc = segue.destinationViewController;
        vc.fromMenu = 0;
    }
}


//MARK: TABLEVIEW FUNCTIONS
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // my code
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // my code
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    // my code
    return 176;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // my code
    if(indexPath.row == 0 || indexPath.row == 2 || indexPath.row == 4){
        //full cell row
        StartCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StartCategoryCell" forIndexPath:indexPath];
        
        cell.catLabel = fullCellNames[indexPath.row];
        cell.imageName = fullImages[indexPath.row];
        
        cell.myLabel.backgroundColor = [[UIColor alloc] initWithRed:55/255 green:56/255 blue:83/255 alpha:0.6];
        [cell updateUI];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    else if(indexPath.row == 1 || indexPath.row == 3) {
        //its a half cell
        HalfCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HalfCategoryCell" forIndexPath:indexPath];
        
//        cell.leftImageView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width/2, cell.frame.size.height);
//        cell.rightImageView.frame = CGRectMake(cell.frame.size.width/2, cell.frame.origin.y, cell.frame.size.width/2, cell.frame.size.height);
        
        cell.leftSection.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width/2, cell.frame.size.height);
        cell.rightView.frame = CGRectMake(cell.frame.size.width/2, cell.frame.origin.y, cell.frame.size.width/2, cell.frame.size.height);
        
        cell.catLabel1 = halfCellLeft[indexPath.row];
        cell.catLabel2 = halfCellRight[indexPath.row];
        if(indexPath.row == 1)
        {
            cell.rightImageView.image = [UIImage imageNamed: @"placestoeat"];
//            cell.RightLabel.backgroundColor = [[UIColor alloc] initWithRed:55/255 green:56/255 blue:83/255 alpha:1.0];
            cell.rightView.alpha = 0.9;
            cell.leftView.alpha = 0.0;
            
            //Left one is Top Picks
            [cell.leftButton addTarget:self action:@selector(topPicksCategory:) forControlEvents:UIControlEventTouchDown];
            
            //RIght one is Food
            [cell.rightButton addTarget:self action:@selector(foodCategory:) forControlEvents:UIControlEventTouchDown];
            
            cell.leftButton.tag = 1;
            cell.rightButton.tag = 2;
        }else if(indexPath.row == 3)
        {
            cell.leftImageView.image = [UIImage imageNamed: @"findabar"];
//            cell.leftLabel.backgroundColor = [[UIColor alloc] initWithRed:55 green:56 blue:83 alpha:1.0];
            cell.rightView.alpha = 0.0;
            cell.leftView.alpha = 1.0;
            
            //left one is drinks
            [cell.leftButton addTarget:self action:@selector(drinksCategory:) forControlEvents:UIControlEventTouchDown];
            
            //right one is hints and tips
            [cell.rightButton addTarget:self action:@selector(hintsAndTipsCategory:) forControlEvents:UIControlEventTouchDown];
            
            cell.leftButton.tag = 4;
            cell.rightButton.tag = 5;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateUI];
        
        return cell;
    }
    
    return [[UITableViewCell alloc] init];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // my code
    if(indexPath.row == 0)
    {
        catFilter = [[NSMutableArray alloc] initWithObjects:@"NONE", nil];
        [self performSegueWithIdentifier:@"showEventResults" sender:self];
    }
    else if(indexPath.row == 2)
    {
        catFilter = [[NSMutableArray alloc] initWithObjects:@"Music", nil];
//        catFilter = @"Music";
        [self performSegueWithIdentifier:@"showEventResults" sender:self];
    }
    else if(indexPath.row == 4)
    {
        catFilter = [[NSMutableArray alloc] initWithObjects:@"Cultural", nil];
//        catFilter = @"Cultural";
        [self performSegueWithIdentifier:@"showEventResults" sender:self];
    }
}

-(void) takeToTopPicks
{
    catFilter = [[NSMutableArray alloc] initWithObjects:@"Top Picks", nil];
    //    catFilter = @"Top Picks";
    [self performSegueWithIdentifier:@"showEventResults" sender:self];
}

-(void) topPicksCategory: (id)sender
{
    catFilter = [[NSMutableArray alloc] initWithObjects:@"Top Picks", nil];
//    catFilter = @"Top Picks";
    [self performSegueWithIdentifier:@"showEventResults" sender:self];
}

-(void) foodCategory: (id)sender
{
    catFilter = [[NSMutableArray alloc] initWithObjects:@"Food", nil];
//    catFilter = @"Food";
    [self performSegueWithIdentifier:@"showEventResults" sender:self];
}

-(void) drinksCategory: (id)sender
{
    catFilter = [[NSMutableArray alloc] initWithObjects:@"Drinks", nil];
//    catFilter = @"Drinks";
    [self performSegueWithIdentifier:@"showEventResults" sender:self];
}

-(void) hintsAndTipsCategory: (id)sender
{
    //hints and tips page show
    [self performSegueWithIdentifier:@"showHintsAndTipsCat" sender:self];
}

- (IBAction)menuPress:(id)sender {
    [self toggleSideMenuView];
}

//MARK: Pressing Category Buttons



@end
