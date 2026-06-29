// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Lista de la compra';

  @override
  String get changeName => 'Cambiar nombre';

  @override
  String get changeNick => 'Cambiar apodo';

  @override
  String get name => 'Nombre';

  @override
  String get nick => 'Apodo';

  @override
  String get theNameCantBeEmpty => 'El nombre no puede estar vacío';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get thisListHasNoResults => 'Esta lista no tiene resultados';

  @override
  String get thisListHasNoResultsStartTypingToAddTheFirst =>
      'Esta lista no tiene resultados. Empieza a escribir para añadir el primero';

  @override
  String get map => 'Mapa';

  @override
  String get createEnvironment => 'Crear entorno';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Entornos disponibles sin conexión';

  @override
  String get environmentsOnOtherMachines => 'Entornos en otras máquinas';

  @override
  String get importEnvironment => 'Importar entorno';

  @override
  String get syncronization => 'Sincronización';

  @override
  String get loading => 'Cargando...';

  @override
  String get home => 'Inicio';

  @override
  String get shoppingList => 'Lista de la compra';

  @override
  String get recipeList => 'Lista de Recetas';

  @override
  String get agenda => 'Agenda';

  @override
  String get export => 'Exportar';

  @override
  String get undo => 'Deshacer';

  @override
  String get product => 'Producto';

  @override
  String get markAsNeeded => ' marcado como necesitado. ';

  @override
  String get markAsBought => ' marcado como comprado. ';

  @override
  String get toBuy => 'Para comprar';

  @override
  String get editName => 'Editar nombre';

  @override
  String get delete => 'Eliminar';

  @override
  String get setAsBought => 'Marcar como comprado';

  @override
  String get setAsNeeded => 'Marcar como necesitado';

  @override
  String get selectRecipe => 'Seleccionar receta';

  @override
  String get add => 'Añadir';

  @override
  String get noNick => 'Sin apodo';

  @override
  String get pairings => 'Emparejamientos';

  @override
  String get connectionType => 'Tipo de conexión';

  @override
  String get notStablished => 'no Establecido';

  @override
  String get stablished => 'Establecido';

  @override
  String get connectionState => 'Estado de conexión';

  @override
  String get generalConfig => 'Configuración general';

  @override
  String get scanStarted => 'Escaneo iniciado';

  @override
  String get noResultsYet => 'No hay resultados aún';

  @override
  String get noName => 'Sin nombre';

  @override
  String get noHost => 'Sin host';

  @override
  String get error => 'Error';

  @override
  String get saveFileToYourDesiredLocation =>
      'Guardar archivo en la ubicación deseada';

  @override
  String get exportToFile => 'Exportar a archivo';

  @override
  String get sendExport => 'Exportar y enviar';

  @override
  String get localDeviceAvailableIPs =>
      'A continuación se listan las IPs en las que está disponible el dispositivo local';

  @override
  String get stopServer => 'Detener servidor';

  @override
  String get startServer => 'Iniciar servidor';

  @override
  String get startingServer => 'Iniciando servidor...';

  @override
  String get stoppingServer => 'Deteniendo servidor...';

  @override
  String get errorStartingServer => 'Error iniciando servidor';

  @override
  String get nearbyDevices => 'Dispositivos cercanos';

  @override
  String get enterAddressManually => 'Introducir dirección manualmente';

  @override
  String get remoteAddress => 'Dirección remota';

  @override
  String get remotePort => 'Puerto remoto';

  @override
  String get errorEmptyRemoteAddress =>
      'Error: la dirección remota no puede estar vacía';

  @override
  String get connect => 'Conectar';

  @override
  String get server => 'Servidor';

  @override
  String get client => 'Cliente';

  @override
  String get inputTheAmount => 'Introducir la cantidad';

  @override
  String get noIngredientsYet => 'No se han añadido ingredientes aún';

  @override
  String get addIngredients => 'Añadir ingredientes';

  @override
  String get showPastDates => 'Mostrar fechas pasadas';

  @override
  String get ingredients => 'Ingredientes';

  @override
  String get dates => 'Fechas';

  @override
  String get buy => 'Comprar';

  @override
  String get all => 'Todo';

  @override
  String get httpClient => 'Cliente HTTP';

  @override
  String get httpServer => 'Servidor HTTP';

  @override
  String get addIngredientsToRecipe => 'Agregar ingredientes a la receta ';

  @override
  String get recipeWithoutIngredients => 'Esta receta no tiene ingredientes';

  @override
  String get noPlannedDates => 'No hay fechas planificadas';

  @override
  String get noHTTPPairings =>
      'No hay emparejamientos anteriores con servidores http';

  @override
  String get loadingIps => 'Cargando direcciones IP';

  @override
  String get ipRefresh => 'Actualizar IPs';

  @override
  String get planner => 'Planificador';

  @override
  String ipCopied(Object address) {
    return 'Dirección IP ($address) copiada al portapapeles';
  }

  @override
  String get search => 'Buscar';

  @override
  String get switchEnvironment => 'Cambiar entorno';

  @override
  String get actions => 'Aciones';

  @override
  String get markAllAs => 'Marcar todo como';

  @override
  String get editAmount => 'Cambiar cantidad';

  @override
  String get details => 'Detalles';

  @override
  String get enoughForA => 'Como para un(a)';

  @override
  String get knownServers => 'Servidores conocidos';

  @override
  String get noOpenConnection => 'Sin conexiones establecidas';

  @override
  String get neverConnected => 'Nunca conectado';

  @override
  String get fallbackLocalNick => 'dispositivo-sin-nombre';

  @override
  String get supermarketList => 'Lista de supermercados';

  @override
  String get renameMe => 'Renombrar';

  @override
  String get houses => 'Casas';

  @override
  String get createHouse => 'Crear casa';

  @override
  String get deleteHouse => 'Eliminar casa';

  @override
  String get selectHouses => 'Seleccionar casas';

  @override
  String get selectHousesPrompt =>
      'Para mostrar la lista de artículos necesarios, primero selecciona un conjunto de casas';

  @override
  String get aisles => 'Pasillos';

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
  String get addProductsToAisle => 'Añadir productos al pasillo';

  @override
  String get selectSupermarket => 'Select Supermarket...';

  @override
  String get exportToICS => 'Exportar a ICS';

  @override
  String get exportToGoogleCalendar => 'Exportar a Google Calendar';

  @override
  String get exportToMarkdownFile => 'Exportar a archivo Markdown';

  @override
  String get noMappingDataAviable => 'No hay datos de mapas disponibles';

  @override
  String get noMapsHaveBeenCreatedForThisSupermarket =>
      'No se han creado mapas para este supermercado';

  @override
  String get createMap => 'Crear mapa';

  @override
  String get editMap => 'Editar mapa';

  @override
  String get newFloor => 'Nueva planta';

  @override
  String floorN(int n) {
    return 'Floor $n';
  }

  @override
  String get assignAisle => 'Asignar pasillo';

  @override
  String get unassignAisle => 'Desasignar pasillo';

  @override
  String get tileTypeFloor => 'Suelo';

  @override
  String get tileTypeStart => 'Inicio';

  @override
  String get tileTypeEnd => 'Fin';

  @override
  String get noAislesToAssign => 'No hay pasillos disponibles para asignar';

  @override
  String get deleteFloor => 'Delete Floor';

  @override
  String tileLockedLastOfType(String tileType) {
    return 'This tile is locked: it is the last $tileType tile.';
  }

  @override
  String get routeNoAisles =>
      'No hay pasillos que visitar dados los productos necesarios. No se puede calcular una ruta';

  @override
  String get pendingAislesToVisit => 'Pasillos pendientes de visitar';

  @override
  String get calculateRoute => 'Calcular ruta';

  @override
  String routeProgress(Object percent) {
    return 'Progress: $percent%';
  }

  @override
  String get cancelRouteCalculation => 'Cancelar cálculo de ruta';

  @override
  String get clearRoute => 'Limpiar ruta';

  @override
  String get selectASupermarket => 'Seleccionar un supermercado';

  @override
  String routeError(Object error) {
    return 'Route error: $error';
  }

  @override
  String get optimizeRoute => 'Optimizar ruta';

  @override
  String get uncategorized => 'Sin categoría';

  @override
  String get tapTileOrGhostTile =>
      'Toca un mosaico para seleccionarlo, o toca un mosaico fantasma para añadir uno';

  @override
  String get tileTypeTransformInfo =>
      'Para transformar este mosaico en un tipo diferente, primero selecciona el nuevo mosaico de inicio o fin';

  @override
  String get noHouseSelected => 'Ninguna casa seleccionada';
}
