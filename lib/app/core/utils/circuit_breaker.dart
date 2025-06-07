import 'dart:async';

enum CircuitBreakerState { closed, open, halfOpen }

class CircuitBreaker {
  final int failureThreshold;
  final Duration timeout;
  final Duration retryTimeout;

  CircuitBreakerState _state = CircuitBreakerState.closed;
  int _failureCount = 0;
  DateTime? _lastFailureTime;
  Timer? _timer;

  CircuitBreaker({
    this.failureThreshold = 5,
    this.timeout = const Duration(seconds: 60),
    this.retryTimeout = const Duration(seconds: 30),
  });

  CircuitBreakerState get state => _state;
  int get failureCount => _failureCount;

  Future<T> execute<T>(Future<T> Function() operation) async {
    if (_state == CircuitBreakerState.open) {
      if (_shouldAttemptReset()) {
        _state = CircuitBreakerState.halfOpen;
      } else {
        throw CircuitBreakerOpenException(
          'Circuit breaker is open. Service unavailable.',
        );
      }
    }

    try {
      final result = await operation();
      _onSuccess();
      return result;
    } catch (e) {
      _onFailure();
      rethrow;
    }
  }

  void _onSuccess() {
    _failureCount = 0;
    _state = CircuitBreakerState.closed;
    _timer?.cancel();
  }

  void _onFailure() {
    _failureCount++;
    _lastFailureTime = DateTime.now();

    if (_failureCount >= failureThreshold) {
      _state = CircuitBreakerState.open;
      _startTimer();
    }
  }

  bool _shouldAttemptReset() {
    return _lastFailureTime != null &&
        DateTime.now().difference(_lastFailureTime!) > retryTimeout;
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer(timeout, () {
      if (_state == CircuitBreakerState.open) {
        _state = CircuitBreakerState.halfOpen;
      }
    });
  }

  void reset() {
    _failureCount = 0;
    _state = CircuitBreakerState.closed;
    _timer?.cancel();
  }

  void dispose() {
    _timer?.cancel();
  }
}

class CircuitBreakerOpenException implements Exception {
  final String message;
  CircuitBreakerOpenException(this.message);

  @override
  String toString() => 'CircuitBreakerOpenException: $message';
}

// Global circuit breakers for different services
class CircuitBreakers {
  static final Map<String, CircuitBreaker> _breakers = {};

  static CircuitBreaker getBreaker(String service) {
    _breakers[service] ??= CircuitBreaker(
      failureThreshold: service == 'metadata'
          ? 3
          : 5, // More lenient for metadata
      timeout: service == 'metadata'
          ? const Duration(minutes: 2)
          : const Duration(minutes: 5),
      retryTimeout: const Duration(seconds: 30),
    );
    return _breakers[service]!;
  }

  static void resetAll() {
    for (final breaker in _breakers.values) {
      breaker.reset();
    }
  }

  static void dispose() {
    for (final breaker in _breakers.values) {
      breaker.dispose();
    }
    _breakers.clear();
  }
}
