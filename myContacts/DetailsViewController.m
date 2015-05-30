//
//  DetailsViewController.m
//  myContacts
//
//  Created by DmitrJuga on 26.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.


#import "AppConstants.h"
#import "Utils.h"
#import "DetailsViewController.h"
#import "ImageViewController.h"

@interface DetailsViewController()

@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *status;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) UIImage *image;

@property (weak, nonatomic) IBOutlet UITableViewCell *btnDeleteCell;
@property (weak, nonatomic) IBOutlet UIButton *btnImageChange;
@property (weak, nonatomic) IBOutlet UIButton *btnImageView;
@property (weak, nonatomic) IBOutlet UIButton *btnDelete;

@property (strong, nonatomic) CoreDataHelper *coreData;
@property (assign, nonatomic) BOOL editMode;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.coreData = [CoreDataHelper sharedInstance];
    
    // обработчик нажатий (чтобы убирать клавиатуру при нажатии вне полей)
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHandler:)];
    [self.view addGestureRecognizer:tap];
    // инициализация UI
    self.editMode = (self.contact == nil);
    [self setupUI];
}

// первоначальная настройка UI
- (void)setupUI {
    
    // "круглая аватарка"
    self.imgView.layer.cornerRadius = self.imgView.bounds.size.width / 2;
    self.imgView.clipsToBounds = YES;
    // оверлеи для предупреждения о невалидности полей
    self.lastName.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];;
    self.lastName.leftViewMode = UITextFieldViewModeNever;
    self.firstName.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];;
    self.firstName.leftViewMode = UITextFieldViewModeNever;
    self.email.leftView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];;
    self.email.leftViewMode = UITextFieldViewModeNever;

    // если передан контакт = > заполняем поля
    if (self.contact) {
        self.title = @"Контакт";
        self.lastName.text = [self.contact valueForKey:ATT_LAST_NAME];
        self.firstName.text = [self.contact valueForKey:ATT_FIRST_NAME];
        self.phone.text = [self.contact valueForKey:ATT_PHONE];
        self.email.text = [self.contact valueForKey:ATT_EMAIL];
        self.status.text = [self.contact valueForKey:ATT_STATUS];
        NSData *imageData = [self.contact valueForKey:ATT_IMAGE];
        if (imageData) {
            self.image = [UIImage imageWithData:imageData];
            self.imgView.image = self.image;
        }
        CGRect frame = self.btnDeleteCell.contentView.frame;
        frame.size.height = 250;
        self.btnDeleteCell.contentView.frame = frame;
        self.btnDelete.layer.cornerRadius = 8;
        self.btnDelete.hidden = NO;
    } else {
        self.title = @"Новый контакт";
        self.btnDelete.hidden = YES;
    }
    [self setupUIForEditMode];
}

// настройка UI для режима редактирования
- (void)setupUIForEditMode {
    NSString *rightButtonTitle;
    if (self.editMode) {
        self.lastName.userInteractionEnabled = YES;
        self.firstName.userInteractionEnabled = YES;
        self.phone.userInteractionEnabled = YES;
        self.email.userInteractionEnabled = YES;
        self.status.userInteractionEnabled = YES;
        self.lastName.textColor = [UIColor blackColor];
        self.firstName.textColor = [UIColor blackColor];
        self.phone.textColor = [UIColor blackColor];
        self.email.textColor = [UIColor blackColor];
        self.status.textColor = [UIColor blackColor];
        self.btnImageChange.hidden = NO;
        [self.lastName becomeFirstResponder];
        rightButtonTitle = (self.contact) ? @"Сохранить" : @"Готово";
    } else {
        self.lastName.userInteractionEnabled = NO;
        self.firstName.userInteractionEnabled = NO;
        self.phone.userInteractionEnabled = NO;
        self.email.userInteractionEnabled = NO;
        self.status.userInteractionEnabled = NO;
        self.lastName.textColor = [UIColor darkGrayColor];
        self.firstName.textColor = [UIColor darkGrayColor];
        self.phone.textColor = [UIColor darkGrayColor];
        self.email.textColor = [UIColor darkGrayColor];
        self.status.textColor = [UIColor darkGrayColor];
        self.btnImageChange.hidden = YES;
        rightButtonTitle = @"Изменить";
    }
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:rightButtonTitle
                                                                    style:UIBarButtonItemStylePlain
                                                                   target:self action:@selector(btnEditSavePressed:)];
    self.navigationItem.rightBarButtonItem = rightButton;
}

// сохранение нового контакта
- (void)saveContact {
    // валидация полей
    NSString *msg = @"Необходимо заполнить поле: %@";
    UITextField *invalidField;
    if (!self.lastName.hasText) {
        invalidField = self.lastName;
    } else if (!self.firstName.hasText) {
        invalidField = self.firstName;
    } else if (self.email.hasText && ![Utils validEmail:self.email.text]) {
        invalidField = self.email;
        msg = @"Некорректный формат %@";
    }
    // предупреждаем пользователя
    if (invalidField) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Внимание!"
                                                                       message:[NSString stringWithFormat:msg, invalidField.placeholder]
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:^{
            [invalidField becomeFirstResponder];
        }];
        return;
    }
    
    // сохраняем
    if (!self.contact) {
        self.contact = [self.coreData addObjectForEntity:ENTITY_NAME_CONTACT];
    }
    [self.contact setValue:self.lastName.text forKey:ATT_LAST_NAME];
    [self.contact setValue:self.firstName.text forKey:ATT_FIRST_NAME];
    [self.contact setValue:self.phone.text forKey:ATT_PHONE];
    [self.contact setValue:self.email.text forKey:ATT_EMAIL];
    [self.contact setValue:self.status.text forKey:ATT_STATUS];
    [self.contact setValue:UIImagePNGRepresentation(self.image) forKey:ATT_IMAGE];
    [self.coreData save];
}

// удаление текущего контакта
- (void)deleteContact {
    // предупреждаем пользователя
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Удаление"
                                                                   message:@"Контакт будет удален безвозвратно!"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Удалить"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *action) {
        // удаляем
        [self.coreData deleteObject:self.contact];
        [self.coreData save];
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}


#pragma mark - UITextFieldDelegate

// переходы между полями
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.lastName]) {
        [self.firstName becomeFirstResponder];
    } else if ([textField isEqual:self.firstName]) {
        [self.phone becomeFirstResponder];
    } else if ([textField isEqual:self.phone]) {
        [self.email becomeFirstResponder];
    } else if ([textField isEqual:self.email]) {
        [self.status becomeFirstResponder];
    } else if ([textField isEqual:self.status]) {
        [self.status resignFirstResponder];
    }
    return YES;
}

// валидация полей и установка предупреждений
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if (([textField isEqual:self.lastName] && !textField.hasText) ||
        ([textField isEqual:self.firstName] && !textField.hasText) ||
        ([textField isEqual:self.email] && textField.hasText && ![Utils validEmail:textField.text])) {
            textField.leftViewMode = UITextFieldViewModeUnlessEditing;
        textField.leftViewMode = UITextFieldViewModeAlways;
    }
    return YES;
}

// сброс предупреждений
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    textField.leftViewMode = UITextFieldViewModeNever;
}

// форматирование ввода данных в поле
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField isEqual:self.phone]) {
        // форматирование для номера телефона
        NSError *error = nil;
        NSString *phString = [NSString stringWithFormat:@"%@%@", textField.text, string];
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[\\s-\\(\\)]"
                                                                               options:NSRegularExpressionCaseInsensitive
                                                                                 error:&error];
        phString = [regex stringByReplacingMatchesInString:phString
                                                   options:0
                                                     range:NSMakeRange(0, phString.length)
                                                    withTemplate:@""];
        phString = (range.length == 1) ? [phString substringToIndex:phString.length - 1] : phString;
        textField.text = [Utils formatPhoneNumber:phString];
        return NO;
    }
    return YES;
}


#pragma mark - Actions Handlers

// обработчик нажатия кнопки сохранить
- (void)btnEditSavePressed:(id)sender {
    if (self.editMode) {
        // кнопка "Сохранить"
        BOOL isNewContact = (self.contact == nil);
        [self saveContact];
        if (isNewContact) {
            // если создавали новый контакт - выходим
            [self.navigationController popViewControllerAnimated:YES];
        } else {
            // если не новый - выключаем режим редактирования
            self.editMode = NO;
            [self setupUIForEditMode];
        }
    } else {
        // кнопка "Редактировать"
        self.editMode = YES;
        [self setupUIForEditMode];
    }
}

// обработчик нажатия на аватарку
- (IBAction)btnImageViewPressed:(id)sender {
    if (self.image) {
        [self performSegueWithIdentifier:SEGUE_IMG sender:nil];
    } else if (self.editMode) {
        [self btnChangeImagePressed:sender];
    }
}

// обработчик нажатия кнопки выбора картинки
- (IBAction)btnChangeImagePressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}

// обработчик нажатия - убрать клавиатуру при нажатии вне полей
- (void)tapHandler:(id)sender {
    [self.lastName resignFirstResponder];
    [self.firstName resignFirstResponder];
    [self.phone resignFirstResponder];
    [self.email resignFirstResponder];
    [self.status resignFirstResponder];
}

// обработчик нажатия кнопки удалить
- (IBAction)btnDeletePressed:(id)sender {
    [self deleteContact];
}


#pragma mark - UIImagePickerControllerDelegate

// выбор картинки из PhotoLibrary
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (self.image) {
        self.imgView.image = self.image;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - UITableViewDelegate

// высота ячеек
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = tableView.rowHeight;
    switch (indexPath.row) {
        case 0: height = 124;
                break;
        case 3: height = (self.contact) ? tableView.frame.size.height - 328 : 0;
                break;
    }
    return height;
}


#pragma mark - Navigation

// передаём параметры в ImageViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ImageViewController *vc = segue.destinationViewController;
    vc.image = self.image;
}


@end
