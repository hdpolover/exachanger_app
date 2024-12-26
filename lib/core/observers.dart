import 'package:flutter_riverpod/flutter_riverpod.dart';

class Observers extends ProviderObserver {
  @override
  void didUpdateProvider(ProviderBase<Object?> provider, Object? previousValue,
      Object? newValue, ProviderContainer container) {
    print('''
Provider Updated:
  - Provider: $provider
  - Previous Value: $previousValue
  - New Value: $newValue
''');
  }

  @override
  void didAddProvider(ProviderBase<Object?> provider, Object? value,
      ProviderContainer container) {
    print('''
Provider Added:
  - Provider: $provider
  - Value: $value
''');
  }

  @override
  void didDisposeProvider(
      ProviderBase<Object?> provider, ProviderContainer container) {
    super.didDisposeProvider(provider, container);
    print('''Provider Disposed:
  - Provider: $provider
''');
  }
}
