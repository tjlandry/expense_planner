import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';
import './chart_bar.dart';

class Chart extends StatelessWidget {
  final List<Transaction> recentTransactions;

  Chart(this.recentTransactions);

  List<Map<String, Object>> get groupedTransactionValues {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(Duration(days: index));
      double totalSum = 0;

      for (var d = 0; d < recentTransactions.length; d++) {
        if (recentTransactions[d].date.day == weekDay.day &&
            recentTransactions[d].date.month == weekDay.month &&
            recentTransactions[d].date.year == weekDay.year) {
          totalSum += recentTransactions[d].amount;
        }
      }

      return {
        'day': DateFormat.Md().format(weekDay),
        'amount': totalSum
      };
    });
  }

  double get totalSpending {
    return groupedTransactionValues.fold(
        0.0, (sum, item) => sum + item['amount']);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 6,
        margin: EdgeInsets.all(15),
        color: Theme.of(context).backgroundColor,
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues
                .map((data) => Flexible(
                  fit: FlexFit.tight,
                  child: ChartBar(
                      label: data['day'],
                      spendingAmount: data['amount'],
                      spendingPercentage: totalSpending == 0.0
                          ? 0.0
                          : (data['amount'] as double) / totalSpending),
                ))
                .toList(),
          ),
        ));
  }
}
