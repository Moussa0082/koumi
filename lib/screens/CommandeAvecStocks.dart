
//  import 'dart:convert';
// import 'package:http/http.dart' as http;

// class CommandeAvecStocks {
//   Commande commande;
//   List<Stock> stocks;
//   List<double> quantitesDemandees;

//   CommandeAvecStocks({
//     required this.commande,
//     required this.stocks,
//     required this.quantitesDemandees,
//   });

//   Map<String, dynamic> toJson() {
//     return {
//       'commande': commande.toJson(),
//       'stocks': stocks.map((stock) => stock.toJson()).toList(),
//       'quantitesDemandees': quantitesDemandees,
//     };
//   }
// }