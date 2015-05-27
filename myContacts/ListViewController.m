//
//  ListViewController.m
//  myContacts
//
//  Created by DmitrJuga on 25.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.


#import "AppConstants.h"
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
    [self.arrayContacts removeAllObjects];
    [self.arrayContacts addObjectsFromArray:[self.coreData fetchObjectsForEntity:@"Contact"]];
    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource

// кол-во строк в списке
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayContacts.count;
}

// возвращаем ячейку
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomCell *cell = [tableView dequeueReusableCellWithIdentifier:CELL_LIST forIndexPath:indexPath];
    NSManagedObject *contact = self.arrayContacts[indexPath.row];
    [cell setupCellForData:contact];
    return cell;
}

// разрешаем удалять
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

// удаление записи
- (void)tableView:(UITableView *)tableView
    commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
     forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObject *contact = self.arrayContacts[indexPath.row];
        [self.coreData deleteObject:contact];
        [self.coreData save];
        [self.arrayContacts removeObjectAtIndex:indexPath.row];
        [tableView reloadData];
    }
}


#pragma mark: - Navigation

// передаём параметры в DetailsViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DetailsViewController *vc = segue.destinationViewController;
    if ([segue.identifier isEqualToString:SEGUE_ADD]) {
        vc.contact = nil;
    } else if ([segue.identifier isEqualToString:SEGUE_DETAILS]) {
        vc.contact = self.arrayContacts[self.tableView.indexPathForSelectedRow.row];
    }
}

@end
