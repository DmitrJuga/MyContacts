//
//  DetailsViewController.m
//  myContacts
//
//  Created by DmitrJuga on 26.05.15.
//  Copyright (c) 2015 Dmitriy Dolotenko. All rights reserved.
//

#import "DetailsViewController.h"
#import "AppConstants.h"

@interface DetailsViewController()

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *status;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *imageChangeButton;
@property (strong, nonatomic) IBOutlet UIImage *image;
@property (strong, nonatomic) CoreDataHelper *coreData;

@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.coreData = [CoreDataHelper sharedInstance];
    [self setUI];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // если новый контакт => клавиатуру в первом поле
    if (!self.contact && !self.image) {
        [self.lastName becomeFirstResponder];
    }
}

// настройка UI
- (void)setUI {
    if (self.contact) {
        // если передан контакт = > режим просмотра
        self.title = @"Контакт";
        
        self.lastName.text = [self.contact valueForKey:ATT_LAST_NAME];
        self.firstName.text = [self.contact valueForKey:ATT_FIRST_NAME];
        self.phone.text = [self.contact valueForKey:ATT_PHONE];
        self.email.text = [self.contact valueForKey:ATT_EMAIL];
        self.status.text = [self.contact valueForKey:ATT_STATUS];
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
        
        NSData *imageData = [self.contact valueForKey:ATT_IMAGE_DATA];
        if (imageData) {
            self.image = [UIImage imageWithData:imageData];
            self.imgView.image = self.image;
        }
        self.imageChangeButton.hidden = YES;
        
        self.bottomButton.backgroundColor = [UIColor redColor];
        [self.bottomButton setTitle:@"Удалить" forState:UIControlStateNormal];
    }
    self.bottomButton.layer.cornerRadius = 8;
}

// сохранение нового контакта
- (void)saveContact {
    // проверка на незаполненные поля
    UITextField *emptyField = nil;
    if (!self.lastName.hasText) {
        emptyField = self.lastName;
    } else if (!self.firstName.hasText) {
        emptyField = self.firstName;
    } else if (!self.phone.hasText) {
        emptyField = self.phone;
    } else if (!self.email.hasText) {
        emptyField = self.email;
    } else if (!self.status.hasText) {
        emptyField = self.status;
    }
    // предупреждаем пользователя
    if (emptyField) {
        NSString *msg = [NSString stringWithFormat:@"Необходимо заполнить поле: %@", emptyField.placeholder];
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Пустое поле"
                                                                        message:msg
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    } else {
        // сохраняем
        NSManagedObject *contact = [self.coreData addObjectForEntity:ENTITY_NAME_CONTACT];
        [contact setValue:self.lastName.text forKey:ATT_LAST_NAME];
        [contact setValue:self.firstName.text forKey:ATT_FIRST_NAME];
        [contact setValue:self.phone.text forKey:ATT_PHONE];
        [contact setValue:self.email.text forKey:ATT_EMAIL];
        [contact setValue:self.status.text forKey:ATT_STATUS];
        [contact setValue:UIImagePNGRepresentation(self.image) forKey:ATT_IMAGE_DATA];
        [self.coreData save];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

// удаление текущего контакта
- (void)deleteContact{
    // предупреждаем пользователя
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"Удаление"
                                                                    message:@"Контакт будет удален безвозвратно!"
                                                             preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"Удалить" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        // удаляем
        [self.coreData deleteObject:self.contact];
        [self.coreData save];
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Отмена" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

// убрать клавиатуру при нажатии вне полей
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    CGPoint touchPoint = [[touches anyObject] locationInView:self.view];
    UIView *touchView = [self.view hitTest:touchPoint withEvent:event];
    if ([touchView isEqual:self.view]) {
        for (UIView *view in self.view.subviews) {
            if (view.isFirstResponder) {
                [view resignFirstResponder];
            }
        }
    }
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


#pragma mark - UIImagePickerControllerDelegate

// выбор картинки из PhotoLibrary
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (self.image) {
        self.imgView.image = self.image;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Actions Handlers

// обработчик нажатия нижней кнопки
- (IBAction)btnPressed:(id)sender {
    if (self.contact) {
        // сохранить
        [self deleteContact];
    } else {
        // удалить
        [self saveContact];
    }
}

// обработчик нажатия кнопки выбора картинки
- (IBAction)btnChangeImagePressed:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:picker animated:YES completion:nil];
}


@end
