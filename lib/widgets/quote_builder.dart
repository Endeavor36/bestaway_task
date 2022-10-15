import 'package:flutter/material.dart';

import '../models/quote.dart';

class QuoteBuilder extends StatefulWidget {
  const QuoteBuilder({
    Key? key,
    required this.quotes,
  }) : super(key: key);

  final List<Quote> quotes;

  @override
  State<QuoteBuilder> createState() => _QuoteBuilderState();
}

class _QuoteBuilderState extends State<QuoteBuilder> {
  Future<void> _refresh() async {
    await Future.delayed(const Duration(milliseconds: 500));
    setState(() {
      widget.quotes.shuffle();
    });
  }

  @override
  void initState() {
    super.initState();
    widget.quotes.shuffle();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView.builder(
        itemCount: widget.quotes.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purple[50],
              foregroundColor: Colors.purple[800],
              child: Text(
                (index + 1).toString(),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            title: Text(widget.quotes[index].text),
            subtitle: Text(widget.quotes[index].author!),
          );
        },
      ),
    );
  }
}
