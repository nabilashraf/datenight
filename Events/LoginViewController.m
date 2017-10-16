//
//  LoginViewController.m
//  Events
//
//  Copyright (c) 2014 Teknowledge Software. All rights reserved.
//

#import "LoginViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKLoginKit/FBSDKLoginManager.h>

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize delegate;
@synthesize txtEmail, txtPassword;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
    }
    return self;
}

#pragma mark - View Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    FBSDKLoginButton *loginButton = [[FBSDKLoginButton alloc] init];
    
    self.title = @"Login";
    [self InitializeNavigationBatItem];
    
    // Optional: Place the button in the center of your view.
    loginButton.center = self.view.center;
    [self.view addSubview:loginButton];
    
    if ([FBSDKAccessToken currentAccessToken]) {
        // User is logged in, do work such as go to next view controller.
        [DSBezelActivityView newActivityViewForView:self.view.window];
        NSDictionary *dictOfParameters  =   [[NSDictionary alloc] initWithObjectsAndKeys:@"testuser@test.com",@"email",@"pakistan",@"pwd", nil];
        
        [Utility GetDataForMethod:NSLocalizedString(@"LOGIN_METHOD", @"LOGIN_METHOD") parameters:dictOfParameters key:@"" withCompletion:^(id response){
            
            [DSBezelActivityView removeViewAnimated:YES];
            if ([response isKindOfClass:[NSArray class]]) {
                
                if ([[[response objectAtIndex:0] objectForKey:@"status"] intValue] == 0) {
                    [Utility alertNotice:@"" withMSG:[[response objectAtIndex:0] objectForKey:@"message"] cancleButtonTitle:@"OK" otherButtonTitle:nil];
                }
                else{
                    [Utility setNSUserDefaultValueForString:[[response objectAtIndex:0] objectForKey:@"user_id"] strKey:KUSERID];
                    
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:APPNAME message:@"Login Successful" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av setTag:99];
                    [av show];
                }
            }
            else if ([response isKindOfClass:[NSDictionary class]]){
                if ([[response objectForKey:@"status"] intValue] == 0) {
                    [Utility alertNotice:@"" withMSG:[response objectForKey:@"message"] cancleButtonTitle:@"OK" otherButtonTitle:nil];
                }
                else{
                    [Utility setNSUserDefaultValueForString:[response objectForKey:@"user_id"] strKey:KUSERID];
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:APPNAME message:@"Login Successful" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av setTag:99];
                    [av show];
                }
            }
        }WithFailure:^(NSString *error){
            NSLog(@"%@",error);
            [DSBezelActivityView removeViewAnimated:YES];
        }];
    }

    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Initialize Navigation Bar Item
-(void)InitializeNavigationBatItem
{
    UIButton *btnCancel = [UIButton buttonWithType:UIButtonTypeSystem];
    [btnCancel setFrame:CGRectMake(0, 7, 80, 30)];
    [btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
    [btnCancel addTarget:self action:@selector(btnCancelPressed)
        forControlEvents:UIControlEventTouchUpInside];
    [btnCancel setShowsTouchWhenHighlighted:YES];
    UIBarButtonItem *leftBarBtn =[[UIBarButtonItem alloc] initWithCustomView:btnCancel];
    self.navigationItem.leftBarButtonItems  =       [[NSArray alloc] initWithObjects:leftBarBtn, nil];
}



/**
 *  call delegate method through cancel button when user press cancel button instead of login
 */
-(void)btnCancelPressed
{
    if (delegate) {
        [delegate dismissLoginView];
    }
}

#pragma mark - Registration Button
-(IBAction)btnRegistrationPressed:(id)sender
{
    RegistrationViewController *registrationView    =   [self.storyboard instantiateViewControllerWithIdentifier:@"registrationView"];
    registrationView.delegate = self;
    UINavigationController *navController   =   [[UINavigationController alloc] initWithRootViewController:registrationView];
    
    [UIView transitionWithView:self.view.window
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromLeft
                    animations:^{ [self.navigationController presentViewController:navController animated:NO completion:nil]; }
                    completion:nil];
}

/**
 *  Remove Registration View and back to login view
 */
-(void)dismissRegistrationView
{
    [UIView transitionWithView:self.view
                      duration:0.5
                       options:UIViewAnimationOptionTransitionFlipFromRight
                    animations:^{ [self dismissViewControllerAnimated:NO completion:nil]; }
                    completion:nil];
}

#pragma mark - login button tap
-(IBAction)btnLoginPressed:(id)sender
{
    [txtEmail resignFirstResponder];
    [txtPassword resignFirstResponder];
    
    if ([self isValid]) {
        [DSBezelActivityView newActivityViewForView:self.view.window];
        NSDictionary *dictOfParameters  =   [[NSDictionary alloc] initWithObjectsAndKeys:self.txtEmail.text,@"email",self.txtPassword.text,@"pwd", nil];
        
        [Utility GetDataForMethod:NSLocalizedString(@"LOGIN_METHOD", @"LOGIN_METHOD") parameters:dictOfParameters key:@"" withCompletion:^(id response){
            
            [DSBezelActivityView removeViewAnimated:YES];
            if ([response isKindOfClass:[NSArray class]]) {
                
                if ([[[response objectAtIndex:0] objectForKey:@"status"] intValue] == 0) {
                    [Utility alertNotice:@"" withMSG:[[response objectAtIndex:0] objectForKey:@"message"] cancleButtonTitle:@"OK" otherButtonTitle:nil];
                }
                else{
                    [Utility setNSUserDefaultValueForString:[[response objectAtIndex:0] objectForKey:@"user_id"] strKey:KUSERID];
                    
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:APPNAME message:@"Login Successful" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av setTag:99];
                    [av show];
                }
            }
            else if ([response isKindOfClass:[NSDictionary class]]){
                if ([[response objectForKey:@"status"] intValue] == 0) {
                    [Utility alertNotice:@"" withMSG:[response objectForKey:@"message"] cancleButtonTitle:@"OK" otherButtonTitle:nil];
                }
                else{
                    [Utility setNSUserDefaultValueForString:[response objectForKey:@"user_id"] strKey:KUSERID];
                    UIAlertView *av = [[UIAlertView alloc] initWithTitle:APPNAME message:@"Login Successful" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [av setTag:99];
                    [av show];
                }
                
            }
            
        }WithFailure:^(NSString *error){
            NSLog(@"%@",error);
            [DSBezelActivityView removeViewAnimated:YES];
        }];
    }
}

#pragma mark - Check Validations for login
-(BOOL)isValid
{
    NSString *message   =   @"";
    if (![txtEmail.text length]>0) {
        message =   @"Please enter email";
    }
    else if (![txtPassword.text length]>0){
        message =   @"Please enter password";
    }
    else if (![self validateEmail:txtEmail.text]){
        message =   @"Please enter valid email";
    }
    
    if ([message length]>0) {
        [Utility alertNotice:APPNAME withMSG:message cancleButtonTitle:@"OK" otherButtonTitle:nil];
        return NO;
    }
    return YES;
}

#pragma mark - TextField Delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.returnKeyType == UIReturnKeyDone)
    {
        [textField resignFirstResponder];
    }
    else
    {
        UIResponder *nextResponder = [textField.superview viewWithTag:textField.tag+1];
        
        if (nextResponder){
            [nextResponder becomeFirstResponder];
        }
    }
    return NO;
}

#pragma mark - email validation
-(BOOL)validateEmail:(NSString *) candidate {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:candidate];
}

#pragma mark - Alert View Delegates
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 99) {
        if (delegate) {
            [delegate dismissLoginView];
        }
    }
}
@end
