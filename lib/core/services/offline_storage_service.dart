import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:convert';

/// Offline storage service using Hive for caching data
class OfflineStorageService {
  static final OfflineStorageService _instance = OfflineStorageService._internal();
  factory OfflineStorageService() => _instance;
  OfflineStorageService._internal();

  static OfflineStorageService get instance => _instance;

  // Box names
  static const String _elevatorsBox = 'elevators';
  static const String _queueStatusBox = 'queue_status';
  static const String _userDataBox = 'user_data';
  static const String _haulHistoryBox = 'haul_history';
  static const String _settingsBox = 'settings';

  bool _initialized = false;
  bool get isInitialized => _initialized;

  /// Initialize Hive
  Future<void> initialize() async {
    try {
      // Initialize Hive
      await Hive.initFlutter();

      // Open boxes
      await Hive.openBox(_elevatorsBox);
      await Hive.openBox(_queueStatusBox);
      await Hive.openBox(_userDataBox);
      await Hive.openBox(_haulHistoryBox);
      await Hive.openBox(_settingsBox);

      _initialized = true;

      if (kDebugMode) {
        debugPrint('✅ Hive initialized');
        debugPrint('📦 Boxes opened: $_elevatorsBox, $_queueStatusBox, $_userDataBox, $_haulHistoryBox, $_settingsBox');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Hive initialization error: $e');
      }
    }
  }

  /// Get box by name
  Box _getBox(String boxName) {
    if (!_initialized) {
      throw Exception('OfflineStorageService not initialized');
    }
    return Hive.box(boxName);
  }

  // ==================== ELEVATORS ====================

  /// Save elevator data
  Future<void> saveElevator(String id, Map<String, dynamic> data) async {
    try {
      final box = _getBox(_elevatorsBox);
      await box.put(id, jsonEncode(data));

      if (kDebugMode) {
        debugPrint('💾 Saved elevator: $id');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Save elevator error: $e');
      }
    }
  }

  /// Get elevator data
  Map<String, dynamic>? getElevator(String id) {
    try {
      final box = _getBox(_elevatorsBox);
      final data = box.get(id);

      if (data == null) return null;

      return jsonDecode(data as String) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Get elevator error: $e');
      }
      return null;
    }
  }

  /// Save multiple elevators
  Future<void> saveElevators(List<Map<String, dynamic>> elevators) async {
    try {
      final box = _getBox(_elevatorsBox);

      for (final elevator in elevators) {
        final id = elevator['id'] as String;
        await box.put(id, jsonEncode(elevator));
      }

      if (kDebugMode) {
        debugPrint('💾 Saved ${elevators.length} elevators');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Save elevators error: $e');
      }
    }
  }

  /// Get all elevators
  List<Map<String, dynamic>> getAllElevators() {
    try {
      final box = _getBox(_elevatorsBox);
      final elevators = <Map<String, dynamic>>[];

      for (final key in box.keys) {
        final data = box.get(key);
        if (data != null) {
          elevators.add(jsonDecode(data as String) as Map<String, dynamic>);
        }
      }

      return elevators;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Get all elevators error: $e');
      }
      return [];
    }
  }

  /// Clear all elevators
  Future<void> clearElevators() async {
    try {
      final box = _getBox(_elevatorsBox);
      await box.clear();

      if (kDebugMode) {
        debugPrint('🗑️ Cleared all elevators');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Clear elevators error: $e');
      }
    }
  }

  // ==================== QUEUE STATUS ====================

  /// Save queue status
  Future<void> saveQueueStatus(String elevatorId, Map<String, dynamic> status) async {
    try {
      final box = _getBox(_queueStatusBox);
      await box.put(elevatorId, jsonEncode(status));

      if (kDebugMode) {
        debugPrint('💾 Saved queue status for: $elevatorId');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Save queue status error: $e');
      }
    }
  }

  /// Get queue status
  Map<String, dynamic>? getQueueStatus(String elevatorId) {
    try {
      final box = _getBox(_queueStatusBox);
      final data = box.get(elevatorId);

      if (data == null) return null;

      return jsonDecode(data as String) as Map<String, dynamic>;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Get queue status error: $e');
      }
      return null;
    }
  }

  // ==================== HAUL HISTORY ====================

  /// Save haul
  Future<void> saveHaul(String id, Map<String, dynamic> haul) async {
    try {
      final box = _getBox(_haulHistoryBox);
      await box.put(id, jsonEncode(haul));

      if (kDebugMode) {
        debugPrint('💾 Saved haul: $id');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Save haul error: $e');
      }
    }
  }

  /// Get all hauls
  List<Map<String, dynamic>> getAllHauls() {
    try {
      final box = _getBox(_haulHistoryBox);
      final hauls = <Map<String, dynamic>>[];

      for (final key in box.keys) {
        final data = box.get(key);
        if (data != null) {
          hauls.add(jsonDecode(data as String) as Map<String, dynamic>);
        }
      }

      return hauls;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Get all hauls error: $e');
      }
      return [];
    }
  }

  // ==================== USER DATA ====================

  /// Save user data
  Future<void> saveUserData(String key, dynamic value) async {
    try {
      final box = _getBox(_userDataBox);
      await box.put(key, value is Map || value is List ? jsonEncode(value) : value);

      if (kDebugMode) {
        debugPrint('💾 Saved user data: $key');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Save user data error: $e');
      }
    }
  }

  /// Get user data
  dynamic getUserData(String key) {
    try {
      final box = _getBox(_userDataBox);
      final data = box.get(key);

      if (data == null) return null;

      // Try to decode JSON if it's a string
      if (data is String) {
        try {
          return jsonDecode(data);
        } catch (_) {
          return data;
        }
      }

      return data;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Get user data error: $e');
      }
      return null;
    }
  }

  // ==================== SETTINGS ====================

  /// Save setting
  Future<void> saveSetting(String key, dynamic value) async {
    try {
      final box = _getBox(_settingsBox);
      await box.put(key, value);

      if (kDebugMode) {
        debugPrint('💾 Saved setting: $key = $value');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Save setting error: $e');
      }
    }
  }

  /// Get setting
  dynamic getSetting(String key, {dynamic defaultValue}) {
    try {
      final box = _getBox(_settingsBox);
      return box.get(key, defaultValue: defaultValue);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Get setting error: $e');
      }
      return defaultValue;
    }
  }

  // ==================== CACHE MANAGEMENT ====================

  /// Get cache size in bytes
  int getCacheSize() {
    try {
      int totalSize = 0;

      totalSize += _getBox(_elevatorsBox).length;
      totalSize += _getBox(_queueStatusBox).length;
      totalSize += _getBox(_userDataBox).length;
      totalSize += _getBox(_haulHistoryBox).length;

      return totalSize;
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Get cache size error: $e');
      }
      return 0;
    }
  }

  /// Clear all cache (except settings)
  Future<void> clearAllCache() async {
    try {
      await _getBox(_elevatorsBox).clear();
      await _getBox(_queueStatusBox).clear();
      await _getBox(_userDataBox).clear();
      await _getBox(_haulHistoryBox).clear();

      if (kDebugMode) {
        debugPrint('🗑️ Cleared all cache');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Clear cache error: $e');
      }
    }
  }

  /// Close all boxes
  Future<void> close() async {
    try {
      await Hive.close();
      _initialized = false;

      if (kDebugMode) {
        debugPrint('📦 Hive closed');
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('❌ Hive close error: $e');
      }
    }
  }
}
