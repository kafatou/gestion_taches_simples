# gestion_taches_simples

## Description
Cette application Flutter de gestion de tâches permet aux utilisateurs de créer, modifier, supprimer. Elle offre une interface intuitive avec des fonctionnalités de recherche.

## Fonctionnalités principales
- Gestion complète des tâches : Créer, modifier et supprimer des tâches
- Statut des tâches : Marquer les tâches comme "Complète" ou "Incomplète"
- Dates de planification : Définir des dates de début et de fin pour chaque tâche
- Recherche intelligente : Filtrer les tâches par nom avec recherche en temps réel
- Interface responsive : Compatible avec différentes tailles d'écran
- Persistance des données : Sauvegarde automatique des tâches

## Installation et Configuration
### Prérequis
Flutter SDK (3.35.2)
Dart SDK (3.9.0)
IDE compatible (Android Studio, VS Code)
Émulateur Android ou appareil physique

### Étapes d'installation
#### Cloner le projet
git clone https://github.com/kafatou/gestion_taches_simples
cd gestion_taches

#### Installer les dépendances
flutter pub get

#### Générer les fichiers nécessaires 
flutter packages pub run build_runner build

#### Lancer l'application
flutter run

### Configuration pour les tests
Tests d'un fichier spécifique
flutter test test/task_provider_test.dart

## Architecture Adoptée
### Choix
L'application suit une architecture modulaire basée sur les principes de Clean Architecture et utilise le pattern Provider pour la gestion d'état.
### Structure des dossiers
lib/
├── features/
│   └── tasks/
│       ├── data/           # Couche de données
│       │   └── task_service.dart
│       ├── models/         # Modèles de données
│       │   └── task_model.dart
│       ├── providers/      # Gestionnaires d'état
│       │   └── task_provider.dart
│       └── views/          # Interface utilisateur
│           ├── addtask_view.dart
│           └── home_view.dart
├── utils/                  # Utilitaires partagés
│   ├── constants.dart
│   └── functions.dart
└── main.dart

## Difficultés Rencontrées et Solutions
- Problème : Les tests échouaient à cause des toasts.
  Solution : Les enlever dans le provider et réadapter les méthodes concernées
