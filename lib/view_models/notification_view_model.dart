import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/responses/notification_response.dart';

import '../repositories/notification_repository.dart';
import '../services/locator.dart';

import 'base_view_model.dart';



final notificationViewModel =
    NotifierProvider.autoDispose<NotificationViewModel, NotificationState>(
     NotificationViewModel.new,
    );

class NotificationViewModel extends BaseViewModel<NotificationState> {
  NotificationViewModel() :super(const NotificationState() );

  final NotificationRepository _repository = locator<NotificationRepository>();


  Future<void> fetchReels({int page = 1, bool showLoading = true}) async {
    return await runSafely(showLoading: false, () async {
      state = state.copyWith(loading: showLoading);

      final response = await _repository.fetchNotification(
        page: page,
        limit: state.pageSize,
      );

      state = state.copyWith(
        loading: false,
        notification: response.data ?? [],
        totalPages: response.totalPages,
        currentPage: response.page,
      );
    });
  }

  @override
  void onError(String message) {
    super.onError(message);
    state.copyWith(loading: false);
    EasyLoading.dismiss();
  }
}

class NotificationState {
  final List<NotificationData> notification;
  final int totalPages;
  final int currentPage;
  final int pageSize;
  final bool loading;

  const NotificationState({
    this.loading = false,
    this.notification = const [],
    this.totalPages = 1,
    this.currentPage = 1,
    this.pageSize = 10,
  });

  NotificationState copyWith({
    bool? loading,
    List<NotificationData>? notification,
    int? totalPages,
    int? currentPage,
    int? pageSize,
  }) {
    return NotificationState(
      loading: loading ?? this.loading,
      notification: notification ?? this.notification,
      totalPages: totalPages ?? this.totalPages,
      currentPage: currentPage ?? this.currentPage,
      pageSize: pageSize ?? this.pageSize,
    );
  }

  NotificationState clearFiles() {
    return NotificationState(
      loading: loading,
      notification: notification,
      totalPages: totalPages,
      currentPage: currentPage,
      pageSize: pageSize,
    );
  }
}
