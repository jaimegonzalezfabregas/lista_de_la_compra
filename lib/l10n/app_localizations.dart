import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_bg.dart';
import 'app_localizations_bn.dart';
import 'app_localizations_cs.dart';
import 'app_localizations_da.dart';
import 'app_localizations_de.dart';
import 'app_localizations_el.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_he.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_hu.dart';
import 'app_localizations_id.dart';
import 'app_localizations_it.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_ko.dart';
import 'app_localizations_ms.dart';
import 'app_localizations_nb.dart';
import 'app_localizations_nl.dart';
import 'app_localizations_pl.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ro.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_sk.dart';
import 'app_localizations_sv.dart';
import 'app_localizations_th.dart';
import 'app_localizations_tr.dart';
import 'app_localizations_uk.dart';
import 'app_localizations_vi.dart';
import 'app_localizations_zh.dart';

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
    Locale('ar'),
    Locale('bg'),
    Locale('bn'),
    Locale('cs'),
    Locale('da'),
    Locale('de'),
    Locale('el'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('he'),
    Locale('hi'),
    Locale('hu'),
    Locale('id'),
    Locale('it'),
    Locale('ja'),
    Locale('ko'),
    Locale('ms'),
    Locale('nb'),
    Locale('nl'),
    Locale('pl'),
    Locale('pt'),
    Locale('ro'),
    Locale('ru'),
    Locale('sk'),
    Locale('sv'),
    Locale('th'),
    Locale('tr'),
    Locale('uk'),
    Locale('vi'),
    Locale('zh'),
  ];

  /// Shopping List
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get appTitle;

  /// Change Name
  ///
  /// In en, this message translates to:
  /// **'Change Name'**
  String get changeName;

  /// Change Nick
  ///
  /// In en, this message translates to:
  /// **'Change Nick'**
  String get changeNick;

  /// Name
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Nick
  ///
  /// In en, this message translates to:
  /// **'Nick'**
  String get nick;

  /// The name cant be empty
  ///
  /// In en, this message translates to:
  /// **'The name cant be empty'**
  String get theNameCantBeEmpty;

  /// Cancel
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Save
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// This list has no results
  ///
  /// In en, this message translates to:
  /// **'This list has no results'**
  String get thisListHasNoResults;

  /// Create environment
  ///
  /// In en, this message translates to:
  /// **'Create environment'**
  String get createEnvironment;

  /// Available environments without connection
  ///
  /// In en, this message translates to:
  /// **'Available environments without connection'**
  String get availableEnvironmentsWithoutConnection;

  /// Environments on other machines
  ///
  /// In en, this message translates to:
  /// **'Environments on other machines'**
  String get environmentsOnOtherMachines;

  /// Import environment
  ///
  /// In en, this message translates to:
  /// **'Import environment'**
  String get importEnvironment;

  /// Syncronization
  ///
  /// In en, this message translates to:
  /// **'Syncronization'**
  String get syncronization;

  /// Loading...
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Home
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Shopping List
  ///
  /// In en, this message translates to:
  /// **'Shopping List'**
  String get shoppingList;

  /// Recipe List
  ///
  /// In en, this message translates to:
  /// **'Recipe List'**
  String get recipeList;

  /// Agenda
  ///
  /// In en, this message translates to:
  /// **'Agenda'**
  String get agenda;

  /// Export
  ///
  /// In en, this message translates to:
  /// **'Export'**
  String get export;

  /// Undo
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get undo;

  /// Product
  ///
  /// In en, this message translates to:
  /// **'Product'**
  String get product;

  ///  marked as needed.
  ///
  /// In en, this message translates to:
  /// **' marked as needed. '**
  String get markAsNeeded;

  ///  marked as bought.
  ///
  /// In en, this message translates to:
  /// **' marked as bought. '**
  String get markAsBought;

  /// To buy
  ///
  /// In en, this message translates to:
  /// **'To buy'**
  String get toBuy;

  /// Edit name
  ///
  /// In en, this message translates to:
  /// **'Edit name'**
  String get editName;

  /// Delete
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Set as bought
  ///
  /// In en, this message translates to:
  /// **'Set as bought'**
  String get setAsBought;

  /// Set as needed
  ///
  /// In en, this message translates to:
  /// **'Set as needed'**
  String get setAsNeeded;

  /// Select recipe
  ///
  /// In en, this message translates to:
  /// **'Select recipe'**
  String get selectRecipe;

  /// Add
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No nick
  ///
  /// In en, this message translates to:
  /// **'No nick'**
  String get noNick;

  /// Pairings
  ///
  /// In en, this message translates to:
  /// **'Pairings'**
  String get pairings;

  /// Connection type
  ///
  /// In en, this message translates to:
  /// **'Connection type'**
  String get connectionType;

  /// Not stablished
  ///
  /// In en, this message translates to:
  /// **'Not stablished'**
  String get notStablished;

  /// Stablished
  ///
  /// In en, this message translates to:
  /// **'Stablished'**
  String get stablished;

  /// Conection state
  ///
  /// In en, this message translates to:
  /// **'Conection state'**
  String get connectionState;

  /// General Config
  ///
  /// In en, this message translates to:
  /// **'General Config'**
  String get generalConfig;

  /// Scan started
  ///
  /// In en, this message translates to:
  /// **'Scan started'**
  String get scanStarted;

  /// No results yet
  ///
  /// In en, this message translates to:
  /// **'No results yet'**
  String get noResultsYet;

  /// No name
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// No host
  ///
  /// In en, this message translates to:
  /// **'No host'**
  String get noHost;

  /// Error
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Save file to your desired location
  ///
  /// In en, this message translates to:
  /// **'Save file to your desired location'**
  String get saveFileToYourDesiredLocation;

  /// Export to file
  ///
  /// In en, this message translates to:
  /// **'Export to file'**
  String get exportToFile;

  /// Export and send
  ///
  /// In en, this message translates to:
  /// **'Export and send'**
  String get sendExport;

  /// The current device is available on the following IPs
  ///
  /// In en, this message translates to:
  /// **'The current device is available on the following IPs'**
  String get localDeviceAvailableIPs;

  /// Stop server
  ///
  /// In en, this message translates to:
  /// **'Stop server'**
  String get stopServer;

  /// Start server
  ///
  /// In en, this message translates to:
  /// **'Start server'**
  String get startServer;

  /// Starting server...
  ///
  /// In en, this message translates to:
  /// **'Starting server...'**
  String get startingServer;

  /// Stopping server...
  ///
  /// In en, this message translates to:
  /// **'Stopping server...'**
  String get stoppingServer;

  /// Error starting server
  ///
  /// In en, this message translates to:
  /// **'Error starting server'**
  String get errorStartingServer;

  /// Nearby devices
  ///
  /// In en, this message translates to:
  /// **'Nearby devices'**
  String get nearbyDevices;

  /// Enter address manually
  ///
  /// In en, this message translates to:
  /// **'Enter address manually'**
  String get enterAddressManually;

  /// Remote address
  ///
  /// In en, this message translates to:
  /// **'Remote address'**
  String get remoteAddress;

  /// Remote port
  ///
  /// In en, this message translates to:
  /// **'Remote port'**
  String get remotePort;

  /// Error: the remote address cannot be empty
  ///
  /// In en, this message translates to:
  /// **'Error: the remote address cannot be empty'**
  String get errorEmptyRemoteAddress;

  /// Connect
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// Server
  ///
  /// In en, this message translates to:
  /// **'Server'**
  String get server;

  /// Client
  ///
  /// In en, this message translates to:
  /// **'Client'**
  String get client;

  /// Input the amount
  ///
  /// In en, this message translates to:
  /// **'Input the amount'**
  String get inputTheAmount;

  /// No ingredients have been added yet
  ///
  /// In en, this message translates to:
  /// **'No ingredients have been added yet'**
  String get noIngredientsYet;

  /// Add ingredients
  ///
  /// In en, this message translates to:
  /// **'Add ingredients'**
  String get addIngredients;

  /// Show past dates
  ///
  /// In en, this message translates to:
  /// **'Show past dates'**
  String get showPastDates;

  /// Ingredients
  ///
  /// In en, this message translates to:
  /// **'Ingredients'**
  String get ingredients;

  /// Dates
  ///
  /// In en, this message translates to:
  /// **'Dates'**
  String get dates;

  /// Buy
  ///
  /// In en, this message translates to:
  /// **'Buy'**
  String get buy;

  /// Everything
  ///
  /// In en, this message translates to:
  /// **'Everything'**
  String get all;

  /// HTTP Client
  ///
  /// In en, this message translates to:
  /// **'HTTP Client'**
  String get httpClient;

  /// HTTP Server
  ///
  /// In en, this message translates to:
  /// **'HTTP Server'**
  String get httpServer;

  /// Select ingredients
  ///
  /// In en, this message translates to:
  /// **'Select ingredients'**
  String get selectIngredients;

  /// This recipe has no ingredients
  ///
  /// In en, this message translates to:
  /// **'This recipe has no ingredients'**
  String get recipeWithoutIngredients;

  /// No planned dates
  ///
  /// In en, this message translates to:
  /// **'No planned dates'**
  String get noPlannedDates;

  /// There are no past pairings with http servers
  ///
  /// In en, this message translates to:
  /// **'There are no past pairings with http servers'**
  String get noHTTPPairings;

  /// Loading IP addresses
  ///
  /// In en, this message translates to:
  /// **'Loading IP addresses'**
  String get loadingIps;

  /// Refresh IPs
  ///
  /// In en, this message translates to:
  /// **'Refresh IPs'**
  String get ipRefresh;

  /// Planner
  ///
  /// In en, this message translates to:
  /// **'Planner'**
  String get planner;

  /// Message shown when an IP address is copied to the clipboard
  ///
  /// In en, this message translates to:
  /// **'IP Address ({address}) copied to clipboard'**
  String ipCopied(Object address);

  /// Search
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// Switch environment
  ///
  /// In en, this message translates to:
  /// **'Switch environment'**
  String get switchEnvironment;

  /// Actions
  ///
  /// In en, this message translates to:
  /// **'Actions'**
  String get actions;

  /// Mark all as
  ///
  /// In en, this message translates to:
  /// **'Mark all as'**
  String get markAllAs;

  /// Edit amount
  ///
  /// In en, this message translates to:
  /// **'Edit amount'**
  String get editAmount;

  /// Details
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// Enough for a
  ///
  /// In en, this message translates to:
  /// **'Enough for a'**
  String get enoughForA;

  /// Known servers
  ///
  /// In en, this message translates to:
  /// **'Known servers'**
  String get knownServers;

  /// No open connections
  ///
  /// In en, this message translates to:
  /// **'No open connections'**
  String get noOpenConnection;

  /// Never connected
  ///
  /// In en, this message translates to:
  /// **'Never connected'**
  String get neverConnected;

  /// unnamed-device
  ///
  /// In en, this message translates to:
  /// **'unnamed-device'**
  String get fallbackLocalNick;

  /// Supermarket list
  ///
  /// In en, this message translates to:
  /// **'Supermarket list'**
  String get supermarketList;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'bg',
    'bn',
    'cs',
    'da',
    'de',
    'el',
    'en',
    'es',
    'fr',
    'he',
    'hi',
    'hu',
    'id',
    'it',
    'ja',
    'ko',
    'ms',
    'nb',
    'nl',
    'pl',
    'pt',
    'ro',
    'ru',
    'sk',
    'sv',
    'th',
    'tr',
    'uk',
    'vi',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'bg':
      return AppLocalizationsBg();
    case 'bn':
      return AppLocalizationsBn();
    case 'cs':
      return AppLocalizationsCs();
    case 'da':
      return AppLocalizationsDa();
    case 'de':
      return AppLocalizationsDe();
    case 'el':
      return AppLocalizationsEl();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'he':
      return AppLocalizationsHe();
    case 'hi':
      return AppLocalizationsHi();
    case 'hu':
      return AppLocalizationsHu();
    case 'id':
      return AppLocalizationsId();
    case 'it':
      return AppLocalizationsIt();
    case 'ja':
      return AppLocalizationsJa();
    case 'ko':
      return AppLocalizationsKo();
    case 'ms':
      return AppLocalizationsMs();
    case 'nb':
      return AppLocalizationsNb();
    case 'nl':
      return AppLocalizationsNl();
    case 'pl':
      return AppLocalizationsPl();
    case 'pt':
      return AppLocalizationsPt();
    case 'ro':
      return AppLocalizationsRo();
    case 'ru':
      return AppLocalizationsRu();
    case 'sk':
      return AppLocalizationsSk();
    case 'sv':
      return AppLocalizationsSv();
    case 'th':
      return AppLocalizationsTh();
    case 'tr':
      return AppLocalizationsTr();
    case 'uk':
      return AppLocalizationsUk();
    case 'vi':
      return AppLocalizationsVi();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
