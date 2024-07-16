import 'package:flutter/material.dart';
import 'package:search_field_autocomplete/search_field_autocomplete.dart';

class AutoComplet {

  static List<SearchFieldAutoCompleteItem<String>> get getTransportVehicles {
    return const [
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Monospace', value: 'Monospace'),
      SearchFieldAutoCompleteItem<String>(searchKey: 'Camion', value: 'Camion'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Fourgon', value: 'Fourgon'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Minibus', value: 'Minibus'),
      SearchFieldAutoCompleteItem<String>(searchKey: 'Bus', value: 'Bus'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Autobus', value: 'Autobus'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Autocar', value: 'Autocar'),
      SearchFieldAutoCompleteItem<String>(searchKey: 'Taxi', value: 'Taxi'),
      SearchFieldAutoCompleteItem<String>(searchKey: 'Vélo', value: 'Vélo'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Scooter', value: 'Scooter'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Tricycle motorisé', value: 'Tricycle motorisé'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Voiture', value: 'Voiture'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Berline', value: 'Berline'),
      SearchFieldAutoCompleteItem<String>(searchKey: 'SUV', value: 'SUV'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Monospace', value: 'Monospace'),
      SearchFieldAutoCompleteItem<String>(searchKey: 'Coupé', value: 'Coupé'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Cabriolet', value: 'Cabriolet'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Limousine', value: 'Limousine'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Camion-citerne', value: 'Camion-citerne'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Camion frigorifique', value: 'Camion frigorifique'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Camion-benne', value: 'Camion-benne'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Tracteur routier', value: 'Tracteur routier'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Remorque', value: 'Remorque'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Semi-remorque', value: 'Semi-remorque'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Pick-up', value: 'Pick-up'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Motocyclette', value: 'Motocyclette'),
      SearchFieldAutoCompleteItem<String>(searchKey: 'Quad', value: 'Quad'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Tracteur', value: 'Tracteur'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Camion-bâché', value: 'Camion-bâché'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Camion à benne basculante',
          value: 'Camion à benne basculante'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Voiture électrique', value: 'Voiture électrique'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Bus électrique', value: 'Bus électrique'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Vélo électrique', value: 'Vélo électrique'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Scooter électrique', value: 'Scooter électrique'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Fourgon réfrigéré', value: 'Fourgon réfrigéré'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Camion plateau', value: 'Camion plateau'),
      SearchFieldAutoCompleteItem<String>(searchKey: 'Van', value: 'Van'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Camping-car', value: 'Camping-car'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Bus scolaire', value: 'Bus scolaire'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Tuk-tuk', value: 'Tuk-tuk'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Roulotte', value: 'Roulotte'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Ambulance', value: 'Ambulance'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Camion de pompiers', value: 'Camion de pompiers'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Dépanneuse', value: 'Dépanneuse'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Camionnette', value: 'Camionnette'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Remorque citerne', value: 'Remorque citerne'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Bus articulé', value: 'Bus articulé'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Camion surbaissé', value: 'Camion surbaissé'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Camion porte-conteneurs',
          value: 'Camion porte-conteneurs')
    ];
  }

  static List<SearchFieldAutoCompleteItem<String>> get getAgriculturalProducts {
  return const [
    SearchFieldAutoCompleteItem<String>(searchKey: 'Blé', value: 'Blé'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Riz', value: 'Riz'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Maïs', value: 'Maïs'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Orge', value: 'Orge'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Avoine', value: 'Avoine'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Sorgho', value: 'Sorgho'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Soja', value: 'Soja'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Haricot', value: 'Haricot'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pois', value: 'Pois'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Lentille', value: 'Lentille'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pois chiche', value: 'Pois chiche'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Luzerne', value: 'Luzerne'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Foin', value: 'Foin'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pomme de terre', value: 'Pomme de terre'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Carotte', value: 'Carotte'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Betterave', value: 'Betterave'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Chou', value: 'Chou'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Tomate', value: 'Tomate'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Oignon', value: 'Oignon'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Ail', value: 'Ail'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Piment', value: 'Piment'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Poivron', value: 'Poivron'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Courgette', value: 'Courgette'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Concombre', value: 'Concombre'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Laitue', value: 'Laitue'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Épinard', value: 'Épinard'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Brocoli', value: 'Brocoli'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Chou-fleur', value: 'Chou-fleur'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Radis', value: 'Radis'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Navet', value: 'Navet'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Melon', value: 'Melon'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pastèque', value: 'Pastèque'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pomme', value: 'Pomme'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Poire', value: 'Poire'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Cerise', value: 'Cerise'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Fraise', value: 'Fraise'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Framboise', value: 'Framboise'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Mûre', value: 'Mûre'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Groseille', value: 'Groseille'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Raisin', value: 'Raisin'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pêche', value: 'Pêche'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Abricot', value: 'Abricot'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Prune', value: 'Prune'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Olive', value: 'Olive'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Amande', value: 'Amande'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Noisette', value: 'Noisette'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Noix', value: 'Noix')
  ];
}

  static List<SearchFieldAutoCompleteItem<String>> get getAgriculturalInputs {
  return const [
    SearchFieldAutoCompleteItem<String>(searchKey: 'Engrais azoté', value: 'Engrais azoté'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Engrais phosphaté', value: 'Engrais phosphaté'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Engrais potassique', value: 'Engrais potassique'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Engrais organique', value: 'Engrais organique'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Fumier', value: 'Fumier'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Compost', value: 'Compost'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Tourbe', value: 'Tourbe'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Lime', value: 'Lime'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Calcaire', value: 'Calcaire'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Dolomie', value: 'Dolomie'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Superphosphate', value: 'Superphosphate'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Sulphate d\'ammonium', value: 'Sulphate d\'ammonium'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Nitrate de potassium', value: 'Nitrate de potassium'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Nitrate de calcium', value: 'Nitrate de calcium'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Herbicide', value: 'Herbicide'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Insecticide', value: 'Insecticide'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Fongicide', value: 'Fongicide'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pesticide', value: 'Pesticide'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Régulateur de croissance', value: 'Régulateur de croissance'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Amendement calcique', value: 'Amendement calcique'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Amendement magnésien', value: 'Amendement magnésien'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Semences', value: 'Semences'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Plantules', value: 'Plantules'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Bulbes', value: 'Bulbes'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Racines nues', value: 'Racines nues'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Plantes en pot', value: 'Plantes en pot'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Sachets de plantation', value: 'Sachets de plantation'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pots de culture', value: 'Pots de culture'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Serres', value: 'Serres'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Systèmes d\'irrigation', value: 'Systèmes d\'irrigation'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pompes à eau', value: 'Pompes à eau'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pulvérisateurs', value: 'Pulvérisateurs'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Tuyaux d\'arrosage', value: 'Tuyaux d\'arrosage'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Goutteurs', value: 'Goutteurs'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Aspersoirs', value: 'Aspersoirs'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Bâches de paillage', value: 'Bâches de paillage'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Filets de protection', value: 'Filets de protection'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Clôtures', value: 'Clôtures'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Ruches', value: 'Ruches'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Nourriture pour animaux', value: 'Nourriture pour animaux'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Vaccins vétérinaires', value: 'Vaccins vétérinaires'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Médicaments vétérinaires', value: 'Médicaments vétérinaires'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Vitamines pour animaux', value: 'Vitamines pour animaux'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Additifs alimentaires', value: 'Additifs alimentaires'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Systèmes de traite', value: 'Systèmes de traite'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Réservoirs de lait', value: 'Réservoirs de lait'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Matériel de nettoyage', value: 'Matériel de nettoyage')
  ];
}

  static List<SearchFieldAutoCompleteItem<String>> get getMateriels {
  return const [
  
    SearchFieldAutoCompleteItem<String>(searchKey: 'Lime', value: 'Lime'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pots de culture', value: 'Pots de culture'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Serres', value: 'Serres'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Systèmes d\'irrigation', value: 'Systèmes d\'irrigation'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pompes à eau', value: 'Pompes à eau'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Pulvérisateurs', value: 'Pulvérisateurs'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Tuyaux d\'arrosage', value: 'Tuyaux d\'arrosage'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Réservoirs de lait', value: 'Réservoirs de lait'),
    SearchFieldAutoCompleteItem<String>(searchKey: 'Matériel de nettoyage', value: 'Matériel de nettoyage'),
     SearchFieldAutoCompleteItem<String>(
          searchKey: 'Pulvérisateur à dos', value: 'Pulvérisateur à dos'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Semoir à main', value: 'Semoir à main'),
           SearchFieldAutoCompleteItem<String>(
          searchKey: 'Filets de protection', value: 'Filets de protection'),
      SearchFieldAutoCompleteItem<String>(
          searchKey: 'Clôtures', value: 'Clôtures'),
      SearchFieldAutoCompleteItem<String>(searchKey: 'Ruches', value: 'Ruches'),
  ];
}

}
