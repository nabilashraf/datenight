//
//  MoreDetailsViewController.h
//  Events
//
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface MoreDetailsViewController : UIViewController<UITextViewDelegate,MFMailComposeViewControllerDelegate>
{
    __weak IBOutlet UITextView * txtVWDetails;
}

@property (nonatomic, retain) NSString * strDetailContent, *strTitle;

@end