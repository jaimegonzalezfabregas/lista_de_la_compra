// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Shopping List';

  @override
  String get changeName => 'Change Name';

  @override
  String get changeNick => 'Change Nick';

  @override
  String get name => 'Name';

  @override
  String get nick => 'Nick';

  @override
  String get theNameCantBeEmpty => 'The name cant be empty';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get thisListHasNoResults => 'This list has no results';

  @override
  String get createEnvironment => 'Create environment';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Available environments without connection';

  @override
  String get environmentsOnOtherMachines => 'Environments on other machines';

  @override
  String get importEnvironment => 'Import environment';

  @override
  String get syncronization => 'Syncronization';

  @override
  String get loading => 'Loading...';

  @override
  String get home => 'Home';

  @override
  String get shoppingList => 'Shopping List';

  @override
  String get recipeList => 'Recipe List';

  @override
  String get agenda => 'Agenda';

  @override
  String get export => 'Export';

  @override
  String get undo => 'Undo';

  @override
  String get product => 'Product';

  @override
  String get markAsNeeded => ' marked as needed. ';

  @override
  String get markAsBought => ' marked as bought. ';

  @override
  String get toBuy => 'To buy';

  @override
  String get editName => 'Edit name';

  @override
  String get delete => 'Delete';

  @override
  String get setAsBought => 'Set as bought';

  @override
  String get setAsNeeded => 'Set as needed';

  @override
  String get selectRecipe => 'Select recipe';

  @override
  String get add => 'Add';

  @override
  String get noNick => 'No nick';

  @override
  String get pairings => 'Pairings';

  @override
  String get connectionType => 'Connection type';

  @override
  String get notStablished => 'Not stablished';

  @override
  String get stablished => 'Stablished';

  @override
  String get connectionState => 'Conection state';

  @override
  String get generalConfig => 'General Config';

  @override
  String get scanStarted => 'Scan started';

  @override
  String get noResultsYet => 'No results yet';

  @override
  String get noName => 'No name';

  @override
  String get noHost => 'No host';

  @override
  String get error => 'Error';

  @override
  String get saveFileToYourDesiredLocation =>
      'Save file to your desired location';

  @override
  String get exportToFile => 'Export to file';

  @override
  String get sendExport => 'Export and send';

  @override
  String get localDeviceAvailableIPs =>
      'The current device is available on the following IPs';

  @override
  String get stopServer => 'Stop server';

  @override
  String get startServer => 'Start server';

  @override
  String get startingServer => 'Starting server...';

  @override
  String get stoppingServer => 'Stopping server...';

  @override
  String get errorStartingServer => 'Error starting server';

  @override
  String get nearbyDevices => 'Nearby devices';

  @override
  String get enterAddressManually => 'Enter address manually';

  @override
  String get remoteAddress => 'Remote address';

  @override
  String get remotePort => 'Remote port';

  @override
  String get errorEmptyRemoteAddress =>
      'Error: the remote address cannot be empty';

  @override
  String get connect => 'Connect';

  @override
  String get server => 'Server';

  @override
  String get client => 'Client';

  @override
  String get inputTheAmount => 'Input the amount';

  @override
  String get noIngredientsYet => 'No ingredients have been added yet';

  @override
  String get addIngredients => 'Add ingredients';

  @override
  String get showPastDates => 'Show past dates';

  @override
  String get ingredients => 'Ingredients';

  @override
  String get dates => 'Dates';

  @override
  String get buy => 'Buy';

  @override
  String get all => 'Everything';

  @override
  String get httpClient => 'HTTP Client';

  @override
  String get httpServer => 'HTTP Server';

  @override
  String addIngredientsToRecipe(Object recipe) {
    return 'Add ingredients to recipe ($recipe)';
  }

  @override
  String get recipeWithoutIngredients => 'This recipe has no ingredients';

  @override
  String get noPlannedDates => 'No planned dates';

  @override
  String get noHTTPPairings => 'There are no past pairings with http servers';

  @override
  String get loadingIps => 'Loading IP addresses';

  @override
  String get ipRefresh => 'Refresh IPs';

  @override
  String get planner => 'Planner';

  @override
  String ipCopied(Object address) {
    return 'IP Address ($address) copied to clipboard';
  }

  @override
  String get search => 'Search';

  @override
  String get switchEnvironment => 'Switch environment';

  @override
  String get actions => 'Actions';

  @override
  String get markAllAs => 'Mark all as';

  @override
  String get editAmount => 'Edit amount';

  @override
  String get details => 'Details';

  @override
  String get enoughForA => 'Enough for a';

  @override
  String get knownServers => 'Known servers';

  @override
  String get noOpenConnection => 'No open connections';

  @override
  String get neverConnected => 'Never connected';

  @override
  String get fallbackLocalNick => 'unnamed-device';

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
  String addProductsToAisle(Object aisle, Object supermarket) {
    return 'Add products to aisle ($aisle — $supermarket)';
  }

  @override
  String get selectSupermarket => 'Select Supermarket...';
}
