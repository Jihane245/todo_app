# 📱 TaskFlow — Application de Gestion des Tâches

> Mini-projet Flutter — Module de Développement Mobile

---

## 👥 Membres du groupe

| Nom | Rôle |
|-----|------|
| *(À compléter)* | Développeur Flutter |
| *(À compléter)* | Développeur Flutter |

---

## 📋 Description de l'application

**TaskFlow** est une application mobile de gestion des tâches de type *Todoist / Trello*, développée avec Flutter et Dart.
Elle permet à chaque utilisateur de créer, organiser, modifier et supprimer ses tâches personnelles, avec un système d'authentification local, des statistiques de productivité, un mode sombre et une citation de motivation quotidienne.

Toutes les données sont stockées **localement sur l'appareil** grâce à SQLite (sqflite). Aucun compte cloud n'est requis.

---

## 🛠️ Technologies utilisées

| Technologie | Version | Usage |
|---|---|---|
| Flutter | ≥ 3.x | Framework UI mobile |
| Dart | ≥ 3.x | Langage de programmation |
| SQLite / sqflite | ^2.4.2 | Stockage local des données |
| http | ^1.2.2 | Consommation API REST (citation du jour) |
| Android Studio | Latest | IDE de développement |
| Material Design 3 | — | Composants UI |

---

## ✅ Fonctionnalités réalisées

### Fonctionnalités de base
- [x] **Authentification** : Inscription (Register), Connexion (Login), Mot de passe oublié avec code secret
- [x] **Navigation multi-écrans** : Login → Home → Add/Edit Task, Drawer latéral
- [x] **CRUD complet** : Création, lecture, modification et suppression de tâches
- [x] **Formulaires avec validation** : champs obligatoires, format email, longueur mot de passe, confirmation mot de passe, dates cohérentes
- [x] **Stockage local SQLite** : toutes les données (utilisateurs + tâches) stockées sur l'appareil
- [x] **Interface responsive et moderne** : Material Design 3, gradients, animations
- [x] **Architecture MVC stricte** : Models / Views / Controllers / Database
- [x] **Icônes et thème personnalisés** : palette violette `#6C63FF`, icônes Material

### Gestion des tâches
- [x] Titre, description, dates (début/fin), priorité (Basse/Moyenne/Haute), progression (slider 0-100%), statut (en cours / terminée), **catégorie**
- [x] Checkbox pour marquer une tâche terminée (progression auto à 100%)
- [x] Completion automatique si progression = 100%
- [x] Tâches filtrées par utilisateur connecté (isolation des données)

---

## ⭐ Fonctionnalités recommandées intégrées

### 1. 💾 SQLite (stockage local)
- Base de données locale avec `sqflite`
- 2 tables : `users` et `tasks`
- Migrations gérées proprement (`onUpgrade`) — pas de perte de données lors des mises à jour

### 2. 📊 Dashboard statistiques
- Affiché directement dans la HomePage
- **Total des tâches**, **Tâches terminées**, **Tâches en cours**, **Tâches à priorité haute**
- Statistiques calculées uniquement pour l'utilisateur connecté, sans requête DB supplémentaire

### 3. 🌙 Dark Mode
- ThemeData clair et sombre configurés dans `main.dart`
- Basculement via un **Switch dans le Drawer** (menu latéral)
- Implémenté avec `ValueNotifier<ThemeMode>` global — aucun package externe, aucun Provider/Bloc

### 4. 🎬 Animations simples
- Apparition progressive des cartes de tâches (`TweenAnimationBuilder` + `Opacity` + `Transform.translate`)
- Animation fade-in sur les cartes de statistiques (scale + opacity)
- Animation fade-in sur la carte de citation
- Animations de transition sur les formulaires (slide-up)

### 5. 🌐 API REST simple
- **API utilisée** : [ZenQuotes.io](https://zenquotes.io/api/today) — gratuite, sans clé API
- Affichage d'une **citation de motivation** dans une carte violette en haut de la HomePage
- Timeout de 5 secondes — en cas d'erreur réseau, une citation locale est affichée
- L'échec de l'API ne bloque jamais l'application
- CRUD SQLite non modifié

---

## 🏗️ Architecture MVC adoptée

```
lib/
├── main.dart                      ← Point d'entrée + themeNotifier (Dark Mode)
├── controllers/
│   ├── auth_controller.dart       ← Logique d'authentification (login/register/reset)
│   ├── task_controller.dart       ← Logique CRUD des tâches + statistiques
│   └── quote_controller.dart      ← Fetch API REST (citation du jour)
├── database/
│   └── database_helper.dart       ← Accès SQLite (requêtes brutes)
├── models/
│   ├── user.dart                  ← Structure de données Utilisateur
│   └── task.dart                  ← Structure de données Tâche
└── views/
    ├── login_page.dart            ← Interface de connexion
    ├── register_page.dart         ← Interface d'inscription
    ├── forgot_password_page.dart  ← Interface de réinitialisation du mot de passe
    ├── home_page.dart             ← Accueil : stats + citation + liste des tâches
    ├── add_task_page.dart         ← Formulaire de création de tâche
    └── edit_task_page.dart        ← Formulaire de modification de tâche
```

**Règle MVC respectée** : les Views ne communiquent jamais directement avec DatabaseHelper. Toute la logique métier passe par les Controllers.

---

## 🗄️ Structure de la base de données SQLite

**Fichier** : `todo.db` (stocké dans le répertoire de l'app sur l'appareil)

### Table `users`

| Colonne | Type | Description |
|---|---|---|
| `id` | INTEGER (PK, AI) | Identifiant unique |
| `name` | TEXT | Nom de l'utilisateur |
| `email` | TEXT (UNIQUE) | Email de connexion |
| `password` | TEXT | Mot de passe |
| `secret_code` | TEXT | Code secret pour réinitialiser le mot de passe |

### Table `tasks`

| Colonne | Type | Description |
|---|---|---|
| `id` | INTEGER (PK, AI) | Identifiant unique |
| `title` | TEXT | Titre de la tâche |
| `description` | TEXT | Description détaillée |
| `start_date` | TEXT | Date de début (ISO 8601) |
| `end_date` | TEXT | Date de fin (ISO 8601) |
| `priority` | INTEGER | 1 = Basse, 2 = Moyenne, 3 = Haute |
| `progress` | INTEGER | Progression 0–100 (%) |
| `status` | INTEGER | 0 = En cours, 1 = Terminée |
| `category` | TEXT | Catégorie (Général, Travail, Études…) |
| `user_id` | INTEGER (FK) | Référence vers `users.id` |

**Versions de migration** :
- v1 → v2 : ajout des colonnes `start_date` et `end_date`
- v2 → v3 : ajout de la colonne `category` (DEFAULT `'Général'`)

---

## ⚙️ Installation

### Prérequis
- [Flutter SDK](https://flutter.dev/docs/get-started/install) installé et configuré
- Android Studio ou VS Code avec l'extension Flutter
- Un appareil Android ou un émulateur

### Étapes

```bash
# 1. Cloner le projet
git clone <url-du-repo>
cd todo_app

# 2. Installer les dépendances
flutter pub get

# 3. Vérifier l'installation Flutter
flutter doctor
```

---

## ▶️ Exécution

```bash
# Lancer sur un émulateur ou un appareil connecté
flutter run

# Lancer en mode release (production)
flutter run --release
```

---

## 📁 Packages utilisés

```yaml
dependencies:
  sqflite: ^2.4.2+1    # Base de données SQLite locale
  path: ^1.9.1          # Gestion des chemins de fichiers
  http: ^1.2.2          # Requêtes HTTP (API REST ZenQuotes)
```

---

## 📌 Notes importantes

- **Stockage 100% local** : toutes les données (utilisateurs et tâches) sont stockées localement sur l'appareil avec SQLite. Aucune connexion à un serveur externe n'est requise pour le CRUD.
- **Confidentialité** : les données d'un utilisateur ne sont jamais accessibles par un autre utilisateur (filtrage par `user_id`).
- **Mode hors ligne** : l'application fonctionne entièrement sans connexion Internet. La citation du jour se replie sur une citation locale si le réseau est indisponible.
- **Migration non destructive** : les mises à jour de la base de données utilisent `ALTER TABLE` — aucune donnée existante n'est jamais perdue.