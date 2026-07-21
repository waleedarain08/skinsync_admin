import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:skinsync_admin/models/responses/booking_configuration_response.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/view_models/booking_config_view_model.dart';
import 'package:skinsync_admin/widgets/app_network_image.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/dailogbox/appointment_type_dialog.dart';
import 'package:skinsync_admin/widgets/dailogbox/booking_method_dialog.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';

class BookingConfigScreen extends ConsumerStatefulWidget {
  static const String routeName = '/booking-config';
  const BookingConfigScreen({super.key});

  @override
  ConsumerState<BookingConfigScreen> createState() => _BookingConfigScreenState();
}

class _BookingConfigScreenState extends ConsumerState<BookingConfigScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(bookingConfigViewModelProvider.notifier).fetchBookingConfig();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(bookingConfigViewModelProvider);

    return GradientScaffold(
      appBar: AppBar(
        title: Text('Booking Configuration', style: context.fonts.black18w600),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const BackButton(color: Colors.black),
      ),
      body: state.loading && state.config == null
          ? const Center(child: CircularProgressIndicator())
          : state.errorMessage != null
              ? Center(child: Text(state.errorMessage!))
              : SingleChildScrollView(
                  padding: context.appEdgeInsets(all: 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionHeader(
                        'Booking Methods',
                        'Manage and configure descriptions for your available booking channels.',
                        onAdd: () => _showBookingMethodDialog(context),
                      ),
                      context.verticalSpace(16),
                      _buildBookingMethodsList(state.config?.bookingMethods ?? []),
                      context.verticalSpace(32),
                      _buildSectionHeader(
                        'Appointment Types',
                        'Set timing rules and maximum durations for different clinical sessions.',
                        onAdd: () => _showAppointmentTypeDialog(context),
                      ),
                      context.verticalSpace(16),
                      _buildAppointmentTypesList(state.config?.appointmentTypes ?? []),
                    ],
                  ),
                ),
    );
  }

  Widget _buildSectionHeader(String title, String description, {VoidCallback? onAdd}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: context.fonts.black18w600),
            if (onAdd != null)
              IconButton(
                onPressed: onAdd,
                icon: const Icon(Icons.add_circle_outline_rounded, color: CustomColors.purple),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
          ],
        ),
        context.verticalSpace(4),
        Text(description, style: context.fonts.grey13w500),
      ],
    );
  }

  Widget _buildBookingMethodsList(List<BookingMethodModel> methods) {
    if (methods.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No booking methods found'),
      ));
    }

    return BorderdContainerWidget(
      padding: EdgeInsets.zero,
      child: ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: methods.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (context, index) {
          final method = methods[index];
          return ListTile(
            contentPadding: context.appEdgeInsets(horizontal: 20, vertical: 12),
            leading: Container(
              padding: context.appEdgeInsets(all: 10),
              decoration: BoxDecoration(
                color: CustomColors.palePurple,
                borderRadius: context.appBorderRadius(all: 10),
              ),
              child: method.icon != null && method.icon!.isNotEmpty
                  ? AppNetworkImage(imageUrl: method.icon!, width: 20, height: 20)
                  : const Icon(Icons.language_rounded, color: CustomColors.purple, size: 20),
            ),
            title: Row(
              children: [
                Text(method.title, style: context.fonts.black14w600),
                context.horizontalSpace(8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: CustomColors.softGrey,
                    borderRadius: context.appBorderRadius(all: 4),
                  ),
                  child: Text(
                    method.key,
                    style: context.fonts.grey10w700.copyWith(fontSize: 8),
                  ),
                ),
              ],
            ),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(method.description, style: context.fonts.grey12w400),
            ),
            trailing: IconButton(
              onPressed: () => _showBookingMethodDialog(context, method: method),
              icon: const Icon(Icons.edit_outlined, color: CustomColors.purple, size: 20),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppointmentTypesList(List<AppointmentTypeModel> types) {
    if (types.isEmpty) {
      return const Center(child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Text('No appointment types found'),
      ));
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: types.length,
      separatorBuilder: (context, index) => context.verticalSpace(16),
      itemBuilder: (context, index) {
        final type = types[index];

        return Container(
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            borderRadius: context.appBorderRadius(all: 16),
            border: Border.all(color: CustomColors.border),
          ),
          child: Stack(
            children: [
              if (type.image != null && type.image!.isNotEmpty)
                Positioned.fill(
                  child: AppNetworkImage(
                    imageUrl: type.image!,
                    fit: BoxFit.cover,
                  ),
                ),
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      stops: const [0.0, 0.5, 1.0],
                      colors: [
                        Colors.white,
                        Colors.white.withValues(alpha: 0.9),
                        Colors.white.withValues(alpha: 0.4),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: context.appEdgeInsets(all: 20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: context.appEdgeInsets(all: 12),
                      decoration: BoxDecoration(
                        color: CustomColors.palePurple,
                        borderRadius: context.appBorderRadius(all: 12),
                      ),
                      child: type.icon != null && type.icon!.isNotEmpty
                          ? AppNetworkImage(imageUrl: type.icon!, width: 24, height: 24)
                          : const Icon(Icons.medical_services_outlined, color: CustomColors.purple, size: 24),
                    ),
                    context.horizontalSpace(16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(type.title, style: context.fonts.black16w700),
                              context.horizontalSpace(12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: CustomColors.softGrey,
                                  borderRadius: context.appBorderRadius(all: 6),
                                  border: Border.all(color: CustomColors.border.withValues(alpha: 0.1)),
                                ),
                                child: Text(
                                  type.timing,
                                  style: context.fonts.grey10w700.copyWith(fontSize: 10),
                                ),
                              ),
                              context.horizontalSpace(8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: CustomColors.palePurple.withValues(alpha: 0.5),
                                  borderRadius: context.appBorderRadius(all: 5),
                                ),
                                child: Text(
                                  'Key: ${type.key}',
                                  style: context.fonts.purple11w600.copyWith(fontSize: 9),
                                ),
                              ),
                            ],
                          ),
                          context.verticalSpace(8),
                          Text(
                            type.description,
                            style: context.fonts.grey14w400,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          context.verticalSpace(12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Duration: ${type.maxDuration} mins',
                                style: context.fonts.black13w600,
                              ),
                              Row(
                                children: type.appointmentModes.map((mode) {
                                  return Container(
                                    margin: const EdgeInsets.only(left: 8),
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: CustomColors.palePurple,
                                      borderRadius: context.appBorderRadius(all: 4),
                                      border: Border.all(color: CustomColors.purple.withValues(alpha: 0.2)),
                                    ),
                                    child: Text(
                                      mode,
                                      style: context.fonts.purple11w600.copyWith(fontSize: 9),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () => _showAppointmentTypeDialog(context, type: type),
                      icon: const Icon(Icons.edit_outlined, color: CustomColors.purple, size: 22),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showBookingMethodDialog(BuildContext context, {BookingMethodModel? method}) {
    showDialog(
      context: context,
      builder: (context) => BookingMethodDialog(method: method),
    );
  }

  void _showAppointmentTypeDialog(BuildContext context, {AppointmentTypeModel? type}) {
    showDialog(
      context: context,
      builder: (context) => AppointmentTypeDialog(type: type),
    );
  }
}
