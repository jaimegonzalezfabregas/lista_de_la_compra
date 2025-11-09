// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Список покупок';

  @override
  String get changeName => 'Изменить имя';

  @override
  String get changeNick => 'Изменить псевдоним';

  @override
  String get name => 'Имя';

  @override
  String get nick => 'Псевдоним';

  @override
  String get theNameCantBeEmpty => 'Имя не может быть пустым';

  @override
  String get cancel => 'Отмена';

  @override
  String get save => 'Сохранить';

  @override
  String get thisListHasNoResults => 'В этом списке нет результатов';

  @override
  String get createEnvironment => 'Создать окружение';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Доступные окружения без подключения';

  @override
  String get environmentsOnOtherMachines => 'Окружения на других устройствах';

  @override
  String get importEnvironment => 'Импортировать окружение';

  @override
  String get syncronization => 'Синхронизация';

  @override
  String get loading => 'Загрузка...';

  @override
  String get home => 'Главная';

  @override
  String get shoppingList => 'Список покупок';

  @override
  String get recipeList => 'Список рецептов';

  @override
  String get agenda => 'Расписание';

  @override
  String get export => 'Экспорт';

  @override
  String get undo => 'Отменить';

  @override
  String get product => 'Продукт';

  @override
  String get markAsNeeded => ' отмечено как необходимое. ';

  @override
  String get markAsBought => ' отмечено как купленное. ';

  @override
  String get toBuy => 'К покупке';

  @override
  String get editName => 'Редактировать имя';

  @override
  String get delete => 'Удалить';

  @override
  String get setAsBought => 'Пометить как купленное';

  @override
  String get setAsNeeded => 'Пометить как необходимое';

  @override
  String get selectRecipe => 'Выбрать рецепт';

  @override
  String get add => 'Добавить';

  @override
  String get noNick => 'Нет псевдонима';

  @override
  String get pairings => 'Сопряжения';

  @override
  String get connectionType => 'Тип подключения';

  @override
  String get notStablished => 'Не установлено';

  @override
  String get stablished => 'Установлено';

  @override
  String get connectionState => 'Статус подключения';

  @override
  String get generalConfig => 'Общие настройки';

  @override
  String get scanStarted => 'Сканирование начато';

  @override
  String get noResultsYet => 'Пока нет результатов';

  @override
  String get noName => 'Нет имени';

  @override
  String get noHost => 'Нет хоста';

  @override
  String get error => 'Ошибка';

  @override
  String get saveFileToYourDesiredLocation => 'Сохранить файл в нужное место';

  @override
  String get exportToFile => 'Экспорт в файл';

  @override
  String get sendExport => 'Экспорт и отправка';

  @override
  String get localDeviceAvailableIPs =>
      'Это устройство доступно по следующим IP-адресам';

  @override
  String get stopServer => 'Остановить сервер';

  @override
  String get startServer => 'Запустить сервер';

  @override
  String get startingServer => 'Запуск сервера...';

  @override
  String get stoppingServer => 'Остановка сервера...';

  @override
  String get errorStartingServer => 'Ошибка запуска сервера';

  @override
  String get nearbyDevices => 'Близлежащие устройства';

  @override
  String get enterAddressManually => 'Ввести адрес вручную';

  @override
  String get remoteAddress => 'Удаленный адрес';

  @override
  String get remotePort => 'Удаленный порт';

  @override
  String get errorEmptyRemoteAddress =>
      'Ошибка: удаленный адрес не может быть пустым';

  @override
  String get connect => 'Подключиться';

  @override
  String get server => 'Сервер';

  @override
  String get client => 'Клиент';

  @override
  String get inputTheAmount => 'Введите количество';

  @override
  String get noIngredientsYet => 'Ингредиенты еще не добавлены';

  @override
  String get addIngredients => 'Добавить ингредиенты';

  @override
  String get showPastDates => 'Показать прошедшие даты';

  @override
  String get ingredients => 'Ингредиенты';

  @override
  String get dates => 'Даты';

  @override
  String get buy => 'Купить';

  @override
  String get all => 'Все';

  @override
  String get httpClient => 'HTTP-клиент';

  @override
  String get httpServer => 'HTTP-сервер';

  @override
  String get selectIngredients => 'Выбрать ингредиенты';

  @override
  String get recipeWithoutIngredients => 'В этом рецепте нет ингредиентов';

  @override
  String get noPlannedDates => 'Нет запланированных дат';

  @override
  String get noHTTPPairings => 'Нет предыдущих сопряжений с HTTP-серверами';

  @override
  String get loadingIps => 'Загрузка IP-адресов';

  @override
  String get ipRefresh => 'Обновить IP';

  @override
  String get planner => 'Планировщик';

  @override
  String ipCopied(Object address) {
    return 'IP-адрес ($address) скопирован в буфер';
  }

  @override
  String get search => 'Поиск';

  @override
  String get switchEnvironment => 'Сменить окружение';

  @override
  String get actions => 'Действия';

  @override
  String get markAllAs => 'Отметить все как';

  @override
  String get editAmount => 'Изменить количество';

  @override
  String get details => 'Подробности';

  @override
  String get enoughForA => 'Достаточно для';

  @override
  String get knownServers => 'Известные серверы';

  @override
  String get noOpenConnection => 'Нет открытых соединений';

  @override
  String get neverConnected => 'Никогда не подключался';

  @override
  String get fallbackLocalNick => 'устройство-без-имени';

  @override
  String get supermarketList => 'Supermarket list';
}
