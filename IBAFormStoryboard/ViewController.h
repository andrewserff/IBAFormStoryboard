//
//  ViewController.h
//  IBAFormStoryboard
//
//  Created by Andrew Serff on 1/8/13.
//  Copyright (c) 2013 sunkencity software. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IBAForms/IBAForms.h"

@interface ViewController : IBAFormViewController
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
