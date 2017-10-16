//
//  ViewController.m
//  Events
//
//  Created by Shabbir Hasan Zaheb on 22/02/14.
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "ViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
//    _loginButton.readPermissions =
//    @[@"public_profile", @"email"];
//    self.loginButton.alpha = 0.0;
//    self.loginButton.userInteractionEnabled = NO;
    
    // Add a custom login button to your app
//    UIButton *myLoginButton=[UIButton buttonWithType:UIButtonTypeCustom];
//    myLoginButton.frame = self.loginButton.frame;
//    myLoginButton.backgroundColor = self.loginButton.backgroundColor;
//    myLoginButton.titleLabel.font = self.loginButton.titleLabel.font;
//    myLoginButton.center = self.loginButton.center; //self.view.center;
//    [myLoginButton setTitle: @"Connect with FaceBook" forState: UIControlStateNormal];
//    [myLoginButton setImage: [UIImage imageNamed:@"fb-logo"] forState: UIControlStateNormal];
//    
//    myLoginButton.layer.cornerRadius = 20.0;
    
    
    self.loginButton.layer.cornerRadius = 20.0;
    [self.loginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    // Add the button to the view
//    [self.view addSubview:myLoginButton];
//    [self.view bringSubviewToFront:myLoginButton];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        
        FBSDKAccessToken * token = [FBSDKAccessToken currentAccessToken];
        
        NSString* userEmail = [token.userID stringByAppendingString:@"@fb.com"];
        
        [self loginFBAccount:userEmail];
    }
    else
    {
        //do nothing
        NSString* userId = [Utility getNSUserDefaultValue:@"user_id"];
        
        if(userId != NULL)
        {
            //userId is saved proceed
            [self performSegueWithIdentifier:@"successLogin" sender:self];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Once the button is clicked, show the login dialog
-(void)loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login
     logInWithReadPermissions: @[@"public_profile",@"email"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error) {
             NSLog(@"Process error");
         } else if (result.isCancelled) {
             NSLog(@"Cancelled");
         } else {
             NSLog(@"Logged in");
             //take to START PAGE AND SEND INFO OF LOGIN
             [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:@{@"fields": @"email,name"}]
              startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                  if (!error) {
                      NSLog(@"fetched user:%@  and Email : %@", result,result[@"email"]);
                      NSLog(@"fetched user:%@  and Name : %@", result,result[@"name"]);
                      
                      NSString* userEmail = [result[@"id"] description];
                      userEmail = [userEmail stringByAppendingString:@"@fb.com"];
                      NSLog(@"fetched user:%@", userEmail);
                      
                      NSString* name1 = [result[@"name"] description];
                      
                      NSDictionary* dictOfParameters = [[NSDictionary alloc] initWithObjectsAndKeys: name1, @"name", userEmail, @"email", @"fbPass_123", @"pwd",nil];
                      
                      //[[NSDictionary alloc] initWithObjectsAndKeys: name1,@"name", userEmail,@"email","fbPass_123",@"pwd", nil];
                      [self registerFBAccount:dictOfParameters];
                  }else{
                      NSLog(@"ERROR GETTING DATA");
                  }
              }];
         }
     }];
}

-(void) registerFBAccount: (NSDictionary *) dictOfParameters
{
    [DSBezelActivityView newActivityViewForView:self.view.window];
    
    [Utility GetDataForMethod:NSLocalizedString(@"REGISTER_METHOD", @"REGISTER_METHOD") parameters:dictOfParameters key:@"" withCompletion:^(id response){
        
        if ([response isKindOfClass:[NSDictionary class]]) {
            if ([[response objectForKey:@"message"] isEqualToString:@"Sorry, that username already exists!"]) {
//                [Utility alertNotice:APPNAME withMSG:[response objectForKey:@"message"] cancleButtonTitle:@"OK" otherButtonTitle:nil];
                [self loginFBAccount: [dictOfParameters valueForKey:@"email"]];
            }
            else{
                NSString* abc = [response objectForKey:@"user_id"];
                [Utility setNSUserDefaultValueForString:[response objectForKey:@"user_id"] strKey:@"user_id"];
                
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:APPNAME message:[response objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av setTag:99];
                [av show];
                
                [self performSegueWithIdentifier:@"successLogin" sender:self];
            }
        }
        else if ([response isKindOfClass:[NSArray class]]) {
            
            if ([[[response objectAtIndex:0] objectForKey:@"message"] isEqualToString:@"Sorry, that username already exists!"]) {
//                [Utility alertNotice:APPNAME withMSG:[[response objectAtIndex:0] objectForKey:@"message"] cancleButtonTitle:@"OK" otherButtonTitle:nil];
                [self loginFBAccount: [dictOfParameters valueForKey:@"email"]];
            }
            else{
                NSString* abc = [[response objectAtIndex:0] objectForKey:@"user_id"];
                [Utility setNSUserDefaultValueForString:[[response objectAtIndex:0] objectForKey:@"user_id"] strKey:@"user_id"];
                
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:APPNAME message:[[response objectAtIndex:0] objectForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av setTag:99];
                [av show];
                
                [self performSegueWithIdentifier:@"successLogin" sender:self];
            }
        }
        [DSBezelActivityView removeViewAnimated:YES];
        
    }WithFailure:^(NSString *error){
        [DSBezelActivityView removeViewAnimated:YES];
        NSLog(@"%@",error);
    }];
}

-(void) loginFBAccount: (NSString*) userEmail
{
    [DSBezelActivityView newActivityViewForView:self.view.window];
    
    NSDictionary *dictOfParameters  =   [[NSDictionary alloc] initWithObjectsAndKeys: userEmail,@"email", @"fbPass_123", @"pwd", nil];
    
    [Utility GetDataForMethod:NSLocalizedString(@"LOGIN_METHOD", @"LOGIN_METHOD") parameters:dictOfParameters key:@"" withCompletion:^(id response){
        
        [DSBezelActivityView removeViewAnimated:YES];
        if ([response isKindOfClass:[NSArray class]]) {
            
            if ([[[response objectAtIndex:0] objectForKey:@"status"] intValue] == 0) {
                [Utility alertNotice:@"" withMSG:[[response objectAtIndex:0] objectForKey:@"message"] cancleButtonTitle:@"OK" otherButtonTitle:nil];
            }
            else{
                NSString* abc = [[response objectAtIndex:0] objectForKey:@"user_id"];
                [Utility setNSUserDefaultValueForString:[[response objectAtIndex:0] objectForKey:@"user_id"] strKey:@"user_id"];
                
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:APPNAME message:@"Login Successful" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av setTag:99];
                [av show];
                [self performSegueWithIdentifier:@"successLogin" sender:self];
            }
        }
        else if ([response isKindOfClass:[NSDictionary class]]){
            if ([[response objectForKey:@"status"] intValue] == 0) {
                [Utility alertNotice:@"" withMSG:[response objectForKey:@"message"] cancleButtonTitle:@"OK" otherButtonTitle:nil];
            }
            else{
                NSNumber* abc = [response objectForKey:@"user_id"];
                [Utility setNSUserDefaultValueForString:[response objectForKey:@"user_id"] strKey:@"user_id"];
                UIAlertView *av = [[UIAlertView alloc] initWithTitle:APPNAME message:@"Login Successful" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [av setTag:99];
                [av show];
                [self performSegueWithIdentifier:@"successLogin" sender:self];
            }
        }
        
    }WithFailure:^(NSString *error){
        NSLog(@"%@",error);
        [DSBezelActivityView removeViewAnimated:YES];
    }];
}
@end
