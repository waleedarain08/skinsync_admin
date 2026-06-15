import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:skinsync_admin/utils/assets.dart';
import 'package:skinsync_admin/utils/theme.dart';

import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class PushNotificationScreen extends StatelessWidget {
  const PushNotificationScreen({super.key});
  static const String routeName = '/pushNotification-screen';

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: Padding(
        padding: context.appEdgeInsets(horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              context.verticalSpace(40),
              Text('Push Notifications', style: context.fonts.black32w700),
              context.verticalSpace(10),
              Text(
                'Send push notifications to app users about updates, offers, and alerts',
                style: context.fonts.grey14w400,
              ),
              context.verticalSpace(20),
              const Divider(color: CustomColors.border),
              context.verticalSpace(50),
              Container(
                padding: context.appEdgeInsets(all: 20),
                decoration: BoxDecoration(
                  borderRadius: context.appBorderRadius(all: 20),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.notifications_outlined,
                          size: context.sp(20),
                          color: CustomColors.black,
                        ),
                        context.horizontalSpace(20),
                        Text(
                          'Send New Notification',
                          style: context.fonts.black20w600,
                        ),
                      ],
                    ),
                    context.verticalSpace(40),
                    Text('Notification Title', style: context.fonts.black16w600),
                    context.verticalSpace(10),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: CustomColors.white,
                        hintText: 'e.g., New Feature Launch',
                        hintStyle: context.fonts.grey16w400,
                        contentPadding: context.appEdgeInsets(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: context.appBorderRadius(all: 10),
                          borderSide: const BorderSide(color: CustomColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: context.appBorderRadius(all: 10),
                          borderSide: const BorderSide(color: CustomColors.purple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: context.appBorderRadius(all: 10),
                          borderSide: const BorderSide(color: CustomColors.border),
                        ),
                      ),
                    ),
                    context.verticalSpace(10),
                    Text('0/50 characters', style: context.fonts.grey14w400),
                    context.verticalSpace(10),
                    Text('Message', style: context.fonts.black16w600),
                    context.verticalSpace(10),
                    TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: CustomColors.white,
                        hintText: 'Enter your notification message...',
                        hintStyle: context.fonts.grey16w400,
                        contentPadding: context.appEdgeInsets(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: context.appBorderRadius(all: 10),
                          borderSide: const BorderSide(color: CustomColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: context.appBorderRadius(all: 10),
                          borderSide: const BorderSide(color: CustomColors.purple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: context.appBorderRadius(all: 10),
                          borderSide: const BorderSide(color: CustomColors.border),
                        ),
                      ),
                    ),
                    context.verticalSpace(20),
                    Text('Target Audience', style: context.fonts.black16w600),
                    context.verticalSpace(10),
                    TextField(
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: CustomColors.white,
                        hintText: 'All Users (1,247 users)',
                        hintStyle: context.fonts.grey16w400,
                        contentPadding: context.appEdgeInsets(
                          vertical: 15,
                          horizontal: 20,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: context.appBorderRadius(all: 10),
                          borderSide: const BorderSide(color: CustomColors.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: context.appBorderRadius(all: 10),
                          borderSide: const BorderSide(color: CustomColors.purple),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: context.appBorderRadius(all: 10),
                          borderSide: const BorderSide(color: CustomColors.border),
                        ),
                      ),
                    ),
                    context.verticalSpace(20),
                    Container(
                      padding: context.appEdgeInsets(
                        vertical: 15,
                        horizontal: 20,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: context.appBorderRadius(all: 20),
                        color: const Color(0xFFEFF6FF),
                        border: Border.all(color: const Color(0XFFBEDBFF)),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            SvgAssets.pushNotification,
                            height: context.w(30),
                            width: context.w(30),
                          ),
                          context.horizontalSpace(12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Notification Preview',
                                style: context.fonts.black20w600,
                              ),
                              context.horizontalSpace(12),
                              Text(
                                'Your notification preview will appear here',
                                style: context.fonts.black16w400,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    context.verticalSpace(20),
                    Divider(color: Colors.grey.shade300, height: 0),
                    context.verticalSpace(34.5),
                    Text.rich(
                      TextSpan(
                        text: 'This notification will be sent to ',
                        style: context.fonts.black16w500, // normal text
                        children: [
                          TextSpan(
                            text: '1247 users',
                            style: context.fonts.black18w600, // BIG text
                          ),
                        ],
                      ),
                    ),
                    context.verticalSpace(34.5),
                  ],
                ),
              ),
              context.verticalSpace(20),
              Container(
                padding: context.appEdgeInsets(all: 20),
                decoration: BoxDecoration(
                  borderRadius: context.appBorderRadius(all: 20),
                  border: Border.all(color: CustomColors.border),
                ),
                child: Column(
                  children: [
                    Text(
                      'Notification History',
                      style: context.fonts.black20w600,
                    ),
                    context.verticalSpace(20),
                    const PushNotificationTable(),
                     context.verticalSpace(20),
                  ],
                ),
              ),
              context.verticalSpace(20),
              Container(
                width: double.infinity,
                padding: context.appEdgeInsets(vertical: 15, horizontal: 15),
                decoration: BoxDecoration(
                  borderRadius: context.appBorderRadius(all: 20),
                  color: const Color(0xFFFAF5FF),
                  border: Border.all(color: const Color(0XFFE9D4FF)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Best Practices for Push Notifications:',
                      style: context.fonts.black20w600,
                    ),
                    context.verticalSpace(5),
                    Text(
                      ' • Keep titles short and actionable (under 50 characters)',
                      style: context.fonts.black16w400,
                    ),
                    context.verticalSpace(5),
                    Text(
                      ' • Make messages clear and concise (under 200 characters)',
                      style: context.fonts.black16w400,
                    ),
                    context.verticalSpace(5),
                    Text(
                      ' • Target the right audience to improve engagement',
                      style: context.fonts.black16w400,
                    ),
                    context.verticalSpace(5),
                    Text(
                      ' • Avoid sending too many notifications to prevent user fatigue',
                      style: context.fonts.black16w400,
                    ),
                    context.verticalSpace(5),
                    Text(
                      ' • Use notifications for important updates, offers, and alerts only',
                      style: context.fonts.black16w400,
                    ),
                  ],
                ),
              ),
              context.verticalSpace(30),
            ],
          ),
        ),
      ),
    );
  }
}

class PushNotificationTable extends StatelessWidget {
  const PushNotificationTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: context.appBorderRadius(all: 8),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: ConstrainedBox(
              constraints: BoxConstraints(minWidth: constraints.maxWidth),
              child: DataTable(
                headingRowColor: WidgetStateProperty.all(
                  Colors.grey.shade100,
                ),
                headingRowHeight: context.h(50),
                dataRowMinHeight: context.h(60),
                dataRowMaxHeight: context.h(60),
                columnSpacing: context.w(40),
                border: TableBorder(
                  horizontalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                  verticalInside: BorderSide(
                    color: Colors.grey.shade300,
                    width: 1,
                  ),
                ),
                columns: [
                  DataColumn(
                    columnWidth: FixedColumnWidth(context.w(176)),
                    label: Text('Title', style: context.fonts.black16w600),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(context.w(260)),
                    label: Text('Message',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis, 
                    style: context.fonts.black16w600),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(context.w(192)),
                    label: Text('Audience', style: context.fonts.black16w600),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(context.w(130)),
                    label: Text('Recipients', style: context.fonts.black16w600),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(context.w(102)),
                    label: Text('Sent At', style: context.fonts.black16w600),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(context.w(130)),
                    label: Text('Sent At', style: context.fonts.black16w600),
                  ),
                  DataColumn(
                    columnWidth: FixedColumnWidth(context.w(114)),
                    label: Text('Status', style: context.fonts.black16w600),
                  ),
                ],
                rows: [
                  _buildDataRow(
                    context,
                    'New Feature Launch',
                    'Check out our new AI-powered skin consultation feature!',
                    'Radiant Skin Clinic',
                    'All Users',
                    '1,247',
                    'Nov 1, 2025, 10:30 AM',
                    'Sent',
                  ),
                  _buildDataRow(
                    context,
                    'New Feature Launch',
                    'Check out our new AI-powered skin consultation feature!',
                    'Radiant Skin Clinic',
                    'All Users',
                    '1,247',
                    'Nov 1, 2025, 10:30 AM',
                    'Sent',
                  ),
                  _buildDataRow(
                    context,
                    'New Feature Launch',
                    'Check out our new AI-powered skin consultation feature!',
                    'Radiant Skin Clinic',
                    'All Users',
                    '1,247',
                    'Nov 1, 2025, 10:30 AM',
                    'Sent',
                  ),
                  _buildDataRow(
                    context,
                    'New Feature Launch',
                    'Check out our new AI-powered skin consultation feature!',
                    'Radiant Skin Clinic',
                    'All Users',
                    '1,247',
                    'Nov 1, 2025, 10:30 AM',
                    'Sent',
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  DataRow _buildDataRow(
    BuildContext context,
    String title,
    String message,
    String audience,
    String recipients,
    String sentAtTime,
    String sentAtDate,
    String status,
  ) {
    return DataRow(
      cells: [
        DataCell(Text(title, style: context.fonts.black14w400)),
        DataCell(Text(message, style: context.fonts.black14w400)),
        DataCell(Text(audience, style: context.fonts.black14w400)),
        DataCell(Text(recipients, style: context.fonts.black14w400)),
        DataCell(Text(sentAtTime, style: context.fonts.black14w400)),
        DataCell(Text(sentAtDate, style: context.fonts.black14w400)),
        DataCell(
          Container(
            padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: CustomColors.green,
              borderRadius: context.appBorderRadius(all: 20),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.white,
                  size: context.sp(10),
                ),
                context.horizontalSpace(10),
                Text(status, style: context.fonts.white16w400),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
