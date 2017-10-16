//
//  MoreDetailsViewController.m
//  Events
//
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "MoreDetailsViewController.h"

@interface MoreDetailsViewController ()

@end

@implementation MoreDetailsViewController
@synthesize strDetailContent, strTitle;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = strTitle;
    
    txtVWDetails.text = NSLocalizedString(self.strDetailContent, self.strDetailContent);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([self.strDetailContent isEqualToString:@"CONTENT_HELPCENTRE"]) {
        
        MFMailComposeViewController * mailComposeVC = [[MFMailComposeViewController alloc] init];
        mailComposeVC.mailComposeDelegate = self;
        [mailComposeVC setSubject:@"Event App iOS Question"];
        [mailComposeVC setToRecipients:[NSArray arrayWithObjects:@"contact@myapptemplates.com", nil]];
        
        [self presentViewController:mailComposeVC animated:YES completion:nil];
        
        return NO;
    }
    
    return YES;
}
                                             
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result) {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultFailed:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            [Utility alertNotice:@"" withMSG:@"Mail sent successfully" cancleButtonTitle:@"OK" otherButtonTitle:nil];
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
