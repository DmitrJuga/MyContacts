//
//  CustomCell.m
//  myContacts
//
//  Created by DmitrJuga on 25.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "CustomCell.h"
#import "AppConstants.h"

@interface CustomCell()

@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UILabel *lastName;
@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end
    
@implementation CustomCell

// Заполнение кастомной ячейки
- (void)setupCellForData:(NSManagedObject *)contact {
    NSData *imageData = [contact valueForKey:ATT_IMAGE_DATA];
    if (imageData) {
        self.imgView.image = [UIImage imageWithData:imageData];
    }
    self.lastName.text = [contact valueForKey:ATT_LAST_NAME];
    self.firstName.text = [contact valueForKey:ATT_FIRST_NAME];
    self.status.text = [contact valueForKey:ATT_STATUS];
}

@end
