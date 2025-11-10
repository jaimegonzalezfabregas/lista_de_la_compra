// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Liste de courses';

  @override
  String get changeName => 'Modifier le nom';

  @override
  String get changeNick => 'Modifier le pseudo';

  @override
  String get name => 'Nom';

  @override
  String get nick => 'Pseudo';

  @override
  String get theNameCantBeEmpty => 'Le nom ne peut pas être vide';

  @override
  String get cancel => 'Annuler';

  @override
  String get save => 'Enregistrer';

  @override
  String get thisListHasNoResults => 'Cette liste n\'a pas de résultat';

  @override
  String get createEnvironment => 'Créer un environnement';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Environnements disponibles hors connexion';

  @override
  String get environmentsOnOtherMachines =>
      'Environnements sur d\'autres machines';

  @override
  String get importEnvironment => 'Importer un environnement';

  @override
  String get syncronization => 'Synchronisation';

  @override
  String get loading => 'Chargement...';

  @override
  String get home => 'Accueil';

  @override
  String get shoppingList => 'Liste de courses';

  @override
  String get recipeList => 'Liste de recettes';

  @override
  String get agenda => 'Agenda';

  @override
  String get export => 'Exporter';

  @override
  String get undo => 'Annuler';

  @override
  String get product => 'Produit';

  @override
  String get markAsNeeded => 'marqué comme nécessaire';

  @override
  String get markAsBought => 'marqué comme acheté';

  @override
  String get toBuy => 'À acheter';

  @override
  String get editName => 'Modifier le nom';

  @override
  String get delete => 'Supprimer';

  @override
  String get setAsBought => 'Marquer comme acheté';

  @override
  String get setAsNeeded => 'Marquer comme nécessaire';

  @override
  String get selectRecipe => 'Sélectionner une recette';

  @override
  String get add => 'Ajouter';

  @override
  String get noNick => 'Pas de pseudo';

  @override
  String get pairings => 'Appairages';

  @override
  String get connectionType => 'Type de connexion';

  @override
  String get notStablished => 'Non établie';

  @override
  String get stablished => 'Établie';

  @override
  String get connectionState => 'État de la connexion';

  @override
  String get generalConfig => 'Configuration générale';

  @override
  String get scanStarted => 'Scan commencé';

  @override
  String get noResultsYet => 'Aucun résultat pour l\'instant';

  @override
  String get noName => 'Pas de nom';

  @override
  String get noHost => 'Pas d\'hôte';

  @override
  String get error => 'Erreur';

  @override
  String get saveFileToYourDesiredLocation =>
      'Enregistrer le fichier à l\'emplacement souhaité';

  @override
  String get exportToFile => 'Exporter vers un fichier';

  @override
  String get sendExport => 'Exporter et envoyer';

  @override
  String get localDeviceAvailableIPs =>
      'L\'appareil local est disponible aux adresses IP suivantes';

  @override
  String get stopServer => 'Arrêter le serveur';

  @override
  String get startServer => 'Démarrer le serveur';

  @override
  String get startingServer => 'Démarrage du serveur...';

  @override
  String get stoppingServer => 'Arrêt du serveur...';

  @override
  String get errorStartingServer => 'Erreur lors du démarrage du serveur';

  @override
  String get nearbyDevices => 'Appareils à proximité';

  @override
  String get enterAddressManually => 'Saisir l\'adresse manuellement';

  @override
  String get remoteAddress => 'Adresse distante';

  @override
  String get remotePort => 'Port distant';

  @override
  String get errorEmptyRemoteAddress =>
      'Erreur : l\'adresse distante ne peut pas être vide';

  @override
  String get connect => 'Se connecter';

  @override
  String get server => 'Serveur';

  @override
  String get client => 'Client';

  @override
  String get inputTheAmount => 'Saisir la quantité';

  @override
  String get noIngredientsYet => 'Aucun ingrédient ajouté pour l\'instant';

  @override
  String get addIngredients => 'Ajouter des ingrédients';

  @override
  String get showPastDates => 'Afficher les dates passées';

  @override
  String get ingredients => 'Ingrédients';

  @override
  String get dates => 'Dates';

  @override
  String get buy => 'Acheter';

  @override
  String get all => 'Tout';

  @override
  String get httpClient => 'Client HTTP';

  @override
  String get httpServer => 'Serveur HTTP';

  @override
  String get selectIngredients => 'Ajouter des ingrédients à la recette';

  @override
  String get recipeWithoutIngredients =>
      'Cette recette n\'a pas d\'ingrédients';

  @override
  String get noPlannedDates => 'Aucune date planifiée';

  @override
  String get noHTTPPairings =>
      'Aucun appairage précédent avec des serveurs HTTP';

  @override
  String get loadingIps => 'Chargement des adresses IP';

  @override
  String get ipRefresh => 'Rafraîchir les IPs';

  @override
  String get planner => 'Planificateur';

  @override
  String ipCopied(Object address) {
    return 'Adresse IP ($address) copiée dans le presse-papiers';
  }

  @override
  String get search => 'Rechercher';

  @override
  String get switchEnvironment => 'Changer d\'environnement';

  @override
  String get actions => 'Actions';

  @override
  String get markAllAs => 'Tout marquer comme';

  @override
  String get editAmount => 'Modifier la quantité';

  @override
  String get details => 'Détails';

  @override
  String get enoughForA => 'Suffisant pour un(e)';

  @override
  String get knownServers => 'Serveurs connus';

  @override
  String get noOpenConnection => 'Aucune connexion ouverte';

  @override
  String get neverConnected => 'Jamais connecté';

  @override
  String get fallbackLocalNick => 'appareil-sans-nom';

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
  String get addProductsToAisle => 'Ajouter des produits à l\'allée';
}
