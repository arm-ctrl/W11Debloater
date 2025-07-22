# W11Debloater

Script complet d'installation, de nettoyage et de personnalisation pour Windows 11 (et Windows 10)

## Présentation

**W11Debloater** est un script PowerShell automatisant le nettoyage d'un PC neuf ou fraîchement réinstallé : suppression des bloatwares, désactivation des fonctions inutiles, personnalisation de la barre des tâches, du menu Démarrer, du Bluetooth, du presse-papiers, de la gestion des imprimantes, activation du pavé numérique, création d'un point de restauration, etc.

- **Désinstalle** les applications préinstallées inutiles (Xbox, Bing, réseaux sociaux, etc.) pour tous les utilisateurs et futurs comptes
- **Personnalise** la barre des tâches : alignement, désactivation widgets, Task View, Copilot, Cortana, BingSearch, etc.
- **Désactive** le Bluetooth
- **Active** l'historique du presse-papiers (Win+V)
- **Active** le pavé numérique au démarrage (via une clé de registre)
- **Désactive** la gestion automatique de l'imprimante par défaut
- **Nettoie la barre de favoris Edge** : supprime tous les favoris et ajoute uniquement Google.fr
- **Propose** de renommer le PC
- **Crée** un point de restauration système à la fin
- **Propose** un redémarrage pour appliquer les changements

## Utilisation

1. **Téléchargez** le dépôt ou copiez les fichiers sur le PC à configurer.
2. Placez le script PowerShell (`W11Debloater-arm-ctrl.ps1`) sur le Bureau de l'utilisateur.
3. Double-cliquez sur `start.bat` (ou exécutez-le en tant qu'administrateur). Ce batch :
   - Autorise temporairement l'exécution de scripts PowerShell
   - Lance le script principal avec les droits administrateur
4. Suivez les instructions à l'écran (renommage, redémarrage, etc.).

## Prérequis
- Windows 11 (fonctionne aussi sur Windows 10 avec quelques limitations)
- Droits administrateur

## Conseils
- Testé sur plusieurs éditions de Windows 11 (Home, Pro). Certaines fonctions peuvent être limitées sur les versions Entreprise ou verrouillées par des GPO.
- Le script est modulaire et chaque bloc est clairement commenté pour faciliter l'adaptation à vos besoins.
- Un point de restauration est créé automatiquement avant redémarrage.

## Personnalisations possibles
- Ajoutez ou retirez des applications à désinstaller dans la section `$bloatwareApps`.
- Modifiez les personnalisations ergonomiques selon vos préférences.
- La gestion Edge se limite à la barre de favoris (vider + Google.fr).
- Ajoutez d'autres scripts ou commandes à la suite si besoin (installation de logiciels, configuration réseau, etc.).

## Avertissement
**Utilisez ce script à vos risques et périls.** Certaines actions sont irréversibles sans restauration système. Lisez et adaptez le script avant de l'utiliser en production ou sur un grand nombre de machines.

## Auteur
arm-ctrl

---

N'hésitez pas à ouvrir une issue ou une PR pour toute suggestion ou amélioration !