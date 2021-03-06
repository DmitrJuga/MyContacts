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
- (void)setupWithContact:(NSManagedObject *)contact {
    NSData *imageData = [contact valueForKey:ATT_IMAGE];
    self.imgView.image = (imageData) ? [UIImage imageWithData:imageData] : [UIImage imageNamed:@"dummy"];
    self.lastName.text = [contact valueForKey:ATT_LAST_NAME];
    self.firstName.text = [contact valueForKey:ATT_FIRST_NAME];
    self.status.text = [contact valueForKey:ATT_STATUS];
    // "круглая аватарка"
    self.imgView.layer.cornerRadius = self.imgView.bounds.size.width / 2;
    self.imgView.clipsToBounds = YES;
}

@end
