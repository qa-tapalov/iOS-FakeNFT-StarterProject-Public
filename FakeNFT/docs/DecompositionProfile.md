Клейменов Юрий Дмитриевич 
<br /> Когорта: 16
<br /> Группа: 1
<br /> Эпик: Профиль
<br /> Ссылка: https://github.com/users/qa-tapalov/projects/4/views/4

# Profile Flow Decomposition


## Module 1:

#### Верстка
- Экран "Профиль" (est: 2 h; fact: x h).
- Экран "Редактирования профиля" (est: 2 h; fact: x h). 
- UITableView с ячейками "Мои NFT", "Избранные NFT", "Сайт пользователя" (est: 1.5 h; fact: x h)

#### Логика
- Добавить экран профиля в navBar (est: 1 h; fact: x h).
- Отображение данных профиля (аватар, никнейм, описание, ссылка) с API (est: 4 h; fact: x h).
- Отображение кол-ва NFT на главном экране  (est: 2 h; fact: x h).
- Переход на экраны "Редактирования Профиля", "Мои NFT", "Избранное" (est: 1 h; fact: x h).
- Переход на webView после нажатия на сайт в профиле (est: 1 h; fact: x h). 
- Отправка измененных данных профиля на сервер + изменение их (h: 4 min; fact: x h).

     
`Total:` est: 15.5 h; fact: x h.


## Module 2:
#### Верстка
- Экран "Мои NFT" (est: 4 h; fact: x h).
Добавить коллекцию, сверстать UICollectionViewCell с данными NFT
- Экран "Избранные NFT" (est: 4 h; fact: x h).
Добавить коллекцию, сверстать UICollectionViewCell с данными NFT

#### Логика
- Отображение данных с сервера в UICollectionViewCell (est: 2 h; fact: x h).
- Добавление NFT в избранное по нажатию на кнопку Like (est: 2 h; fact: x h).
- Фильтрация NFT по аттрибутам (est: 1 h; fact: x h).
- Отображение заглушки если нет NFT (est: 1 h; fact: x h).
-------------------
- Отображение добавленных в избранное NFT в UICollectionView по данным с сервера (est: 2 h; fact: x h).
- Отображение заглушки если нет избранных NFT (est: 1 h; fact: x h).

`Total:` est: 17 h; fact: x h.


## Module 3:

#### Верстка
- Экран "Мои NFT": Верстка UITableView с ячейками (иконка, название, автор, цена) + кнопка сортировки (est: 2 h; fact: x h).
- Экран "Избранные NFT": Верстка UICollectionView с ячейками (иконка, сердечко, название, рейтинг, цена) (est: 2 h; fact: x h).

#### Логика
- Реализация сортировки для экрана "Мои NFT" (est: 2 h; fact: x h).
- Удаление NFT из избранного с обновлением коллекции (est: 2 h; fact: x h).

`Total:` est: 8 h; fact: x h.


