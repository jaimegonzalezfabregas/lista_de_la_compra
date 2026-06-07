// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => '购物清单';

  @override
  String get changeName => '更改名称';

  @override
  String get changeNick => '更改昵称';

  @override
  String get name => '名称';

  @override
  String get nick => '昵称';

  @override
  String get theNameCantBeEmpty => '名称不能为空';

  @override
  String get cancel => '取消';

  @override
  String get save => '保存';

  @override
  String get thisListHasNoResults => '此列表无结果';

  @override
  String get thisListHasNoResultsStartTypingToAddTheFirst =>
      '此列表无结果。开始输入以添加第一个';

  @override
  String get map => '地图';

  @override
  String get createEnvironment => '创建环境';

  @override
  String get availableEnvironmentsWithoutConnection => '无连接的可用环境';

  @override
  String get environmentsOnOtherMachines => '其他设备上的环境';

  @override
  String get importEnvironment => '导入环境';

  @override
  String get syncronization => '同步';

  @override
  String get loading => '加载中...';

  @override
  String get home => '首页';

  @override
  String get shoppingList => '购物清单';

  @override
  String get recipeList => '食谱列表';

  @override
  String get agenda => '日程';

  @override
  String get export => '导出';

  @override
  String get undo => '撤销';

  @override
  String get product => '产品';

  @override
  String get markAsNeeded => ' 标记为需要。';

  @override
  String get markAsBought => ' 标记为已购买。';

  @override
  String get toBuy => '待购买';

  @override
  String get editName => '编辑名称';

  @override
  String get delete => '删除';

  @override
  String get setAsBought => '标记为已购买';

  @override
  String get setAsNeeded => '标记为需要';

  @override
  String get selectRecipe => '选择食谱';

  @override
  String get add => '添加';

  @override
  String get noNick => '无昵称';

  @override
  String get pairings => '配对';

  @override
  String get connectionType => '连接类型';

  @override
  String get notStablished => '未建立';

  @override
  String get stablished => '已建立';

  @override
  String get connectionState => '连接状态';

  @override
  String get generalConfig => '通用设置';

  @override
  String get scanStarted => '扫描已开始';

  @override
  String get noResultsYet => '暂无结果';

  @override
  String get noName => '无名称';

  @override
  String get noHost => '无主机';

  @override
  String get error => '错误';

  @override
  String get saveFileToYourDesiredLocation => '保存文件到指定位置';

  @override
  String get exportToFile => '导出到文件';

  @override
  String get sendExport => '导出并发送';

  @override
  String get localDeviceAvailableIPs => '本设备可用IP地址';

  @override
  String get stopServer => '停止服务器';

  @override
  String get startServer => '启动服务器';

  @override
  String get startingServer => '正在启动服务器...';

  @override
  String get stoppingServer => '正在停止服务器...';

  @override
  String get errorStartingServer => '启动服务器时出错';

  @override
  String get nearbyDevices => '附近设备';

  @override
  String get enterAddressManually => '手动输入地址';

  @override
  String get remoteAddress => '远程地址';

  @override
  String get remotePort => '远程端口';

  @override
  String get errorEmptyRemoteAddress => '错误：远程地址不能为空';

  @override
  String get connect => '连接';

  @override
  String get server => '服务器';

  @override
  String get client => '客户端';

  @override
  String get inputTheAmount => '输入数量';

  @override
  String get noIngredientsYet => '尚未添加食材';

  @override
  String get addIngredients => '添加食材';

  @override
  String get showPastDates => '显示过去日期';

  @override
  String get ingredients => '食材';

  @override
  String get dates => '日期';

  @override
  String get buy => '购买';

  @override
  String get all => '全部';

  @override
  String get httpClient => 'HTTP客户端';

  @override
  String get httpServer => 'HTTP服务器';

  @override
  String get addIngredientsToRecipe => '选择食材 ';

  @override
  String get recipeWithoutIngredients => '此食谱无食材';

  @override
  String get noPlannedDates => '无计划日期';

  @override
  String get noHTTPPairings => '无HTTP服务器历史配对';

  @override
  String get loadingIps => '正在加载IP地址';

  @override
  String get ipRefresh => '刷新IP';

  @override
  String get planner => '计划器';

  @override
  String ipCopied(Object address) {
    return 'IP地址（$address）已复制到剪贴板';
  }

  @override
  String get search => '搜索';

  @override
  String get switchEnvironment => '切换环境';

  @override
  String get actions => '操作';

  @override
  String get markAllAs => '全部标记为';

  @override
  String get editAmount => '编辑数量';

  @override
  String get details => '详情';

  @override
  String get enoughForA => '足够一个';

  @override
  String get knownServers => '已知服务器';

  @override
  String get noOpenConnection => '无开放连接';

  @override
  String get neverConnected => '从未连接';

  @override
  String get fallbackLocalNick => '未命名设备';

  @override
  String get supermarketList => '购物清单';

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
  String get addProductsToAisle => '将产品添加到通道';

  @override
  String get selectSupermarket => 'Select Supermarket...';

  @override
  String get exportToICS => '导出为ICS';

  @override
  String get exportToGoogleCalendar => '导出到Google日历';

  @override
  String get exportToMarkdownFile => '导出为Markdown文件';

  @override
  String get noMappingDataAviable => 'No mapping data available';

  @override
  String get noMapsHaveBeenCreatedForThisSupermarket => '尚未为该超市创建地图';

  @override
  String get createMap => '创建地图';

  @override
  String get editMap => '编辑地图';

  @override
  String get newFloor => '新楼层';

  @override
  String floorN(int n) {
    return 'Floor $n';
  }

  @override
  String get assignAisle => '分配通道';

  @override
  String get unassignAisle => '取消分配通道';

  @override
  String get tileTypeFloor => '地板';

  @override
  String get tileTypeStart => '起点';

  @override
  String get tileTypeEnd => '终点';

  @override
  String get noAislesToAssign => '没有可分配的通道';

  @override
  String get deleteFloor => 'Delete Floor';

  @override
  String tileLockedLastOfType(String tileType) {
    return 'This tile is locked: it is the last $tileType tile.';
  }

  @override
  String get routeNoAisles =>
      'There are no aisles to visit given the needed products. No route can be calculated';

  @override
  String get pendingAislesToVisit => 'Pending aisles to visit';

  @override
  String get calculateRoute => 'Calculate route';

  @override
  String routeProgress(Object percent) {
    return 'Progress: $percent%';
  }

  @override
  String get cancelRouteCalculation => 'Cancel route calculation';

  @override
  String get clearRoute => 'Clear route';

  @override
  String get selectASupermarket => 'Select a supermarket';

  @override
  String routeError(Object error) {
    return 'Route error: $error';
  }

  @override
  String get optimizeRoute => 'Optimize route';

  @override
  String get uncategorized => 'Uncategorized';

  @override
  String get tapTileOrGhostTile =>
      'Tap a tile to select it, or tap a ghost tile to add one';

  @override
  String get tileTypeTransformInfo =>
      'To transform this tile into a different type, first select the new start or end tile';
}
