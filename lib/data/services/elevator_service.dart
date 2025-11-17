import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/elevator_models.dart';

/// Service for managing elevator data from Supabase
///
/// Fetches from elevators_import table (513 rows, BIGINT id, no RLS)
/// This is the canonical elevator directory imported from your source.
class ElevatorService {
  final SupabaseClient _client;

  ElevatorService({SupabaseClient? client})
      : _client = client ?? Supabase.instance.client;

  /// Fetch elevators from Supabase with pagination
  ///
  /// Uses elevators_import table (513 rows) for the complete directory.
  /// Selects explicit columns to reduce payload size.
  Future<List<Map<String, dynamic>>> fetchElevators({
    int limit = 200,
    int offset = 0,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('📍 Fetching elevators from Supabase (limit: $limit, offset: $offset)');
      }

      final query = _client
          .from('elevators_import')
          .select('id,name,company,address,capacity_tonnes,grain_types,railway,elevator_type,car_spots,created_at')
          .order('name', ascending: true)
          .range(offset, offset + limit - 1); // pagination

      final data = await query;

      if (kDebugMode) {
        debugPrint('✅ Fetched ${(data as List).length} elevators');
      }

      return (data as List).cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Error fetching elevators: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Fetch a single elevator by BIGINT ID
  Future<Map<String, dynamic>?> fetchElevatorById(int id) async {
    try {
      if (kDebugMode) {
        debugPrint('📍 Fetching elevator with ID: $id');
      }

      final response = await _client
          .from('elevators_import')
          .select('id,name,company,address,capacity_tonnes,grain_types,railway,elevator_type,car_spots,created_at')
          .eq('id', id)
          .maybeSingle();

      if (response == null) {
        if (kDebugMode) {
          debugPrint('⚠️ Elevator with ID $id not found');
        }
        return null;
      }

      return response;
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Error fetching elevator by ID: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Search elevators by name and optionally filter by companies
  ///
  /// Uses ilike for case-insensitive substring search and in_ for company filtering.
  Future<List<Map<String, dynamic>>> searchElevators({
    String? name,
    List<String>? companies,
    int limit = 50,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('🔍 Searching elevators (name: $name, companies: $companies, limit: $limit)');
      }

      PostgrestFilterBuilder q = _client
          .from('elevators_import')
          .select('id,name,company,address,capacity_tonnes,grain_types,railway,elevator_type');

      if (name != null && name.isNotEmpty) {
        q = q.ilike('name', '%$name%'); // case-insensitive substring
      }

      if (companies != null && companies.isNotEmpty) {
        q = q.inFilter('company', companies);
      }

      final transformedQuery = q.order('name').limit(limit);

      final data = await transformedQuery;

      if (kDebugMode) {
        debugPrint('✅ Found ${(data as List).length} matching elevators');
      }

      return (data as List).cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Error searching elevators: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Fetch next page of elevators using cursor-based pagination
  ///
  /// More efficient than offset-based pagination for large datasets.
  /// Pass the id of the last elevator from the previous page.
  Future<List<Map<String, dynamic>>> fetchPageAfter(int? lastId, {int pageSize = 100}) async {
    try {
      if (kDebugMode) {
        debugPrint('📍 Fetching page after ID: $lastId (pageSize: $pageSize)');
      }

      PostgrestFilterBuilder q = _client
          .from('elevators_import')
          .select('id,name,company,address,capacity_tonnes,grain_types');

      if (lastId != null) {
        q = q.gt('id', lastId);
      }

      final transformedQuery = q.order('id', ascending: true).limit(pageSize);

      final data = await transformedQuery;

      if (kDebugMode) {
        debugPrint('✅ Fetched ${(data as List).length} elevators');
      }

      return (data as List).cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Error fetching page: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Fetch elevators near a location
  ///
  /// Note: This is a placeholder. For production, use a PostGIS RPC function
  /// like get_elevators_near(lat, lng, km) for proper distance-based queries.
  Future<List<Map<String, dynamic>>> nearbyElevators({
    required double lat,
    required double lng,
    int limit = 25,
  }) async {
    try {
      if (kDebugMode) {
        debugPrint('📍 Fetching elevators near ($lat, $lng) - limit: $limit');
        debugPrint('⚠️ Using placeholder query - recommend using PostGIS RPC for production');
      }

      // Placeholder: fetch all and filter client-side
      // TODO: Replace with RPC call: supabase.rpc('get_elevators_near', {'lat': lat, 'lng': lng, 'km': 50})
      final data = await _client
          .from('elevators_import')
          .select('id,name,address,location')
          .order('created_at')
          .limit(limit);

      if (kDebugMode) {
        debugPrint('✅ Fetched ${(data as List).length} elevators (placeholder query)');
      }

      return (data as List).cast<Map<String, dynamic>>();
    } catch (e, stackTrace) {
      if (kDebugMode) {
        debugPrint('❌ Error fetching nearby elevators: $e');
        debugPrint('Stack trace: $stackTrace');
      }
      rethrow;
    }
  }

  /// Parse elevator data from Supabase JSON to Elevator model
  ///
  /// Note: This converts the raw Map data to your Elevator model.
  /// If your Elevator model expects different fields, you may need to adapt the mapping.
  Elevator parseElevator(Map<String, dynamic> json) {
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
  ///
  /// Use this for client-side distance calculations if not using PostGIS RPC.
  double calculateDistance(
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
