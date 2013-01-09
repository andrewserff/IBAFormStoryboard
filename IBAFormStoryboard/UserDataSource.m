//
//  UserDataSource.m
//  IBAFormStoryboard
//
//  Created by Andrew Serff on 1/8/13.
//  Copyright (c) 2013 sunkencity software. All rights reserved.
//

#import "UserDataSource.h"
#import <IBAForms/IBAForms.h>

@implementation UserDataSource
@synthesize actionBlock = actionBlock_;

- (void)dealloc {
	actionBlock_ = nil;
    
    //	[super dealloc];
}

- (id)initWithModel:(id)model formAction:(IBAButtonFormFieldBlock)action
{
    if ((self = [super initWithModel:model])) {
		[self setActionBlock:action];
        
		IBAFormSection *loginFormSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
		IBATextFormField *emailTextFormField = [IBATextFormField emailTextFormFieldWithSection:loginFormSection
                                                                                       keyPath:@"email"
                                                                                         title:NSLocalizedString(@"Email", @"")
                                                                              valueTransformer:nil];
		IBATextFormField *passwordTextFormField = [IBATextFormField passwordTextFormFieldWithSection:loginFormSection
                                                                                             keyPath:@"password"
                                                                                               title:NSLocalizedString(@"Password", @"")
                                                                                    valueTransformer:nil];
        
        //		[emailTextFormField setFormFieldStyle:[IBAFormFieldStyle textFormFieldStyle]];
        //		[passwordTextFormField setFormFieldStyle:[IBAFormFieldStyle textFormFieldStyle]];
        
		UITextField *passwordTextField = [[passwordTextFormField textFormFieldCell] textField];
		[passwordTextField setKeyboardType:UIKeyboardTypeDefault];
		[passwordTextField setReturnKeyType:UIReturnKeyDone];
		[passwordTextField addTarget:self
							  action:@selector(passwordTextFieldEditingDidEnd:withEvent:)
					forControlEvents:UIControlEventEditingDidEnd];
        
		IBAFormSection *submitFormSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
		IBAButtonFormField *submitFormField = [[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Login", @"")
                                                                                   icon:nil
                                                                         executionBlock:action];
        //		[submitFormField setFormFieldStyle:[IBAFormFieldStyle buttonFormFieldStyle]];
		[submitFormSection addFormField:submitFormField];
	}
    
	return self;
}

- (void)passwordTextFieldEditingDidEnd:(id)sender withEvent:(UIEvent *)event {
	if ([self actionBlock]) {
		[self actionBlock]();
	}
}

@end
