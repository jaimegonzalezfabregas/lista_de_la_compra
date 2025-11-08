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
  String get selectIngredients => 'Seleccionar ingredientes';

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
}
