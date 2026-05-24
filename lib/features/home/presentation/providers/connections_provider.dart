import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thiruvivaha_mobile/config/supabase_config.dart';
import 'package:thiruvivaha_mobile/core/utils/logger.dart';
import 'package:thiruvivaha_mobile/features/home/domain/entities/connection_request.dart';

// ---------------------------------------------------------------------------
// State
// ---------------------------------------------------------------------------

class ConnectionsState {
  final List<ConnectionRequest> received;
  final List<ConnectionRequest> sent;
  final List<ConnectionRequest> accepted;
  final List<ConnectionRequest> rejected;
  final bool isLoading;
  final String? error;

  const ConnectionsState({
    this.received = const [],
    this.sent = const [],
    this.accepted = const [],
    this.rejected = const [],
    this.isLoading = true,
    this.error,
  });

  ConnectionsState copyWith({
    List<ConnectionRequest>? received,
    List<ConnectionRequest>? sent,
    List<ConnectionRequest>? accepted,
    List<ConnectionRequest>? rejected,
    bool? isLoading,
    String? error,
    bool clearError = false,
  }) {
    return ConnectionsState(
      received: received ?? this.received,
      sent: sent ?? this.sent,
      accepted: accepted ?? this.accepted,
      rejected: rejected ?? this.rejected,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// ---------------------------------------------------------------------------
// Notifier
// ---------------------------------------------------------------------------

class ConnectionsNotifier extends StateNotifier<ConnectionsState> {
  ConnectionsNotifier() : super(const ConnectionsState()) {
    fetchAll();
  }

  Future<void> fetchAll() async {
    final authUserId = SupabaseConfig.auth.currentUser?.id;
    if (authUserId == null) {
      state = state.copyWith(isLoading: false, clearError: true);
      return;
    }

    state = state.copyWith(isLoading: true, clearError: true);

    try {
      AppLogger.debug('connections: fetching all tabs');

      final results = await Future.wait([
        _fetchType('received'),
        _fetchType('sent'),
        _fetchType('accepted'),
        _fetchType('rejected'),
      ]);

      state = ConnectionsState(
        received: results[0],
        sent: results[1],
        accepted: results[2],
        rejected: results[3],
        isLoading: false,
      );

      AppLogger.debug(
        'connections: received=${results[0].length} sent=${results[1].length} '
        'accepted=${results[2].length} rejected=${results[3].length}',
      );
    } catch (e, st) {
      AppLogger.error('connections: fetchAll failed — $e\n$st');
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<List<ConnectionRequest>> _fetchType(String type) async {
    final response = await SupabaseConfig.client.rpc(
      'get_connections',
      params: {'p_type': type},
    );
    return (response as List<dynamic>)
        .map((r) => ConnectionRequest.fromMap(r as Map<String, dynamic>))
        .toList();
  }

  /// Accept or reject a received request. Moves it out of [received] list.
  Future<void> respond({
    required String connectionId,
    required bool accept,
  }) async {
    // Optimistic remove from received list.
    final item = state.received.firstWhere(
      (r) => r.connectionId == connectionId,
      orElse: () => throw StateError('Connection not found'),
    );

    state = state.copyWith(
      received: state.received
          .where((r) => r.connectionId != connectionId)
          .toList(),
      accepted: accept ? [...state.accepted, item] : state.accepted,
      rejected: !accept ? [...state.rejected, item] : state.rejected,
    );

    try {
      await SupabaseConfig.client.rpc(
        'respond_to_connection',
        params: {'p_connection_id': connectionId, 'p_accept': accept},
      );
      AppLogger.debug(
        'connections: responded connectionId=$connectionId accept=$accept',
      );
    } catch (e) {
      AppLogger.error('connections: respond failed — $e');
      // Rollback on failure.
      await fetchAll();
    }
  }
}

// ---------------------------------------------------------------------------
// Provider
// ---------------------------------------------------------------------------

final connectionsProvider =
    StateNotifierProvider<ConnectionsNotifier, ConnectionsState>(
      (_) => ConnectionsNotifier(),
    );
