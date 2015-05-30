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

@property (weak, nonatomic) IBOutlet UIButton *bottomButton;
@property (weak, nonatomic) IBOutlet UITextField *lastName;
@property (weak, nonatomic) IBOutlet UITextField *firstName;
@property (weak, nonatomic) IBOutlet UITextField *phone;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *status;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIButton *imageChangeButton;
@property (weak, nonatomic) IBOutlet UIButton *imageViewButton;

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
        
        NSData *imageData = [self.contact valueForKey:ATT_IMAGE];
        if (imageData) {
            self.image = [UIImage imageWithData:imageData];
            self.imgView.image = self.image;
            self.imageViewButton.hidden = NO;
        }
        self.imageChangeButton.hidden = YES;
        self.bottomButton.backgroundColor = [UIColor redColor];
        [self.bottomButton setTitle:@"Удалить" forState:UIControlStateNormal];
    }
    self.bottomButton.layer.cornerRadius = 8;
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
    NSManagedObject *contact = [self.coreData addObjectForEntity:ENTITY_NAME_CONTACT];
    [contact setValue:self.lastName.text forKey:ATT_LAST_NAME];
    [contact setValue:self.firstName.text forKey:ATT_FIRST_NAME];
    [contact setValue:self.phone.text forKey:ATT_PHONE];
    [contact setValue:self.email.text forKey:ATT_EMAIL];
    [contact setValue:self.status.text forKey:ATT_STATUS];
    [contact setValue:UIImagePNGRepresentation(self.image) forKey:ATT_IMAGE];
    [self.coreData save];

    [self.navigationController popViewControllerAnimated:YES];
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

// обработчик нажатия на аватарку
- (IBAction)btnImageViewPressed:(id)sender {
    if (self.image) {
        [self performSegueWithIdentifier:SEGUE_IMG sender:nil];
    } else if (!self.contact) {
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


#pragma mark - UIImagePickerControllerDelegate

// выбор картинки из PhotoLibrary
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    self.image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (self.image) {
        self.imgView.image = self.image;
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark - Navigation

// передаём параметры в ImageViewController
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ImageViewController *vc = segue.destinationViewController;
    vc.image = self.image;
}


@end
