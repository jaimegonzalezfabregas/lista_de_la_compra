// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'قائمة التسوق';

  @override
  String get changeName => 'تغيير الاسم';

  @override
  String get changeNick => 'تغيير اللقب';

  @override
  String get name => 'الاسم';

  @override
  String get nick => 'اللقب';

  @override
  String get theNameCantBeEmpty => 'الاسم لا يمكن أن يكون فارغًا';

  @override
  String get cancel => 'إلغاء';

  @override
  String get save => 'حفظ';

  @override
  String get thisListHasNoResults => 'هذه القائمة لا تحتوي على نتائج';

  @override
  String get createEnvironment => 'إنشاء بيئة';

  @override
  String get availableEnvironmentsWithoutConnection =>
      'البيئات المتاحة بدون اتصال';

  @override
  String get environmentsOnOtherMachines => 'البيئات على أجهزة أخرى';

  @override
  String get importEnvironment => 'استيراد بيئة';

  @override
  String get syncronization => 'مزامنة';

  @override
  String get loading => 'جاري التحميل...';

  @override
  String get home => 'الرئيسية';

  @override
  String get shoppingList => 'قائمة التسوق';

  @override
  String get recipeList => 'قائمة الوصفات';

  @override
  String get agenda => 'جدول الأعمال';

  @override
  String get export => 'تصدير';

  @override
  String get undo => 'تراجع';

  @override
  String get product => 'منتج';

  @override
  String get markAsNeeded => ' تم تحديده كمطلوب. ';

  @override
  String get markAsBought => ' تم تحديده كمشترى. ';

  @override
  String get toBuy => 'لشراء';

  @override
  String get editName => 'تعديل الاسم';

  @override
  String get delete => 'حذف';

  @override
  String get setAsBought => 'تعيين كمشترى';

  @override
  String get setAsNeeded => 'تعيين كمطلوب';

  @override
  String get selectRecipe => 'اختر وصفة';

  @override
  String get add => 'إضافة';

  @override
  String get noNick => 'لا يوجد لقب';

  @override
  String get pairings => 'إقرانات';

  @override
  String get connectionType => 'نوع الاتصال';

  @override
  String get notStablished => 'غير مثبت';

  @override
  String get stablished => 'مثبت';

  @override
  String get connectionState => 'حالة الاتصال';

  @override
  String get generalConfig => 'الإعدادات العامة';

  @override
  String get scanStarted => 'بدأ المسح';

  @override
  String get noResultsYet => 'لا توجد نتائج حتى الآن';

  @override
  String get noName => 'بدون اسم';

  @override
  String get noHost => 'بدون مضيف';

  @override
  String get error => 'خطأ';

  @override
  String get saveFileToYourDesiredLocation => 'احفظ الملف في الموقع المطلوب';

  @override
  String get exportToFile => 'تصدير إلى ملف';

  @override
  String get sendExport => 'تصدير وإرسال';

  @override
  String get localDeviceAvailableIPs => 'هذا الجهاز متاح على عناوين IP التالية';

  @override
  String get stopServer => 'إيقاف الخادم';

  @override
  String get startServer => 'تشغيل الخادم';

  @override
  String get startingServer => 'جاري تشغيل الخادم...';

  @override
  String get stoppingServer => 'جاري إيقاف الخادم...';

  @override
  String get errorStartingServer => 'خطأ في تشغيل الخادم';

  @override
  String get nearbyDevices => 'الأجهزة القريبة';

  @override
  String get enterAddressManually => 'أدخل العنوان يدويًا';

  @override
  String get remoteAddress => 'عنوان بعيد';

  @override
  String get remotePort => 'منفذ بعيد';

  @override
  String get errorEmptyRemoteAddress =>
      'خطأ: العنوان البعيد لا يمكن أن يكون فارغًا';

  @override
  String get connect => 'اتصل';

  @override
  String get server => 'الخادم';

  @override
  String get client => 'العميل';

  @override
  String get inputTheAmount => 'أدخل الكمية';

  @override
  String get noIngredientsYet => 'لم تتم إضافة مكونات بعد';

  @override
  String get addIngredients => 'أضف مكونات';

  @override
  String get showPastDates => 'عرض التواريخ السابقة';

  @override
  String get ingredients => 'المكونات';

  @override
  String get dates => 'التواريخ';

  @override
  String get buy => 'شراء';

  @override
  String get all => 'الكل';

  @override
  String get httpClient => 'عميل HTTP';

  @override
  String get httpServer => 'خادم HTTP';

  @override
  String get selectIngredients => 'اختر المكونات';

  @override
  String get recipeWithoutIngredients => 'هذه الوصفة ليس لها مكونات';

  @override
  String get noPlannedDates => 'لا توجد تواريخ مخططة';

  @override
  String get noHTTPPairings => 'لا توجد إقرانات سابقة مع خوادم HTTP';

  @override
  String get loadingIps => 'جاري تحميل عناوين IP';

  @override
  String get ipRefresh => 'تحديث IP';

  @override
  String get planner => 'المخطط';

  @override
  String ipCopied(Object address) {
    return 'عنوان IP ($address) تم نسخه للحافظة';
  }

  @override
  String get search => 'بحث';

  @override
  String get switchEnvironment => 'تبديل البيئة';

  @override
  String get actions => 'الإجراءات';

  @override
  String get markAllAs => 'وضع علامة على الكل كـ';

  @override
  String get editAmount => 'تحرير الكمية';

  @override
  String get details => 'التفاصيل';

  @override
  String get enoughForA => 'يكفي ل';

  @override
  String get knownServers => 'الخوادم المعروفة';

  @override
  String get noOpenConnection => 'لا يوجد اتصال مفتوح';

  @override
  String get neverConnected => 'لم يتم الاتصال أبدًا';

  @override
  String get fallbackLocalNick => 'جهاز-بدون-اسم';
}
