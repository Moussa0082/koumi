import 'package:flutter/material.dart';

class AutoComplet {
   static List<String> getSuggestions() {
    return [
      // Fruits
      'Pomme',
      'Banane',
      'Orange',
      'Fraise',
      'Raisin',
      'Mangue',
      'Ananas',
      'Citron',
      'Pastèque',
      'Cerise',
      'Pêche',
      'Abricot',
      'Melon',
      'Kiwi',
      'Papaye',

      // Légumes
      'Carotte',
      'Brocoli',
      'Tomate',
      'Concombre',
      'Poivron',
      'Courgette',
      'Laitue',
      'Chou-fleur',
      'Épinard',
      'Betterave',
      'Haricot vert',
      'Aubergine',
      'Oignon',
      'Ail',
      'Radis',

      // Produits céréaliers
      'Riz',
      'Blé',
      'Avoine',
      'Quinoa',
      'Orge',
      'Maïs',
      'Sarrasin',
      'Millet',
      'Seigle',
      'Amarante',
      'Fonio',
      'Epeautre',
      'Farro',
      'Sorgho',
      'Teff',
    ];
  }

   static List<String> getAgriculturalInputs() {
    return [
      // Intrants agricoles
      'Engrais azoté', 'Engrais phosphaté', 'Engrais potassique',
      'Engrais organique',
      'Pesticides', 'Herbicides', 'Fongicides', 'Insecticides',
      'Fertilisant liquide',
      'Fertilisant granulé', 'Amendements calcaires', 'Amendements soufrés',
      'Semences hybrides',
      'Semences OGM', 'Semences non-OGM', 'Paillis plastique',
      'Paillis organique', 'Filet anti-insectes',
      'Filet anti-grêle', 'Irrigation goutte-à-goutte',
      'Système d’irrigation par aspersion',
      'Serre', 'Tunnel plastique', 'Bâche agricole', 'Film de paillage',
      'Silo de stockage',
      'Conteneur de transport', 'Sac de jute', 'Sac en polypropylène',
      'Bidon en plastique',
      'Cuve de stockage', 'Citerne à eau', 'Mélangeur d’engrais',
      'Pulvérisateur à dos',
      'Pulvérisateur électrique', 'Tracteur agricole', 'Moissonneuse-batteuse',
      'Faucheuse',
      'Bineuse', 'Arracheuse de pommes de terre', 'Machine à vendanger',
      'Semoir', 'Enrubanneuse',
      'Epandeur à engrais', 'Epandeur à fumier', 'Broyeur de végétaux',
      'Charrue', 'Herse rotative',
    ];
  }

static List<String> getAgriculturalProductTypes() {
    return [
      // Types de produits agricoles
      'Céréales', 'Légumineuses', 'Fruits', 'Légumes', 'Oléagineux', 'Tubercules',
      'Racines', 'Fruits secs', 'Épices', 'Plantes aromatiques', 'Plantes médicinales',
      'Fourrages', 'Cultures industrielles', 'Coton', 'Café', 'Cacao', 'Thé', 'Tabac',
      'Sucre', 'Huiles végétales', 'Fleurs', 'Plantes ornementales', 'Plantes à fibres',
      'Plantes à latex', 'Plantes colorantes', 'Plantes tinctoriales', 'Plantes à tanin',
      'Plantes à biocarburants', 'Plantes fourragères', 'Plantes de couverture', 'Plantes de rotation',
      'Plantes de service', 'Plantes mellifères', 'Plantes mycorrhiziennes', 'Plantes compagnes',
      'Plantes pièges', 'Plantes bio-indicatrices', 'Plantes à fumure verte', 'Plantes de pâturage',
      'Plantes aquatiques', 'Plantes de marais', 'Plantes halophytes', 'Plantes acidophiles',
      'Plantes calcicoles', 'Plantes nitrophiles', 'Plantes saxicoles', 'Plantes psammophiles',
      'Plantes xérophiles', 'Plantes hygrophiles', 'Plantes ombrophiles', 'Plantes héliophiles',
    ];
  }
  
  static List<String> getTransportVehicles() {
    return [
      // Véhicules de transport
      'Camion', 'Camionnette', 'Fourgon', 'Minibus', 'Bus', 'Autobus',
      'Autocar', 'Taxi',
      'Vélo', 'Moto', 'Scooter', 'Tricycle motorisé', 'Voiture', 'Break',
      'Berline', 'SUV',
      'Monospace', 'Coupé', 'Cabriolet', 'Limousine', 'Camion-citerne',
      'Camion frigorifique',
      'Camion-benne', 'Tracteur routier', 'Remorque', 'Semi-remorque',
      'Caravane', 'Camping-car',
      'Bateau de transport', 'Péniche', 'Barge', 'Ferry',
      'Train de marchandises', 'Train de voyageurs',
      'Tramway', 'Métro', 'Hélicoptère de transport', 'Avion de transport',
      'Jet privé',
      'Drone de livraison', 'Véhicule électrique', 'Véhicule hybride',
      'Voiture autonome',
      'Bus électrique', 'Camion électrique', 'Camion autonome',
      'Scooter électrique', 'Trottinette électrique',
      'Vélo électrique', 'Cargo-bike', 'Remorque pour vélo',
    ];
  }
}