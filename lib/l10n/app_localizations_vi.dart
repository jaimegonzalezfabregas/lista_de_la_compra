// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Danh sách mua sắm';

  @override
  String get changeName => 'Đổi tên';

  @override
  String get changeNick => 'Đổi biệt danh';

  @override
  String get name => 'Tên';

  @override
  String get nick => 'Biệt danh';

  @override
  String get theNameCantBeEmpty => 'Tên không được để trống';

  @override
  String get cancel => 'Hủy';

  @override
  String get save => 'Lưu';

  @override
  String get thisListHasNoResults => 'Danh sách này không có kết quả';

  @override
  String get createEnvironment => 'Tạo môi trường';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'Môi trường có sẵn không có kết nối';

  @override
  String get environmentsOnOtherMachines => 'Môi trường trên các máy khác';

  @override
  String get importEnvironment => 'Nhập môi trường';

  @override
  String get syncronization => 'Đồng bộ';

  @override
  String get loading => 'Đang tải...';

  @override
  String get home => 'Trang chủ';

  @override
  String get shoppingList => 'Danh sách mua sắm';

  @override
  String get recipeList => 'Danh sách công thức';

  @override
  String get agenda => 'Lịch trình';

  @override
  String get export => 'Xuất';

  @override
  String get undo => 'Hoàn tác';

  @override
  String get product => 'Sản phẩm';

  @override
  String get markAsNeeded => ' được đánh dấu là cần thiết. ';

  @override
  String get markAsBought => ' được đánh dấu là đã mua. ';

  @override
  String get toBuy => 'Mua';

  @override
  String get editName => 'Chỉnh sửa tên';

  @override
  String get delete => 'Xóa';

  @override
  String get setAsBought => 'Đánh dấu là đã mua';

  @override
  String get setAsNeeded => 'Đánh dấu là cần thiết';

  @override
  String get selectRecipe => 'Chọn công thức';

  @override
  String get add => 'Thêm';

  @override
  String get noNick => 'Không có biệt danh';

  @override
  String get pairings => 'Ghép đôi';

  @override
  String get connectionType => 'Loại kết nối';

  @override
  String get notStablished => 'Chưa thiết lập';

  @override
  String get stablished => 'Đã thiết lập';

  @override
  String get connectionState => 'Trạng thái kết nối';

  @override
  String get generalConfig => 'Cấu hình chung';

  @override
  String get scanStarted => 'Bắt đầu quét';

  @override
  String get noResultsYet => 'Chưa có kết quả';

  @override
  String get noName => 'Không có tên';

  @override
  String get noHost => 'Không có host';

  @override
  String get error => 'Lỗi';

  @override
  String get saveFileToYourDesiredLocation => 'Lưu tệp vào vị trí bạn muốn';

  @override
  String get exportToFile => 'Xuất ra tệp';

  @override
  String get sendExport => 'Xuất và gửi';

  @override
  String get localDeviceAvailableIPs =>
      'Thiết bị hiện tại có sẵn trên các IP sau';

  @override
  String get stopServer => 'Dừng máy chủ';

  @override
  String get startServer => 'Khởi động máy chủ';

  @override
  String get startingServer => 'Đang khởi động máy chủ...';

  @override
  String get stoppingServer => 'Đang dừng máy chủ...';

  @override
  String get errorStartingServer => 'Lỗi khi khởi động máy chủ';

  @override
  String get nearbyDevices => 'Thiết bị gần đây';

  @override
  String get enterAddressManually => 'Nhập địa chỉ thủ công';

  @override
  String get remoteAddress => 'Địa chỉ từ xa';

  @override
  String get remotePort => 'Cổng từ xa';

  @override
  String get errorEmptyRemoteAddress =>
      'Lỗi: địa chỉ từ xa không được để trống';

  @override
  String get connect => 'Kết nối';

  @override
  String get server => 'Máy chủ';

  @override
  String get client => 'Máy khách';

  @override
  String get inputTheAmount => 'Nhập số lượng';

  @override
  String get noIngredientsYet => 'Chưa thêm nguyên liệu';

  @override
  String get addIngredients => 'Thêm nguyên liệu';

  @override
  String get showPastDates => 'Hiển thị ngày cũ';

  @override
  String get ingredients => 'Nguyên liệu';

  @override
  String get dates => 'Ngày';

  @override
  String get buy => 'Mua';

  @override
  String get all => 'Tất cả';

  @override
  String get httpClient => 'HTTP Client';

  @override
  String get httpServer => 'HTTP Server';

  @override
  String get selectIngredients => 'Chọn nguyên liệu';

  @override
  String get recipeWithoutIngredients => 'Công thức này không có nguyên liệu';

  @override
  String get noPlannedDates => 'Không có ngày dự kiến';

  @override
  String get noHTTPPairings => 'Không có cặp trước đó với máy chủ HTTP';

  @override
  String get loadingIps => 'Đang tải địa chỉ IP';

  @override
  String get ipRefresh => 'Làm mới IP';

  @override
  String get planner => 'Bộ lập kế hoạch';

  @override
  String ipCopied(Object address) {
    return 'Địa chỉ IP ($address) đã được sao chép vào bộ nhớ tạm';
  }

  @override
  String get search => 'Tìm kiếm';

  @override
  String get switchEnvironment => 'Chuyển môi trường';

  @override
  String get actions => 'Hành động';

  @override
  String get markAllAs => 'Đánh dấu tất cả là';

  @override
  String get editAmount => 'Chỉnh sửa số lượng';

  @override
  String get details => 'Chi tiết';

  @override
  String get enoughForA => 'Đủ cho';

  @override
  String get knownServers => 'Máy chủ đã biết';

  @override
  String get noOpenConnection => 'Không có kết nối mở';

  @override
  String get neverConnected => 'Chưa bao giờ kết nối';

  @override
  String get fallbackLocalNick => 'thiết-bị-không-tên';

  @override
  String get supermarketList => 'Supermarket list';
}
