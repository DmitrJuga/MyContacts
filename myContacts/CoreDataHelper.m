//
//  CoreDataHelper.m
//  myContacts
//
//  Created by DmitrJuga on 25.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.


#import "CoreDataHelper.h"

@interface CoreDataHelper()

@property (strong, nonatomic) NSManagedObjectModel *model;
@property (strong, nonatomic) NSPersistentStoreCoordinator *coordinator;
@property (strong, nonatomic) NSManagedObjectContext *context;

@end

@implementation CoreDataHelper

// метод класса, возвращающий синглтон
+ (CoreDataHelper *)sharedInstance {
    
    static CoreDataHelper *singleton = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

// инициализация стека CoreData
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSError *error = nil;
        
        // ManagedObjectModel
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:MODEL_FILE_NAME withExtension:MODEL_FILE_EXT];
        _model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        // PersistentStoreCoordinator
        NSURL *docsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        NSURL *storeURL = [docsURL URLByAppendingPathComponent:STORE_FILE_NAME];
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        if (![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
        
        // ManagedObjectContext
        _context = [[NSManagedObjectContext alloc] init];
        _context.persistentStoreCoordinator = _coordinator;
        
    }
    return self;
}


// сохранение контекста
- (void)save {
    NSError *error = nil;
    
    if ([self.context hasChanges] && ![self.context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

// создание нового объекта для указанного entity
- (NSManagedObject *)addObjectForEntity:(NSString *)entityName {
    return [NSEntityDescription insertNewObjectForEntityForName:entityName inManagedObjectContext:self.context];
}

// получение всех объектов для указанного entity
- (NSArray *)fetchObjectsForEntity:(NSString *)entityName {
    NSError *error = nil;

    NSFetchRequest *request = [[NSFetchRequest alloc]initWithEntityName:entityName];
    NSArray *array = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    return array;
}

// удаление объекта
- (void)deleteObject:(NSManagedObject *)object {
    [self.context deleteObject:object];
}


@end
