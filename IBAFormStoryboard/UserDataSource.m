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
}

- (id)initWithModel:(id)model formAction:(IBAButtonFormFieldBlock)action
{
    if ((self = [super initWithModel:model])) {
        //Save the Action for later use.
		[self setActionBlock:action];
        
        //Create the form fields for the login info.
		IBAFormSection *loginFormSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
        //Note the keyPath.  This is the selector for the field in our Model that will map to this field.
		IBATextFormField *emailTextFormField = [IBATextFormField emailTextFormFieldWithSection:loginFormSection
                                                                                       keyPath:@"email"
                                                                                         title:NSLocalizedString(@"Email", @"")
                                                                              valueTransformer:nil];
		IBATextFormField *passwordTextFormField = [IBATextFormField passwordTextFormFieldWithSection:loginFormSection
                                                                                             keyPath:@"password"
                                                                                               title:NSLocalizedString(@"Password", @"")
                                                                                    valueTransformer:nil];
        
        //Give the fields a little more style
        [emailTextFormField setFormFieldStyle:[self textFormFieldStyle]];
        [passwordTextFormField setFormFieldStyle:[self textFormFieldStyle]];
        
        //Change the behavior of the password text field.
		UITextField *passwordTextField = [[passwordTextFormField textFormFieldCell] textField];
		[passwordTextField setKeyboardType:UIKeyboardTypeDefault];
		[passwordTextField setReturnKeyType:UIReturnKeyDone];
        
        //Attach our action to when the user is done editing the text field.
		[passwordTextField addTarget:self
							  action:@selector(passwordTextFieldEditingDidEnd:withEvent:)
					forControlEvents:UIControlEventEditingDidEnd];
        
        //Create a Login button they can click on and attach our action to it.
		IBAFormSection *submitFormSection = [self addSectionWithHeaderTitle:nil footerTitle:nil];
		IBAButtonFormField *submitFormField = [[IBAButtonFormField alloc] initWithTitle:NSLocalizedString(@"Login", @"")
                                                                                   icon:nil
                                                                         executionBlock:action];
        [submitFormField setFormFieldStyle:[self buttonFormFieldStyle]];
		[submitFormSection addFormField:submitFormField];
	}
    
	return self;
}

- (void)passwordTextFieldEditingDidEnd:(id)sender withEvent:(UIEvent *)event {
	if ([self actionBlock]) {
		[self actionBlock]();
	}
}

- (IBAFormFieldStyle *)textFormFieldStyle {
	IBAFormFieldStyle *style = [[IBAFormFieldStyle alloc] init];
    
	[style setLabelTextColor:[UIColor blackColor]];
	[style setLabelFont:[UIFont boldSystemFontOfSize:13.]];
	[style setLabelTextAlignment:UITextAlignmentRight];
	[style setLabelFrame:CGRectMake(IBAFormFieldLabelX, 8., 180., IBAFormFieldLabelHeight)];
    
	[style setValueTextAlignment:UITextAlignmentLeft];
	[style setValueTextColor:[UIColor colorWithRed:.22 green:.329 blue:.529 alpha:1.]];
	[style setValueFont:[UIFont systemFontOfSize:14.]];
	[style setValueFrame:CGRectMake(210., 20., 110., IBAFormFieldValueHeight)];
    
	return style;
}

- (IBAFormFieldStyle *)buttonFormFieldStyle {
	IBAFormFieldStyle *style = [[IBAFormFieldStyle alloc] init];
    
	[style setLabelTextColor:[UIColor colorWithRed:.318 green:.4 blue:.569 alpha:1.]];
	[style setLabelFont:[UIFont boldSystemFontOfSize:20.]];
	[style setLabelFrame:CGRectMake(10., 8., 300., 30.)];
	[style setLabelTextAlignment:UITextAlignmentCenter];
	[style setLabelAutoresizingMask:UIViewAutoresizingFlexibleWidth];
    
	return style;
}

@end
