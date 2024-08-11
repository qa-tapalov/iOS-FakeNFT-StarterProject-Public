Клейменов Юрий Дмитриевич 
<br /> Когорта: 16
<br /> Группа: 1
<br /> Эпик: Профиль
<br /> Ссылка: https://github.com/users/qa-tapalov/projects/4/views/1

# Profile Flow Decomposition


## Module 1:

#### Верстка
- Экран "Профиль" (est: 120 min; fact: x min).
- Экран "Редактирования профиля" (est: 60 min; fact: x min). 
- UITableView с ячейками "Мои NFT", "Избранные NFT", "Сайт пользователя" (est: 60 min; fact: x min)

#### Логика
- Добавить экран профиля в navBar (est: 30 min; fact: x min).
- Отображение данных профиля (аватар, никнейм, описание, ссылка) с API (est: 30 min; fact: x min).
- Отображение всех NFT + отображение их кол-ва на главном экране  (est: 60 min; fact: x min).
- Отображение избранных NFT + их кол-во (est: 60 min; fact: x min).
- Переход на экраны "Редактирования Профиля", "Мои NFT", "Избранное" (est: 30 min; fact: x min).
- Переход на webView после нажатия на сайт в профиле (est: 30 min; fact: x min). 
- Отправка измененных данных профиля на сервер + изменение их (est: 90 min; fact: x min).

     
`Total:` est: 570 min; fact: x min.


## Module 2:
#### Верстка
- Экран "Мои NFT" (est: 120 min; fact: x min).
Добавить коллекцию, сверстать UICollectionViewCell с данными NFT
- Экран "Избранные NFT" (est: 120 min; fact: x min).
Добавить коллекцию, сверстать UICollectionViewCell с данными NFT

#### Логика
- Отображение данных с сервера в UICollectionViewCell (est: 120 min; fact: x min).
- Добавление NFT в избранное по нажатию на кнопку Like (est: 120 min; fact: x min).
- Фильтрация NFT по аттрибутам (est: 90 min; fact: x min).
- Отображение заглушки если нет NFT (est: 30 min; fact: x min).
-------------------
- Отображение добавленных в избранное NFT в UICollectionView по данным с сервера (est: 120 min; fact: x min).
- Отображение заглушки если нет избранных NFT (est: 30 min; fact: x min).

`Total:` est: 750 min; fact: x min.


## Module 3:

#### Верстка
- Экран "Мои NFT": Верстка UITableView с ячейками (иконка, название, автор, цена) + кнопка сортировки (est: 120 min; fact: x min).
- Экран "Избранные NFT": Верстка UICollectionView с ячейками (иконка, сердечко, название, рейтинг, цена) (est: 120 min; fact: x min).

#### Логика
- Реализация сортировки для экрана "Мои NFT" (est: 60 min; fact: x min).
- Удаление NFT из избранного с обновлением коллекции (est: 60 min; fact: x min).

`Total:` est: 360 min; fact: x min.

