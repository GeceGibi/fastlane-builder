import 'dart:io';

/// Updates App Store/Play Store metadata files.
/// Run from project root.
void main(List<String> args) async {
  // Ensure running from root
  if (!File('pubspec.yaml').existsSync()) {
    print('❌ Error: Run from project root.');
    exit(1);
  }

  // Platform flags
  final enableHuawei = args.contains('--huawei');
  final enableEnglish = args.contains('--en');

  final trBody = [
    'Uygulama deneyiminizi iyileştirmek için güncelledik.',
    '',
    'Bu sürümde:',
    '- Performans iyileştirmeleri ve hata düzeltmeleri yapıldı.',
    '- Kullanıcı deneyimi geliştirildi.',
  ].join('\n');

  final enBody = [
    'We have made updates to improve your app experience.',
    '',
    'In this version:',
    '- Performance improvements and bug fixes.',
    '- User experience enhancements.',
  ].join('\n');

  final contentMap = {
    'tr': trBody,
    'tr-TR': trBody,
    'en-US': enBody,
    'default': trBody,
  };

  print('🚀 Generating metadata...');

  // Configure locales
  final iosLocales = ['tr', 'default'];
  final androidLocales = ['tr-TR'];

  if (enableEnglish) {
    iosLocales.add('en-US');
    androidLocales.add('en-US');
  }

  // iOS
  await _process(
    'iOS',
    'ios/fastlane/metadata',
    iosLocales,
    contentMap,
    'release_notes.txt',
  );

  // Android
  await _process(
    'Android',
    'android/fastlane/metadata/android',
    androidLocales,
    contentMap,
    'changelogs/default.txt',
  );

  // Huawei (Optional)
  if (enableHuawei) {
    await _process(
      'Huawei',
      'android/fastlane/metadata/huawei',
      androidLocales,
      contentMap,
      'changelog.txt',
    );
  }

  print('\n✅ Done.');
}

Future<void> _process(
  String name,
  String base,
  List<String> locales,
  Map<String, String> map,
  String fileSuffix,
) async {
  // Check if platform folder exists
  if (!Directory(base.split('/').first).existsSync()) return;

  print('\n📱 Processing $name...');
  for (final loc in locales) {
    final text = map[loc] ?? map['default'];
    if (text == null) continue;
    await _write('$base/$loc/$fileSuffix', text);
  }
}

Future<void> _write(String path, String text) async {
  final f = File(path);
  try {
    if (!f.parent.existsSync()) await f.parent.create(recursive: true);
    if (!f.existsSync()) {
      await f.writeAsString(text);
      print('   ✅ Created: $path');
    } else {
      print('   ⚠️ Skipped: $path');
    }
  } catch (e) {
    print('   ❌ Error: $e');
  }
}
