import 'package:before_after/before_after.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../models/responses/patient_treatment_request_response.dart';
import '../utils/assets.dart';
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
  String _selectedSubTab = "Simulation";
  bool _isComparisonMode = false;
  final Map<String, double> _sliderValues = {};

  @override
  Widget build(BuildContext context) {
    final request = widget.request;

    return Container(
      margin: EdgeInsets.only(bottom: context.h(20)),
      padding: context.appEdgeInsets(all: 16),
      decoration: BoxDecoration(
        color: CustomColors.white,
        borderRadius: BorderRadius.circular(context.r(20)),
        border: Border.all(color: CustomColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.assignment_outlined,
                size: 22,
                color: CustomColors.purple,
              ),
              context.horizontalSpace(12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(request.name, style: context.fonts.black18w600),
                    Text(
                      'Request Date: ${request.createdAt?.substring(0, 10) ?? ""}',
                      style: context.fonts.grey12w400,
                    ),
                  ],
                ),
              ),
            ],
          ),
          context.verticalSpace(16),
          Row(
            children: [
              _buildSubTabButton(context, "Simulation"),
              context.horizontalSpace(12),
              _buildSubTabButton(context, "Treatments"),
            ],
          ),
          context.verticalSpace(16),
          if (_selectedSubTab == "Simulation")
            _buildImageComparison(context, request)
          else
            _buildTreatmentsList(context, request),
        ],
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
          height: context.h(45),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isSelected ? CustomColors.purple : Colors.transparent,
            borderRadius: BorderRadius.circular(context.r(100)),
            border: isSelected ? null : Border.all(color: CustomColors.border),
          ),
          child: Text(
            title,
            style: isSelected
                ? context.fonts.white14w600
                : context.fonts.black14w600,
          ),
        ),
      ),
    );
  }

  // ----- Simulation tab (before/after photos, row layout) -----

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
                maxLines: 2,
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
                      height: context.h(326),
                      width: context.w(300),
                      decoration: BoxDecoration(
                        color: CustomColors.softGrey,
                        borderRadius: BorderRadius.circular(context.r(20)),
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
                      width: context.w(300),
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
      padding: context.appEdgeInsets(horizontal: 10, vertical: 4),
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
          height: context.h(180),
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

  // ----- Treatments tab (chips) -----

  Widget _buildTreatmentsList(
    BuildContext context,
    PatientTreatmentRequestData request,
  ) {
    if (request.treatments.isEmpty) {
      return Center(
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
              SimulationTreatmentAreaChip(
                icon: treatment.icon,
                imageUrl: treatment.image,
                label: treatment.treatmentName,
                isTreatment: true,
                onTap: () => widget.onTreatmentTap?.call(treatment.treatmentId),
              ),
              if (treatment.areas.isNotEmpty) ...[
                SizedBox(height: context.h(16)),
                Padding(
                  padding: EdgeInsets.only(
                    left: context.w(4),
                    bottom: context.h(10),
                  ),
                  child: Text(
                    "Selected Areas",
                    style: context.fonts.black14w600.copyWith(
                      color: CustomColors.grey,
                    ),
                  ),
                ),
                Wrap(
                  spacing: context.w(8),
                  runSpacing: context.h(8),
                  children: treatment.areas.map((area) {
                    final materialCount = area.materials
                        .where((m) => m.selectedQuantity > 0)
                        .length;

                    return SimulationTreatmentAreaChip(
                      icon: area.icon,
                      imageUrl: area.image,
                      label: area.areaName,
                      isTreatment: false,
                      materialCount: materialCount,
                    );
                  }).toList(),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
