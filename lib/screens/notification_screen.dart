import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:skinsync_admin/models/responses/notification_response.dart';
import 'package:skinsync_admin/utils/responsive.dart';
import 'package:skinsync_admin/view_models/notification_view_model.dart';

import '../utils/theme.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/number_paginator.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  static const String routeName = '/Notification';

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(notificationViewModel.notifier).fetchReels(page: 1);
    });
  }

  void _onPageChanged(int page) {
    // NumberPaginator is 0-indexed in the UI; the API is 1-indexed.
    ref.read(notificationViewModel.notifier).fetchReels(page: page + 1);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationViewModel);

    return GradientScaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: context.h(20),
            horizontal: context.isLandscape ? context.w(250) : context.w(20),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Icon(
                      Icons.arrow_back,
                      size: context.r(24),
                      color: CustomColors.black,
                    ),
                  ),
                  SizedBox(width: context.w(12)),
                  Text('Notifications', style: CustomFonts.black20w600),
                ],
              ),
              SizedBox(height: context.h(16)),

              const Divider(
                height: 1,
                thickness: 1,
                color: CustomColors.border,
              ),

              SizedBox(height: context.h(16)),

              // Notifications
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(context.r(16)),
                  decoration: BoxDecoration(
                    color: CustomColors.white,
                    borderRadius: BorderRadius.circular(context.r(8)),
                    border: Border.all(color: CustomColors.border, width: 1),
                  ),
                  child: _buildBody(state),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(NotificationState state) {
    if (state.loading && state.notification.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.notification.isEmpty) {
      return Center(
        child: Text('No notifications yet', style: context.fonts.grey16w400),
      );
    }

    return Column(
      children: [
        Expanded(
          child: ListView.separated(
            itemCount: state.notification.length,
            separatorBuilder: (context, index) => Divider(
              height: context.h(24),
              thickness: 1,
              color: CustomColors.softGrey,
            ),
            itemBuilder: (context, index) {
              return _buildNotificationItem(state.notification[index]);
            },
          ),
        ),

        if (state.totalPages > 1) ...[
          SizedBox(height: context.h(16)),

          const Divider(height: 1, thickness: 1, color: CustomColors.border),

          SizedBox(height: context.h(16)),

          NumberPaginator(
            totalPages: state.totalPages,
            currentPage: state.currentPage - 1, // back to 0-indexed for UI
            onPageChanged: _onPageChanged,
          ),
        ],
      ],
    );
  }

  Widget _buildNotificationItem(NotificationData notification) {
    return Container(
      padding: EdgeInsets.all(context.w(12)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: CustomColors.purple, width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(context.r(10)),
            decoration: BoxDecoration(
              color: CustomColors.white,
              shape: BoxShape.circle,
              border: Border.all(color: CustomColors.purple, width: 1),
            ),
            child: Icon(
              Icons.notifications_outlined,
              color: CustomColors.purple,
              size: context.r(20),
            ),
          ),

          SizedBox(width: context.w(12)),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification.title ?? '',
                  style: context.fonts.black16w600,
                ),

                SizedBox(height: context.h(4)),

                Text(notification.body ?? '', style: context.fonts.grey16w400),
              ],
            ),
          ),

          SizedBox(width: context.w(12)),

          if (notification.createdAt != null)
            Text(
              _formatRelativeTime(notification.createdAt!),
              style: context.fonts.grey16w400.copyWith(
                fontSize: context.sp(12),
              ),
            ),
        ],
      ),
    );
  }

  String _formatRelativeTime(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);

    if (difference.inSeconds < 60) {
      return 'Just now';
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'min' : 'mins'} ago';
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    }

    if (difference.inDays < 7) {
      final days = difference.inDays;
      return '$days ${days == 1 ? 'day' : 'days'} ago';
    }

    if (difference.inDays < 30) {
      final weeks = difference.inDays ~/ 7;
      return '$weeks ${weeks == 1 ? 'week' : 'weeks'} ago';
    }

    if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    }

    final years = difference.inDays ~/ 365;
    return '$years ${years == 1 ? 'year' : 'years'} ago';
  }
}
