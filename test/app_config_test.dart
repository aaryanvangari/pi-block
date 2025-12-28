import 'package:flutter_test/flutter_test.dart';
import 'package:pi_block/config/app_config.dart';

void main() {
  test('AppConfig defaults to prod', () {
    expect(AppConfig.env, 'prod');
    expect(AppConfig.isDev, false);
  });
}
