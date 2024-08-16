Ходосевич Глеб Дмитриевич
<br /> Когорта: 16
<br /> Группа: 1
<br /> Эпик: Каталог
<br /> Ссылка: https://github.com/users/qa-tapalov/projects/4/views/1

# Catalog Flow Decomposition


## Module 1:

##### Верстка [Экран] Catalogue:
- Ячейка таблицы с NFT + элементы (est: 60 min; fact: 60 min).
- Таблица с NFT на экране каталога (est: 60 min; fact: 60 min).
- Кнопка сортировки (est: 20 min; fact: 20 min).
- Action sheet для обработки нажатия на кнопку сортировки (est: 30 min; fact: 30 min).
- Индикатор загрузки NFT (est: 30 min; fact: 30 min).

##### Логика:
- Загрузка изображения NFT (est: 180 min, fact: 180 min).
- Получение названия / кол-ва NFT (est: 90 min; fact: 90 min).
- Обработка нажатия кнопки сортировки NFT (est: 90 min; fact: 90 min).

`Total:` est: 560 min; fact: 560 min.

## Module 2:
        
##### Верстка [Экран] Collection:
- Элементы экрана коллекции (обложка, название и т.д.) (est: 80 min; fact: x min).
- Ячейка коллекции (est: 120 min; fact: x min).
- Футер ячейки коллекции (est: 120 min; fact: x min).
- Коллекция NFT (UICollectionView) - (est: 180 min; fact: x min).

##### Логика:
- Загрузка с сервера на экран коллекции (est: 180 min; fact: x min).
- Переход между экранами (est: 180 min; fact: x min).

`Total:` est: 860 min; fact: x min.
        
## Module 3:

#### Верстка [Экран] Подробнее об авторе
- Страница автора (est: 120 min, fact: x min).

##### Логика:
- Добавление в избранное (est: 120 min, fact: x min).
- Удаление из избранного (est: 120 min, fact: x min).
- Добавление в корзину (est: 120 min, fact: x min).
- Удаление из корзины (est: 120 min, fact: x min).
- Переход на страницу автора (est: 120 min, fact: x min).
- Загрузка страницы автора (est: 120 min, fact: x min).
- Индикаторы загрузки для действий (est: 60 min, fact: x min).
- Реализация обработки ошибок на экранах (est: 120 min, fact: x min).

`Total:` est: 1020 min; fact: x min.

####`Total Epic Catalogue:` est: 2440 min; fact: x min.
