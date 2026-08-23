import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:skinsync_admin/utils/theme.dart';
import 'package:skinsync_admin/widgets/borderd_container_widget.dart';
import 'package:skinsync_admin/widgets/gradient_scaffold.dart';
import 'package:skinsync_admin/widgets/mini_stat_card.dart';

import '../widgets/dailogbox/payment_dailog_box.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});
  static const String routeName = '/payment-screen';

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      body: SingleChildScrollView(
        padding: context.appEdgeInsets(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            context.verticalSpace(32),
            _buildPaymentMetrics(context),
            context.verticalSpace(32),
            _buildRecentTransactionsTable(context),
            context.verticalSpace(32),
            _buildPayoutRequestsTable(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Financial Console', style: context.fonts.level1Heading),
        context.verticalSpace(8),
        Text(
          'Monitor network-wide transactions, commissions, and clinic payouts.',
          style: context.fonts.grey14w400,
        ),
      ],
    );
  }

  Widget _buildPaymentMetrics(BuildContext context) {
    return Row(
      children: [
        const MiniStatCard(
          title: 'Total Network GMV',
          value: 124500,
          prefix: '\$',
          icon: Icons.account_balance_wallet_outlined,
          color: CustomColors.purple,
        ),
        context.horizontalSpace(16),
        const MiniStatCard(
          title: 'Net Platform Revenue',
          value: 18675,
          prefix: '\$',
          icon: Icons.trending_up_rounded,
          color: CustomColors.green,
        ),
        context.horizontalSpace(16),
        const MiniStatCard(
          title: 'Pending Payouts',
          value: 4200,
          prefix: '\$',
          icon: Icons.hourglass_empty_rounded,
          color: CustomColors.amber,
        ),
        context.horizontalSpace(16),
        const MiniStatCard(
          title: 'Active Subscriptions',
          value: 142,
          icon: Icons.sync_rounded,
          color: CustomColors.black,
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsTable(BuildContext context) {
    return BorderdContainerWidget(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: context.appEdgeInsets(all: 20),
            child: Text(
              'Global Transactions',
              style: context.fonts.subHeading,
            ),
          ),
          SizedBox(
            height: context.h(300),
            child: DataTable2(
              columnSpacing: 24,
              horizontalMargin: 20,
              minWidth: 1000,
              headingRowColor: WidgetStateProperty.all(CustomColors.softGrey),
              columns: const [
                DataColumn2(label: Text('DATE'), size: ColumnSize.M),
                DataColumn2(label: Text('CLINIC'), size: ColumnSize.L),
                DataColumn2(label: Text('AMOUNT'), size: ColumnSize.S),
                DataColumn2(label: Text('COMMISSION'), size: ColumnSize.S),
                DataColumn2(label: Text('STATUS'), size: ColumnSize.S),
                DataColumn2(label: Text('ACTIONS'), size: ColumnSize.S),
              ],
              rows: List.generate(5, (index) => _transactionRow(context)),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _transactionRow(BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text('Oct 24, 14:20', style: context.fonts.black14w400)),
        DataCell(Text('Radiant Skin Care', style: context.fonts.black14w400)),
        DataCell(Text('\$250.00', style: context.fonts.black14w400)),
        DataCell(
          Text(
            '\$37.50',
            style: context.fonts.black14w400.copyWith(
              color: CustomColors.green,
            ),
          ),
        ),
        DataCell(_statusBadge('Completed')),
        DataCell(
          IconButton(
            icon: const Icon(Icons.receipt_long_outlined, size: 20),
            onPressed: () {
              showDialog(
                context: context,
                builder: (_) => const TransactionDetailsDialog(),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildPayoutRequestsTable(BuildContext context) {
    return BorderdContainerWidget(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: context.appEdgeInsets(all: 20),
            child: Text('Pending Payouts', style: context.fonts.black20w600),
          ),
          SizedBox(
            height: context.h(300),
            child: DataTable2(
              columnSpacing: 24,
              horizontalMargin: 20,
              minWidth: 1000,
              headingRowColor: WidgetStateProperty.all(CustomColors.softGrey),
              columns: const [
                DataColumn2(label: Text('CLINIC'), size: ColumnSize.L),
                DataColumn2(
                  label: Text('REQUESTED AMOUNT'),
                  size: ColumnSize.M,
                ),
                DataColumn2(label: Text('BANK ACCOUNT'), size: ColumnSize.L),
                DataColumn2(label: Text('ACTIONS'), size: ColumnSize.M),
              ],
              rows: List.generate(2, (index) => _payoutRow(context)),
            ),
          ),
        ],
      ),
    );
  }

  DataRow _payoutRow(BuildContext context) {
    return DataRow(
      cells: [
        DataCell(Text('Aura Med Spa', style: context.fonts.black14w400)),
        DataCell(Text('\$1,450.00', style: context.fonts.black14w600)),
        DataCell(Text('Chase Bank •••• 4421', style: context.fonts.grey13w500)),
        DataCell(
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: CustomColors.purple,
              minimumSize: Size(context.w(120), context.h(36)),
            ),
            child: const Text('Approve Payout'),
          ),
        ),
      ],
    );
  }

  Widget _statusBadge(String status) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: CustomColors.green.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(status, style: CustomFonts.green14w600),
    );
  }
}
