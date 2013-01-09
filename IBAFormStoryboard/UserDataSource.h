//
//  UserDataSource.h
//  IBAFormStoryboard
//
//  Created by Andrew Serff on 1/8/13.
//  Copyright (c) 2013 sunkencity software. All rights reserved.
//

#import "IBAForms/IBAForms.h"
#import <IBAForms/IBAButtonFormField.h>

@interface UserDataSource : IBAFormDataSource

@property (nonatomic, copy) IBAButtonFormFieldBlock actionBlock;

- (id)initWithModel:(id)model formAction:(IBAButtonFormFieldBlock)action;

@end
