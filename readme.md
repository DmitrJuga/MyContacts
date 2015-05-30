geekbrains.ru, Objective-C level 2 course
#"Мои Контакты" (записная книжка)

![](https://github.com/DmitrJuga/MyContacts/blob/master/screenshots/screen0.png)
![](https://github.com/DmitrJuga/MyContacts/blob/master/screenshots/screen1.png)
![](https://github.com/DmitrJuga/MyContacts/blob/master/screenshots/screen2.png)
![](https://github.com/DmitrJuga/MyContacts/blob/master/screenshots/screen3.png)
![](https://github.com/DmitrJuga/MyContacts/blob/master/screenshots/screen4.png)
![](https://github.com/DmitrJuga/MyContacts/blob/master/screenshots/screen5.png)
## Lesson 6 - homework
ДЗ: Сделать записную книжку с использованием Core Data. Сделать несколько параметров (на выбор) но не менее трех. Реализовать блокирование сохранения данных, если какое-то поле пустое с выводом Алерта, относительно того, что осталось незаполненным. Текстовые поля должны быть скрыты, когда заходим в детали записи. А когда создаем новую запись, то должны быть открыты. Дополнительно необходимо использовать изображения, хранить и считывать в формате NSData.


Выполнено.

Особенности:
- реализован вспомогательный класс для работы с CoreData - CoreDataHelper; для класса реализован синглтон; создание всего стека объектов CoreData перенесено из AppDelegate в инициализатор класса CoreDataHelper;
- работа с CoreData осуществляется с помощью класса CoreDataHelper, а также с применением KVC;
- в базе данных одна сущность - Контакт (Contact) с пятью строковыми атрибутами и картинкой;
- при запуске приложения, если в базе пусто, добавляются два тестовых контакта;
- при создании нового контакта можно выбирать картинку из PhotoLibrary телефона (использую UIImagePickerController);
- реализовано удаление контактов из CoreData, как из списка (tableView), так и из окна просмотра контакта;


вот как-то так...

:)
