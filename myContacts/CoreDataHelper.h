//
//  CoreDataHelper.h
//  myContacts
//
//  Created by DmitrJuga on 25.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#define     MODEL_FILE_NAME     @"Model"
#define     MODEL_FILE_EXT      @"momd"
#define     STORE_FILE_NAME     @"database.sqlite"

@interface CoreDataHelper : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectModel *model;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (readonly, strong, nonatomic) NSManagedObjectContext *context;

+ (CoreDataHelper *)sharedInstance;
- (void)save;

- (NSManagedObject *)addObjectForEntity:(NSString *)entityName;
- (NSArray *)fetchObjectsForEntity:(NSString *)entityName;
- (void)deleteObject:(NSManagedObject *)object;

@end
