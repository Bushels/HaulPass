import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/elevator_models.dart';

/// Service for managing elevator data from Supabase
class ElevatorService {
  final SupabaseClient _client;

  ElevatorService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Fetch all elevators from Supabase
  ///
  /// This method fetches from the grain_elevators table which contains
  /// the complete elevator data imported from your source.
  Future<List<Elevator>> fetchElevators({
    int? limit,
    bool activeOnly = true,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('📍 Fetching elevators from Supabase...');
      }

      PostgrestFilterBuilder query = _client
          .from('grain_elevators')
          .select('*');

      if (activeOnly) {
        query = query.eq('is_active', true);
      }

      PostgrestTransformBuilder transformedQuery = query.order('name', ascending: true);

      if (limit != null) {
        transformedQuery = transformedQuery.limit(limit);
      }

      final response = await transformedQuery;

      if (kDebugMode) {
        debugPrint('✅ Fetched ${(response as List).length} elevators');
      }

      return (response as List)
          .map((json) => _parseElevator(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Error fetching elevators: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Fetch a single elevator by ID
  Future<Elevator?> fetchElevatorById(String id) async {
    try {
      if (kDebugMode) {
        debugPrint('📍 Fetching elevator with ID: $id');
      }

      final response = await _client
          .from('grain_elevators')
          .select('*')
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        if (kDebugMode) {
          debugPrint('⚠️ Elevator with ID $id not found');
        }
        return null;
      }

      return _parseElevator(response);
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Error fetching elevator by ID: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Search elevators by query string
  /// Searches across name, company, and address fields
  Future<List<Elevator>> searchElevators(String query) async {
    try {
      if (kDebugMode) {
        debugPrint('🔍 Searching elevators for: $query');
      }

      if (query.trim().isEmpty) {
        return fetchElevators();
      }

      // Use ilike for case-insensitive search
      final response = await _client
          .from('grain_elevators')
          .select('*')
          .or('name.ilike.%$query%,company.ilike.%$query%,address.ilike.%$query%')
          .order('name', ascending: true);

      if (kDebugMode) {
        debugPrint('✅ Found ${(response as List).length} matching elevators');
      }

      return (response as List)
          .map((json) => _parseElevator(json as Map<String, dynamic>))
          .toList();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Error searching elevators: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Fetch elevators near a specific location
  Future<List<Elevator>> fetchNearbyElevators({
    required double latitude,
    required double longitude,
    double radiusKm = 50.0,
    int? limit,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('📍 Fetching elevators within ${radiusKm}km of ($latitude, $longitude)');
      }

      // Use PostGIS distance function if location is stored as geography
      // This is a placeholder - adjust based on your actual schema
      final response = await _client
          .from('grain_elevators')
          .select('*')
          .order('name', ascending: true);

      if (limit != null) {
        final limitedResponse = await _client
            .from('grain_elevators')
            .select('*')
            .order('name', ascending: true)
            .limit(limit);

        return (limitedResponse as List)
            .map((json) => _parseElevator(json as Map<String, dynamic>))
            .toList();
      }

      // TODO: Implement proper distance filtering using PostGIS
      // For now, return all and filter client-side
      final elevators = (response as List)
          .map((json) => _parseElevator(json as Map<String, dynamic>))
          .toList();

      // Client-side distance filtering (temporary)
      final nearby = elevators.where((elevator) {
        final distance = _calculateDistance(
          latitude,
          longitude,
          elevator.location.latitude,
          elevator.location.longitude,
        );
        return distance <= radiusKm;
      }).toList();

      // Sort by distance
      nearby.sort((a, b) {
        final distA = _calculateDistance(
          latitude,
          longitude,
          a.location.latitude,
          a.location.longitude,
        );
        final distB = _calculateDistance(
          latitude,
          longitude,
          b.location.latitude,
          b.location.longitude,
        );
        return distA.compareTo(distB);
      });

      if (kDebugMode) {
        debugPrint('✅ Found ${nearby.length} nearby elevators');
      }

      return nearby;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Error fetching nearby elevators: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Parse elevator data from Supabase JSON
  Elevator _parseElevator(Map<String, dynamic> json) {
    try {
      return Elevator.fromJson(json);
    } catch (e) {
      if (kDebugMode) {
        debugPrint('⚠️ Error parsing elevator: $e');
        debugPrint('JSON: $json');
      }
      rethrow;
    }
  }

  /// Calculate distance between two coordinates using Haversine formula
  /// Returns distance in kilometers
  double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371.0; // Earth's radius in kilometers

    final dLat = _degreesToRadians(lat2 - lat1);
    final dLon = _degreesToRadians(lon2 - lon1);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_degreesToRadians(lat1)) *
        math.cos(_degreesToRadians(lat2)) *
        math.sin(dLon / 2) *
        math.sin(dLon / 2);

    final c = 2 * math.asin(math.sqrt(a));

    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) {
    return degrees * math.pi / 180.0;
  }
}
