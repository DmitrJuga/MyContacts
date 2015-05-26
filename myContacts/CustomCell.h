//
//  CustomCell.h
//  myContacts
//
//  Created by DmitrJuga on 25.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.


#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface CustomCell : UITableViewCell

- (void)setupCellForData:(NSManagedObject *)contact;

@end
