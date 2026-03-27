// ============================================================
// LEGAL QUEST — Banque de questions complète (20 fiches)
// ============================================================

import 'game_models.dart';

class QuestionBank {
  static const List<Question> allQuestions = [

    // ═══════════════════════════════════════════════════════
    // MODULE 1 — FONDAMENTAUX JURIDIQUES (Fiches 1-3)
    // ═══════════════════════════════════════════════════════

    Question(
      id: 'f1_q1',
      questionText:
          'Léa veut ouvrir DIGIT\'SHOP. Quelle loi française encadre principalement le commerce en ligne ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.easy,
      ficheReference: 'Fiche 1',
      module: ModuleTheme.fondamentaux,
      points: 100,
      timeSeconds: 30,
      correctAnswerId: 'b',
      explanation:
          'La LCEN (Loi pour la Confiance dans l\'Économie Numérique) du 21 juin 2004 est le texte fondateur du droit de l\'internet en France. Elle encadre le e-commerce, les hébergeurs, la publicité en ligne et les communications électroniques.',
      answers: [
        Answer(id: 'a', text: 'La loi Sapin II (2016)', isCorrect: false),
        Answer(id: 'b', text: 'La LCEN — Loi pour la Confiance dans l\'Économie Numérique (2004)', isCorrect: true),
        Answer(id: 'c', text: 'La loi HADOPI (2009)', isCorrect: false),
        Answer(id: 'd', text: 'Le Code de commerce (article L.121)', isCorrect: false),
      ],
    ),

    Question(
      id: 'f1_q2',
      questionText:
          'VRAI ou FAUX : Un site e-commerce basé en France doit obligatoirement respecter le droit français même s\'il vend à des clients européens.',
      type: QuestionType.trueFalse,
      difficulty: Difficulty.medium,
      ficheReference: 'Fiche 1',
      module: ModuleTheme.fondamentaux,
      points: 80,
      timeSeconds: 20,
      correctAnswerId: 'vrai',
      explanation:
          'VRAI. Un site établi en France est soumis au droit français. De plus, pour les consommateurs européens, c\'est le droit de leur pays de résidence qui s\'applique pour leur protection (règlement Rome I). Léa doit donc connaître les deux niveaux de réglementation.',
      answers: [
        Answer(id: 'vrai', text: 'VRAI', isCorrect: true),
        Answer(id: 'faux', text: 'FAUX', isCorrect: false),
      ],
    ),

    Question(
      id: 'f2_q1',
      questionText:
          'Léa veut déposer le nom de domaine "digitshop.fr". Quel organisme gère les noms de domaine en ".fr" ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.easy,
      ficheReference: 'Fiche 2',
      module: ModuleTheme.fondamentaux,
      points: 100,
      timeSeconds: 25,
      correctAnswerId: 'b',
      explanation:
          'L\'AFNIC (Association Française pour le Nommage Internet en Coopération) est le registre officiel des noms de domaine en .fr. Elle délègue la vente aux bureaux d\'enregistrement accrédités. L\'ICANN gère les noms de domaine génériques (.com, .org, etc.).',
      answers: [
        Answer(id: 'a', text: 'L\'ICANN (Internet Corporation for Assigned Names)', isCorrect: false),
        Answer(id: 'b', text: 'L\'AFNIC (Association Française pour le Nommage Internet)', isCorrect: true),
        Answer(id: 'c', text: 'L\'ARCEP (Autorité de Régulation des Télécoms)', isCorrect: false),
        Answer(id: 'd', text: 'La CNIL (Commission Nationale Informatique et Libertés)', isCorrect: false),
      ],
    ),

    Question(
      id: 'f2_q2',
      questionText:
          'Un concurrent enregistre "digit-shop.fr" pour nuire à DIGIT\'SHOP. Comment appelle-t-on cette pratique ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.medium,
      ficheReference: 'Fiche 2',
      module: ModuleTheme.fondamentaux,
      points: 120,
      timeSeconds: 30,
      correctAnswerId: 'c',
      explanation:
          'Le cybersquatting consiste à enregistrer un nom de domaine correspondant à une marque connue dans le but de le revendre ou de nuire. La victime peut agir en justice via la procédure UDRP (Uniform Domain Name Dispute Resolution Policy) ou devant les tribunaux français.',
      answers: [
        Answer(id: 'a', text: 'Le phishing', isCorrect: false),
        Answer(id: 'b', text: 'Le typosquatting', isCorrect: false),
        Answer(id: 'c', text: 'Le cybersquatting', isCorrect: true),
        Answer(id: 'd', text: 'La contrefaçon numérique', isCorrect: false),
      ],
    ),

    Question(
      id: 'f3_q1',
      questionText:
          'Léa fait appel à un graphiste pour créer son logo. Elle paie la prestation. À qui appartiennent les droits sur le logo ?',
      type: QuestionType.scenario,
      difficulty: Difficulty.hard,
      ficheReference: 'Fiche 3',
      module: ModuleTheme.fondamentaux,
      points: 200,
      timeSeconds: 45,
      correctAnswerId: 'b',
      explanation:
          'En droit français, les droits d\'auteur appartiennent automatiquement au créateur (le graphiste), même s\'il est payé. Pour que Léa soit propriétaire du logo, elle DOIT inclure une clause de cession de droits dans le contrat de prestation. Sans cette clause, le graphiste reste titulaire des droits.',
      answers: [
        Answer(id: 'a', text: 'À Léa, car elle a payé la prestation', isCorrect: false),
        Answer(id: 'b', text: 'Au graphiste, sauf clause contractuelle de cession de droits', isCorrect: true),
        Answer(id: 'c', text: 'Les deux en co-propriété automatiquement', isCorrect: false),
        Answer(id: 'd', text: 'À personne, c\'est un objet commercial non protégeable', isCorrect: false),
      ],
    ),

    Question(
      id: 'f3_q2',
      questionText:
          'VRAI ou FAUX : Léa peut utiliser librement une image trouvée sur Google Images pour illustrer son site web.',
      type: QuestionType.trueFalse,
      difficulty: Difficulty.easy,
      ficheReference: 'Fiche 3',
      module: ModuleTheme.fondamentaux,
      points: 80,
      timeSeconds: 20,
      correctAnswerId: 'faux',
      explanation:
          'FAUX. Toute image sur Internet est protégée par le droit d\'auteur dès sa création. Utiliser une image sans autorisation constitue une contrefaçon, même si elle est facilement accessible sur Google. Léa doit utiliser des images libres de droits (Creative Commons, Unsplash, Pixabay) ou acheter les droits d\'utilisation.',
      answers: [
        Answer(id: 'vrai', text: 'VRAI', isCorrect: false),
        Answer(id: 'faux', text: 'FAUX', isCorrect: true),
      ],
    ),

    // ═══════════════════════════════════════════════════════
    // MODULE 2 — DONNÉES PERSONNELLES & RGPD (Fiches 4-5)
    // ═══════════════════════════════════════════════════════

    Question(
      id: 'f4_q1',
      questionText:
          'DIGIT\'SHOP collecte les emails de ses clients. Quel est le montant maximal d\'amende pour violation grave du RGPD ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.medium,
      ficheReference: 'Fiche 4',
      module: ModuleTheme.donneesRGPD,
      points: 150,
      timeSeconds: 30,
      correctAnswerId: 'c',
      explanation:
          'Le RGPD prévoit deux niveaux de sanction : jusqu\'à 10 millions € ou 2% du CA mondial pour les violations moins graves (niveau 1), et jusqu\'à 20 millions € ou 4% du CA mondial annuel pour les violations les plus graves (niveau 2), notamment en cas d\'atteinte aux droits fondamentaux des personnes.',
      answers: [
        Answer(id: 'a', text: '500 000 € ou 1% du chiffre d\'affaires', isCorrect: false),
        Answer(id: 'b', text: '10 millions € ou 2% du CA mondial', isCorrect: false),
        Answer(id: 'c', text: '20 millions € ou 4% du CA mondial annuel', isCorrect: true),
        Answer(id: 'd', text: '50 millions € forfaitaires', isCorrect: false),
      ],
    ),

    Question(
      id: 'f4_q2',
      questionText:
          'Léa collecte uniquement les données strictement nécessaires à la livraison. Quel principe RGPD respecte-t-elle ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.medium,
      ficheReference: 'Fiche 4',
      module: ModuleTheme.donneesRGPD,
      points: 120,
      timeSeconds: 30,
      correctAnswerId: 'b',
      explanation:
          'Le principe de minimisation des données (Art. 5.1.c RGPD) impose de ne collecter que les données adéquates, pertinentes et limitées à ce qui est nécessaire au regard des finalités pour lesquelles elles sont traitées. C\'est l\'un des 7 principes fondamentaux du RGPD.',
      answers: [
        Answer(id: 'a', text: 'Le principe de finalité', isCorrect: false),
        Answer(id: 'b', text: 'Le principe de minimisation des données', isCorrect: true),
        Answer(id: 'c', text: 'Le principe d\'exactitude', isCorrect: false),
        Answer(id: 'd', text: 'Le principe de transparence', isCorrect: false),
      ],
    ),

    Question(
      id: 'f4_q3',
      questionText:
          'SCÉNARIO — Un client demande à Léa d\'effacer toutes ses données personnelles. Léa a 72 heures pour répondre. VRAI ou FAUX ?',
      type: QuestionType.trueFalse,
      difficulty: Difficulty.hard,
      ficheReference: 'Fiche 4',
      module: ModuleTheme.donneesRGPD,
      points: 160,
      timeSeconds: 25,
      correctAnswerId: 'faux',
      explanation:
          'FAUX. Pour répondre à une demande d\'exercice de droits (droit à l\'effacement, droit d\'accès, etc.), le délai légal est d\'1 mois (pouvant être prolongé de 2 mois supplémentaires si la demande est complexe). Le délai de 72 heures concerne la notification d\'une violation de données personnelles à la CNIL (Art. 33 RGPD).',
      answers: [
        Answer(id: 'vrai', text: 'VRAI', isCorrect: false),
        Answer(id: 'faux', text: 'FAUX', isCorrect: true),
      ],
    ),

    Question(
      id: 'f5_q1',
      questionText:
          'Léa installe des cookies analytiques sur DIGIT\'SHOP. Que doit-elle faire AVANT leur activation ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.medium,
      ficheReference: 'Fiche 5',
      module: ModuleTheme.donneesRGPD,
      points: 140,
      timeSeconds: 35,
      correctAnswerId: 'd',
      explanation:
          'Pour les cookies non essentiels (analytiques, publicitaires, de personnalisation), le consentement préalable et éclairé de l\'utilisateur est OBLIGATOIRE avant toute activation. La bannière cookies doit proposer un bouton "Accepter" et un bouton "Refuser" également visible. Le simple refus doit être aussi simple que l\'acceptation.',
      answers: [
        Answer(id: 'a', text: 'Mentionner les cookies dans les CGV uniquement', isCorrect: false),
        Answer(id: 'b', text: 'Envoyer un email d\'information aux utilisateurs', isCorrect: false),
        Answer(id: 'c', text: 'Déclarer les cookies à la CNIL par formulaire', isCorrect: false),
        Answer(id: 'd', text: 'Obtenir le consentement préalable via une bannière conforme', isCorrect: true),
      ],
    ),

    Question(
      id: 'f5_q2',
      questionText:
          'FLASH — Citez 2 types de cookies qui NE nécessitent PAS de consentement (exemption CNIL). Vous avez 15 secondes !',
      type: QuestionType.flashChallenge,
      difficulty: Difficulty.hard,
      ficheReference: 'Fiche 5',
      module: ModuleTheme.donneesRGPD,
      points: 200,
      timeSeconds: 15,
      correctAnswerId: 'b',
      explanation:
          'Les cookies exemptés de consentement selon les lignes directrices CNIL incluent : (1) les cookies de session (panier d\'achat, authentification), (2) les cookies de préférence linguistique, (3) certains cookies de mesure d\'audience strictement limités à la mesure statistique anonyme (ex: Matomo configuré en mode anonyme). Les cookies publicitaires, de réseaux sociaux et analytics tiers (Google Analytics) NÉCESSITENT un consentement.',
      answers: [
        Answer(id: 'a', text: 'Cookies publicitaires + cookies de session', isCorrect: false),
        Answer(id: 'b', text: 'Cookies de session (panier/auth) + cookies de mesure d\'audience anonymes', isCorrect: true),
        Answer(id: 'c', text: 'Cookies Google Analytics + cookies de préférence', isCorrect: false),
        Answer(id: 'd', text: 'Tous les cookies internes au site', isCorrect: false),
      ],
    ),

    // ═══════════════════════════════════════════════════════
    // MODULE 3 — CONTRAT & CONSOMMATEUR (Fiches 6-10)
    // ═══════════════════════════════════════════════════════

    Question(
      id: 'f6_q1',
      questionText:
          'Léa veut envoyer une newsletter commerciale à ses clients particuliers (B2C). Quelle règle s\'applique ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.medium,
      ficheReference: 'Fiche 6',
      module: ModuleTheme.contratConsommateur,
      points: 130,
      timeSeconds: 35,
      correctAnswerId: 'a',
      explanation:
          'En B2C, la règle de l\'OPT-IN s\'applique obligatoirement : le consommateur doit avoir donné son consentement PRÉALABLE et EXPLICITE avant de recevoir des emails commerciaux. En B2B, c\'est l\'opt-out qui s\'applique : les professionnels peuvent recevoir des emails commerciaux liés à leur activité, sauf s\'ils s\'y sont opposés.',
      answers: [
        Answer(id: 'a', text: 'Opt-in obligatoire : consentement préalable explicite requis', isCorrect: true),
        Answer(id: 'b', text: 'Opt-out suffisant : ils peuvent se désinscrire après', isCorrect: false),
        Answer(id: 'c', text: 'Aucune règle particulière, l\'email est libre', isCorrect: false),
        Answer(id: 'd', text: 'Autorisation préfectorale requise pour l\'e-mailing', isCorrect: false),
      ],
    ),

    Question(
      id: 'f7_q1',
      questionText:
          'Quelles informations sont OBLIGATOIRES dans les mentions légales d\'un site e-commerce selon la LCEN ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.hard,
      ficheReference: 'Fiche 7',
      module: ModuleTheme.contratConsommateur,
      points: 180,
      timeSeconds: 40,
      correctAnswerId: 'c',
      explanation:
          'Les mentions légales obligatoires incluent : (1) Nom/raison sociale de l\'entreprise, (2) Adresse du siège social, (3) Numéro RCS ou SIRET, (4) Numéro de TVA intracommunautaire, (5) Coordonnées de contact (email + téléphone), (6) Nom de l\'hébergeur et ses coordonnées, (7) Directeur de publication. L\'absence de mentions légales est une infraction pénale (amende jusqu\'à 75 000€).',
      answers: [
        Answer(id: 'a', text: 'Uniquement le nom et l\'adresse email de contact', isCorrect: false),
        Answer(id: 'b', text: 'Nom, adresse et logo de l\'entreprise seulement', isCorrect: false),
        Answer(id: 'c', text: 'Identité complète, SIRET, hébergeur, directeur de publication et contacts', isCorrect: true),
        Answer(id: 'd', text: 'CGV, politique de confidentialité et numéro de TVA', isCorrect: false),
      ],
    ),

    Question(
      id: 'f8_q1',
      questionText:
          'SCÉNARIO — Un commentaire injurieux est posté sur le blog de DIGIT\'SHOP. Quelle est la responsabilité de Léa ?',
      type: QuestionType.scenario,
      difficulty: Difficulty.hard,
      ficheReference: 'Fiche 8',
      module: ModuleTheme.contratConsommateur,
      points: 200,
      timeSeconds: 45,
      correctAnswerId: 'b',
      explanation:
          'En tant qu\'éditeur de son site, Léa a une responsabilité éditoriale sur les contenus qu\'elle publie. Pour les contenus tiers (commentaires), elle bénéficie du régime allégé des hébergeurs SI elle réagit promptement après notification. Si elle est informée du contenu illicite et ne le supprime pas rapidement, sa responsabilité civile ET pénale peut être engagée (LCEN Art. 6).',
      answers: [
        Answer(id: 'a', text: 'Aucune responsabilité : les internautes sont seuls responsables', isCorrect: false),
        Answer(id: 'b', text: 'Responsabilité engagée si elle ne supprime pas le contenu après signalement', isCorrect: true),
        Answer(id: 'c', text: 'Responsabilité automatique et immédiate dès la publication', isCorrect: false),
        Answer(id: 'd', text: 'Seule la responsabilité pénale, jamais civile', isCorrect: false),
      ],
    ),

    Question(
      id: 'f9_q1',
      questionText:
          'VRAI ou FAUX : Les CGV (Conditions Générales de Vente) sont facultatives pour un site e-commerce B2C en France.',
      type: QuestionType.trueFalse,
      difficulty: Difficulty.easy,
      ficheReference: 'Fiche 9',
      module: ModuleTheme.contratConsommateur,
      points: 80,
      timeSeconds: 20,
      correctAnswerId: 'faux',
      explanation:
          'FAUX. Les CGV sont OBLIGATOIRES pour tout site e-commerce en B2C. L\'article L.111-1 du Code de la consommation impose l\'information pré-contractuelle obligatoire. Les CGV doivent être accessibles facilement et lues + acceptées avant toute commande. En B2B, elles sont fortement recommandées et constituent souvent le socle de la relation commerciale.',
      answers: [
        Answer(id: 'vrai', text: 'VRAI', isCorrect: false),
        Answer(id: 'faux', text: 'FAUX', isCorrect: true),
      ],
    ),

    Question(
      id: 'f10_q1',
      questionText:
          'Léa doit afficher un bouton pour finaliser la commande. Quelle formulation est légalement requise ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.medium,
      ficheReference: 'Fiche 10',
      module: ModuleTheme.contratConsommateur,
      points: 140,
      timeSeconds: 30,
      correctAnswerId: 'b',
      explanation:
          'La directive européenne 2011/83 (transposée en droit français) impose que le bouton de validation de commande comporte une formulation explicite indiquant l\'obligation de paiement. La mention "Commander et payer" (ou équivalent : "Valider ma commande payante") est la formulation standard. Un simple "Valider" ou "OK" est insuffisant et constitue une infraction.',
      answers: [
        Answer(id: 'a', text: '"Valider" ou "Confirmer"', isCorrect: false),
        Answer(id: 'b', text: '"Commander et payer" ou équivalent explicite', isCorrect: true),
        Answer(id: 'c', text: '"Accepter les CGV et finaliser"', isCorrect: false),
        Answer(id: 'd', text: 'Aucune formulation spécifique n\'est imposée', isCorrect: false),
      ],
    ),

    // ═══════════════════════════════════════════════════════
    // MODULE 4 — PRATIQUES ET DROITS (Fiches 11-15)
    // ═══════════════════════════════════════════════════════

    Question(
      id: 'f11_q1',
      questionText:
          'Un client commande des fournitures de bureau sur DIGIT\'SHOP. De combien de jours dispose-t-il pour se rétracter ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.easy,
      ficheReference: 'Fiche 11',
      module: ModuleTheme.pratiquesPublicite,
      points: 100,
      timeSeconds: 25,
      correctAnswerId: 'b',
      explanation:
          'Le droit de rétractation légal est de 14 jours calendaires à compter de la réception du bien (Art. L.221-18 Code de la consommation). Ce délai s\'applique à toute vente à distance B2C dans l\'UE. Si Léa n\'informe pas le client de ce droit, le délai est automatiquement prolongé à 12 mois + 14 jours !',
      answers: [
        Answer(id: 'a', text: '7 jours ouvrables', isCorrect: false),
        Answer(id: 'b', text: '14 jours calendaires', isCorrect: true),
        Answer(id: 'c', text: '30 jours calendaires', isCorrect: false),
        Answer(id: 'd', text: '21 jours ouvrables', isCorrect: false),
      ],
    ),

    Question(
      id: 'f11_q2',
      questionText:
          'SCÉNARIO — Une cliente commande un agenda personnalisé avec ses initiales gravées. Peut-elle se rétracter ?',
      type: QuestionType.scenario,
      difficulty: Difficulty.hard,
      ficheReference: 'Fiche 11',
      module: ModuleTheme.pratiquesPublicite,
      points: 200,
      timeSeconds: 45,
      correctAnswerId: 'c',
      explanation:
          'NON. L\'article L.221-28 du Code de la consommation liste les exceptions au droit de rétractation. Les biens confectionnés selon les spécifications du consommateur (sur mesure, personnalisés) ne peuvent pas être retournés car ils ne peuvent pas être revendus à un tiers. Léa doit informer clairement le client de cette exception AVANT la commande.',
      answers: [
        Answer(id: 'a', text: 'Oui, le droit de rétractation s\'applique toujours en ligne', isCorrect: false),
        Answer(id: 'b', text: 'Oui, mais uniquement dans les 7 jours suivant la livraison', isCorrect: false),
        Answer(id: 'c', text: 'Non, les biens personnalisés sont exclus du droit de rétractation', isCorrect: true),
        Answer(id: 'd', text: 'Oui, sauf si Léa a inclus une clause contraire dans ses CGV', isCorrect: false),
      ],
    ),

    Question(
      id: 'f12_q1',
      questionText:
          'Léa affiche "-50%" sur un article. Quel est le prix de référence légal depuis la directive Omnibus (2022) ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.hard,
      ficheReference: 'Fiche 12',
      module: ModuleTheme.pratiquesPublicite,
      points: 180,
      timeSeconds: 40,
      correctAnswerId: 'a',
      explanation:
          'La directive Omnibus (transposée en France en 2022) impose que le prix de référence pour calculer une réduction soit le prix le plus bas pratiqué par le vendeur dans les 30 jours précédant la promotion. Cette règle vise à interdire les fausses promotions (gonfler artificiellement le prix avant de faire une "réduction"). La DGCCRF peut infliger des amendes jusqu\'à 15 000€ par infraction.',
      answers: [
        Answer(id: 'a', text: 'Le prix le plus bas des 30 derniers jours avant la promotion', isCorrect: true),
        Answer(id: 'b', text: 'Le prix conseillé par le fournisseur (PRIX public)', isCorrect: false),
        Answer(id: 'c', text: 'Le prix moyen du marché constaté par la DGCCRF', isCorrect: false),
        Answer(id: 'd', text: 'Le prix pratiqué la veille de la promotion', isCorrect: false),
      ],
    ),

    Question(
      id: 'f13_q1',
      questionText:
          'VRAI ou FAUX : Un contrat conclu en ligne par double-clic a la même valeur juridique qu\'un contrat papier signé.',
      type: QuestionType.trueFalse,
      difficulty: Difficulty.medium,
      ficheReference: 'Fiche 13',
      module: ModuleTheme.pratiquesPublicite,
      points: 120,
      timeSeconds: 20,
      correctAnswerId: 'vrai',
      explanation:
          'VRAI. Le Code civil (art. 1366 et 1367) reconnaît la valeur probatoire de l\'écrit électronique et de la signature électronique. Le mécanisme du "double clic" (présentation de l\'offre → validation → récapitulatif → confirmation définitive) constitue un processus de formation du contrat électronique valide, ayant la même force juridique qu\'un contrat papier signé.',
      answers: [
        Answer(id: 'vrai', text: 'VRAI', isCorrect: true),
        Answer(id: 'faux', text: 'FAUX', isCorrect: false),
      ],
    ),

    Question(
      id: 'f15_q1',
      questionText:
          'Léa publie une photo d\'une cliente satisfaite sur son site. La cliente n\'a rien signé. C\'est légal ?',
      type: QuestionType.trueFalse,
      difficulty: Difficulty.medium,
      ficheReference: 'Fiche 15',
      module: ModuleTheme.pratiquesPublicite,
      points: 140,
      timeSeconds: 25,
      correctAnswerId: 'faux',
      explanation:
          'FAUX. Le droit à l\'image est un droit de la personnalité (Art. 9 du Code civil). Toute personne a le droit exclusif sur son image et son utilisation. Léa doit obligatoirement obtenir une autorisation écrite (release ou contrat de droit à l\'image) de la personne photographiée, même si celle-ci est cliente, avant toute diffusion publique de sa photo. À défaut, la cliente peut exiger le retrait ET demander des dommages-intérêts.',
      answers: [
        Answer(id: 'vrai', text: 'VRAI', isCorrect: false),
        Answer(id: 'faux', text: 'FAUX', isCorrect: true),
      ],
    ),

    // ═══════════════════════════════════════════════════════
    // MODULE 5 — CONTENUS & RÉPUTATION (Fiches 16-19)
    // ═══════════════════════════════════════════════════════

    Question(
      id: 'f16_q1',
      questionText:
          'Le DSA (Digital Services Act) est entré en vigueur en 2024. Quelle obligation principale impose-t-il à DIGIT\'SHOP ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.hard,
      ficheReference: 'Fiche 16',
      module: ModuleTheme.contenuReputation,
      points: 180,
      timeSeconds: 40,
      correctAnswerId: 'b',
      explanation:
          'Le DSA (Règlement (UE) 2022/2065) impose aux plateformes et aux sites permettant des contenus générés par des utilisateurs (UGC) de mettre en place un mécanisme de signalement des contenus illicites facilement accessible. Les grandes plateformes ont des obligations renforcées (transparence algorithmique, audit annuel). Pour les PME comme DIGIT\'SHOP, l\'obligation principale est la mise en place d\'un système de signalement interne.',
      answers: [
        Answer(id: 'a', text: 'Supprimer tous les contenus des utilisateurs sous 24h automatiquement', isCorrect: false),
        Answer(id: 'b', text: 'Mettre en place un mécanisme de signalement des contenus illicites', isCorrect: true),
        Answer(id: 'c', text: 'Vérifier l\'identité de chaque utilisateur avant publication', isCorrect: false),
        Answer(id: 'd', text: 'Payer une taxe DSA à la Commission européenne', isCorrect: false),
      ],
    ),

    Question(
      id: 'f17_q1',
      questionText:
          'SCÉNARIO — Un concurrent publie de faux avis 5 étoiles sur son propre site. Comment appelle-t-on cette pratique ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.medium,
      ficheReference: 'Fiche 17',
      module: ModuleTheme.contenuReputation,
      points: 150,
      timeSeconds: 30,
      correctAnswerId: 'c',
      explanation:
          'Les faux avis constituent une pratique commerciale trompeuse (Art. L.121-2 du Code de la consommation), également qualifiée d\'astroturfing. Depuis 2023, la directive Omnibus impose aux plateformes d\'indiquer si les avis sont vérifiés et comment. Les sanctions peuvent aller jusqu\'à 300 000€ d\'amende et 2 ans d\'emprisonnement pour les dirigeants.',
      answers: [
        Answer(id: 'a', text: 'Du dénigrement commercial', isCorrect: false),
        Answer(id: 'b', text: 'De la concurrence parasitaire', isCorrect: false),
        Answer(id: 'c', text: 'Une pratique commerciale trompeuse / astroturfing', isCorrect: true),
        Answer(id: 'd', text: 'Du review bombing', isCorrect: false),
      ],
    ),

    Question(
      id: 'f18_q1',
      questionText:
          'VRAI ou FAUX : Critiquer les produits d\'un concurrent avec des arguments factuels vrais est légalement autorisé.',
      type: QuestionType.trueFalse,
      difficulty: Difficulty.hard,
      ficheReference: 'Fiche 18',
      module: ModuleTheme.contenuReputation,
      points: 160,
      timeSeconds: 30,
      correctAnswerId: 'faux',
      explanation:
          'FAUX (nuancé). Si la critique s\'appuie sur des faits avérés et vérifiables, elle peut être licite. Mais en pratique, dénigrer un concurrent même avec des arguments vrais peut constituer un acte de concurrence déloyale si l\'intention est de nuire et si cela cause un préjudice commercial. La jurisprudence distingue la critique légitime (comparative, objective) du dénigrement (affirmations portant atteinte à la réputation dans l\'intention de nuire).',
      answers: [
        Answer(id: 'vrai', text: 'VRAI', isCorrect: false),
        Answer(id: 'faux', text: 'FAUX — Risque de dénigrement même avec des faits vrais', isCorrect: true),
      ],
    ),

    Question(
      id: 'f19_q1',
      questionText:
          'Léa veut surveiller sa réputation en ligne. Quel outil GRATUIT lui permet d\'être alertée dès qu\'on parle de DIGIT\'SHOP ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.easy,
      ficheReference: 'Fiche 19',
      module: ModuleTheme.contenuReputation,
      points: 80,
      timeSeconds: 20,
      correctAnswerId: 'a',
      explanation:
          'Google Alerts (alerts.google.com) est un service gratuit qui envoie des notifications par email dès que Google indexe un nouveau contenu contenant les mots-clés choisis. C\'est l\'outil de veille d\'e-réputation le plus accessible pour une TPE/PME. Des outils plus avancés (Mention, Brand24, Talkwalker) existent mais sont payants.',
      answers: [
        Answer(id: 'a', text: 'Google Alerts', isCorrect: true),
        Answer(id: 'b', text: 'Google Search Console', isCorrect: false),
        Answer(id: 'c', text: 'SEMrush', isCorrect: false),
        Answer(id: 'd', text: 'HubSpot CRM', isCorrect: false),
      ],
    ),

    // ═══════════════════════════════════════════════════════
    // MODULE 6 — GRAND FINAL : DIGIT'SHOP EN CRISE (Fiche 20)
    // ═══════════════════════════════════════════════════════

    Question(
      id: 'gf_q1',
      questionText:
          '🚨 CRISE — DIGIT\'SHOP subit une fuite de données ! 5 000 emails clients sont exposés. Délai légal pour notifier la CNIL ?',
      type: QuestionType.scenario,
      difficulty: Difficulty.hard,
      ficheReference: 'Fiche 20',
      module: ModuleTheme.grandFinal,
      points: 300,
      timeSeconds: 30,
      correctAnswerId: 'b',
      explanation:
          'En cas de violation de données personnelles présentant un risque pour les personnes, le responsable de traitement doit notifier la CNIL dans un délai de 72 HEURES après en avoir pris connaissance (Art. 33 RGPD). Si la violation présente un risque élevé pour les droits des personnes, les individus concernés doivent également être informés "dans les meilleurs délais". DIGIT\'SHOP doit aussi documenter l\'incident dans son registre de violations.',
      answers: [
        Answer(id: 'a', text: '24 heures', isCorrect: false),
        Answer(id: 'b', text: '72 heures', isCorrect: true),
        Answer(id: 'c', text: '7 jours ouvrables', isCorrect: false),
        Answer(id: 'd', text: '1 mois', isCorrect: false),
      ],
    ),

    Question(
      id: 'gf_q2',
      questionText:
          '🚨 CRISE — Un influenceur publie une revue de DIGIT\'SHOP sans mentionner qu\'il est payé. Quelle infraction commet-il ?',
      type: QuestionType.qcm,
      difficulty: Difficulty.hard,
      ficheReference: 'Fiche 20',
      module: ModuleTheme.grandFinal,
      points: 250,
      timeSeconds: 35,
      correctAnswerId: 'c',
      explanation:
          'La loi du 9 juin 2023 sur les influenceurs impose une transparence totale sur les partenariats commerciaux. Tout contenu publicitaire doit être clairement identifié comme tel avec la mention "Publicité" ou "Collaboration commerciale". L\'absence de mention constitue une pratique commerciale trompeuse (jusqu\'à 300 000€ d\'amende) et un manquement aux obligations imposées aux influenceurs commerciaux.',
      answers: [
        Answer(id: 'a', text: 'Du dénigrement involontaire', isCorrect: false),
        Answer(id: 'b', text: 'Une violation du RGPD', isCorrect: false),
        Answer(id: 'c', text: 'Une pratique commerciale trompeuse — absence de mention "Publicité"', isCorrect: true),
        Answer(id: 'd', text: 'Une concurrence déloyale envers les autres influenceurs', isCorrect: false),
      ],
    ),

    Question(
      id: 'gf_q3',
      questionText:
          '🏆 DÉFI FINAL — Complétez la checklist DIGIT\'SHOP : Quelle est la bonne ORDER des étapes de création d\'un site e-commerce conforme ?',
      type: QuestionType.scenario,
      difficulty: Difficulty.hard,
      ficheReference: 'Fiche 20',
      module: ModuleTheme.grandFinal,
      points: 400,
      timeSeconds: 60,
      correctAnswerId: 'b',
      explanation:
          'L\'ordre optimal pour un site e-commerce conforme est : (1) Déposer le nom de domaine et la marque (protection intellectuelle), (2) Rédiger les CGV et mentions légales (cadre contractuel), (3) Configurer le RGPD / registre des traitements / bannière cookies (données personnelles), (4) Mettre en place les mécanismes de commande conformes - bouton "Commander et payer", processus double clic (contrat), (5) Lancer avec une politique d\'e-mailing opt-in et une veille e-réputation (communication). Cette séquence garantit une conformité totale avant ouverture.',
      answers: [
        Answer(id: 'a', text: 'RGPD → CGV → Nom de domaine → Commande → E-mailing', isCorrect: false),
        Answer(id: 'b', text: 'Nom de domaine → CGV & Mentions → RGPD & Cookies → Commande → E-mailing & Veille', isCorrect: true),
        Answer(id: 'c', text: 'CGV → Commande → RGPD → Nom de domaine → Cookies', isCorrect: false),
        Answer(id: 'd', text: 'Toutes les étapes peuvent être faites simultanément sans ordre', isCorrect: false),
      ],
    ),
  ];

  static List<Question> getModuleQuestions(ModuleTheme module) =>
      allQuestions.where((q) => q.module == module).toList();
}
