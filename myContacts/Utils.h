//
//  Utils.h
//  MyContacts
//
//  Created by DmitrJuga on 29.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Utils : NSObject

+ (BOOL)validEmail:(NSString*)emailString;
+ (NSString *)formatPhoneNumber:(NSString *)simpleNumber;
+ (NSArray *)splitArray:(NSArray *)array withKey:(NSString *)key keyLenght:(NSInteger)length;

@end
