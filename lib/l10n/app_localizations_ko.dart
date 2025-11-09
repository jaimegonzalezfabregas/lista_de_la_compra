// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '쇼핑 목록';

  @override
  String get changeName => '이름 변경';

  @override
  String get changeNick => '별명 변경';

  @override
  String get name => '이름';

  @override
  String get nick => '별명';

  @override
  String get theNameCantBeEmpty => '이름은 비워 둘 수 없습니다';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get thisListHasNoResults => '이 목록에는 결과가 없습니다';

  @override
  String get createEnvironment => '환경 생성';

  @override
  String get availableEnvironmentsWithoutConnection => '연결 없이 사용 가능한 환경';

  @override
  String get environmentsOnOtherMachines => '다른 기기의 환경';

  @override
  String get importEnvironment => '환경 가져오기';

  @override
  String get syncronization => '동기화';

  @override
  String get loading => '로딩 중...';

  @override
  String get home => '홈';

  @override
  String get shoppingList => '쇼핑 목록';

  @override
  String get recipeList => '레시피 목록';

  @override
  String get agenda => '일정';

  @override
  String get export => '내보내기';

  @override
  String get undo => '실행 취소';

  @override
  String get product => '제품';

  @override
  String get markAsNeeded => ' 필요로 표시되었습니다. ';

  @override
  String get markAsBought => ' 구매됨으로 표시되었습니다. ';

  @override
  String get toBuy => '구매할 것';

  @override
  String get editName => '이름 편집';

  @override
  String get delete => '삭제';

  @override
  String get setAsBought => '구매함으로 설정';

  @override
  String get setAsNeeded => '필요함으로 설정';

  @override
  String get selectRecipe => '레시피 선택';

  @override
  String get add => '추가';

  @override
  String get noNick => '별명 없음';

  @override
  String get pairings => '페어링';

  @override
  String get connectionType => '연결 유형';

  @override
  String get notStablished => '설정되지 않음';

  @override
  String get stablished => '설정됨';

  @override
  String get connectionState => '연결 상태';

  @override
  String get generalConfig => '일반 설정';

  @override
  String get scanStarted => '스캔 시작됨';

  @override
  String get noResultsYet => '아직 결과가 없습니다';

  @override
  String get noName => '이름 없음';

  @override
  String get noHost => '호스트 없음';

  @override
  String get error => '오류';

  @override
  String get saveFileToYourDesiredLocation => '원하는 위치에 파일 저장';

  @override
  String get exportToFile => '파일로 내보내기';

  @override
  String get sendExport => '내보내기 및 전송';

  @override
  String get localDeviceAvailableIPs => '현재 기기는 다음 IP에서 사용 가능합니다';

  @override
  String get stopServer => '서버 중지';

  @override
  String get startServer => '서버 시작';

  @override
  String get startingServer => '서버 시작 중...';

  @override
  String get stoppingServer => '서버 중지 중...';

  @override
  String get errorStartingServer => '서버 시작 중 오류 발생';

  @override
  String get nearbyDevices => '근처 기기';

  @override
  String get enterAddressManually => '주소 수동 입력';

  @override
  String get remoteAddress => '원격 주소';

  @override
  String get remotePort => '원격 포트';

  @override
  String get errorEmptyRemoteAddress => '오류: 원격 주소는 비워 둘 수 없습니다';

  @override
  String get connect => '연결';

  @override
  String get server => '서버';

  @override
  String get client => '클라이언트';

  @override
  String get inputTheAmount => '수량 입력';

  @override
  String get noIngredientsYet => '아직 추가된 재료가 없습니다';

  @override
  String get addIngredients => '재료 추가';

  @override
  String get showPastDates => '지난 날짜 보기';

  @override
  String get ingredients => '재료';

  @override
  String get dates => '날짜';

  @override
  String get buy => '구매';

  @override
  String get all => '모두';

  @override
  String get httpClient => 'HTTP 클라이언트';

  @override
  String get httpServer => 'HTTP 서버';

  @override
  String get selectIngredients => '재료 선택';

  @override
  String get recipeWithoutIngredients => '이 레시피에는 재료가 없습니다';

  @override
  String get noPlannedDates => '예정된 날짜 없음';

  @override
  String get noHTTPPairings => 'HTTP 서버와의 과거 페어링이 없습니다';

  @override
  String get loadingIps => 'IP 주소 로딩 중';

  @override
  String get ipRefresh => 'IP 새로고침';

  @override
  String get planner => '플래너';

  @override
  String ipCopied(Object address) {
    return 'IP 주소 ($address) 가 클립보드에 복사되었습니다';
  }

  @override
  String get search => '검색';

  @override
  String get switchEnvironment => '환경 전환';

  @override
  String get actions => '작업';

  @override
  String get markAllAs => '모두 표시';

  @override
  String get editAmount => '수량 편집';

  @override
  String get details => '세부사항';

  @override
  String get enoughForA => '충분함';

  @override
  String get knownServers => '알려진 서버';

  @override
  String get noOpenConnection => '열린 연결 없음';

  @override
  String get neverConnected => '연결된 적 없음';

  @override
  String get fallbackLocalNick => '이름없는-기기';

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
  String get addProductsToAisle => '통로에 상품 추가';
}
