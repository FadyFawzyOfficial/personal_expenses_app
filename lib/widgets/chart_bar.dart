import 'package:flutter/material.dart';

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double spendingPercentOfTotal;

  const ChartBar(
    this.label,
    this.spendingAmount,
    this.spendingPercentOfTotal,
  );

  @override
  Widget build(BuildContext context) {
    // print('build() ChartBar');
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) => Column(
        children: [
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                '\$${spendingAmount.toStringAsFixed(0)}',
              ),
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(220, 220, 220, 1),
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                FractionallySizedBox(
                  heightFactor: spendingPercentOfTotal,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: constraints.maxHeight * 0.05,
          ),
          Container(
            height: constraints.maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                label,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
