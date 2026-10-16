# Tiroir pour macOS

Tiroir ouvre des étagères flottantes en Liquid Glass où l'on dépose des fichiers, du texte, des images et des liens.
Secouer un fichier qu'on glisse ouvre une étagère sous le curseur ; un téléchargement en cours, une capture d'écran ou un
fichier qui arrive dans un dossier surveillé en ouvrent une seule. On y range, on y traite (AirDrop, Messages, Mail,
compresser, renommer par lot, redimensionner, convertir, fusionner en PDF, masquer le texte d'une image) et on en ressort.
L'app vit dans la barre des menus. Tout reste sur le Mac : aucun compte, aucune télémétrie.

Ce dépôt ne contient que les versions à installer. Le code source n'est pas public.

## Ce qu'il faut

- un Mac à puce Apple (M1 ou plus récent) ;
- macOS 26 ou plus.

Aucun compte GitHub, aucun outil à installer, aucun mot de passe administrateur.

## Installer

Deux façons, au choix.

**1. Le fichier d'installation (le plus simple).** Télécharger [Tiroir.dmg](https://github.com/LucasHRCHatReply/tiroir-releases/releases/latest/download/Tiroir.dmg), l'ouvrir, puis glisser Tiroir dans Applications. Au premier lancement macOS refuse d'ouvrir l'app (voir l'avertissement plus bas) : clic droit sur Tiroir › Ouvrir, ou Réglages Système › Confidentialité et sécurité › « Ouvrir quand même ». Au premier lancement, un didacticiel de cinq écrans fait essayer Tiroir ; il se rouvre depuis l'icône du menu › « Didacticiel… ».

**2. Une commande dans Terminal.** Dans Terminal (Cmd + Espace, « Terminal »), une seule commande, qui installe aussi les mises à jour :

```
curl -fsSL https://raw.githubusercontent.com/LucasHRCHatReply/tiroir-releases/main/installer.sh | zsh
```

Le script télécharge la dernière version, vérifie l'empreinte SHA-256 du zip, l'identifiant de l'app et sa signature
(équipe Apple `JT9FY7PP7K`, `codesign --verify --deep --strict`), copie `Tiroir.app` dans `~/Applications`, puis ouvre
l'app. Il garde les étagères et les réglages. Au premier lancement, macOS demande l'accès au dossier Téléchargements :
c'est lui qui permet de voir arriver un téléchargement.

## Avertissement : app non validée par Apple

Tiroir est signé mais pas « notarisé » : cela demande un compte développeur payant. macOS le juge donc non vérifié au
premier lancement. Le script retire pour cela le blocage du premier lancement (l'attribut de quarantaine posé par le
téléchargement), seulement sur `Tiroir.app`. À ne lancer que si vous faites confiance à l'auteur ; le script se lit en
entier : [installer.sh](installer.sh). Le contrôle d'équipe et d'empreinte protège contre un zip altéré en route, pas
contre quelqu'un qui détiendrait aussi ce dépôt.

## Mettre à jour

Dans l'app : icône du menu › « Rechercher des mises à jour… », ou Réglages › Général › Mises à jour. Tiroir lit la liste
publique des versions au démarrage puis au plus une fois par jour (la case se décoche), propose la nouvelle version,
contrôle l'identifiant, l'équipe, la signature et la version, remplace l'app et la relance ; si la nouvelle app ne démarre
pas, l'ancienne est remise. Ou relancer la commande ci-dessus. Journal : `~/Library/Logs/Tiroir-mise-a-jour.log`.

## Venir de Tiroir 1.0

La 1.1 reprend les réglages et les tiroirs de la 1.0 au premier lancement, sans rien effacer de la 1.0.

## Désinstaller

Télécharger le zip de la dernière version dans les [Releases](../../releases/latest), le décompresser, puis lancer
`./uninstall.sh` dans le dossier `Tiroir-X.Y.Z` : l'app est supprimée, et le script demande avant d'effacer les données.
