// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get appTitle => 'Список покупок';

  @override
  String get changeName => 'Змінити назву';

  @override
  String get changeNick => 'Змінити прізвисько';

  @override
  String get name => 'Ім\'я';

  @override
  String get nick => 'Прізвисько';

  @override
  String get theNameCantBeEmpty => 'Ім\'я не може бути порожнім';

  @override
  String get cancel => 'Скасувати';

  @override
  String get save => 'Зберегти';

  @override
  String get thisListHasNoResults => 'Цей список не має результатів';

  @override
  String get createEnvironment => 'Створити середовище';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Доступні середовища без підключення';

  @override
  String get environmentsOnOtherMachines => 'Середовища на інших машинах';

  @override
  String get importEnvironment => 'Імпортувати середовище';

  @override
  String get syncronization => 'Синхронізація';

  @override
  String get loading => 'Завантаження...';

  @override
  String get home => 'Головна';

  @override
  String get shoppingList => 'Список покупок';

  @override
  String get recipeList => 'Список рецептів';

  @override
  String get agenda => 'Порядок денний';

  @override
  String get export => 'Експорт';

  @override
  String get undo => 'Скасувати';

  @override
  String get product => 'Продукт';

  @override
  String get markAsNeeded => ' позначено як необхідне. ';

  @override
  String get markAsBought => ' позначено як куплене. ';

  @override
  String get toBuy => 'Купити';

  @override
  String get editName => 'Редагувати назву';

  @override
  String get delete => 'Видалити';

  @override
  String get setAsBought => 'Позначити як куплене';

  @override
  String get setAsNeeded => 'Позначити як необхідне';

  @override
  String get selectRecipe => 'Вибрати рецепт';

  @override
  String get add => 'Додати';

  @override
  String get noNick => 'Немає прізвиська';

  @override
  String get pairings => 'Спарування';

  @override
  String get connectionType => 'Тип підключення';

  @override
  String get notStablished => 'Не встановлено';

  @override
  String get stablished => 'Встановлено';

  @override
  String get connectionState => 'Стан підключення';

  @override
  String get generalConfig => 'Загальні налаштування';

  @override
  String get scanStarted => 'Сканування розпочалося';

  @override
  String get noResultsYet => 'Ще немає результатів';

  @override
  String get noName => 'Немає імені';

  @override
  String get noHost => 'Немає хоста';

  @override
  String get error => 'Помилка';

  @override
  String get saveFileToYourDesiredLocation => 'Збережіть файл у бажаному місці';

  @override
  String get exportToFile => 'Експорт у файл';

  @override
  String get sendExport => 'Експорт і відправка';

  @override
  String get localDeviceAvailableIPs =>
      'Поточний пристрій доступний за наступними IP';

  @override
  String get stopServer => 'Зупинити сервер';

  @override
  String get startServer => 'Запустити сервер';

  @override
  String get startingServer => 'Запуск сервера...';

  @override
  String get stoppingServer => 'Зупинка сервера...';

  @override
  String get errorStartingServer => 'Помилка при запуску сервера';

  @override
  String get nearbyDevices => 'Пристрої поблизу';

  @override
  String get enterAddressManually => 'Введіть адресу вручну';

  @override
  String get remoteAddress => 'Віддалена адреса';

  @override
  String get remotePort => 'Віддалений порт';

  @override
  String get errorEmptyRemoteAddress =>
      'Помилка: віддалена адреса не може бути порожньою';

  @override
  String get connect => 'Підключитись';

  @override
  String get server => 'Сервер';

  @override
  String get client => 'Клієнт';

  @override
  String get inputTheAmount => 'Введіть кількість';

  @override
  String get noIngredientsYet => 'Інгредієнти ще не додані';

  @override
  String get addIngredients => 'Додати інгредієнти';

  @override
  String get showPastDates => 'Показати минулі дати';

  @override
  String get ingredients => 'Інгредієнти';

  @override
  String get dates => 'Дати';

  @override
  String get buy => 'Купити';

  @override
  String get all => 'Все';

  @override
  String get httpClient => 'HTTP клієнт';

  @override
  String get httpServer => 'HTTP сервер';

  @override
  String get selectIngredients => 'Виберіть інгредієнти';

  @override
  String get recipeWithoutIngredients => 'Цей рецепт не має інгредієнтів';

  @override
  String get noPlannedDates => 'Немає запланованих дат';

  @override
  String get noHTTPPairings => 'Немає попередніх спарувань із HTTP серверами';

  @override
  String get loadingIps => 'Завантаження IP-адрес';

  @override
  String get ipRefresh => 'Оновити IP';

  @override
  String get planner => 'Планувальник';

  @override
  String ipCopied(Object address) {
    return 'IP-адреса ($address) скопійована в буфер обміну';
  }

  @override
  String get search => 'Пошук';

  @override
  String get switchEnvironment => 'Змінити середовище';

  @override
  String get actions => 'Дії';

  @override
  String get markAllAs => 'Позначити все як';

  @override
  String get editAmount => 'Редагувати кількість';

  @override
  String get details => 'Деталі';

  @override
  String get enoughForA => 'Достатньо для';

  @override
  String get knownServers => 'Відомі сервери';

  @override
  String get noOpenConnection => 'Немає відкритих з\'єднань';

  @override
  String get neverConnected => 'Ніколи не підключався';

  @override
  String get fallbackLocalNick => 'пристрій-без-імені';

  @override
  String get supermarketList => 'Supermarket list';
}
