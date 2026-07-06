import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/view_models/treatment_view_model.dart';
import 'base_state_model.dart';
import 'base_view_model.dart';

final sessionViewModelProvider =
    NotifierProvider<SessionViewModel, SessionState>(SessionViewModel._);

class SessionState extends BaseStateModel {
  final List<SessionViewModelEntry> sessions;
  final int? activeSessionIndex;

  SessionState({
    super.loading,
    super.currentPage,
    super.totalPages,
    super.totalResults,
    this.sessions = const [],
    this.activeSessionIndex,
  });

  SessionState copyWith({
    bool? loading,
    int? currentPage,
    int? totalPages,
    int? totalResults,
    List<SessionViewModelEntry>? sessions,
    int? activeSessionIndex,
    bool clearActiveSessionIndex = false,
  }) {
    return SessionState(
      loading: loading ?? this.loading,
      currentPage: currentPage ?? this.currentPage,
      totalPages: totalPages ?? this.totalPages,
      totalResults: totalResults ?? this.totalResults,
      sessions: sessions ?? this.sessions,
      activeSessionIndex: clearActiveSessionIndex ? null : (activeSessionIndex ?? this.activeSessionIndex),
    );
  }
}

class SessionViewModel extends BaseViewModel<SessionState> {
  SessionViewModel._() : super(SessionState());

  void addCustomSession(String title, int number) {
    final newSession = SessionViewModelEntry(
      sessionNumber: number,
      title: title,
    );
    state = state.copyWith(sessions: [...state.sessions, newSession]);
  }

  void removeCustomSession(int index) {
    if (index >= 0 && index < state.sessions.length) {
      final updated = List<SessionViewModelEntry>.from(state.sessions);
      final removed = updated.removeAt(index);
      removed.dispose();
      state = state.copyWith(sessions: updated);
    }
  }

  void setActiveSessionIndex(int? index) {
    state = state.copyWith(activeSessionIndex: index);
  }

  void markActiveSessionAsDetailed({
    required String durationText,
    required String priceText,
    required List<String> protocols,
    required String preInstructions,
    required String postInstructions,
    required bool requirePhotosSnapshot,
    required int photosCountSnapshot,
    required List<String> preNotifs,
    required List<String> postNotifs,
    required String downtimeLevel,
    required List<String> selectedRoles,
    required String consentSnapshot,
    required List<ProductUsageEntry> productUsageEntries,
  }) {
    if (state.activeSessionIndex != null) {
      final List<SessionViewModelEntry> updatedSessions = List.from(state.sessions);
      if (state.activeSessionIndex! < updatedSessions.length) {
        final activeEntry = updatedSessions[state.activeSessionIndex!];

        updatedSessions[state.activeSessionIndex!] = SessionViewModelEntry(
          sessionNumber: activeEntry.sessionNumber,
          title: activeEntry.title,
          totalFollowUpsController: activeEntry.totalFollowUpsController,
          followUps: List.from(activeEntry.followUps),
          isDetailedEntered: true,
          productUsageSnapshot: List<ProductUsageEntry>.from(productUsageEntries),
          durationSnapshot: durationText,
          priceSnapshot: priceText,
          protocolSnapshot: protocols,
          preInstructionsSnapshot: preInstructions,
          postInstructionsSnapshot: postInstructions,
          requirePhotosSnapshot: requirePhotosSnapshot,
          photosCountSnapshot: photosCountSnapshot,
          preNotificationsSnapshot: preNotifs,
          postNotificationsSnapshot: postNotifs,
          downtimeSnapshot: downtimeLevel,
          rolesSnapshot: List.from(selectedRoles),
          consentSnapshot: consentSnapshot,
        );
        state = state.copyWith(sessions: updatedSessions);
      }
    }
  }

  void resetSessions() {
    for (final session in state.sessions) {
      session.dispose();
    }
    state = state.copyWith(
      sessions: const [],
      clearActiveSessionIndex: true,
    );
  }
}
