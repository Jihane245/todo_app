# Todo App - Flutter MVC Project
Jihane El Ghazrani & 
Riyad Moukhliss



   1.Introduction 

   
TaskFlow est une application mobile de productivité moderne développée sous Flutter, alliant performance et design intuitif. Architecturée selon le modèle MVC, elle permet une gestion fluide et sécurisée de vos tâches quotidiennes grâce au stockage local SQLite et à une interface dynamique. Entre authentification personnalisée, dashboard avec statistiques animées et intégration d'API REST, cette application constitue une solution complète pour optimiser votre organisation au quotidien.

   2.Technologies Utilisées 
   
Pour la conception et le développement de TaskFlow, nous avons mobilisé un écosystème technologique moderne et robuste :
.Framework & Langage : Développement cross-platform avec Flutter et le langage Dart.
.Architecture logicielle : Adoption rigoureuse du design pattern MVC (Model-View-Controller) pour assurer la séparation des préoccupations.

<img width="392" height="472" alt="WhatsApp Image 2026-06-03 at 01 10 13" src="https://github.com/user-attachments/assets/5b3cb6bc-efe6-4e32-b0eb-c33383cde918" />

## Models

Contiennent les structures de données :

* User
* Task

## Views

Contiennent toutes les interfaces graphiques :

* Login Page
* Register Page
* Forgot Password Page
* Home Page
* Add Task Page
* Edit Task Page


## Controllers

Contiennent la logique métier :

* AuthController
* TaskController
* quoteController 


.L'application utilise SQLite (via sqflite) pour assurer une gestion sécurisée et locale des données. L'architecture repose sur deux entités relationnelles clés :
      Table users : Centralise l'identité, les paramètres de sécurité (code secret pour réinitialisation) et le chemin de la photo de profil.
      Table tasks : Gère l'intégralité du cycle de vie des objectifs (titre, description, catégories, priorités, avancement et état).
      Le DatabaseHelper orchestre ces données grâce à un système de migration automatisé (onUpgrade), garantissant l'évolution de la structure sans perte    d'information. Il centralise toutes les opérations CRUD via des requêtes optimisées, assurant ainsi une cohérence parfaite et une réactivité immédiate de l'interface utilisateur. 
.Consommation de services : Intégration d'API REST pour la récupération de données dynamiques externes.  
.Environnement de développement : Conception optimisée via Android Studio et tests réalisés sur Émulateur Android (configuré en Medium Phone:5554).

  <img width="1918" height="968" alt="image" src="https://github.com/user-attachments/assets/86f745bd-718f-4e9e-8391-2434201e3083" />



    3.Fonctionnalités Réalisées
Notre application TaskFlow a été pensée pour offrir une expérience utilisateur complète, alliant simplicité d'utilisation et richesse fonctionnelle pour une gestion optimale du quotidien.

      3.1.Système d'Authentification et Gestion de Compte
Le module d'authentification est le pilier de sécurité de notre application, offrant un parcours utilisateur fluide et protégé. Lors de la phase de création de compte (Sign Up), l'utilisateur est invité à définir ses identifiants, incluant une confirmation de mot de passe rigoureuse ainsi qu'un code secret personnalisé.


<img width="304" height="728" alt="Capture d&#39;écran 2026-06-11 212943" src="https://github.com/user-attachments/assets/e7160a2d-dbf5-4e55-bb22-ab4c682d0d3a" />



Ce code unique est crucial, car il sert de clé de sécurité pour la fonctionnalité "Mot de passe oublié", permettant de réinitialiser un accès perdu sans intervention tierce. 


<img width="325" height="734" alt="Capture d&#39;écran 2026-06-11 213003" src="https://github.com/user-attachments/assets/aac5ec4b-dd8f-4cb7-bfad-05bb0f1435da" />


Le flux est complété par une interface de connexion (Login) intuitive et une option de déconnexion , garantissant ainsi la confidentialité des données de chaque utilisateur à tout moment.

<img width="309" height="730" alt="Capture d&#39;écran 2026-06-11 211125" src="https://github.com/user-attachments/assets/e17f0c3e-403c-4e93-bbf6-ec7a21fe9eff" />



    4.Gestion Intelligente des Tâches
Le cœur de TaskFlow repose sur une gestion dynamique et centralisée de vos objectifs, permettant une réalisation totale du cycle CRUD. Lors de la création, l'utilisateur définit un titre, une description détaillée, ainsi que des paramètres précis : catégories (Études, Travail, etc.), dates de début et de fin, et niveaux de priorité.

<img width="307" height="733" alt="WhatsApp Image 2026-06-11 at 21 13 53" src="https://github.com/user-attachments/assets/f8afa80d-e6fb-4e40-99ee-400ae0310a7d" />


<img width="307" height="733" alt="WhatsApp Image 2026-06-11 at 21 13 53" src="https://github.com/user-attachments/assets/a17925be-9853-4418-b834-210281a0d816" />

  <img width="316" height="726" alt="WhatsApp Image 2026-06-11 at 21 14 39" src="https://github.com/user-attachments/assets/5223ee84-4e4e-4ee8-a300-1da372b3be11" />

 
Toutes les tâches créées sont instantanément persistées et ajoutées à la page d'accueil, offrant une vue d'ensemble claire.



<img width="310" height="728" alt="WhatsApp Image 2026-06-11 at 21 15 27" src="https://github.com/user-attachments/assets/0be6ee9e-3e05-4135-a11a-b94e03f3ef68" />


La modification permet d'ajuster chaque paramètre, incluant le suivi de l'état d'avancement,



<img width="310" height="726" alt="image" src="https://github.com/user-attachments/assets/ecddcf45-a23b-49e0-a084-629beae8df74" />


tandis que la suppression est sécurisée par une fenêtre de confirmation pour éviter toute erreur.

<img width="317" height="727" alt="image" src="https://github.com/user-attachments/assets/030666b9-3e8c-4842-95a1-d05f74f962b7" />


Cette interface permet ainsi un suivi complet du cycle de vie de chaque tâche, de sa planification jusqu'à sa réalisation.

<img width="310" height="728" alt="image" src="https://github.com/user-attachments/assets/391c0fae-088b-4b66-81fd-6e317f25849a" />

    5.Dashboard et Statistiques Dynamiques


<img width="312" height="727" alt="image" src="https://github.com/user-attachments/assets/da608538-bc24-481d-b93d-37a513362d61" />

     Le Dashboard est le centre névralgique de TaskFlow, conçu pour offrir une vue d'ensemble instantanée de votre productivité. Il agrège les données de vos tâches en temps réel sous forme de cartes statistiques (Total, Tâches terminées, En cours, et Haute priorité), chacune animée lors du chargement pour une expérience visuelle attractive. Cette vue est complétée par une section "Citation du jour", alimentée dynamiquement via une API REST pour stimuler votre motivation. Ce module communique de manière asynchrone avec le serveur ZenQuotes pour récupérer des données au format JSON, lesquelles sont ensuite traitées pour dynamiser le Dashboard. Pour garantir une disponibilité totale, nous avons implémenté une stratégie de tolérance aux pannes (fallback) : en cas d'absence de connexion ou d'erreur réseau, l'application bascule instantanément sur un contenu local, assurant ainsi une interface toujours élégante et motivante, quelle que soit la situation de l'utilisateur.
     
     <img width="302" height="108" alt="image" src="https://github.com/user-attachments/assets/57ed5d20-591a-412a-9427-15f1926d8e23" />


L'accès à ces informations est parfaitement intégré au Sidebar (Drawer), véritable outil de pilotage latéral. Depuis ce menu, vous pouvez non seulement naviguer vers le Dashboard, mais également personnaliser votre environnement de travail en basculant dynamiquement entre les modes Clair et Sombre. 

<img width="311" height="735" alt="image" src="https://github.com/user-attachments/assets/e33b3666-76de-4fff-8ea4-eebb36b9e458" />

<img width="306" height="727" alt="image" src="https://github.com/user-attachments/assets/5914fb76-1f07-4802-ab07-39626c447000" />

Le Sidebar renforce également la personnalisation de votre espace via la gestion de votre profil (  Ainsi l'ajout , la modification et la suppression d'une photo de profil ) 

        6.Animations :

Les animations dans TaskFlow sont intégrées directement au cœur de l'interface utilisateur (via des widgets comme AnimatedContainer ou AnimatedOpacity) pour garantir une navigation fluide et interactive. Elles se manifestent lors du chargement dynamique des statistiques du Dashboard, de l'apparition des tâches dans la liste, ou lors des transitions de thèmes (clair/sombre), apportant une expérience visuelle moderne et réactive sans nécessiter de ressources externes. Ces effets, gérés nativement par le framework Flutter, permettent de fluidifier les interactions tout en maintenant les performances optimales de l'application.

     7.Conclusion
Ce projet a permis de concevoir une application de gestion de tâches performante, alliant une architecture MVC rigoureuse à une interface intuitive. Grâce à l'utilisation de SQLite pour la persistance locale et à l'intégration d'API REST, TaskFlow offre une solution robuste, fluide et sécurisée pour l'organisation quotidienne. Ce développement démontre une maîtrise concrète des cycles de vie des données et des bonnes pratiques de développement mobile.

       8.Perspectives
Pour enrichir davantage cette application, les évolutions suivantes sont envisagées :
Synchronisation Cloud : Déploiement d'un backend pour permettre l'accès aux données sur plusieurs appareils.
Notifications intelligentes : Mise en place de rappels automatiques pour mieux gérer les échéances.
Mode Collaboratif : Possibilité de partager des tâches au sein d'équipes ou de groupes de travail.
Intégration IA : Automatisation de la priorisation des tâches grâce à des algorithmes prédictifs.
