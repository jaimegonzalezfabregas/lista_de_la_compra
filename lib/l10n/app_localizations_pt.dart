// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get appTitle => 'Lista de compras';

  @override
  String get changeName => 'Alterar nome';

  @override
  String get changeNick => 'Alterar apelido';

  @override
  String get name => 'Nome';

  @override
  String get nick => 'Apelido';

  @override
  String get theNameCantBeEmpty => 'O nome não pode ficar vazio';

  @override
  String get cancel => 'Cancelar';

  @override
  String get save => 'Guardar';

  @override
  String get thisListHasNoResults => 'Esta lista não tem resultados';

  @override
  String get createEnvironment => 'Criar ambiente';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Ambientes disponíveis sem ligação';

  @override
  String get environmentsOnOtherMachines => 'Ambientes noutros dispositivos';

  @override
  String get importEnvironment => 'Importar ambiente';

  @override
  String get syncronization => 'Sincronização';

  @override
  String get loading => 'Carregando...';

  @override
  String get home => 'Início';

  @override
  String get shoppingList => 'Lista de compras';

  @override
  String get recipeList => 'Lista de receitas';

  @override
  String get agenda => 'Agenda';

  @override
  String get export => 'Exportar';

  @override
  String get undo => 'Desfazer';

  @override
  String get product => 'Produto';

  @override
  String get markAsNeeded => ' marcado como necessário. ';

  @override
  String get markAsBought => ' marcado como comprado. ';

  @override
  String get toBuy => 'Para comprar';

  @override
  String get editName => 'Editar nome';

  @override
  String get delete => 'Eliminar';

  @override
  String get setAsBought => 'Marcar como comprado';

  @override
  String get setAsNeeded => 'Marcar como necessário';

  @override
  String get selectRecipe => 'Selecionar receita';

  @override
  String get add => 'Adicionar';

  @override
  String get noNick => 'Sem apelido';

  @override
  String get pairings => 'Emparelhamentos';

  @override
  String get connectionType => 'Tipo de ligação';

  @override
  String get notStablished => 'Não estabelecido';

  @override
  String get stablished => 'Estabelecido';

  @override
  String get connectionState => 'Estado da ligação';

  @override
  String get generalConfig => 'Configuração geral';

  @override
  String get scanStarted => 'Digitalização iniciada';

  @override
  String get noResultsYet => 'Ainda sem resultados';

  @override
  String get noName => 'Sem nome';

  @override
  String get noHost => 'Sem host';

  @override
  String get error => 'Erro';

  @override
  String get saveFileToYourDesiredLocation =>
      'Guarde o ficheiro no local desejado';

  @override
  String get exportToFile => 'Exportar para ficheiro';

  @override
  String get sendExport => 'Exportar e enviar';

  @override
  String get localDeviceAvailableIPs =>
      'O dispositivo atual está disponível nos seguintes IPs';

  @override
  String get stopServer => 'Parar servidor';

  @override
  String get startServer => 'Iniciar servidor';

  @override
  String get startingServer => 'Iniciando servidor...';

  @override
  String get stoppingServer => 'A encerrar servidor...';

  @override
  String get errorStartingServer => 'Erro ao iniciar o servidor';

  @override
  String get nearbyDevices => 'Dispositivos próximos';

  @override
  String get enterAddressManually => 'Introduza o endereço manualmente';

  @override
  String get remoteAddress => 'Endereço remoto';

  @override
  String get remotePort => 'Porta remota';

  @override
  String get errorEmptyRemoteAddress =>
      'Erro: o endereço remoto não pode estar vazio';

  @override
  String get connect => 'Ligar';

  @override
  String get server => 'Servidor';

  @override
  String get client => 'Cliente';

  @override
  String get inputTheAmount => 'Introduza a quantidade';

  @override
  String get noIngredientsYet => 'Ainda não foram adicionados ingredientes';

  @override
  String get addIngredients => 'Adicionar ingredientes';

  @override
  String get showPastDates => 'Mostrar datas passadas';

  @override
  String get ingredients => 'Ingredientes';

  @override
  String get dates => 'Datas';

  @override
  String get buy => 'Comprar';

  @override
  String get all => 'Tudo';

  @override
  String get httpClient => 'Cliente HTTP';

  @override
  String get httpServer => 'Servidor HTTP';

  @override
  String addIngredientsToRecipe(Object recipe) {
    return 'Selecionar ingredientes ($recipe)';
  }

  @override
  String get recipeWithoutIngredients => 'Esta receita não tem ingredientes';

  @override
  String get noPlannedDates => 'Sem datas planeadas';

  @override
  String get noHTTPPairings =>
      'Não há emparelhamentos anteriores com servidores HTTP';

  @override
  String get loadingIps => 'A carregar endereços IP';

  @override
  String get ipRefresh => 'Atualizar IPs';

  @override
  String get planner => 'Planeador';

  @override
  String ipCopied(Object address) {
    return 'Endereço IP ($address) copiado para a área de transferência';
  }

  @override
  String get search => 'Pesquisar';

  @override
  String get switchEnvironment => 'Mudar ambiente';

  @override
  String get actions => 'Ações';

  @override
  String get markAllAs => 'Marcar tudo como';

  @override
  String get editAmount => 'Editar quantidade';

  @override
  String get details => 'Detalhes';

  @override
  String get enoughForA => 'Suficiente para um(a)';

  @override
  String get knownServers => 'Servidores conhecidos';

  @override
  String get noOpenConnection => 'Sem conexões abertas';

  @override
  String get neverConnected => 'Nunca ligado';

  @override
  String get fallbackLocalNick => 'dispositivo-sem-nome';

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
    return 'Adicionar produtos ao corredor ($aisle — $supermarket)';
  }

  @override
  String get selectSupermarket => 'Select Supermarket...';
}
