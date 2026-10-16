# Tiroir pour macOS

Tiroir ouvre des tiroirs flottants en verre où l'on dépose des fichiers. Secouer un fichier qu'on glisse ouvre un
tiroir, un fichier terminé dans Téléchargements y arrive tout seul, et un tiroir se range en languette sur le bord de
l'écran. Les fichiers sont copiés (l'original n'est jamais touché) ; vider un tiroir met les copies à la corbeille.
L'app vit dans la barre des menus (icône de tiroir). Tout reste sur le Mac : aucun compte, aucune télémétrie.

Ce dépôt ne contient que les versions à installer. Le code source n'est pas public.

## Ce qu'il faut

- un Mac à puce Apple (M1 ou plus récent) ;
- macOS 15 ou plus (Liquid Glass natif sous macOS 26, matériau translucide avant).

Aucun compte GitHub, aucun outil à installer, aucun mot de passe administrateur.

## Installer

Dans Terminal (Cmd + Espace, « Terminal »), une seule commande, qui installe aussi les mises à jour :

```
curl -fsSL https://raw.githubusercontent.com/LucasHRCHatReply/tiroir-releases/main/installer.sh | zsh
```

Le script télécharge la dernière version, vérifie l'empreinte SHA-256 du zip, l'identifiant de l'app et sa signature
(équipe Apple `JT9FY7PP7K`, `codesign --verify --deep --strict`), copie `Tiroir.app` dans `~/Applications`, puis ouvre
l'app. Il garde les tiroirs et les réglages. Aucune autorisation n'est demandée : macOS ne demande l'accès à
Téléchargements, au Bureau ou à Documents que si ces dossiers sont surveillés.

## Avertissement : app non validée par Apple

Tiroir est signé mais pas « notarisé » : cela demande un compte développeur payant. macOS le juge donc non vérifié au
premier lancement. Le script retire pour cela le blocage du premier lancement (l'attribut de quarantaine posé par le
téléchargement), seulement sur `Tiroir.app`. À ne lancer que si vous faites confiance à l'auteur ; le script se lit en
entier : [installer.sh](installer.sh). Le contrôle d'équipe et d'empreinte protège contre un zip altéré en route, pas
contre quelqu'un qui détiendrait aussi ce dépôt.

## Mettre à jour

Dans l'app : icône du menu › « Réglages… » › « Mises à jour ». Tiroir lit la liste publique des versions au démarrage
puis au plus une fois par jour (la case se décoche), propose la nouvelle version, contrôle l'identifiant, l'équipe, la
signature et la version, remplace l'app et la relance ; si la nouvelle app ne démarre pas, l'ancienne est remise.
Ou relancer la commande ci-dessus. Journal : `~/Library/Logs/Tiroir-mise-a-jour.log`.

## Désinstaller

Télécharger le zip de la dernière version dans les [Releases](../../releases/latest), le décompresser, puis lancer
`./uninstall.sh` dans le dossier `Tiroir-X.Y.Z` : l'app est supprimée, et le script demande avant d'effacer les tiroirs.
