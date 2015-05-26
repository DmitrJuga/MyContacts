//
//  DetailsViewController.h
//  myContacts
//
//  Created by DmitrJuga on 26.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.


#import <UIKit/UIKit.h>
#import "CoreDataHelper.h"

@interface DetailsViewController : UIViewController <UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>

@property (strong, nonatomic) NSManagedObject *contact;

@end
