//
//  Utils.m
//  MyContacts
//
//  Created by DmitrJuga on 29.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "Utils.h"

@implementation Utils

// валидация e-mail
+ (BOOL)validEmail:(NSString*)emailString {
    NSString *regExPattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern
                                                                      options:NSRegularExpressionCaseInsensitive
                                                                        error:nil];
    NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString
                                                     options:0
                                                       range:NSMakeRange(0, emailString.length)];
    if (regExMatches == 0) {
        return NO;
    } else {
        return YES;
    }
}

// форматирование номера телефона
+ (NSString *)formatPhoneNumber:(NSString *)phoneStr {
    if (phoneStr.length == 0) {
        return @"";
    }

    // use regex to remove non-digits(including spaces) so we are left with just the numbers
    NSError *error = nil;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^[0-9+]]"
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    phoneStr = [regex stringByReplacingMatchesInString:phoneStr
                                               options:0
                                                 range:NSMakeRange(0, phoneStr.length)
                                          withTemplate:@""];

    NSString *firstChar = (phoneStr.length > 0) ? [phoneStr substringToIndex:1] : @"";
    if ([firstChar isEqualToString:@"+"]) {
        //+1 (234)
        if (phoneStr.length < 6) {
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{1})(\\d+)"
                                                           withString:@"$1 ($2)"
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, phoneStr.length)];
        }
        else if(phoneStr.length < 9) {
            //+1 (234) 567
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{1})(\\d{3})(\\d+)"
                                                           withString:@"$1 ($2) $3"
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, phoneStr.length)];
        }
        else if(phoneStr.length < 11) {
            //+1 (234) 567-89
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{1})(\\d{3})(\\d{3})(\\d+)"
                                                           withString:@"$1 ($2) $3-$4"
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, phoneStr.length)];
        } else if (phoneStr.length < 13) {
            // +1 (234) 567-89-.. (like RU or US)
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{1})(\\d{3})(\\d{3})(\\d{2})(\\d+)"
                                                           withString:@"$1 ($2) $3-$4-$5"
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, phoneStr.length)];
        } else if (phoneStr.length == 13) {
            // +123 (45) 678-90-12 (like UA or BY)
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{2})(\\d{3})(\\d{2})(\\d{2})"
                                                           withString:@"$1 ($2) $3-$4-$5"
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, phoneStr.length)];
        } else if (phoneStr.length == 14) {
            // +12 (345) 56790123 (like DE)
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{2})(\\d{3})(\\d+)"
                                                           withString:@"$1 ($2) $3"
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, phoneStr.length)];
        }
    } else {
        if (phoneStr.length < 8) {
            // 1234, 1-23-45, 12-34-56, 123-456-78 (local city numbers)
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d+)(\\d{2})(\\d{2})"
                                                           withString:@"$1-$2-$3"
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, phoneStr.length)];
        } else if (phoneStr.length == 8) {
            // (123) 456-78
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d{2})"
                                                           withString:@"($1) $2-$3"
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, phoneStr.length)];
        } else if (phoneStr.length < 11) {
            // (123) 456-78-..
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{3})(\\d{2})(\\d+)"
                                                           withString:@"($1) $2-$3-$4"
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, phoneStr.length)];
        } else if (phoneStr.length == 11) {
            // 1 (234) 567-89-01 (like RU or US)
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{1})(\\d{3})(\\d{3})(\\d{2})(\\d{2})"
                                                           withString:@"$1 ($2) $3-$4-$5"
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, phoneStr.length)];
        } else if (phoneStr.length == 12) {
            // 123 (45) 678-90-12 (like UA or BY)
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{3})(\\d{2})(\\d{3})(\\d{2})(\\d{2})"
                                                           withString:@"$1 ($2) $3-$4-$5"
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, phoneStr.length)];
        } else if (phoneStr.length == 13) {
            // 12 (345) 56790123 (like DE)
            phoneStr = [phoneStr stringByReplacingOccurrencesOfString:@"(\\d{2})(\\d{3})(\\d+)"
                                                           withString:@"$1 ($2) $3"
                                                              options:NSRegularExpressionSearch
                                                                range:NSMakeRange(0, phoneStr.length)];
        }
    }
    
    return phoneStr;
}

// разбиение массива на секции (массив с вложенными массивами) по ключу
+ (NSArray *)splitArray:(NSArray *)array withKey:(NSString *)key keyLenght:(NSInteger)length {
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    NSMutableArray *subArray = nil;
    NSString *subArrayKey = @"";
    for (id obj in array) {
        NSString *objKey = [[obj valueForKey:key] substringToIndex:length];
        if ([objKey isEqual:subArrayKey]) {
            [subArray addObject:obj];
        } else {
            subArrayKey = objKey;
            subArray = [[NSMutableArray alloc] initWithObjects:obj, nil];
            [resultArray addObject:subArray];
        }
    }
    return resultArray;
}

@end
