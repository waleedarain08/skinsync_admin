import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/responses/patient_treatment_request_response.dart';
import '../utils/string_utils.dart';
import '../utils/theme.dart';
import 'simulation_treatment_area_chip.widget.dart';

class SimulationTreatmentRequestCard extends StatefulWidget {
  final PatientTreatmentRequestData request;
  final void Function(int treatmentId)? onTreatmentTap;

  const SimulationTreatmentRequestCard({
    super.key,
    required this.request,
    this.onTreatmentTap,
  });

  @override
  State<SimulationTreatmentRequestCard> createState() =>
      _SimulationTreatmentRequestCardState();
}

class _SimulationTreatmentRequestCardState
    extends State<SimulationTreatmentRequestCard> {
  // Default directly to Treatments
  String _selectedSubTab = "Treatments";
  bool _isComparisonMode = false;
  bool _isExpanded = false;
  final Map<String, double> _sliderValues = {};

  // Helper getters for robust fallback strings
  String get _patientName {
    final name = widget.request.patientName?.trim();
    if (name != null && name.isNotEmpty) return name.capitalize;
    return 'N/A';
  }

  String get _patientEmail {
    final email = widget.request.patientEmail?.trim();
    if (email != null && email.isNotEmpty) return email;
    return 'N/A';
  }

  String get _optionName {
    final optName = widget.request.name.trim();
    if (optName.isNotEmpty) return optName.capitalize;
    return 'N/A';
  }

  @override
  Widget build(BuildContext context) {
    final request = widget.request;

    return Container(
      margin: EdgeInsets.only(bottom: context.h(16)),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(16)),
        border: Border.all(color: CustomColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Theme(
        // Remove default ExpansionTile dividers, splash, and focus colors
        data: Theme.of(context).copyWith(
          dividerColor: Colors.transparent,
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
        ),
        child: ExpansionTile(
          backgroundColor: CustomColors.white,
          collapsedBackgroundColor: CustomColors.white,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.r(16)),
          ),
          collapsedShape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.r(16)),
          ),
          tilePadding: context.appEdgeInsets(horizontal: 16, vertical: 8),
          childrenPadding: context.appEdgeInsets(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          onExpansionChanged: (expanded) {
            setState(() => _isExpanded = expanded);
          },

          // Header Avatar (Patient Image)
          leading: CircleAvatar(
            radius: context.r(24),
            backgroundColor: CustomColors.softGrey,
            backgroundImage:
                (request.patientImage != null &&
                        request.patientImage!.startsWith('http'))
                    ? CachedNetworkImageProvider(request.patientImage!)
                    : null,
            child:
                (request.patientImage == null ||
                        !request.patientImage!.startsWith('http'))
                    ? Text(
                        _patientName != 'N/A'
                            ? _patientName[0].toUpperCase()
                            : 'N/A',
                        style: context.fonts.black14w600,
                      )
                    : null,
          ),

          // Tile Header: Displays Patient Info & Option Name
          title: Text(
            'Patient: $_patientName',
            style: context.fonts.black16w600,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              context.verticalSpace(2),
              Text(
                'Email: $_patientEmail',
                style: context.fonts.grey12w400,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              context.verticalSpace(4),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Option: $_optionName',
                      style: context.fonts.black12w600,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    (request.createdAt != null &&
                            request.createdAt!.length >= 10)
                        ? request.createdAt!.substring(0, 10)
                        : 'N/A',
                    style: context.fonts.grey12w400,
                  ),
                ],
              ),
            ],
          ),

          children: [
            const Divider(),
            context.verticalSpace(12),
            Row(
              children: [
                /*
                // Simulation tab button hidden for now
                _buildSubTabButton(context, "Simulation"),
                context.horizontalSpace(12),
                */
                _buildSubTabButton(context, "Treatments"),
              ],
            ),
            context.verticalSpace(16),
            _buildTreatmentsList(context, request),
          ],
        ),
      ),
    );
  }

  Widget _buildSubTabButton(BuildContext context, String title) {
    final isSelected = _selectedSubTab == title;

    return Expanded(
      child: InkWell(
        onTap: () => setState(() => _selectedSubTab = title),
        borderRadius: BorderRadius.circular(context.r(100)),
        child: Container(
          height: context.h(40),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? CustomColors.purple : Colors.transparent,
            borderRadius: BorderRadius.circular(context.r(100)),
            border: isSelected ? null : Border.all(color: CustomColors.border),
          ),
          child: Text(
            title.capitalize,
            style: isSelected
                ? context.fonts.white14w600
                : context.fonts.black14w600,
          ),
        ),
      ),
    );
  }

  // ----- Simulation Tab (Commented out) -----

  /*
  Widget _buildImageComparison(
    BuildContext context,
    PatientTreatmentRequestData request,
  ) {
    final images = [
      if (request.frontImageBefore != null || request.frontImageAfter != null)
        ('Front View', request.frontImageBefore, request.frontImageAfter),
      if (request.leftImageBefore != null || request.leftImageAfter != null)
        ('Left Profile', request.leftImageBefore, request.leftImageAfter),
      if (request.rightImageBefore != null || request.rightImageAfter != null)
        ('Right Profile', request.rightImageBefore, request.rightImageAfter),
    ];

    if (images.isEmpty) {
      return Center(
        child: Padding(
          padding: context.appEdgeInsets(vertical: 20),
          child: Text(
            "No simulation images for this request",
            style: context.fonts.grey14w400,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                'Before & After Photos',
                style: context.fonts.black14w600,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              padding: context.appEdgeInsets(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(
                color: CustomColors.softGrey,
                borderRadius: BorderRadius.circular(context.r(12)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isComparisonMode ? "Slider View" : "Side by Side",
                    style: context.fonts.black12w600,
                  ),
                  SizedBox(width: context.w(4)),
                  Transform.scale(
                    scale: 0.7,
                    child: Switch.adaptive(
                      value: _isComparisonMode,
                      activeTrackColor: CustomColors.purple,
                      activeThumbColor: Colors.white,
                      inactiveTrackColor: Colors.grey.shade300,
                      onChanged: (val) =>
                          setState(() => _isComparisonMode = val),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        context.verticalSpace(12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(images.length, (index) {
              final (label, before, after) = images[index];
              final isLast = index == images.length - 1;

              Widget item;
              if (before != null && after != null && _isComparisonMode) {
                final key = '${request.id}_$label';
                _sliderValues.putIfAbsent(key, () => 0.5);

                item = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: context.fonts.grey12w600),
                    context.verticalSpace(8),
                    Container(
                      height: context.h(280),
                      width: context.w(280),
                      decoration: BoxDecoration(
                        color: CustomColors.softGrey,
                        borderRadius: BorderRadius.circular(context.r(16)),
                        border: Border.all(color: CustomColors.border),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Stack(
                        children: [
                          BeforeAfter(
                            value: _sliderValues[key]!,
                            onValueChanged: (value) =>
                                setState(() => _sliderValues[key] = value),
                            before: _buildComparisonImageOnly(
                              context,
                              before,
                              'Before',
                            ),
                            after: _buildComparisonImageOnly(
                              context,
                              after,
                              'After',
                            ),
                            trackColor: Colors.white,
                            trackWidth: context.w(2),
                            thumbDecoration: const BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage(PngAssets.customMarker),
                                fit: BoxFit.contain,
                              ),
                            ),
                            thumbWidth: context.w(32),
                            thumbHeight: context.w(32),
                          ),
                          Positioned(
                            top: context.h(12),
                            left: context.w(12),
                            child: _buildBadge(
                              "BEFORE",
                              Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                          Positioned(
                            top: context.h(12),
                            right: context.w(12),
                            child: _buildBadge(
                              "AFTER",
                              Colors.black.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                item = Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: context.fonts.grey12w600),
                    context.verticalSpace(8),
                    SizedBox(
                      width: context.w(280),
                      child: Row(
                        children: [
                          Expanded(
                            child: _buildComparisonImage(
                              context,
                              before,
                              'Before',
                            ),
                          ),
                          context.horizontalSpace(8),
                          Expanded(
                            child: _buildComparisonImage(
                              context,
                              after,
                              'After',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }

              return Padding(
                padding: EdgeInsets.only(right: isLast ? 0 : context.w(16)),
                child: item,
              );
            }),
          ),
        ),
      ],
    );
  }

  Widget _buildComparisonImageOnly(
    BuildContext context,
    String? url,
    String label,
  ) {
    return url != null
        ? (url.startsWith('http')
            ? CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                errorWidget: (context, url, error) =>
                    const Icon(Icons.broken_image, size: 24),
              )
            : Image.asset(
                url,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image, size: 24),
              ))
        : Center(child: Text(label, style: context.fonts.grey12w400));
  }

  Widget _buildBadge(String text, Color bgColor) {
    return Container(
      padding: context.appEdgeInsets(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(context.r(4)),
      ),
      child: Text(
        text,
        style: context.fonts.white12w700.copyWith(
          letterSpacing: 0.8,
          fontSize: context.sp(10),
        ),
      ),
    );
  }

  Widget _buildComparisonImage(
    BuildContext context,
    String? url,
    String label,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: context.h(160),
          width: double.infinity,
          decoration: BoxDecoration(
            color: CustomColors.softGrey,
            borderRadius: BorderRadius.circular(context.r(12)),
            border: Border.all(color: CustomColors.border),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(context.r(12)),
            child: url != null
                ? (url.startsWith('http')
                    ? CachedNetworkImage(
                        imageUrl: url,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.broken_image, size: 24),
                      )
                    : Image.asset(
                        url,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.broken_image, size: 24),
                      ))
                : Center(child: Text(label, style: context.fonts.grey12w400)),
          ),
        ),
        context.verticalSpace(4),
        Center(
          child: Text(
            label,
            style: context.fonts.black12w600.copyWith(
              color: label == 'Before' ? CustomColors.red : CustomColors.green,
            ),
          ),
        ),
      ],
    );
  }
  */

  // ----- Treatments Tab -----

  Widget _buildTreatmentsList(
    BuildContext context,
    PatientTreatmentRequestData request,
  ) {
    if (request.treatments.isEmpty) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Padding(
          padding: context.appEdgeInsets(vertical: 20),
          child: Text(
            "No treatments for this request",
            style: context.fonts.grey14w400,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: request.treatments.asMap().entries.map((entry) {
        final index = entry.key;
        final treatment = entry.value;

        return Padding(
          padding: EdgeInsets.only(bottom: context.h(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(bottom: context.h(8)),
                child: Text(
                  "Treatment - ${index + 1}",
                  style: context.fonts.black16w600,
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SimulationTreatmentAreaChip(
                  icon: treatment.icon,
                  imageUrl: treatment.image,
                  label: treatment.treatmentName.capitalize,
                  isTreatment: true,
                  onTap: () =>
                      widget.onTreatmentTap?.call(treatment.treatmentId),
                ),
              ),
              if (treatment.areas.isNotEmpty) ...[
                SizedBox(height: context.h(12)),
                Padding(
                  padding: EdgeInsets.only(
                    left: context.w(4),
                    bottom: context.h(8),
                  ),
                  child: Text(
                    "Selected Areas",
                    style: context.fonts.black14w600.copyWith(
                      color: CustomColors.grey,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    spacing: context.w(8),
                    runSpacing: context.h(8),
                    children: treatment.areas.map((area) {
                      final materialCount = area.materials
                          .where((m) => m.selectedQuantity > 0)
                          .length;

                      return SimulationTreatmentAreaChip(
                        icon: area.icon,
                        imageUrl: area.image,
                        label: area.areaName.capitalize,
                        isTreatment: false,
                        materialCount: materialCount,
                      );
                    }).toList(),
                  ),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}