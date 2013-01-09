//
//  ViewController.m
//  IBAFormStoryboard
//
//  Created by Andrew Serff on 1/8/13.
//  Copyright (c) 2013 sunkencity software. All rights reserved.
//

#import "ViewController.h"
#import "User.h"
#import "UserDataSource.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize tableView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [self setTableView:tableView];
    User *user = [User alloc];
    IBAButtonFormFieldBlock action = ^{
		[[IBAInputManager sharedIBAInputManager] performSelector:@selector(setActiveInputRequestor:)
													  withObject:nil
													  afterDelay:1.];
        
		NSLog(@"User %@", user.email);
	};
    
    UserDataSource *dataSource = [[UserDataSource alloc] initWithModel:user formAction:action];
    [self setFormDataSource:dataSource];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
