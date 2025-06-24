import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get appTitle;

  /// No description provided for @changeName.
  ///
  /// In en, this message translates to:
  /// **'Change Name'**
  String get changeName;

  /// No description provided for @changeNick.
  ///
  /// In en, this message translates to:
  /// **'Change Nick'**
  String get changeNick;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @nick.
  ///
  /// In en, this message translates to:
  /// **'Nick'**
  String get nick;

  /// No description provided for @theNameCantBeEmpty.
  ///
  /// In en, this message translates to:
  /// **'The name cant be empty'**
  String get theNameCantBeEmpty;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @thisListHasNoResults.
  ///
  /// In en, this message translates to:
  /// **'This list has no results'**
  String get thisListHasNoResults;

  /// No description provided for @createEnviroment.
  ///
  /// In en, this message translates to:
  /// **'Create enviroment'**
  String get createEnviroment;

  /// No description provided for @aviableEnviromentsWithoutConnection.
  ///
  /// In en, this message translates to:
  /// **'Aviable enviroments without connection'**
  String get aviableEnviromentsWithoutConnection;

  /// No description provided for @enviromentsOnOtherMachines.
  ///
  /// In en, this message translates to:
  /// **'Enviroments on other machines'**
  String get enviromentsOnOtherMachines;

  /// No description provided for @importEnviroment.
  ///
  /// In en, this message translates to:
  /// **'Import enviroment'**
  String get importEnviroment;

  /// No description provided for @syncronization.
  ///
  /// In en, this message translates to:
  /// **'Syncronization'**
  String get syncronization;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @shoppingList.
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shoppingList;

  /// No description provided for @recipeList.
  ///
  /// In en, this message translates to:
  /// **'Recipe List'**
  String get recipeList;

  /// No description provided for @agenda.
  ///
  /// In en, this message translates to:
  /// **'Agenda'**
  String get agenda;

  /// No description provided for @export.
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// No description provided for @undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// No description provided for @product.
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  /// No description provided for @markAsNeeded.
  ///
  /// In en, this message translates to:
  /// **' marked as needed. '**
  String get markAsNeeded;

  /// No description provided for @markAsBought.
  ///
  /// In en, this message translates to:
  /// **' marked as bought. '**
  String get markAsBought;

  /// No description provided for @toBuy.
  ///
  /// In en, this message translates to:
  /// **'To buy'**
  String get toBuy;

  /// No description provided for @editName.
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get editName;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @setAsBought.
  ///
  /// In en, this message translates to:
  /// **'Set as bought'**
  String get setAsBought;

  /// No description provided for @setAsNeeded.
  ///
  /// In en, this message translates to:
  /// **'Set as needed'**
  String get setAsNeeded;

  /// No description provided for @selectRecipe.
  ///
  /// In en, this message translates to:
  /// **'Select recipe'**
  String get selectRecipe;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Añadir'**
  String get add;

  /// No description provided for @noNick.
  ///
  /// In en, this message translates to:
  /// **'No nick'**
  String get noNick;

  /// No description provided for @pastPairings.
  ///
  /// In en, this message translates to:
  /// **'Past pairings'**
  String get pastPairings;

  /// No description provided for @connectionType.
  ///
  /// In en, this message translates to:
  /// **'Connection type'**
  String get connectionType;

  /// No description provided for @notStablished.
  ///
  /// In en, this message translates to:
  /// **'not Stablished'**
  String get notStablished;

  /// No description provided for @stablished.
  ///
  /// In en, this message translates to:
  /// **'Stablished'**
  String get stablished;

  /// No description provided for @connectionState.
  ///
  /// In en, this message translates to:
  /// **'Conection state'**
  String get connectionState;

  /// No description provided for @generalConfig.
  ///
  /// In en, this message translates to:
  /// **'General Config'**
  String get generalConfig;

  /// No description provided for @scanStarted.
  ///
  /// In en, this message translates to:
  /// **'Scan started'**
  String get scanStarted;

  /// No description provided for @noResultsYet.
  ///
  /// In en, this message translates to:
  /// **'No results yet'**
  String get noResultsYet;

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// No description provided for @noHost.
  ///
  /// In en, this message translates to:
  /// **'No host'**
  String get noHost;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @saveFileToYourDesiredLocation.
  ///
  /// In en, this message translates to:
  /// **'Save file to your desired location'**
  String get saveFileToYourDesiredLocation;

  /// No description provided for @exportToFile.
  ///
  /// In en, this message translates to:
  /// **'Export to file'**
  String get exportToFile;

  /// No description provided for @sendExport.
  ///
  /// In en, this message translates to:
  /// **'Export and send'**
  String get sendExport;

  /// No description provided for @localDeviceAvailableIPs.
  ///
  /// In en, this message translates to:
  /// **'The current device is aviable on the following IPs'**
  String get localDeviceAvailableIPs;

  /// No description provided for @stopServer.
  ///
  /// In en, this message translates to:
  /// **'Stop server'**
  String get stopServer;

  /// No description provided for @startServer.
  ///
  /// In en, this message translates to:
  /// **'Start server'**
  String get startServer;

  /// No description provided for @startingServer.
  ///
  /// In en, this message translates to:
  /// **'Starting server...'**
  String get startingServer;

  /// No description provided for @stoppingServer.
  ///
  /// In en, this message translates to:
  /// **'Stopping server...'**
  String get stoppingServer;

  /// No description provided for @errorStartingServer.
  ///
  /// In en, this message translates to:
  /// **'Error starting server'**
  String get errorStartingServer;

  /// No description provided for @nearbyDevices.
  ///
  /// In en, this message translates to:
  /// **'Nearby devices'**
  String get nearbyDevices;

  /// No description provided for @enterAddressManually.
  ///
  /// In en, this message translates to:
  /// **'Enter address manually'**
  String get enterAddressManually;

  /// No description provided for @remoteAddress.
  ///
  /// In en, this message translates to:
  /// **'Remote address'**
  String get remoteAddress;

  /// No description provided for @remotePort.
  ///
  /// In en, this message translates to:
  /// **'Remote port'**
  String get remotePort;

  /// No description provided for @errorEmptyRemoteAddress.
  ///
  /// In en, this message translates to:
  /// **'Error: the remote address cannot be empty'**
  String get errorEmptyRemoteAddress;

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @server.
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// No description provided for @client.
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// No description provided for @inputTheAmount.
  ///
  /// In en, this message translates to:
  /// **'Input the amount'**
  String get inputTheAmount;

  /// No description provided for @noIngredientsYet.
  ///
  /// In en, this message translates to:
  /// **'No ingredients have been added yet'**
  String get noIngredientsYet;

  /// No description provided for @addIngredients.
  ///
  /// In en, this message translates to:
  /// **'Add ingredients'**
  String get addIngredients;

  /// No description provided for @showPastDates.
  ///
  /// In en, this message translates to:
  /// **'Show past dates'**
  String get showPastDates;

  /// No description provided for @ingredients.
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// No description provided for @dates.
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates;

  /// No description provided for @buy.
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// No description provided for @all.
  ///
  /// In en, this message translates to:
  /// **'Everything'**
  String get all;

  /// No description provided for @httpClient.
  ///
  /// In en, this message translates to:
  /// **'HTTP Client'**
  String get httpClient;

  /// No description provided for @httpServer.
  ///
  /// In en, this message translates to:
  /// **'HTTP Server'**
  String get httpServer;

  /// No description provided for @selectIngredients.
  ///
  /// In en, this message translates to:
  /// **'Select ingredients'**
  String get selectIngredients;

  /// No description provided for @recipeWithoutIngredients.
  ///
  /// In en, this message translates to:
  /// **'This recipe has no ingredients'**
  String get recipeWithoutIngredients;

  /// No description provided for @noPlannedDates.
  ///
  /// In en, this message translates to:
  /// **'No planned dates'**
  String get noPlannedDates;

  /// No description provided for @noHTTPPairings.
  ///
  /// In en, this message translates to:
  /// **'There are no past pairings with http servers'**
  String get noHTTPPairings;

  /// No description provided for @loadingIps.
  ///
  /// In en, this message translates to:
  /// **'Loading IP addresses'**
  String get loadingIps;

  /// No description provided for @ipRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh IPs'**
  String get ipRefresh;

  /// No description provided for @planner.
  ///
  /// In en, this message translates to:
  /// **'Planner'**
  String get planner;

  /// No description provided for @ipCopied.
  ///
  /// In en, this message translates to:
  /// **'IP Address ({address}) copied to clipboard'**
  String ipCopied(Object address);

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @switchEnviroment.
  ///
  /// In en, this message translates to:
  /// **'Switch enviroment'**
  String get switchEnviroment;

  /// No description provided for @actions.
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// No description provided for @editAmount.
  ///
  /// In en, this message translates to:
  /// **'Edit amount'**
  String get editAmount;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @enoughForA.
  ///
  /// In en, this message translates to:
  /// **'Enough for a'**
  String get enoughForA;

  /// No description provided for @knownServers.
  ///
  /// In en, this message translates to:
  /// **'Known servers'**
  String get knownServers;

  /// No description provided for @noOpenConnection.
  ///
  /// In en, this message translates to:
  /// **'No open connections'**
  String get noOpenConnection;

  /// No description provided for @neverConnected.
  ///
  /// In en, this message translates to:
  /// **'Never connected'**
  String get neverConnected;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
