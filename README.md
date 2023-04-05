# saemobile
Groupe Tom MARTIN - Vincent POIRIER

# problème projet - git
Nous avons rencontré un problème durant le projet. Pour l'installation de firebase nous avions besoin des fichiers gradle. 
Mais à la création du premier projet ils ne c'étaient pas créés. Donc nous avons du refaire un nouveau projet en y ajoutant nos anciens fichiers.
Pour au final ne pas réussir à implémenter firebase. Si besoin nous avons à disposition l'ancien projet GIT.

# package utilisé
flutter:
sdk: flutter
google_fonts: ^4.0.3
dio: ^4.0.4
provider: ^6.0.5
settings_ui: ^2.0.2
shared_preferences: ^2.0.18
http: ^0.13.5

# fonctionnalité implémenté
- consultation des articles
- gestion des articles favoris
- authentification
- ecran d'accueil
- autre fonctionnalité: 
    - barre de recherche
    - tri par prix
    - augmentation de quantité et pix total
    - animation des boutons

# authentification
Nous avons utilisé les users de l'API pour l'authentification.
Voici un exemple d'utilisateur:
{
    "username": "johnd",
    "password": "m38rmF$",
}
