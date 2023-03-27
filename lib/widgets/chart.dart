import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import 'chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  const Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues =>
      List.generate(7, (index) {
        final weekDay = DateTime.now().subtract(Duration(days: index));
        var totalSum = 0.0;
        for (var i = 0; i < recentTransactions.length; i++)
          if (recentTransactions[i].date.day == weekDay.day &&
              recentTransactions[i].date.month == weekDay.month &&
              recentTransactions[i].date.year == weekDay.year)
            totalSum += recentTransactions[i].amount;

        return {'day': DateFormat.E().format(weekDay)[0], 'amount': totalSum};
      }).reversed.toList();

  double get totalSpending => groupedTransactionValues.fold(
      0.0, (previousValue, element) => previousValue + element['amount']);

  @override
  Widget build(BuildContext context) {
    print('build() Chart');
    return Card(
      elevation: 6,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: groupedTransactionValues
              .map(
                (transaction) => Flexible(
                  // With FlexFit.tight we then ensure that the child also can't
                  // grow because by default every child has the same space but
                  // child can grow and take some space away from other children
                  // if they need to. With tight, we force a child its assigned
                  // width or into its assigned size and it can't grow
                  fit: FlexFit.tight,
                  child: ChartBar(
                    transaction['day'],
                    transaction['amount'],
                    totalSpending == 0.0
                        ? 0.0
                        : (transaction['amount'] as double) / totalSpending,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
