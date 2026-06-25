// lib/l10n/app_localizations.dart

import 'package:flutter/material.dart';

/// Lightweight, codegen-free localization for the app UI.
///
/// Add a new language by adding a [Locale] to [supportedLocales] and a matching
/// map of strings to [_localizedValues]. Right-to-left languages (Urdu, Arabic,
/// Hebrew) are handled automatically via [isRtl].
class AppLocalizations {
  final Locale locale;
  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations) ??
        AppLocalizations(const Locale('en'));
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// Languages offered for the app interface, with their native display names.
  static const Map<String, String> languageNames = {
    'en': 'English',
    'ur': 'اردو',
    'ar': 'العربية',
  };

  static const List<Locale> supportedLocales = [
    Locale('en'),
    Locale('ur'),
    Locale('ar'),
  ];

  static bool isRtl(String languageCode) =>
      const {'ur', 'ar', 'he', 'fa'}.contains(languageCode);

  String t(String key) {
    final lang = locale.languageCode;
    return _localizedValues[lang]?[key] ??
        _localizedValues['en']![key] ??
        key;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appName': 'News App',
      'tagline': 'Stay Informed, Stay Ahead',
      'home': 'Home',
      'search': 'Search',
      'saved': 'Saved',
      'settings': 'Settings',
      'trending': 'Trending',
      'latestNews': 'Latest News',
      'loadMore': 'Load More',
      'allCaughtUp': "You're all caught up!",
      'tryAgain': 'Try Again',
      'noArticles': 'No articles found. Try a different search or category.',
      'noInternetTitle': 'No Internet Connection',
      'noInternetMessage': 'Please check your connection and try again.',
      'retry': 'Retry',
      'searchHint': 'Search news…',
      'searchPrompt': 'Search for news, topics, or keywords',
      'recentSearches': 'Recent Searches',
      'noBookmarks': 'No saved articles yet',
      'noBookmarksHint': 'Tap the bookmark icon on any article to save it here.',
      'appearance': 'Appearance',
      'theme': 'Theme',
      'themeSubtitle': 'Choose how the app looks',
      'light': 'Light',
      'dark': 'Dark',
      'system': 'System',
      'language': 'Language',
      'appLanguage': 'App Language',
      'appLanguageSubtitle': 'Language of the app interface',
      'newsPreferences': 'News Preferences',
      'preferredSource': 'Preferred Source',
      'allSources': 'All Sources',
      'contentLanguage': 'News Language',
      'contentLanguageSubtitle': 'Language of news articles',
      'sortArticlesBy': 'Sort Articles By',
      'sortBy': 'Sort By',
      'latestFirst': 'Latest First',
      'mostPopular': 'Most Popular',
      'mostRelevant': 'Most Relevant',
      'selectSource': 'Select Source',
      'selectLanguage': 'Select Language',
      'dataStorage': 'Data & Storage',
      'bookmarks': 'Bookmarks',
      'clearBookmarks': 'Clear Bookmarks',
      'removeAllSaved': 'Remove all saved articles',
      'clearAllBookmarks': 'Clear All Bookmarks',
      'clearBookmarksConfirm':
          'This will remove all saved articles permanently.',
      'cancel': 'Cancel',
      'clear': 'Clear',
      'about': 'About',
      'readMore': 'Read Full Article',
      'share': 'Share',
      'category_general': 'General',
      'category_business': 'Business',
      'category_entertainment': 'Entertainment',
      'category_health': 'Health',
      'category_science': 'Science',
      'category_sports': 'Sports',
      'category_technology': 'Technology',
    },
    'ur': {
      'appName': 'نیوز ایپ',
      'tagline': 'باخبر رہیں، آگے رہیں',
      'home': 'ہوم',
      'search': 'تلاش',
      'saved': 'محفوظ',
      'settings': 'ترتیبات',
      'trending': 'مقبول',
      'latestNews': 'تازہ ترین خبریں',
      'loadMore': 'مزید دیکھیں',
      'allCaughtUp': 'آپ سب کچھ دیکھ چکے ہیں!',
      'tryAgain': 'دوبارہ کوشش کریں',
      'noArticles': 'کوئی خبر نہیں ملی۔ مختلف تلاش یا زمرہ آزمائیں۔',
      'noInternetTitle': 'انٹرنیٹ کنکشن نہیں',
      'noInternetMessage': 'براہ کرم اپنا کنکشن چیک کر کے دوبارہ کوشش کریں۔',
      'retry': 'دوبارہ کوشش',
      'searchHint': 'خبریں تلاش کریں…',
      'searchPrompt': 'خبریں، موضوعات یا الفاظ تلاش کریں',
      'recentSearches': 'حالیہ تلاش',
      'noBookmarks': 'ابھی تک کوئی خبر محفوظ نہیں',
      'noBookmarksHint': 'محفوظ کرنے کے لیے کسی خبر پر بُک مارک کا نشان دبائیں۔',
      'appearance': 'ظاہری شکل',
      'theme': 'تھیم',
      'themeSubtitle': 'ایپ کی شکل منتخب کریں',
      'light': 'روشن',
      'dark': 'گہرا',
      'system': 'سسٹم',
      'language': 'زبان',
      'appLanguage': 'ایپ کی زبان',
      'appLanguageSubtitle': 'ایپ کے انٹرفیس کی زبان',
      'newsPreferences': 'خبروں کی ترجیحات',
      'preferredSource': 'پسندیدہ ذریعہ',
      'allSources': 'تمام ذرائع',
      'contentLanguage': 'خبروں کی زبان',
      'contentLanguageSubtitle': 'خبروں کے مضامین کی زبان',
      'sortArticlesBy': 'خبروں کی ترتیب',
      'sortBy': 'ترتیب دیں',
      'latestFirst': 'تازہ ترین پہلے',
      'mostPopular': 'سب سے مقبول',
      'mostRelevant': 'سب سے متعلقہ',
      'selectSource': 'ذریعہ منتخب کریں',
      'selectLanguage': 'زبان منتخب کریں',
      'dataStorage': 'ڈیٹا اور اسٹوریج',
      'bookmarks': 'بُک مارکس',
      'clearBookmarks': 'بُک مارکس صاف کریں',
      'removeAllSaved': 'تمام محفوظ خبریں حذف کریں',
      'clearAllBookmarks': 'تمام بُک مارکس صاف کریں',
      'clearBookmarksConfirm': 'یہ تمام محفوظ خبروں کو مستقل طور پر حذف کر دے گا۔',
      'cancel': 'منسوخ',
      'clear': 'صاف کریں',
      'about': 'متعلق',
      'readMore': 'مکمل خبر پڑھیں',
      'share': 'شیئر کریں',
      'category_general': 'عام',
      'category_business': 'کاروبار',
      'category_entertainment': 'تفریح',
      'category_health': 'صحت',
      'category_science': 'سائنس',
      'category_sports': 'کھیل',
      'category_technology': 'ٹیکنالوجی',
    },
    'ar': {
      'appName': 'تطبيق الأخبار',
      'tagline': 'ابقَ مطلعًا، ابقَ في المقدمة',
      'home': 'الرئيسية',
      'search': 'بحث',
      'saved': 'المحفوظة',
      'settings': 'الإعدادات',
      'trending': 'الأكثر رواجًا',
      'latestNews': 'آخر الأخبار',
      'loadMore': 'تحميل المزيد',
      'allCaughtUp': 'لقد اطلعت على كل شيء!',
      'tryAgain': 'حاول مرة أخرى',
      'noArticles': 'لم يتم العثور على مقالات. جرّب بحثًا أو فئة مختلفة.',
      'noInternetTitle': 'لا يوجد اتصال بالإنترنت',
      'noInternetMessage': 'يرجى التحقق من اتصالك والمحاولة مرة أخرى.',
      'retry': 'إعادة المحاولة',
      'searchHint': 'ابحث عن الأخبار…',
      'searchPrompt': 'ابحث عن الأخبار أو المواضيع أو الكلمات',
      'recentSearches': 'عمليات البحث الأخيرة',
      'noBookmarks': 'لا توجد مقالات محفوظة بعد',
      'noBookmarksHint': 'اضغط على أيقونة الحفظ في أي مقال لحفظه هنا.',
      'appearance': 'المظهر',
      'theme': 'السمة',
      'themeSubtitle': 'اختر شكل التطبيق',
      'light': 'فاتح',
      'dark': 'داكن',
      'system': 'النظام',
      'language': 'اللغة',
      'appLanguage': 'لغة التطبيق',
      'appLanguageSubtitle': 'لغة واجهة التطبيق',
      'newsPreferences': 'تفضيلات الأخبار',
      'preferredSource': 'المصدر المفضل',
      'allSources': 'كل المصادر',
      'contentLanguage': 'لغة الأخبار',
      'contentLanguageSubtitle': 'لغة مقالات الأخبار',
      'sortArticlesBy': 'ترتيب المقالات حسب',
      'sortBy': 'ترتيب حسب',
      'latestFirst': 'الأحدث أولاً',
      'mostPopular': 'الأكثر شيوعًا',
      'mostRelevant': 'الأكثر صلة',
      'selectSource': 'اختر المصدر',
      'selectLanguage': 'اختر اللغة',
      'dataStorage': 'البيانات والتخزين',
      'bookmarks': 'المحفوظات',
      'clearBookmarks': 'مسح المحفوظات',
      'removeAllSaved': 'حذف كل المقالات المحفوظة',
      'clearAllBookmarks': 'مسح كل المحفوظات',
      'clearBookmarksConfirm': 'سيؤدي هذا إلى حذف كل المقالات المحفوظة نهائيًا.',
      'cancel': 'إلغاء',
      'clear': 'مسح',
      'about': 'حول',
      'readMore': 'اقرأ المقال كاملاً',
      'share': 'مشاركة',
      'category_general': 'عام',
      'category_business': 'أعمال',
      'category_entertainment': 'ترفيه',
      'category_health': 'صحة',
      'category_science': 'علوم',
      'category_sports': 'رياضة',
      'category_technology': 'تقنية',
    },
  };
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => AppLocalizations.supportedLocales
      .any((l) => l.languageCode == locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
