import 'dart:typed_data';

import 'package:flutter/material.dart' as m;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';

import '../models/responses/category_detail_response.dart';
import '../models/treatment_data_models.dart';
import '../utils/theme.dart';
import '../view_models/category_view_model.dart';
import '../view_models/treatment_data_view_model.dart';
import '../view_models/treatment_view_model.dart';

class ProtocolFormPreview extends StatelessWidget {
  final TreatmentState state;
  final TreatmentDataState dataState;
  final CategoryState categoryState;

  ProtocolFormPreview({
    required this.state,
    required this.dataState,
    required this.categoryState,
  });

  static Future<Uint8List> getPdfBytes({
    required TreatmentState state,
    required TreatmentDataState dataState,
    required CategoryState categoryState,
  }) async {
    final document = Document();
    document.addPage(
      MultiPage(
        pageFormat: .a4,
        build: (_) {
          return [
            ProtocolFormPreview(
              state: state,
              dataState: dataState,
              categoryState: categoryState,
            ),
          ];
        },
      ),
    );
    return await document.save();
  }

  @override
  Widget build(Context mContext) {
    final selectedProtocols = dataState.protocols
        .where((p) => state.selectedProtocolIds.contains(p.id))
        .toList();

    final checkboxes = selectedProtocols
        .where((p) => p.type == ProtocolType.checkbox)
        .toList();

    final textFields = selectedProtocols
        .where((p) => p.type == ProtocolType.text)
        .toList();

    final CategoryDetailDto? selectedCategory = state.selectedCategoryDetail;

    List<TreatmentProtocolNoteItem> notesToShow = [];

    if (state.standaloneNotes.isNotEmpty) {
      notesToShow = state.standaloneNotes;
    } else if (selectedCategory != null) {
      notesToShow = _getCategoryDefaultNotes(selectedCategory);
    }

    final hasProtocols = selectedProtocols.isNotEmpty;
    final hasNotes = notesToShow.isNotEmpty;
    const border = PdfColor.fromInt(0xFFE2E8F0);
    if (!hasProtocols && !hasNotes) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        // padding: context.appEdgeInsets(all: 20),
        decoration: BoxDecoration(
          color: PdfColors.white,
          borderRadius: BorderRadius.circular(12),
          // borderRadius: context.appBorderRadius(all: 12),
          border: Border.all(color: border),
        ),
        child: Center(
          child: Text(
            'No clinical protocols configured yet.',
            // style: context.fonts.grey12w400,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.normal,
              color: PdfColors.grey,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      );
    } else {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        // padding: context.appEdgeInsets(all: 20),
        decoration: BoxDecoration(
          color: PdfColors.white,
          borderRadius: BorderRadius.circular(12),
          // borderRadius: context.appBorderRadius(all: 12),
          border: Border.all(color: border),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (checkboxes.isNotEmpty) ...[
              Text(
                'CHECKLIST',
                style: const TextStyle(fontSize: 10, fontWeight: .bold),
              ), // context.fonts.grey10w700ls1),
              SizedBox(height: 12),
              ...checkboxes.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  // padding: context.appEdgeInsets(bottom: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Container(
                          width: 18,
                          height: 18,
                          // width: context.w(18),
                          // height: context.w(18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4),
                            // borderRadius: context.appBorderRadius(all: 4),
                            border: Border.all(color: border, width: 1.5),
                          ),
                        ),
                      ),
                      SizedBox(height: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              p.title,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: .normal,
                              ),
                              // context.fonts.black13w400
                            ),
                            _ProtocolNotesWidget(
                              protocolName: p.title,
                              notes: state.selectedProtocolNotes,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (checkboxes.isNotEmpty && textFields.isNotEmpty)
              SizedBox(height: 12),

            if (textFields.isNotEmpty) ...[
              Text(
                'NOTES',
                style: const TextStyle(
                  color: PdfColors.grey,
                  fontSize: 10,
                  fontWeight: .bold,
                ),
                //  context.fonts.grey10w700ls1,
              ),
              SizedBox(height: 12),
              ...textFields.map(
                (p) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  // padding: context.appEdgeInsets(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p.title,
                        style: const TextStyle(fontSize: 12, fontWeight: .bold),
                        // context.fonts.black12w600,
                      ),
                      SizedBox(height: 8),
                      Container(
                        height: 40,
                        // height: mContext.h(40),
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const PdfColor.fromInt(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(8),
                          // borderRadius: mContext.appBorderRadius(all: 8),
                          border: Border.all(color: border),
                        ),
                      ),
                      _ProtocolNotesWidget(
                        protocolName: p.title,
                        notes: state.selectedProtocolNotes,
                      ),
                    ],
                  ),
                ),
              ),
            ],

            if (hasNotes) ...[
              if (hasProtocols) ...[
                SizedBox(height: 24),
                Divider(),
                SizedBox(height: 16),
              ],
              Text(
                'NOTES / INSTRUCTIONS',
                style: const TextStyle(
                  color: PdfColors.grey,
                  fontSize: 10,
                  fontWeight: .bold,
                ),
                // style: mContext.fonts.grey10w700ls1,
              ),
              SizedBox(height: 12),
              ...notesToShow.map(
                (note) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            IconData(m.Icons.info_outline.codePoint),
                            size: 14,
                            color: PdfColor.fromInt(CustomColors.purple.value),
                          ),
                          SizedBox(width: 8),
                          if (note.title != null && note.title!.isNotEmpty)
                            Expanded(
                              child: Text(
                                note.title!,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: .bold,
                                ),
                                // style: context.fonts.black13w600,
                              ),
                            ),
                        ],
                      ),
                      SizedBox(height: 4),
                      Padding(
                        padding: const EdgeInsets.only(left: 22),
                        child: Text(
                          note.description,
                          style: const TextStyle(
                            color: PdfColors.grey,
                            fontSize: 12,
                          ),
                          // style: context.fonts.grey12w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      );
    }
  }

  List<TreatmentProtocolNoteItem> _getCategoryDefaultNotes(
    CategoryDetailDto category,
  ) {
    // Move your existing implementation here
    return [];
  }
}

class _ProtocolNotesWidget extends StatelessWidget {
  final String protocolName;
  final List<TreatmentProtocolNote> notes;

  _ProtocolNotesWidget({required this.protocolName, required this.notes});

  @override
  Widget build(context) {
    final protocolNote = notes.firstWhere(
      (n) => n.protocolName == protocolName,
      orElse: () =>
          TreatmentProtocolNote(protocolName: protocolName, notes: []),
    );

    if (protocolNote.notes.isEmpty) {
      return SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Text(
          'Notes:',
          //  style:  context.fonts.black12w600,
        ),
        ...protocolNote.notes.map(
          (note) => Padding(
            padding: const EdgeInsets.only(left: 8, top: 4),
            child: Text(
              "• ${note.title != null && note.title!.isNotEmpty ? '${note.title}: ' : ''}${note.description}",
              // style: context.fonts.grey11w400,
            ),
          ),
        ),
      ],
    );
  }
}
