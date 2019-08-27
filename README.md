# MotiveLetter

Petite application de bureautique pour construire ses lettres de motivation à partir de lettres précédentes.

Créée pour Marion.

* [Pré-requis](#prerequis)
* [Utilisation](#utilisation)
* [Construction de la lettre (de motivation ou autre)](#build_letter)
* [Filtre des paragraphes](#filtre_paragraphes)
* [Récupération du texte final de la lettre](#recup_texte_final)
* [Travail de la lettre sur plusieurs jours](#work_several_days)
* [Indice/pourcentage de similarité](#similarite)
* [Modification des paragraphes](#modify_paragraphs)
* [Les lettres traitées](#lettres_traiteds)

## Pré-requis {#prerequis}

Pour fonctionner, l'application a besoin que le langage [ruby](https://www.ruby-lang.org/fr/documentation/installation/) soit correctement installé sur la machine.

## Utilisation {#utilisation}

* Mettre des lettres de motivations dans le dossier `originales`. Elles doivent se trouver au format `.doc`, `.docx` ou `.odt` (LibreOffice) (note : elles peuvent se trouver dans des sous-dossiers du dossier `originales`),

* lancer le script ruby `runner.rb` à l'aide d'une console (le Terminal, par exemple, sur Mac) en jouant la commande `ruby /path/to/runner.rb`

* ouvrir la page `LM_BUILDER.HTML` dans un navigateur et constuire sa lettre de motivation (cf. ci-dessous).

## Construction de la lettre (de motivation ou autre) {#build_letter}

« Construire une lettre » consiste à choisir des paragraphes par rapport à des exemples de paragraphes, en différentes versions (rassemblées par proximités) et à les agencer dans l'ordre le plus pertinent.

Dans l'interface du navigateur, après avoir ouvert le fichier `LM_BUILDER.HTML`, on trouve trois colonnes :

* la colonne tout à gauche permet de construire la lettre,
* la colonne centrale affiche les paragraphes référents, c'est-à-dire tous les paragraphes qui sont différents (c'est la seule qui devrait être occupée au lancement de l'application),
* la colonne droite affiche les paragraphes similaires lorsqu'un paragraphe référent est sélectionné au centre.

Pour construire la lettre, il suffit de prendre les paragraphes — soit dans la colonne centrale soit dans la colonne droite — et de les glisser à l'endroit voulu dans la colonne gauche.

Commencer par choisir un paragraphe référent en le sélectionnant à la souris. S'ils existent, ses paragraphes similaires s'affichent dans la colonne droite.

Choisir le paragraphe voulu — référent ou similaire — et le glisser à la souris dans la colonne de la lettre.

Dans la lettre — la colonne gauche — on peut modifier l'ordre des paragraphes simplement en les déplaçant à la souris.

## Filtre des paragraphes {#filtre_paragraphes}

On peut filtrer les paragraphes afin de se concentrer sur ceux qu'on cherche à l'aide du champ de recherche placé au-dessus de la liste des paragraphes.

* Cette recherche se fait toujours sans tenir compte de la casse ("VERSION" cherché recherchera aussi "version" et "VersioN").

* Cette recherche se fait par expression régulière. C'est-à-dire que <code>trav(ail|aux)</code> cherchera "travail" et "travaux", <code>expériences?</code> recherchera "expérience" et "expériences". Pour chercher un "?" ou "." ou un "\*", il faut les "échapper" : <code>\\\?</code>, <code>\\\.</code> ou <code>\\\*</code>.

Pour réafficher tous les paragraphes, soit faire une recherche sur un texte vide, soit cliquer le bouton "Reset".

## Récupération du texte final de la lettre {#recup_texte_final}

Pour récupérer le texte de la lettre finale, il suffit de cliquer sur le bouton "Copier \[Texte\]" en haut de la lettre (colonne gauche).

Si votre ordinateur/navigateur le permet, le texte sera entièrement copié dans le presse-papier et vous pourrez le copier où vous voulez. Si votre navigateur est trop ancien, le texte sera placé dans un champ de saisie que vous pourrez copier-coller de la même manière.

## Travail de la lettre sur plusieurs jours {#work_several_days}

Si vous voulez travailler la lettre sur plusieurs jours, sans avoir à la recontruire chaque fois, voici la démarche à suivre :

* commencer à construire la lettre normalement,
* quand vous avez provisoirement fini, cliquez le bouton « Copier \[Liste Ids\]» pour copier la liste des identifiants de paragraphe de votre lettre actuelle,
* ouvrez le fichier `./js/_current_lm_.js` dans un traitement de texte simple et copiez la liste obtenue au bout de `const CURRENT_LM = `. Vous devez impérativement obtenir quelque chose comme `const CURRENT_LM = [23, 4, 128, 12]`.
* enregistrez ce fichier (ATTENTION : si vous avez ouvert ce fichier dans un traitement de texte complexe — comme Word ou LibreOffice —, ce fichier doit impérativement être enregistré en « texte simple » ou « plain text », en tout cas sans mise en forme).

Lorsque vous rechargerez la page `LM_BUILDER.HTML` à votre prochaine session, vous retrouverez la lettre là où vous l'avez laissée et pourrez continuer de la même manière.

> Note : après avoir travaillé une lettre, vous pouvez mettre de côté cette liste d'identifiants de paragraphes, en indiquant à quelle lettre ça correspond, pour repartir de ce modèle de lettre une prochaine fois, simplement en copiant-collant cette liste au bout de `const CURRENT_LM = ` !

## Indice/pourcentage de similarité {#similarite}

Lorsque vous cliquez sur un paragraphe référent (liste centrale), vous affichez les paragraphes similaires dans la colonne droite (s'il y en a). Sur ces paragraphes similaires, en haut à droite, vous trouvez un *indice/pourcentage de similarité*.

Plus cet indice se rapproche de `100` (« 100 % ») et plus le paragraphe est proche, identique, au paragraphe référent. Inversement, plus il est petit et moins le paragraphe est similaire à son référent, plus c'est un paragraphe différent.

## Modification des paragraphes {#modify_paragraphs}

Les paragraphes peuvent être modifiés, détruits ou remplacés dans le fichier `data_paragraphes.yml` à la racine du dossier. Pour modifier un texte d'un paragraphe, il suffit de… modifier ce texte dans ce fichier.

Notez que comme pour le fichier `_current_lm_.js` tout à l'heure, il faut toujours enregistrer ce fichier en texte simple (sans mise en forme). Dans le cas contraire, le fichier deviendrait illisible.

Attention, ce faisant, de ne pas corrompre les données. Le mieux, en l'occurence, est de toujours faire une copie avant de modifier ce fichier et d'y revenir en cas de problème.

Après toute modification, cependant, il ne faut pas oublier de relancer le script `runner.rb` pour actualiser les résultats : `ruby /path/to/runner.rb` dans votre console.

<a name="lettres_traiteds"/>
## Les lettres traitées

Après avoir été traitées, les lettres données en exemple — dont on a extrait les paragraphes au départ — sont placées dans le dossier `originales_traiteds` pour ne pas être traitées deux fois.

## Enjoy!

Amusez-vous bien !

## Versions

### 1.1.0

* Vérification de la validité des informations. Des lettres doivent avoir été traitées pour que la construction soit possible.

### 1.0.3

* Le filtre des paragraphes n'est plus appliqué aux paragraphes de la lettre.

### 1.0.2

Première version complète.
