// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => '買い物リスト';

  @override
  String get changeName => '名前を変更';

  @override
  String get changeNick => 'ニックネームを変更';

  @override
  String get name => '名前';

  @override
  String get nick => 'ニックネーム';

  @override
  String get theNameCantBeEmpty => '名前は空にできません';

  @override
  String get cancel => 'キャンセル';

  @override
  String get save => '保存';

  @override
  String get thisListHasNoResults => 'このリストに結果はありません';

  @override
  String get createEnvironment => '環境を作成';

  @override
  String get availableEnvironmentsWithoutConnection => '接続なしで利用可能な環境';

  @override
  String get environmentsOnOtherMachines => '他のマシン上の環境';

  @override
  String get importEnvironment => '環境をインポート';

  @override
  String get syncronization => '同期';

  @override
  String get loading => '読み込み中...';

  @override
  String get home => 'ホーム';

  @override
  String get shoppingList => '買い物リスト';

  @override
  String get recipeList => 'レシピ一覧';

  @override
  String get agenda => 'スケジュール';

  @override
  String get export => 'エクスポート';

  @override
  String get undo => '元に戻す';

  @override
  String get product => '商品';

  @override
  String get markAsNeeded => ' が必要とマークされました。';

  @override
  String get markAsBought => ' が購入済みとマークされました。';

  @override
  String get toBuy => '購入する';

  @override
  String get editName => '名前を編集';

  @override
  String get delete => '削除';

  @override
  String get setAsBought => '購入済みとしてマーク';

  @override
  String get setAsNeeded => '必要としてマーク';

  @override
  String get selectRecipe => 'レシピを選択';

  @override
  String get add => '追加';

  @override
  String get noNick => 'ニックネームなし';

  @override
  String get pairings => 'ペアリング';

  @override
  String get connectionType => '接続タイプ';

  @override
  String get notStablished => '未確立';

  @override
  String get stablished => '確立済み';

  @override
  String get connectionState => '接続状態';

  @override
  String get generalConfig => '一般設定';

  @override
  String get scanStarted => 'スキャン開始';

  @override
  String get noResultsYet => 'まだ結果がありません';

  @override
  String get noName => '名前なし';

  @override
  String get noHost => 'ホストなし';

  @override
  String get error => 'エラー';

  @override
  String get saveFileToYourDesiredLocation => 'ファイルを希望の場所に保存';

  @override
  String get exportToFile => 'ファイルにエクスポート';

  @override
  String get sendExport => 'エクスポートして送信';

  @override
  String get localDeviceAvailableIPs => 'このデバイスは次のIPで利用可能です';

  @override
  String get stopServer => 'サーバーを停止';

  @override
  String get startServer => 'サーバーを開始';

  @override
  String get startingServer => 'サーバーを起動中...';

  @override
  String get stoppingServer => 'サーバーを停止中...';

  @override
  String get errorStartingServer => 'サーバーの起動中にエラー';

  @override
  String get nearbyDevices => '近くのデバイス';

  @override
  String get enterAddressManually => 'アドレスを手動入力';

  @override
  String get remoteAddress => 'リモートアドレス';

  @override
  String get remotePort => 'リモートポート';

  @override
  String get errorEmptyRemoteAddress => 'エラー：リモートアドレスは空にできません';

  @override
  String get connect => '接続';

  @override
  String get server => 'サーバー';

  @override
  String get client => 'クライアント';

  @override
  String get inputTheAmount => '数量を入力';

  @override
  String get noIngredientsYet => '材料がまだ追加されていません';

  @override
  String get addIngredients => '材料を追加';

  @override
  String get showPastDates => '過去の日付を表示';

  @override
  String get ingredients => '材料';

  @override
  String get dates => '日付';

  @override
  String get buy => '購入';

  @override
  String get all => 'すべて';

  @override
  String get httpClient => 'HTTPクライアント';

  @override
  String get httpServer => 'HTTPサーバー';

  @override
  String get selectIngredients => '材料を選択';

  @override
  String get recipeWithoutIngredients => 'このレシピには材料がありません';

  @override
  String get noPlannedDates => '予定日なし';

  @override
  String get noHTTPPairings => 'HTTPサーバーとの過去のペアリングなし';

  @override
  String get loadingIps => 'IPアドレスを読み込み中';

  @override
  String get ipRefresh => 'IPを更新';

  @override
  String get planner => 'プランナー';

  @override
  String ipCopied(Object address) {
    return 'IPアドレス（$address）をクリップボードにコピー';
  }

  @override
  String get search => '検索';

  @override
  String get switchEnvironment => '環境を切り替え';

  @override
  String get actions => '操作';

  @override
  String get markAllAs => 'すべてをマーク';

  @override
  String get editAmount => '数量を編集';

  @override
  String get details => '詳細';

  @override
  String get enoughForA => '十分な量：';

  @override
  String get knownServers => '既知のサーバー';

  @override
  String get noOpenConnection => 'オープンな接続なし';

  @override
  String get neverConnected => '接続したことがない';

  @override
  String get fallbackLocalNick => '名前なしデバイス';
}
