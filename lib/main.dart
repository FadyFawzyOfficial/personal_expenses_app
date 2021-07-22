import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'models/transaction.dart';
import 'widgets/new_transaction.dart';
import 'widgets/transactions_list.dart';
import 'widgets/chart.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // // Force the app to be view into portrait mode
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',
        // Setup my own textTheme
        textTheme: ThemeData.light().textTheme.copyWith(
              headline6: TextStyle(
                fontFamily: 'Quicksand',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              button: TextStyle(
                color: Colors.white,
              ),
            ),
        // Define an AppBar's text font family
        appBarTheme: AppBarTheme(
          // Assign a new text theme for our app bar so that all text elements
          // in the app bar received that theme, and we based it on the default
          // text theme so that we don't have to override everything like font
          // size and so on. But we use the default text theme and copy that with
          // some new overwritten values. We don't overwrite all text in there,
          // but text, which is marked as a title
          textTheme: ThemeData.light().textTheme.copyWith(
                headline6: TextStyle(
                  fontFamily: 'OpenSans',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Transaction> _userTransactions = [
    Transaction(
      id: 't1',
      title: 'New Shoes',
      amount: 99.99,
      date: DateTime.now(),
    ),
    Transaction(
      id: 't2',
      title: 'Weekly Groceries',
      amount: 80.00,
      date: DateTime.now(),
    ),
  ];

  bool _showChart = false;

  List<Transaction> get _recentTransactions => _userTransactions
      .where(
        (transaction) => transaction.date.isAfter(
          DateTime.now().subtract(
            Duration(days: 7),
          ),
        ),
      )
      .toList();

  void _addNewTransaction(String title, double amount, DateTime date) {
    final newTransaction = Transaction(
      id: DateTime.now().toString(),
      title: title,
      amount: amount,
      date: date,
    );

    setState(() => _userTransactions.add(newTransaction));
  }

  void _deleteTransaction(String id) => setState(() =>
      _userTransactions.removeWhere((transaction) => transaction.id == id));

  void _startAddNewTransaction(BuildContext context) {
    showModalBottomSheet(
      context: context,
      // this will allow the bottom sheet to take the full required height which
      // gives more insurance that TextField is not covered by the keyboard.
      isScrollControlled: true,
      builder: (_) => NewTransaction(_addNewTransaction),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = mediaQuery.orientation == Orientation.landscape;
    // Because of declaring the appBar as a final variable here, I can no access
    // anywhere since it's stored in that variable, has information about the
    // height of the appBar.
    final PreferredSizeWidget appBar = Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal Expenses'),
            trailing: Row(
              // MainAxisSize. By default, it takes all the width it can get as
              // a row (same for the column), the the row will shrink along its
              // main axis,to be only as big as its children need to be.
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddNewTransaction(context),
                ),
              ],
            ),
          )
        : AppBar(
            title: Text('Personal Expenses'),
            actions: [
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddNewTransaction(context),
              ),
            ],
          );

    final transactionListContainer = Container(
      height: (mediaQuery.size.height -
              appBar.preferredSize.height -
              mediaQuery.padding.top) *
          0.7,
      child: TransactionList(_userTransactions, _deleteTransaction),
    );

    // SafeArea makes sure that everything is positioned within the boundaries
    // or moved down a bit, moved up a bit so that we respect these reserved
    // areas on the screen (top or bottom notch)
    final pageBody = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (isLandscape)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Show Chart'),
                  // the adaptive constructor takes the same configuration as the
                  // normal Switch but the difference here is that is automatically
                  // adjusts the look based on the platform.
                  Switch.adaptive(
                    // You might want to keep the general color theme.
                    activeColor: Theme.of(context).accentColor,
                    value: _showChart,
                    onChanged: (value) => setState(() => _showChart = value),
                  )
                ],
              ),
            if (!isLandscape)
              Container(
                height: (
                        // The full height of the device screen.
                        mediaQuery.size.height -
                            // The height of the appBar.
                            appBar.preferredSize.height -
                            // The height of the system status bar.
                            mediaQuery.padding.top) *
                    0.3,
                child: Chart(_recentTransactions),
              ),
            if (!isLandscape) transactionListContainer,
            if (isLandscape)
              _showChart
                  ? Container(
                      height: (
                              // The full height of the device screen.
                              mediaQuery.size.height -
                                  // The height of the appBar.
                                  appBar.preferredSize.height -
                                  // The height of the system status bar.
                                  mediaQuery.padding.top) *
                          0.7,
                      child: Chart(_recentTransactions),
                    )
                  : transactionListContainer,
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            child: pageBody,
            navigationBar: appBar,
          )
        : Scaffold(
            appBar: appBar,
            body: pageBody,
            floatingActionButton: Platform.isIOS
                ? Container() // Render nothing on IOS Platform.
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddNewTransaction(context),
                  ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
