// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Bulgarian (`bg`).
class AppLocalizationsBg extends AppLocalizations {
  AppLocalizationsBg([String locale = 'bg']) : super(locale);

  @override
  String get appTitle => 'Списък за пазаруване';

  @override
  String get changeName => 'Промени име';

  @override
  String get changeNick => 'Промени прякор';

  @override
  String get name => 'Име';

  @override
  String get nick => 'Прякор';

  @override
  String get theNameCantBeEmpty => 'Името не може да бъде празно';

  @override
  String get cancel => 'Отказ';

  @override
  String get save => 'Запази';

  @override
  String get thisListHasNoResults => 'Този списък няма резултати';

  @override
  String get createEnvironment => 'Създай среда';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Налични среди без връзка';

  @override
  String get environmentsOnOtherMachines => 'Среда на други машини';

  @override
  String get importEnvironment => 'Импортирай среда';

  @override
  String get syncronization => 'Синхронизиране';

  @override
  String get loading => 'Зареждане...';

  @override
  String get home => 'Начало';

  @override
  String get shoppingList => 'Списък за пазаруване';

  @override
  String get recipeList => 'Списък с рецепти';

  @override
  String get agenda => 'Дневен ред';

  @override
  String get export => 'Експорт';

  @override
  String get undo => 'Отмени';

  @override
  String get product => 'Продукт';

  @override
  String get markAsNeeded => ' отбелязано като необходимо. ';

  @override
  String get markAsBought => ' отбелязано като закупено. ';

  @override
  String get toBuy => 'За купуване';

  @override
  String get editName => 'Редактирай име';

  @override
  String get delete => 'Изтрий';

  @override
  String get setAsBought => 'Постави като закупено';

  @override
  String get setAsNeeded => 'Постави като необходимо';

  @override
  String get selectRecipe => 'Избери рецепта';

  @override
  String get add => 'Добави';

  @override
  String get noNick => 'Няма прякор';

  @override
  String get pairings => 'Сдвоявания';

  @override
  String get connectionType => 'Тип връзка';

  @override
  String get notStablished => 'Не е установено';

  @override
  String get stablished => 'Установено';

  @override
  String get connectionState => 'Състояние на връзката';

  @override
  String get generalConfig => 'Общи настройки';

  @override
  String get scanStarted => 'Сканиране започна';

  @override
  String get noResultsYet => 'Все още няма резултати';

  @override
  String get noName => 'Няма име';

  @override
  String get noHost => 'Няма хост';

  @override
  String get error => 'Грешка';

  @override
  String get saveFileToYourDesiredLocation =>
      'Запазете файла на желаното място';

  @override
  String get exportToFile => 'Експортирай в файл';

  @override
  String get sendExport => 'Експортирай и изпрати';

  @override
  String get localDeviceAvailableIPs =>
      'Текущото устройство е налично на следните IP адреси';

  @override
  String get stopServer => 'Спри сървъра';

  @override
  String get startServer => 'Стартирай сървъра';

  @override
  String get startingServer => 'Стартиране на сървъра...';

  @override
  String get stoppingServer => 'Спряне на сървъра...';

  @override
  String get errorStartingServer => 'Грешка при стартиране на сървъра';

  @override
  String get nearbyDevices => 'Близки устройства';

  @override
  String get enterAddressManually => 'Въведете адрес ръчно';

  @override
  String get remoteAddress => 'Отдалечен адрес';

  @override
  String get remotePort => 'Отдалечен порт';

  @override
  String get errorEmptyRemoteAddress =>
      'Грешка: отдалеченият адрес не може да е празен';

  @override
  String get connect => 'Свържи';

  @override
  String get server => 'Сървър';

  @override
  String get client => 'Клиент';

  @override
  String get inputTheAmount => 'Въведете количеството';

  @override
  String get noIngredientsYet => 'Все още не са добавени съставки';

  @override
  String get addIngredients => 'Добави съставки';

  @override
  String get showPastDates => 'Покажи минали дати';

  @override
  String get ingredients => 'Съставки';

  @override
  String get dates => 'Дати';

  @override
  String get buy => 'Купи';

  @override
  String get all => 'Всичко';

  @override
  String get httpClient => 'HTTP клиент';

  @override
  String get httpServer => 'HTTP сървър';

  @override
  String get addIngredientsToRecipe => 'Изберете съставки ';

  @override
  String get recipeWithoutIngredients => 'Тази рецепта няма съставки';

  @override
  String get noPlannedDates => 'Няма планирани дати';

  @override
  String get noHTTPPairings => 'Няма предишни сдвоявания с HTTP сървъри';

  @override
  String get loadingIps => 'Зареждане на IP адреси';

  @override
  String get ipRefresh => 'Освежи IP';

  @override
  String get planner => 'Планиращ';

  @override
  String ipCopied(Object address) {
    return 'IP адресът ($address) е копиран в клипборда';
  }

  @override
  String get search => 'Търсене';

  @override
  String get switchEnvironment => 'Смяна на среда';

  @override
  String get actions => 'Действия';

  @override
  String get markAllAs => 'Маркирай всички като';

  @override
  String get editAmount => 'Редактирай количество';

  @override
  String get details => 'Детайли';

  @override
  String get enoughForA => 'Достатъчно за';

  @override
  String get knownServers => 'Известни сървъри';

  @override
  String get noOpenConnection => 'Няма отворени връзки';

  @override
  String get neverConnected => 'Никога не е бил свързан';

  @override
  String get fallbackLocalNick => 'неименувано-устройство';

  @override
  String get supermarketList => 'Supermarket list';

  @override
  String get aisles => 'Aisles';

  @override
  String numberOfProducts(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count products',
      one: '1 product',
      zero: 'No products',
    );
    return '$_temp0';
  }

  @override
  String numberOfAisles(num count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count aisles',
      one: '1 aisle',
      zero: 'No aisles',
    );
    return '$_temp0';
  }

  @override
  String get addProductsToAisle => 'Добавяне на продукти към пътеката';

  @override
  String get selectSupermarket => 'Select Supermarket...';
}
