import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/quote.dart';

class QuoteProvider with ChangeNotifier {
  Future<List<Quote>> getQuote() async {
    List<Quote> quoteList = [];
    var url = Uri.https('type.fit', '/api/quotes');
    var response = await http.get(url);
    var quotes = json.decode(response.body);
    for (int i = 0; i < quotes.length; i++) {
      quoteList.add(
        Quote(
          text: quotes[i]['text'],
          author: quotes[i]['author'] ?? 'N/A',
        ),
      );
    }
    return quoteList;
  }
}
