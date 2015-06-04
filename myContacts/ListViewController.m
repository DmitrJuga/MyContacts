//
//  ListViewController.m
//  myContacts
//
//  Created by DmitrJuga on 25.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "AppConstants.h"
#import "Utils.h"
#import "CoreDataHelper.h"
#import "ListViewController.h"
#import "CustomCell.h"
#import "DetailsViewController.h"

@interface ListViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *arrayContacts;
@property (strong, nonatomic) CoreDataHelper *coreData;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.coreData = [CoreDataHelper sharedInstance];
    self.arrayContacts = [[NSMutableArray alloc] init];
    self.tableView.tableFooterView = [[UIView alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    // перегрузка таблицы данными из CoreData перед появлением на экране
    NSArray *arrayFetch = [self.coreData fetchObjectsForEntity:ENTITY_NAME_CONTACT
                                                      sortedBy:@[ ATT_LAST_NAME, ATT_FIRST_NAME ]];
    [self.arrayContacts removeAllObjects];
    [self.arrayContacts addObjectsFromArray:[Utils splitArray:arrayFetch withKey:ATT_LAST_NAME keyLenght:1]];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDataSource

// кол-во секций
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayContacts.count;
}

// кол-во строк в секции
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayContacts[section] count];
}

// возвращаем заголовок секции
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSManagedObject *contact = [self.arrayContacts[section] firstObject];
    return [[contact valueForKey:ATT_LAST_NAME] substringToIndex:1];
}

// возвращаем ячейку
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_LIST forIndexPath:indexPath];
    NSManagedObject *contact = self.arrayContacts[indexPath.section][indexPath.row];
    [cell setupCellForData:contact];
    return cell;
}

// разрешаем удалять
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// удаление записи
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableArray *subArray = self.arrayContacts[indexPath.section];
        NSManagedObject *contact = subArray[indexPath.row];
        // удаление из coredata
        [self.coreData deleteObject:contact];
        [self.coreData save];
        // удаление из массива и tableView
        [subArray removeObjectAtIndex:indexPath.row];
        if (subArray.count == 0) {
            [self.arrayContacts removeObjectAtIndex:indexPath.section];
            [tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section]
                     withRowAnimation:UITableViewRowAnimationLeft];
        } else {
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}


#pragma mark: - Navigation

// передаём параметры в DetailsViewController
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsViewController *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:SEGUE_ADD]) {
        vc.contact = nil;
    } else if ([segue.identifier isEqualToString:SEGUE_DETAILS]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        vc.contact = self.arrayContacts[indexPath.section][indexPath.row];
    }
}

@end
