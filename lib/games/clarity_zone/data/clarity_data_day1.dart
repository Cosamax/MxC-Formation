import 'package:flutter/material.dart';
import '../models/clarity_models.dart';

// ═══════════════════════════════════════════════════════════════
// CLARITY ZONE — JOUR 1 : Les Fondamentaux (Fiches 1 à 7)
// Entreprise fictive : CLARTÉ CONSEIL
// Secteur : Cabinet de conseil en organisation
// ═══════════════════════════════════════════════════════════════

class ClarityDataDay1 {
  static List<ClarityChallenge> get challenges => [
    // ── CHALLENGE 1 ── Fiche 2 : Reconnaître une vraie consigne ──
    ClarityChallenge(
      id: 'cz_d1_c1',
      dayNumber: 1,
      orderInDay: 1,
      title: 'Le dossier Fontaine',
      subtitle: 'Reconnaître une consigne floue avant qu\'il soit trop tard',
      emoji: '',
      color: const Color(0xFF2196F3),
      ficheRef: 'Fiche 2',
      scenario: ClarityScenario(
        context:
            'Vous êtes assistant(e) de direction chez CLARTÉ CONSEIL. '
            'Ce matin, votre manager Thomas entre en coup de vent dans le bureau '
            'et vous lance une consigne avant de repartir en réunion.',
        urgencyMessage: ' Thomas repart dans 30 secondes — il faut réagir maintenant !',
        roleInstruction:
            ' Vous jouez le rôle de LÉA, assistante de direction. '
            'Thomas vient de vous dire : "Occupe-toi du dossier Fontaine." '
            'Il est déjà dans le couloir. Que faites-vous ?',
        acts: [
          ClarityAct(
            title: 'Acte 1 — La consigne tombe',
            narrative:
                'Thomas passe la tête par la porte : "Léa, occupe-toi du dossier Fontaine, '
                'c\'est important." Il disparaît aussitôt. Vous avez trois dossiers Fontaine '
                'sur votre bureau et aucune idée de ce qu\'il attend.',
            characterMessage: 'Léa, occupe-toi du dossier Fontaine, c\'est important.',
            characterName: 'Thomas — Manager',
            characterEmoji: '',
            roleContext: 'Vous êtes Léa. Que faites-vous en premier ?',
            toolTask:
                'Rédigez la question de clarification exacte que vous poseriez à Thomas par message. '
                'Elle doit identifier les 3 éléments manquants (quoi précisément, pour quand, quel résultat).',
            options: [
              ClarityOption(
                id: 'a', label: 'Je l\'interpelle dans le couloir : "Thomas, tu veux dire lequel des trois ?"',
                explanation: 'Vous ciblez le bon point — lequel — mais la question reste incomplète.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: -5, stress: 5),
                consequence: 'Thomas répond "le principal" et repart. Toujours flou.',
              ),
              ClarityOption(
                id: 'b', label: 'Je lui envoie un message : "Quel dossier Fontaine, pour quand et que dois-je faire exactement ?"',
                explanation: 'Parfait. Vous identifiez les 3 éléments manquants en une seule question ciblée.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 15, trust: 10, efficiency: 10, stress: -10),
                consequence: 'Thomas répond clairement. Vous pouvez démarrer sans risque d\'erreur.',
              ),
              ClarityOption(
                id: 'c', label: 'Je commence par le dossier qui semble le plus urgent parmi les trois.',
                explanation: 'Vous agissez sans vérifier. C\'est le piège classique des suppositions.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -10, efficiency: -15, stress: 15),
                consequence: 'Vous travaillez sur le mauvais dossier. Thomas revient 2h plus tard — frustration des deux côtés.',
              ),
              ClarityOption(
                id: 'd', label: 'J\'attends que Thomas revienne de réunion pour demander.',
                explanation: 'Vous évitez l\'erreur mais perdez du temps précieux.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: -5, efficiency: -10, stress: 10),
                consequence: 'Thomas revient 3h plus tard. Le dossier était urgent.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — Thomas précise, mais à moitié',
            narrative:
                'Thomas vous répond par message : "Le dossier de proposition commerciale. '
                'C\'est pour le client." Mieux, mais toujours incomplet. '
                'Il manque le délai et le format attendu.',
            characterMessage: 'Le dossier de proposition commerciale. C\'est pour le client.',
            characterName: 'Thomas — Manager',
            characterEmoji: '',
            roleContext: 'Bonne nouvelle : il a répondu ! Mais que manque-t-il encore ?',
            toolTask:
                'Identifiez les 2 éléments encore manquants dans la réponse de Thomas '
                'et rédigez la relance en une seule phrase.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je relance : "Pour quand et sous quel format ?"',
                explanation: 'Ciblé, court, efficace. Exactement ce qu\'il faut.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 15, trust: 10, efficiency: 10, stress: -10),
                consequence: 'Thomas donne le délai (vendredi 15h) et le format (PDF 5 pages). Vous pouvez commencer.',
              ),
              ClarityOption(
                id: 'b', label: 'Je commence — le client c\'est forcément pour bientôt.',
                explanation: 'Supposition dangereuse. "Bientôt" peut vouloir dire aujourd\'hui comme dans 3 semaines.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -15, efficiency: -10, stress: 20),
                consequence: 'Le délai était ce soir. Vous avez passé la journée sur autre chose.',
              ),
              ClarityOption(
                id: 'c', label: 'Je relance avec 5 questions : format, délai, budget, longueur, ton.',
                explanation: 'Trop de questions à la fois. Thomas va se sentir harcelé.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: -5, efficiency: -5, stress: 5),
                consequence: 'Thomas répond à 2 questions sur 5 et ne rappelle pas.',
              ),
              ClarityOption(
                id: 'd', label: 'Je demande à un collègue ce qu\'il sait du dossier.',
                explanation: 'Bonne initiative mais insuffisante — le collègue n\'a pas forcément les infos à jour.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: 0, efficiency: -5, stress: 5),
                consequence: 'Le collègue vous donne des infos de la version précédente. Vous repartez sur une base obsolète.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — La reformulation finale',
            narrative:
                'Thomas vous a donné toutes les infos. Avant de commencer, '
                'vous lui envoyez une reformulation pour valider votre compréhension. '
                'C\'est la dernière étape de la méthode en 3 étapes.',
            characterMessage: 'OK vas-y, je te fais confiance.',
            characterName: 'Thomas — Manager',
            characterEmoji: '',
            roleContext: 'Rédigez la reformulation parfaite avant de démarrer le travail.',
            toolTask:
                'Rédigez la reformulation complète que vous envoyez à Thomas. '
                'Elle doit contenir : l\'action, le délai, le format et le destinataire.',
            options: [
              ClarityOption(
                id: 'a', label: '"OK, je m\'en occupe !"',
                explanation: 'Trop court. Vous n\'avez pas confirmé votre compréhension.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: -5, trust: 0, efficiency: 0, stress: 5),
                consequence: 'Thomas suppose que vous avez tout compris. Un détail important reste flou.',
              ),
              ClarityOption(
                id: 'b', label: '"Si je comprends bien : je prépare la proposition commerciale Fontaine en PDF 5 pages pour vendredi 15h. C\'est bien ça ?"',
                explanation: 'Reformulation parfaite. Action + format + délai. Thomas peut corriger si nécessaire.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 15, efficiency: 15, stress: -15),
                consequence: 'Thomas confirme et ajoute : "Ajoute les tarifs 2026." Info cruciale que vous n\'auriez pas eue sinon.',
              ),
              ClarityOption(
                id: 'c', label: '"Je commence maintenant, je t\'envoie ça vendredi !"',
                explanation: 'Vous avez le délai mais pas confirmé le format ni le contenu exact.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 5, efficiency: 5, stress: 0),
                consequence: 'Acceptable mais vous ratez l\'info sur les tarifs 2026.',
              ),
              ClarityOption(
                id: 'd', label: '"Reçu 5/5 chef !"',
                explanation: 'Informel et ne confirme rien de concret.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -5, efficiency: -5, stress: 10),
                consequence: 'Thomas lève les yeux au ciel. Peu professionnel dans un cabinet de conseil.',
              ),
            ],
          ),
        ],
        debriefTitle: 'Consigne floue = travail inutile',
        keyLessons: [
          'Une consigne complète = QUI + QUOI + QUAND + COMMENT + POURQUOI',
          'Demander des précisions est un signe de professionnalisme, pas de faiblesse',
          'La reformulation finale révèle toujours un détail manquant',
          'Agir sur une consigne floue coûte toujours plus cher qu\'une question posée',
        ],
        commonMistakes: [
          'Commencer sans avoir les 3 éléments clés (quoi/quand/résultat)',
          'Poser 5 questions à la fois au lieu d\'une question ciblée',
          'Reformuler mentalement sans le dire à voix haute',
        ],
        ficheRef: 'Fiches 2, 3 & 5',
      ),
    ),

    // ── CHALLENGE 2 ── Fiche 4 : Présupposés ──
    ClarityChallenge(
      id: 'cz_d1_c2',
      dayNumber: 1,
      orderInDay: 2,
      title: 'Le piège du "c\'est évident"',
      subtitle: 'Identifier les présupposés avant de se lancer',
      emoji: '',
      color: const Color(0xFF9C27B0),
      ficheRef: 'Fiche 4',
      scenario: ClarityScenario(
        context:
            'Vous êtes consultant(e) junior chez CLARTÉ CONSEIL. '
            'Votre manager Sonia vous confie une tâche "simple". '
            'Mais derrière chaque mot se cache un présupposé qui peut tout changer.',
        urgencyMessage: '️ La réunion client est dans 4 heures — chaque erreur coûte cher.',
        roleInstruction:
            ' Vous jouez MARC, consultant junior. '
            'Sonia vient de vous dire : "Mets à jour le fichier client et envoie-le à l\'équipe." '
            'Combien de présupposés cachez-vous dans cette phrase ?',
        acts: [
          ClarityAct(
            title: 'Acte 1 — Décoder les sous-entendus',
            narrative:
                'Sonia dit : "Mets à jour le fichier client et envoie-le à l\'équipe avant la réunion." '
                'Simple en apparence. Pourtant, 6 présupposés se cachent dans cette phrase.',
            characterMessage: 'Mets à jour le fichier client et envoie-le à l\'équipe avant la réunion.',
            characterName: 'Sonia — Manager Senior',
            characterEmoji: '‍',
            roleContext: 'Identifiez les présupposés AVANT d\'agir.',
            toolTask:
                'Listez au moins 4 présupposés cachés dans la consigne de Sonia. '
                'Pour chacun, écrivez la question de clarification associée.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je commence directement — je connais bien les fichiers clients.',
                explanation: 'L\'expérience crée des automatismes dangereux. "Je connais" = "je suppose".',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -15, trust: -10, efficiency: -20, stress: 20),
                consequence: 'Vous mettez à jour les numéros de téléphone. Sonia voulait les tarifs 2026. 3h de travail inutile.',
              ),
              ClarityOption(
                id: 'b', label: 'Je liste mentalement : quel fichier ? Quelle mise à jour ? Quelle équipe ? Quel canal ?',
                explanation: 'Excellent réflexe. Identifier les présupposés avant d\'agir prend 30 secondes et évite des heures d\'erreur.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 10, efficiency: 15, stress: -15),
                consequence: 'Vous posez 2 questions ciblées. Sonia précise en 1 minute. Vous partez dans la bonne direction.',
              ),
              ClarityOption(
                id: 'c', label: 'Je demande à un collègue ce qu\'il a fait la dernière fois.',
                explanation: 'Bonne initiative, mais la situation a peut-être changé depuis.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: -5, stress: 5),
                consequence: 'Le collègue vous donne la procédure d\'il y a 6 mois. Les tarifs ont changé depuis.',
              ),
              ClarityOption(
                id: 'd', label: 'Je fais une mise à jour partielle et j\'attends un retour de Sonia.',
                explanation: 'Vous commencez sans cap clair et espérez une correction. Coûteux en temps.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: -5, efficiency: -10, stress: 10),
                consequence: 'Sonia doit corriger votre travail. Elle commence à douter de votre autonomie.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — Le présupposé qui explose',
            narrative:
                'Vous avez bien clarifié et envoyé le fichier. '
                'Mais 30 minutes plus tard, Sonia revient : "Pourquoi tu l\'as envoyé par email ? '
                'On utilise la plateforme Teams pour tout partage de fichier client."',
            characterMessage: 'Pourquoi tu l\'as envoyé par email ? On utilise Teams pour ça !',
            characterName: 'Sonia — Manager Senior',
            characterEmoji: '‍',
            roleContext: 'Un présupposé sur le canal vient d\'exploser. Comment réagissez-vous ?',
            toolTask:
                'Rédigez votre réponse à Sonia et la procédure que vous allez mettre en place '
                'pour ne plus jamais supposer le canal de transmission.',
            options: [
              ClarityOption(
                id: 'a', label: '"Désolé, je ne savais pas. Je renvoie sur Teams tout de suite."',
                explanation: 'Réaction correcte et rapide. Vous assumez sans vous défendre.',
                isCorrect: true,
                impact: ClarityImpact.good,
                effect: ClarityEffect(clarity: 10, trust: 10, efficiency: 5, stress: -5),
                consequence: 'Sonia apprécie la réactivité. Elle note de préciser le canal à l\'avenir.',
              ),
              ClarityOption(
                id: 'b', label: '"Ce n\'est pas marqué dans les procédures !"',
                explanation: 'Vous avez raison mais le ton défensif nuit à la relation professionnelle.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: 0, trust: -20, efficiency: 0, stress: 20),
                consequence: 'Sonia se ferme. La relation se tend. Vous avez perdu plus que vous n\'avez gagné.',
              ),
              ClarityOption(
                id: 'c', label: '"Je note pour la prochaine fois. Je renvoie sur Teams et j\'ajoute \'canal de partage\' à ma checklist de clarification."',
                explanation: 'Parfait. Vous corrigez, vous apprenez et vous systématisez.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 15, trust: 15, efficiency: 10, stress: -10),
                consequence: 'Sonia vous regarde différemment. Cette réaction montre une vraie maturité professionnelle.',
              ),
              ClarityOption(
                id: 'd', label: 'Je ne dis rien et je renvoie sur Teams silencieusement.',
                explanation: 'Vous réglez le problème mais ratez l\'occasion d\'apprendre et d\'améliorer la communication.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: 0, efficiency: 5, stress: 0),
                consequence: 'Le problème est réglé mais l\'erreur se reproduira probablement.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — Construire son antidote aux présupposés',
            narrative:
                'Fin de journée. Sonia vous réunit pour un debriefing. '
                '"Comment on évite que ça se reproduise ?" Elle vous demande de proposer '
                'une méthode concrète pour l\'équipe.',
            characterMessage: 'Comment on s\'organise pour éviter ces malentendus à l\'avenir ?',
            characterName: 'Sonia — Manager Senior',
            characterEmoji: '‍',
            roleContext: 'Proposez une solution concrète et applicable dès demain.',
            toolTask:
                'Créez une mini-checklist de 4 questions à poser AVANT toute tâche '
                'pour détecter les présupposés cachés. Rendez-la pratique et mémorisable.',
            options: [
              ClarityOption(
                id: 'a', label: '"On fait une réunion d\'équipe chaque matin pour tout clarifier."',
                explanation: 'Trop lourd. Une réunion quotidienne pour des questions de canal, c\'est disproportionné.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: -10, stress: 10),
                consequence: 'L\'équipe trouve ça bureaucratique. La proposition est rejetée.',
              ),
              ClarityOption(
                id: 'b', label: '"Je propose 3 questions systématiques : Quel fichier exactement ? Via quel canal ? Pour qui précisément ?"',
                explanation: 'Simple, actionnable, mémorisable. C\'est exactement ce qu\'il faut.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 15, efficiency: 20, stress: -20),
                consequence: 'Sonia adopte votre méthode pour toute l\'équipe. Vous venez de créer une norme de communication.',
              ),
              ClarityOption(
                id: 'c', label: '"Je ferai plus attention à l\'avenir."',
                explanation: 'Intention sans méthode. "Faire attention" ne change pas les habitudes.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -10, efficiency: 0, stress: 5),
                consequence: 'Sonia n\'est pas convaincue. Le problème se reproduira.',
              ),
              ClarityOption(
                id: 'd', label: '"On met à jour le guide des procédures avec les canaux à utiliser par type de tâche."',
                explanation: 'Excellente idée complémentaire, mais plus longue à mettre en place.',
                isCorrect: true,
                impact: ClarityImpact.good,
                effect: ClarityEffect(clarity: 15, trust: 10, efficiency: 15, stress: -10),
                consequence: 'Sonia approuve et vous confie la rédaction du guide. C\'est une promotion informelle.',
              ),
            ],
          ),
        ],
        debriefTitle: 'Le présupposé invisible',
        keyLessons: [
          'Un présupposé est une info que l\'émetteur croit évidente et ne dit pas',
          'Avant d\'agir : lister ses suppositions, évaluer le risque, vérifier les plus importantes',
          'L\'expérience ne protège pas des présupposés — elle en crée de nouveaux',
          'Une question ciblée en 30 secondes évite des heures dans la mauvaise direction',
        ],
        commonMistakes: [
          'Croire que l\'expérience rend nos suppositions fiables',
          'Vérifier tous les présupposés sans discernement — paralyse l\'action',
          'Continuer à travailler avec un doute sérieux non résolu',
        ],
        ficheRef: 'Fiche 4',
      ),
    ),

    // ── CHALLENGE 3 ── Fiche 7 : Lire une consigne écrite ──
    ClarityChallenge(
      id: 'cz_d1_c3',
      dayNumber: 1,
      orderInDay: 3,
      title: 'L\'email piège',
      subtitle: 'Extraire l\'essentiel d\'un message complexe en 3 passes',
      emoji: '',
      color: const Color(0xFF009688),
      ficheRef: 'Fiche 7',
      scenario: ClarityScenario(
        context:
            'Vous êtes chargé(e) de projet chez CLARTÉ CONSEIL. '
            'Un email de 12 lignes vient d\'arriver avec 4 demandes imbriquées. '
            'La réunion commence dans 45 minutes.',
        urgencyMessage: ' 45 minutes avant la réunion — chaque seconde compte.',
        roleInstruction:
            ' Vous jouez JULIE, chargée de projet. '
            'Un email dense vient d\'arriver. Appliquez la méthode des 3 passes '
            'pour en extraire les actions à réaliser.',
        acts: [
          ClarityAct(
            title: 'Acte 1 — La première passe (lecture rapide)',
            narrative:
                'L\'email arrive. Objet : "Réunion de demain — à lire". '
                'Il fait 12 lignes, mélange contexte et actions, commence par l\'historique du client. '
                'Votre instinct : agir sur la première chose que vous lisez.',
            characterMessage: 'Réunion de demain — plusieurs points à traiter. Comme vous savez, le client Moreau a eu des difficultés... [8 lignes de contexte] ...donc merci de préparer le bilan financier, de contacter l\'équipe technique, de valider les livrables et de prévenir la direction avant 16h.',
            characterName: 'Email — Direction Générale',
            characterEmoji: '',
            roleContext: 'Première passe : quel est le sujet principal et quelle est la vraie deadline ?',
            toolTask:
                'Après votre première passe, écrivez en 2 lignes : '
                '1) Le sujet principal de cet email. 2) La deadline absolue.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je lis le début et commence à préparer le bilan financier.',
                explanation: 'Erreur classique : agir sur la première action vue sans avoir lu l\'email entier.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -15, trust: -10, efficiency: -20, stress: 20),
                consequence: 'Vous ratez les 3 autres demandes, dont prévenir la direction avant 16h — la plus urgente.',
              ),
              ClarityOption(
                id: 'b', label: 'Je lis jusqu\'au bout, je retiens : réunion demain, deadline 16h aujourd\'hui pour prévenir la direction.',
                explanation: 'Parfait. Première passe = sujet + deadline. Vous avez les bonnes priorités.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 10, efficiency: 20, stress: -15),
                consequence: 'Vous identifiez la vraie urgence (16h) et pouvez organiser votre temps correctement.',
              ),
              ClarityOption(
                id: 'c', label: 'Je transfère l\'email à mon collègue — trop complexe pour moi.',
                explanation: 'Évitement. Ce n\'est pas une solution professionnelle.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -20, efficiency: -20, stress: 20),
                consequence: 'L\'email vous était adressé. La direction le note négativement.',
              ),
              ClarityOption(
                id: 'd', label: 'Je lis en diagonale et note les 2 premières actions.',
                explanation: 'Lecture superficielle — vous manquez les actions secondaires.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: -5, efficiency: -10, stress: 10),
                consequence: 'Vous ratez "valider les livrables" et "prévenir la direction". Deux oublis critiques.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — La deuxième passe (surligner les actions)',
            narrative:
                'Vous avez identifié le sujet et la deadline. '
                'Maintenant : deuxième passe. Vous surlignez mentalement chaque verbe d\'action. '
                'Il y en a 4 dans cet email.',
            characterMessage: 'préparer... contacter... valider... prévenir... Ces 4 verbes sont vos 4 actions.',
            characterName: 'Votre analyse',
            characterEmoji: '',
            roleContext: 'Listez les 4 actions dans l\'ordre logique d\'exécution.',
            toolTask:
                'Numérotez les 4 actions de cet email dans l\'ordre logique d\'exécution '
                'et justifiez pourquoi vous avez choisi cet ordre.',
            options: [
              ClarityOption(
                id: 'a', label: '1-Prévenir direction, 2-Contacter technique, 3-Valider livrables, 4-Préparer bilan.',
                explanation: 'Ordre par urgence décroissante. La direction d\'abord (deadline 16h), puis les autres.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 15, efficiency: 20, stress: -15),
                consequence: 'Vous priorisez correctement. La direction est prévenue à temps. Tout se déroule bien.',
              ),
              ClarityOption(
                id: 'b', label: '1-Préparer bilan, 2-Contacter technique, 3-Valider livrables, 4-Prévenir direction.',
                explanation: 'Ordre d\'apparition dans le texte. Vous ratez la vraie priorité (prévenir direction avant 16h).',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -10, efficiency: -15, stress: 20),
                consequence: 'Vous prévenez la direction à 17h. La réunion de demain est compromise.',
              ),
              ClarityOption(
                id: 'c', label: 'Je fais tout en même temps pour gagner du temps.',
                explanation: 'Le multitâche réduit la qualité de chaque action. Impossible sur des tâches cognitives.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -5, efficiency: -15, stress: 20),
                consequence: 'Tout est fait à moitié. La direction reçoit un message incomplet.',
              ),
              ClarityOption(
                id: 'd', label: 'Je réponds à l\'email en demandant dans quel ordre faire les tâches.',
                explanation: 'Dans ce cas, la deadline révèle déjà la priorité. Cette question est inutile.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: -5, efficiency: -10, stress: 5),
                consequence: 'Vous perdez 20 minutes à attendre une réponse qui n\'arrive pas avant 16h.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — La troisième passe (liste d\'actions)',
            narrative:
                'Vos 4 actions sont identifiées et priorisées. '
                'Troisième passe : vous les réécrivez en liste numérotée. '
                'Un collègue vous demande comment vous faites pour vous organiser si vite.',
            characterMessage: 'Comment tu fais pour t\'y retrouver si vite dans un email pareil ?',
            characterName: 'Karim — Collègue',
            characterEmoji: '‍',
            roleContext: 'Expliquez votre méthode à Karim en 3 étapes simples.',
            toolTask:
                'Rédigez une liste d\'actions numérotée et prête à exécuter '
                'pour les 4 tâches de l\'email, avec la deadline de chacune.',
            options: [
              ClarityOption(
                id: 'a', label: '"J\'applique les 3 passes : 1-sujet+deadline, 2-verbes d\'action, 3-liste ordonnée."',
                explanation: 'Réponse claire, transmissible, mémorisable. Vous partagez une vraie compétence.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 20, efficiency: 20, stress: -20),
                consequence: 'Karim adopte la méthode. Vous devenez une référence en organisation pour l\'équipe.',
              ),
              ClarityOption(
                id: 'b', label: '"Je lis plusieurs fois jusqu\'à tout comprendre."',
                explanation: 'Inefficace et non transmissible. Relire sans méthode ne structure pas l\'information.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: 0, efficiency: -5, stress: 5),
                consequence: 'Karim essaie mais n\'y arrive pas. La méthode n\'est pas reproductible.',
              ),
              ClarityOption(
                id: 'c', label: '"J\'ai de l\'expérience, ça vient avec le temps."',
                explanation: 'Réponse qui bloque l\'apprentissage de Karim. L\'expérience ne suffit pas sans méthode.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -10, efficiency: 0, stress: 5),
                consequence: 'Karim se démotive. Il continue à se débattre avec les emails complexes.',
              ),
              ClarityOption(
                id: 'd', label: '"Je note tout dans mon carnet et je relis mes notes."',
                explanation: 'Bonne habitude mais ça ne répond pas à la question sur la méthode.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: 5, stress: 0),
                consequence: 'Karim commence à noter mais sans structure, ses notes sont aussi confuses que l\'email.',
              ),
            ],
          ),
        ],
        debriefTitle: 'Lire n\'est pas comprendre',
        keyLessons: [
          'Méthode 3 passes : sujet+deadline  verbes d\'action  liste ordonnée',
          'Les actions importantes se trouvent souvent à la FIN de l\'email, pas au début',
          'Trier par urgence, pas par ordre d\'apparition dans le texte',
          'Une méthode transmissible vaut plus que l\'expérience personnelle',
        ],
        commonMistakes: [
          'Agir sur la première chose vue sans avoir lu jusqu\'au bout',
          'Confondre informations de contexte et actions à réaliser',
          'Relire plusieurs fois sans méthode — inefficace',
        ],
        ficheRef: 'Fiche 7',
      ),
    ),

    // ── CHALLENGE 4 ── Fiche 8 : Rédiger une consigne écrite ──
    ClarityChallenge(
      id: 'cz_d1_c4',
      dayNumber: 1,
      orderInDay: 4,
      title: 'L\'email qui génère 3 relances',
      subtitle: 'Rédiger une consigne claire du premier coup',
      emoji: '️',
      color: const Color(0xFFFF5722),
      ficheRef: 'Fiche 8',
      scenario: ClarityScenario(
        context:
            'Vous êtes manager junior chez CLARTÉ CONSEIL. '
            'Vous devez envoyer une consigne à votre équipe de 5 personnes '
            'pour préparer la présentation client de vendredi. '
            'Votre objectif : zéro relance.',
        urgencyMessage: ' Vous avez 10 minutes pour rédiger un email parfait.',
        roleInstruction:
            ' Vous jouez NINA, manager junior. '
            'Appliquez la structure en 4 blocs et les 7 règles d\'or '
            'pour rédiger une consigne écrite qui ne génère aucune relance.',
        acts: [
          ClarityAct(
            title: 'Acte 1 — Le mauvais email',
            narrative:
                'Voici l\'email que vous aviez rédigé la semaine dernière pour une tâche similaire. '
                'Il a généré 3 relances. Identifiez les 5 erreurs qu\'il contient.',
            characterMessage: 'Bonjour à tous, comme vous savez nous avons une présentation importante vendredi. Le client est exigeant et nous devons être au top. Il faudrait que quelqu\'un prépare quelque chose de bien. Merci de vous organiser. Nina',
            characterName: 'Votre ancien email — à corriger',
            characterEmoji: '',
            roleContext: 'Identifiez toutes les erreurs dans cet email.',
            toolTask:
                'Listez les 5 erreurs de cet email en les associant aux règles d\'or violées. '
                '(Rappel : action d\'abord, responsable nommé, délai concret, actions numérotées, format précisé, contact, relecture)',
            options: [
              ClarityOption(
                id: 'a', label: 'Erreurs : pas de responsable nommé, pas de délai, pas d\'action précise, pas de format, contexte avant la demande.',
                explanation: 'Vous avez identifié les 5 principales erreurs. Excellente analyse.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 10, efficiency: 15, stress: -15),
                consequence: 'Vous savez exactement quoi corriger. Votre prochain email sera radicalement différent.',
              ),
              ClarityOption(
                id: 'b', label: 'L\'email est trop court — il faut plus de détails.',
                explanation: 'Ce n\'est pas un problème de longueur mais de structure et de précision.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -5, efficiency: -10, stress: 10),
                consequence: 'Vous rédigez un email encore plus long mais toujours mal structuré. 5 relances cette fois.',
              ),
              ClarityOption(
                id: 'c', label: 'Le ton est trop formel — il faut être plus sympathique.',
                explanation: 'Le problème n\'est pas le ton mais l\'absence d\'informations essentielles.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: -5, trust: 0, efficiency: -5, stress: 5),
                consequence: 'L\'email est plus chaleureux mais toujours aussi flou. Les relances continuent.',
              ),
              ClarityOption(
                id: 'd', label: 'Erreurs : pas de responsable, délai flou, action vague, pas de format, pas de contact.',
                explanation: 'Bonne analyse partielle — vous en identifiez 4 sur 5. Le 5e : contexte mis avant la demande.',
                isCorrect: true,
                impact: ClarityImpact.good,
                effect: ClarityEffect(clarity: 15, trust: 10, efficiency: 10, stress: -10),
                consequence: 'Vous corrigez 4 erreurs sur 5. L\'email est bien meilleur même s\'il reste perfectible.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — Construire l\'email parfait',
            narrative:
                'Vous avez identifié les erreurs. Maintenant : rédigez l\'email '
                'en appliquant la structure en 4 blocs : Objet / Actions / Précisions / Contact.',
            characterMessage: 'Nina, ton email de la semaine dernière m\'a valu 3 heures de relances. Comment tu vas faire différemment ?',
            characterName: 'Directeur — Alexandre',
            characterEmoji: '‍',
            roleContext: 'Appliquez la structure en 4 blocs. Chaque bloc a sa place.',
            toolTask:
                'Rédigez l\'email complet selon la structure en 4 blocs. '
                'Objet : [sujet + action]. Bloc 1 : actions numérotées. '
                'Bloc 2 : précisions. Bloc 3 : contact.',
            options: [
              ClarityOption(
                id: 'a', label: '"Objet : Présentation vendredi — Actions à réaliser. 1) Marc : prépare 10 slides synthèse projet Alpha. 2) Sara : valide les chiffres Q3 avant jeudi 12h. Contact : Nina poste 45."',
                explanation: 'Structure parfaite. Objet actionnable, responsables nommés, délai concret, contact. Zéro ambiguïté.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 25, stress: -25),
                consequence: 'Aucune relance. Marc et Sara livrent exactement ce qu\'on attendait. Alexandre vous félicite.',
              ),
              ClarityOption(
                id: 'b', label: '"Objet : Réunion vendredi. Bonjour, merci de préparer la présentation pour vendredi. Cordialement."',
                explanation: 'Vous n\'avez appliqué aucune des 7 règles. Même problème qu\'avant.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -20, efficiency: -20, stress: 30),
                consequence: '5 relances. Alexandre remet en question votre capacité à manager.',
              ),
              ClarityOption(
                id: 'c', label: '"Objet : URGENT - Présentation vendredi. Actions : 1) Slides, 2) Chiffres, 3) Validation. Délai : vendredi. Contact : moi."',
                explanation: 'La structure est là mais les responsables ne sont pas nommés et les délais sont vagues.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: 0, stress: 5),
                consequence: 'Une seule relance au lieu de 3. Progrès, mais Marc et Sara attendent encore des précisions.',
              ),
              ClarityOption(
                id: 'd', label: '"Je convoque une réunion pour expliquer à voix haute — l\'écrit c\'est trop risqué."',
                explanation: 'L\'oral peut compléter mais ne remplace pas une consigne écrite traçable.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -5, efficiency: -15, stress: 10),
                consequence: 'La réunion prend 45 minutes. Tout le monde a compris différemment. Pas de trace écrite.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — La relecture du destinataire',
            narrative:
                'Email rédigé. Avant d\'envoyer, une règle d\'or reste : '
                '"Relire du point de vue du destinataire." '
                'Vous imaginez Sara lire votre email sans aucun contexte.',
            characterMessage: 'Sara reçoit votre email. Elle n\'était pas en réunion hier. Elle n\'a aucun contexte.',
            characterName: 'Simulation — Point de vue de Sara',
            characterEmoji: '',
            roleContext: 'Que manque-t-il à Sara pour comprendre sans contexte ?',
            toolTask:
                'Listez les 3 éléments de contexte minimal à ajouter dans votre email '
                'pour qu\'une personne sans contexte puisse agir correctement.',
            options: [
              ClarityOption(
                id: 'a', label: 'Ajouter : nom du client, objectif de la présentation, public cible.',
                explanation: 'Parfait. Ces 3 éléments permettent à Sara de prendre des décisions intelligentes si un imprévu surgit.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 15, efficiency: 20, stress: -20),
                consequence: 'Sara comprend le POURQUOI. Quand un chiffre manque, elle sait quoi privilégier sans vous relancer.',
              ),
              ClarityOption(
                id: 'b', label: 'Ajouter tout l\'historique du projet sur 3 pages.',
                explanation: 'Surcharge d\'information. Sara ne lira pas 3 pages pour une tâche ponctuelle.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -5, efficiency: -15, stress: 15),
                consequence: 'Sara est submergée. Elle vous relance : "C\'est quoi l\'essentiel ?"',
              ),
              ClarityOption(
                id: 'c', label: 'Ne rien ajouter — Sara peut poser des questions si besoin.',
                explanation: 'Cela transfère la charge de clarification sur Sara. Ce n\'est pas son rôle.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: -5, trust: -5, efficiency: -5, stress: 5),
                consequence: 'Sara pose 2 questions. Vous passez 15 minutes à répondre.',
              ),
              ClarityOption(
                id: 'd', label: 'Ajouter : nom du client et deadline absolue.',
                explanation: 'Minimum vital. Correct mais le POURQUOI (objectif de la présentation) reste manquant.',
                isCorrect: false,
                impact: ClarityImpact.good,
                effect: ClarityEffect(clarity: 10, trust: 10, efficiency: 10, stress: -5),
                consequence: 'Sara livre à temps mais les slides manquent de fil directeur car elle ne connaît pas l\'objectif.',
              ),
            ],
          ),
        ],
        debriefTitle: 'L\'email zéro relance',
        keyLessons: [
          'Structure en 4 blocs : Objet actionnable  Actions numérotées  Précisions  Contact',
          '7 règles d\'or : action d\'abord, responsable nommé, délai concret, numérotation, format, contact, relecture',
          'Relire du point de vue du destinataire révèle toujours ce qui manque',
          'Donner le POURQUOI permet au récepteur de prendre de bonnes décisions en cas d\'imprévu',
        ],
        commonMistakes: [
          '3 paragraphes de contexte avant d\'arriver à la demande',
          'Mélanger actions et informations dans le même paragraphe',
          'Envoyer sans relire du point de vue du destinataire',
        ],
        ficheRef: 'Fiche 8',
      ),
    ),

    // ── CHALLENGE 5 ── Fiche 6 : Reformuler, demander, vérifier ──
    ClarityChallenge(
      id: 'cz_d1_c5',
      dayNumber: 1,
      orderInDay: 5,
      title: 'Le trio gagnant',
      subtitle: 'Reformuler, questionner, vérifier — les 3 réflexes pro',
      emoji: '',
      color: const Color(0xFF4CAF50),
      ficheRef: 'Fiche 6',
      scenario: ClarityScenario(
        context:
            'Grande journée chez CLARTÉ CONSEIL : audit client en cours. '
            'Les consignes pleuvent de toutes parts. '
            'Celui qui maîtrise les 3 réflexes ressort gagnant.',
        urgencyMessage: ' Journée d\'audit — chaque erreur est visible par le client.',
        roleInstruction:
            ' Vous jouez ALEX, consultant confirmé. '
            'Trois situations se succèdent. Dans chacune, '
            'choisissez le bon réflexe parmi : reformuler / questionner / vérifier.',
        acts: [
          ClarityAct(
            title: 'Acte 1 — Reformuler avant d\'agir',
            narrative:
                'Le directeur vous dit : "Prépare un rapport sur les résultats du trimestre." '
                'Sans reformulation la semaine dernière, un collègue a rendu 20 pages '
                'alors qu\'on voulait 1 page de synthèse.',
            characterMessage: 'Alex, prépare un rapport sur les résultats du trimestre pour lundi.',
            characterName: 'Directeur — Alexandre',
            characterEmoji: '‍',
            roleContext: 'Utilisez la formule de reformulation efficace avant de partir.',
            toolTask:
                'Rédigez votre reformulation complète selon la formule : '
                '"Si je comprends bien, tu me demandes de [action] + [délai] + [format]. C\'est bien ça ?"',
            options: [
              ClarityOption(
                id: 'a', label: '"Si je comprends bien, tu veux une synthèse des résultats T3 en 1 page pour lundi matin. C\'est bien ça ?"',
                explanation: 'Reformulation parfaite. Action + format + délai. Alexandre peut corriger si nécessaire.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 15, efficiency: 20, stress: -20),
                consequence: 'Alexandre confirme et ajoute "avec les comparatifs N-1". Info cruciale que vous n\'auriez pas eue.',
              ),
              ClarityOption(
                id: 'b', label: '"OK, je prépare ça pour lundi !"',
                explanation: 'Vous avez le délai mais pas confirmé le format ni le périmètre.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 5, efficiency: 5, stress: 5),
                consequence: 'Vous rendez 15 pages. Alexandre voulait 1 page. Frustration des deux côtés.',
              ),
              ClarityOption(
                id: 'c', label: '"C\'est noté ! Je prends le modèle de rapport habituel."',
                explanation: 'Présupposé sur le format. Le modèle habituel n\'est peut-être pas celui attendu ici.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -10, efficiency: -10, stress: 15),
                consequence: 'Le modèle habituel fait 12 pages. Alexandre voulait un format court pour le comité de direction.',
              ),
              ClarityOption(
                id: 'd', label: '"Tu peux préciser ce que tu attends exactement ?"',
                explanation: 'Question vague. Alexandre va devoir deviner ce qui vous manque.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: -5, efficiency: -5, stress: 5),
                consequence: 'Alexandre hésite : "Ben... un rapport normal quoi." Toujours aussi flou.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — Questionner avec précision',
            narrative:
                'Une collègue vous dit : "Quand tu as un moment, occupe-toi du client Martin." '
                'Vous avez 3 dossiers Martin ouverts. Il faut questionner — mais de façon ciblée.',
            characterMessage: 'Alex, quand tu as un moment, occupe-toi du client Martin.',
            characterName: 'Collègue — Inès',
            characterEmoji: '‍',
            roleContext: 'Posez UNE question ciblée qui révèle l\'essentiel manquant.',
            toolTask:
                'Rédigez la question ciblée parfaite. '
                'Elle doit nommer précisément ce qui manque (pas une question vague).',
            options: [
              ClarityOption(
                id: 'a', label: '"Tu peux m\'en dire plus ?"',
                explanation: 'Question trop vague. Inès ne sait pas quoi préciser en priorité.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: -5, efficiency: -5, stress: 5),
                consequence: 'Inès répond avec 5 informations dont 4 que vous saviez déjà.',
              ),
              ClarityOption(
                id: 'b', label: '"Quel dossier Martin : la proposition de mars, l\'audit en cours ou le renouvellement ?"',
                explanation: 'Question ciblée avec options. Vous montrez que vous connaissez les dossiers et vous facilitez la réponse.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 15, efficiency: 20, stress: -15),
                consequence: 'Inès répond en 5 secondes : "L\'audit en cours." Vous pouvez agir immédiatement.',
              ),
              ClarityOption(
                id: 'c', label: '"C\'est pour quand ?"',
                explanation: 'Pertinent mais incomplet — vous avez encore le problème du "quel dossier".',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: 0, stress: 5),
                consequence: 'Inès dit "cette semaine". Toujours 3 dossiers Martin possibles.',
              ),
              ClarityOption(
                id: 'd', label: 'Je commence par le dossier Martin le plus récent.',
                explanation: 'Supposition. Le plus récent n\'est pas forcément le bon.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -15, trust: -10, efficiency: -15, stress: 20),
                consequence: 'Mauvais dossier. 2h de travail perdues.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — La checklist de vérification finale',
            narrative:
                'Vous avez terminé votre rapport. Avant de l\'envoyer, '
                'vous appliquez la checklist universelle : Sais-je exactement ce que j\'ai fait ? '
                'Est-ce dans le bon format ? Est-ce rendu dans les délais ?',
            characterMessage: 'Le rapport est prêt. Mais... ai-je bien répondu à toutes les demandes ?',
            characterName: 'Votre vérification interne',
            characterEmoji: '',
            roleContext: 'Appliquez la checklist des 3 questions avant d\'envoyer.',
            toolTask:
                'Décrivez votre routine de vérification en 3 questions avant tout envoi. '
                'Rendez-la applicable à n\'importe quelle tâche.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je relis rapidement et j\'envoie — j\'ai confiance en mon travail.',
                explanation: 'La confiance ne remplace pas la vérification structurée.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: 0, efficiency: 5, stress: 0),
                consequence: 'Vous avez oublié les comparatifs N-1 demandés par Alexandre. Une relance.',
              ),
              ClarityOption(
                id: 'b', label: 'Je vérifie : 1) Ai-je fait exactement ce qui était demandé ? 2) Le format est-il bon ? 3) Toutes les actions sont-elles traitées ?',
                explanation: 'Checklist universelle. 3 questions, 2 minutes, zéro oubli.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 20, efficiency: 20, stress: -20),
                consequence: 'Vous détectez l\'oubli des comparatifs N-1. Vous l\'ajoutez. Envoi parfait.',
              ),
              ClarityOption(
                id: 'c', label: 'Je demande à un collègue de relire pour être sûr.',
                explanation: 'Bonne pratique pour les travaux importants, mais chronophage pour une tâche courante.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 5, efficiency: -10, stress: 0),
                consequence: 'Le collègue n\'est pas disponible. Vous envoyez sans vérification.',
              ),
              ClarityOption(
                id: 'd', label: 'J\'attends un retour d\'Alexandre — il me dira si quelque chose manque.',
                explanation: 'Vous transférez la responsabilité de la vérification à Alexandre.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -15, efficiency: -10, stress: 15),
                consequence: 'Alexandre doit faire lui-même ce que vous auriez dû faire. Sa confiance diminue.',
              ),
            ],
          ),
        ],
        debriefTitle: 'Trois réflexes, une carrière',
        keyLessons: [
          'Reformuler = répéter dans ses mots pour que l\'émetteur puisse corriger',
          'Question ciblée = nommer précisément ce qui manque, pas une question vague',
          'Checklist universelle : quoi exactement / bon format / toutes les actions',
          'Ces 3 réflexes prennent 2 minutes et évitent des heures d\'erreur',
        ],
        commonMistakes: [
          'Reformuler en répétant mot pour mot — ce n\'est pas une reformulation',
          'Poser une question vague au lieu d\'une question précise et ciblée',
          'Ne jamais demander pour ne pas "déranger" — le dérangement coûte 10 secondes',
        ],
        ficheRef: 'Fiche 6',
      ),
    ),
  ];
}
