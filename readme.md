# ![MyContacts](https://github.com/DmitrJuga/MyContacts/blob/master/myContacts/Images.xcassets/AppIcon.appiconset/mzl.fbquoxfc-29@2x.png) "Мои контакты" / "My Contacts"

"Мои контакты" - простая записная книжка (cписок контактов).    
Учебный (тренировочный) проект на Objective-C c использованием CoreData.

![](https://github.com/DmitrJuga/MyContacts/blob/master/screenshots/screenshot1.png)
![](https://github.com/DmitrJuga/MyContacts/blob/master/screenshots/screenshot2.png)

## Функционал

- Добавление/просмотр/редактирование/удаление контактов;
- Контактные данные содержат **Фамилию** и **Имя** лица, его **Фото** (аватар), **Телефон**, **E-mail** и **Статус** (примечание);
- Список контактов отсортирован по фамилии и имени, секционирован по буквам алфавита (по первой букве фамилии), отображает **Фамилию**, **Имя**, **Фото** (аватар) и **Статус** контакта;
- Фотографии выбираются и добавляются из локального фотоальбома (фотоплёнки);
- Есть возможность просмотра фото контакта в увеличеном виде;
- Проверка вводимых данных: форматирование номера телефона, валидация e-mail;
- *В пустую (новую) базу при запуске добавляются 2 тестовых контакта* :)

## Technical Information

**CoreData framework usage:**
- CoreData model contain 1 entity (`Сontact`) with 6 attributes (including Binary Data for image storage);
- Use my own `CoreDataHelper` class providing singleton instance;
- KVC for processing CoreData `NSManagedObjects`;   

**UIKit framework usage:**
- Use 3 `UIViewController`s with Segue transitions + `UINavigationController`;
- `UITableViewController` with static cells;
- `UITableView` with sections and custom cells;
- `UIImagePickerController` to pick photo for contact;
- Auto Layout (Storyboard constraints);   

**Extra:**
- Launch Screen, App Icon (images from open web sources);
- My own `Utils` class for routine functions like phone number formatting or e-mail validation _(some based on code examples from [stackoverflow.com] (http://stackoverflow.com/))_.

## More Screenshots

![](https://github.com/DmitrJuga/MyContacts/blob/master/screenshots/screenshot3.png)
![](https://github.com/DmitrJuga/MyContacts/blob/master/screenshots/screenshot6.png)
![](https://github.com/DmitrJuga/MyContacts/blob/master/screenshots/screenshot4.png)
![](https://github.com/DmitrJuga/MyContacts/blob/master/screenshots/screenshot5.png)


## Основа проекта

Проект создан на основе моей домашней работы к уроку 6 по курсу **"Objective C. Уровень 2"** в [НОЧУ ДО «Школа программирования» (http://geekbrains.ru)](http://geekbrains.ru/)   
См. **домашнее задание** и пояснения к выполненой работе в [homework_readme.md](https://github.com/DmitrJuga/MyContacts/blob/master/homework_readme.md).

---

### Contacts

**Дмитрий Долотенко / Dmitry Dolotenko**

Krasnodar, Russia   
Phone: +7 (918) 464-02-63   
E-mail: <dmitrjuga@gmail.com>   
Skype: d2imas

:]

