//
//  ImageViewController.m
//  MyContacts
//
//  Created by DmitrJuga on 30.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "ImageViewController.h"

@interface ImageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@implementation ImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imageView.image = self.image;
}

@end
