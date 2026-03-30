import 'package:flutter/material.dart';
import '../models/clarity_models.dart';

// ═══════════════════════════════════════════════════════════════
// CLARITY ZONE — JOUR 3 : Leadership & Situations Complexes (Fiches 15 à 20)
// Entreprise fictive : CLARTÉ CONSEIL
// Secteur : Cabinet de conseil en organisation
// ═══════════════════════════════════════════════════════════════

class ClarityDataDay3 {
  static List<ClarityChallenge> get challenges => [

    // ── CHALLENGE 1 ── Fiche 15 : Manager à distance ──
    ClarityChallenge(
      id: 'cz_d3_c1',
      dayNumber: 3,
      orderInDay: 1,
      title: 'L\'équipe dispersée',
      subtitle: 'Donner des consignes claires à distance',
      emoji: '',
      color: const Color(0xFF673AB7),
      ficheRef: 'Fiche 15',
      scenario: ClarityScenario(
        context:
            'Vous êtes chef de projet chez CLARTÉ CONSEIL. '
            'Votre équipe de 5 personnes travaille en télétravail sur trois sites différents. '
            'Un livrable urgent doit être remis demain matin au client.',
        urgencyMessage: ' Livrable client dans 18 h — coordination critique !',
        roleInstruction:
            ' Vous jouez MARC, chef de projet. '
            'Vous devez coordonner votre équipe à distance pour finaliser le rapport.',
        acts: [
          ClarityAct(
            title: 'Acte 1 — La réunion Zoom chaotique',
            narrative:
                'Votre réunion de coordination a commencé. Julie (Paris) a des problèmes audio, '
                'Karim (Lyon) n\'a pas reçu le dernier fichier, Sarah (Bordeaux) attend vos instructions.',
            characterMessage: 'Marc, on fait quoi ? J\'ai pas le bon fichier et Julie entend rien.',
            characterName: 'Karim — Consultant senior',
            characterEmoji: '',
            roleContext: 'Comment gérez-vous cette réunion chaotique ?',
            toolTask:
                'Rédigez le message de coordination que vous enverrez immédiatement sur le canal commun : '
                '3 actions concrètes, 3 responsables identifiés, 1 délai précis pour chacun.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je reporte la réunion et envoie les fichiers par email à tous',
                explanation: 'Reporter aggrave la situation d\'urgence — le délai ne le permet pas.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -5, efficiency: -15, stress: 20),
                consequence: ' Deux heures de perdues. L\'équipe est déstabilisée par l\'absence de leadership.',
              ),
              ClarityOption(
                id: 'b', label: 'Je continue la réunion en ignorant les problèmes techniques',
                explanation: 'Ignorer les obstacles bloque la communication et démotive l\'équipe.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -15, trust: -10, efficiency: -10, stress: 15),
                consequence: ' Julie et Karim décrochent. La réunion devient inutile.',
              ),
              ClarityOption(
                id: 'c', label: 'Je structure en 2 min : chat pour Karim/fichier, Julie en solo call, Sarah débute sa partie',
                explanation: 'Action structurée immédiate : vous adressez chaque problème séparément et maintenez le cap.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 15, efficiency: 20, stress: -15),
                consequence: ' Chacun a une action claire. La réunion reprend en 5 min efficacement.',
              ),
              ClarityOption(
                id: 'd', label: 'Je demande à l\'équipe de se débrouiller et de me donner le résultat ce soir',
                explanation: 'Déléguer sans structure en situation d\'urgence crée de l\'anxiété et des erreurs.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: -5, trust: -8, efficiency: 5, stress: 10),
                consequence: '️ L\'équipe avance mais dans des directions divergentes. Risque de retravail.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — Le rapport incomplet',
            narrative:
                'Deux heures plus tard, vous recevez les contributions. Karim a fait sa partie, '
                'mais Sarah a mal compris la consigne et fourni un format différent. '
                'Il reste 4 h avant la deadline.',
            characterMessage: 'J\'ai fait ce que tu m\'as dit, c\'est pas le bon format ?',
            characterName: 'Sarah — Consultante',
            characterEmoji: '',
            roleContext: 'Comment réagissez-vous face à ce malentendu de consigne ?',
            toolTask:
                'Rédigez la consigne corrective que vous donnez à Sarah : '
                'reconnaissez votre part dans le malentendu, indiquez exactement le format attendu, '
                'proposez une aide concrète.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je lui dis que la consigne était claire et qu\'elle doit refaire en urgence',
                explanation: 'Blâmer sans reconnaître votre part dégrade la confiance et ne résout rien rapidement.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -20, efficiency: -5, stress: 25),
                consequence: ' Sarah se sent injustement attaquée. Sa motivation chute drastiquement.',
              ),
              ClarityOption(
                id: 'b', label: 'Je refais moi-même sa partie pour gagner du temps',
                explanation: 'Efficace à court terme mais vous surcharge et prive Sarah d\'apprentissage.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: -10, efficiency: 10, stress: 20),
                consequence: '️ Le rapport sera livré mais vous serez épuisé et Sarah frustrée.',
              ),
              ClarityOption(
                id: 'c', label: 'Je reconnais ma consigne floue, partage un exemple du format, la guide 15 min',
                explanation: 'Responsabilité partagée + exemple concret + accompagnement = solution durable.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 15, stress: -10),
                consequence: ' Sarah comprend exactement ce qui est attendu. Elle corrige en 45 min.',
              ),
              ClarityOption(
                id: 'd', label: 'Je laisse Sarah décider du format car elle est experte dans son domaine',
                explanation: 'Le client a des exigences précises — laisser libre cours sans cadre est risqué.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: 5, efficiency: -15, stress: 10),
                consequence: ' Le rapport présente deux formats incohérents. Le client est insatisfait.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — Le debriefing',
            narrative:
                'Le rapport est livré à temps. Le client est satisfait. '
                'C\'est le moment de faire un retour à votre équipe sur cette journée difficile.',
            characterMessage: 'On a réussi mais c\'était vraiment tendu... On peut éviter ça la prochaine fois ?',
            characterName: 'Julie — Consultante senior',
            characterEmoji: '',
            roleContext: 'Comment conduisez-vous ce debriefing constructif ?',
            toolTask:
                'Rédigez les 3 règles que vous proposez à l\'équipe pour améliorer la coordination à distance : '
                'chacune doit être actionnable dès la prochaine mission.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je félicite l\'équipe et passe à la prochaine mission sans m\'attarder',
                explanation: 'La célébration est nécessaire mais le retour d\'expérience l\'est tout autant.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 10, efficiency: -10, stress: 0),
                consequence: '️ Bonne ambiance mais les mêmes problèmes réapparaîtront à la prochaine mission.',
              ),
              ClarityOption(
                id: 'b', label: 'Je liste les erreurs commises et les responsables de chacune',
                explanation: 'Pointer les erreurs individuelles en public détruit la cohésion d\'équipe.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -5, trust: -25, efficiency: -5, stress: 20),
                consequence: ' L\'atmosphère se détériore. L\'équipe se sent jugée, pas soutenue.',
              ),
              ClarityOption(
                id: 'c', label: 'Je co-construis avec l\'équipe 3 règles pratiques pour la suite (canal dédié, templates, check-in)',
                explanation: 'La co-construction crée l\'adhésion. Des règles pratiques et partagées sont durables.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 25, efficiency: 20, stress: -20),
                consequence: ' L\'équipe repart avec des engagements clairs et une meilleure cohésion.',
              ),
              ClarityOption(
                id: 'd', label: 'Je propose une formation obligatoire aux outils digitaux pour toute l\'équipe',
                explanation: 'La formation peut aider mais ce n\'est pas la priorité immédiate identifiée.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: 5, stress: 5),
                consequence: '️ Bonne intention mais perçu comme une punition collective après une réussite.',
              ),
            ],
          ),
        ],
        debriefTitle: 'À distance, la clarté double les performances',
        keyLessons: [
          'En télétravail, chaque consigne doit être écrite + confirmée + datée',
          'Un malentendu à distance coûte 3 fois plus cher qu\'en présentiel',
          'Le debriefing collectif après une mission difficile renforce l\'équipe',
          'Reconnaître sa part dans un malentendu est un signe de leadership fort',
        ],
        commonMistakes: [
          'Donner des consignes verbales sans trace écrite à distance',
          'Blâmer le collaborateur plutôt que la consigne mal formulée',
          'Passer directement à la mission suivante sans capitaliser sur l\'expérience',
        ],
        ficheRef: 'Fiche 15',
      ),
    ),

    // ── CHALLENGE 2 ── Fiche 16 : Conflit de consignes ──
    ClarityChallenge(
      id: 'cz_d3_c2',
      dayNumber: 3,
      orderInDay: 2,
      title: 'Double hiérarchie',
      subtitle: 'Gérer des consignes contradictoires de deux supérieurs',
      emoji: '️',
      color: const Color(0xFFE91E63),
      ficheRef: 'Fiche 16',
      scenario: ClarityScenario(
        context:
            'Chez CLARTÉ CONSEIL, vous recevez deux consignes contradictoires : '
            'votre N+1 Sylvie veut que vous priorisiez le client Dupont, '
            'votre N+2 Patrick veut que vous vous occupiez du projet interne en premier.',
        urgencyMessage: ' Deux chefs, deux priorités opposées — vous devez choisir !',
        roleInstruction:
            ' Vous jouez ALEX, consultant. '
            'Sylvie et Patrick vous attendent tous les deux. Que faites-vous ?',
        acts: [
          ClarityAct(
            title: 'Acte 1 — Le conflit éclate',
            narrative:
                'Il est 9h. Sylvie : "Alex, concentre-toi sur Dupont aujourd\'hui, c\'est urgent." '
                'Patrick, 10 min plus tard : "Alex, j\'ai besoin de toi sur le projet interne, Sylvie peut attendre."',
            characterMessage: 'Tu as entendu ce que j\'ai dit ce matin ? Le projet interne ne peut pas attendre.',
            characterName: 'Patrick — Directeur',
            characterEmoji: '',
            roleContext: 'Patrick est votre N+2. Comment répondez-vous ?',
            toolTask:
                'Rédigez la réponse exacte que vous donnez à Patrick : '
                'reconnaissez sa demande, exposez le conflit de priorité, '
                'proposez une solution sans choisir à la place de vos supérieurs.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je dis à Patrick que j\'obéis à Sylvie car c\'est mon N+1 direct',
                explanation: 'Mettre Patrick en porte-à-faux avec Sylvie devant vous n\'est pas professionnel.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -15, efficiency: -10, stress: 20),
                consequence: ' Tension entre Patrick et Sylvie. Vous êtes au cœur du conflit hiérarchique.',
              ),
              ClarityOption(
                id: 'b', label: 'Je fais les deux en même temps pour satisfaire tout le monde',
                explanation: 'Tenter de tout faire simultanément mène à faire les deux choses à moitié.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -10, efficiency: -20, stress: 30),
                consequence: ' Ni Dupont ni le projet interne n\'avancent correctement. Tout le monde est déçu.',
              ),
              ClarityOption(
                id: 'c', label: 'Je demande à Patrick et Sylvie de se synchroniser et de me donner une priorité commune',
                explanation: 'Escalader la décision là où elle doit être prise est la démarche professionnelle.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 15, efficiency: 15, stress: -15),
                consequence: ' Patrick et Sylvie arbitrent eux-mêmes. Vous recevez une consigne unique et claire.',
              ),
              ClarityOption(
                id: 'd', label: 'Je m\'occupe de Dupont en cachette et mens à Patrick sur mon avancement',
                explanation: 'Le mensonge dans une relation professionnelle est toujours contre-productif.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -25, efficiency: 5, stress: 30),
                consequence: ' Patrick découvre la vérité. Votre crédibilité est irrémédiablement entachée.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — La réunion d\'arbitrage',
            narrative:
                'Sylvie et Patrick se réunissent. Ils vous demandent votre avis : '
                '"Alex, toi qui connais les deux dossiers, quelle est ta recommandation ?"',
            characterMessage: 'On te demande ton avis professionnel. Qu\'est-ce qui est le plus urgent selon toi ?',
            characterName: 'Sylvie & Patrick',
            characterEmoji: '',
            roleContext: 'Comment positionnez-vous votre réponse pour rester professionnel ?',
            toolTask:
                'Structurez votre recommandation en 3 points : '
                'impact client Dupont si on attend, impact projet interne si on attend, '
                'votre proposition d\'organisation (pas votre choix personnel).',
            options: [
              ClarityOption(
                id: 'a', label: 'Je prends clairement parti pour Sylvie et Dupont',
                explanation: 'Prendre parti risque de froisser Patrick et de paraître partial.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -15, efficiency: 5, stress: 15),
                consequence: ' Patrick vous en tient rigueur. La relation professionnelle se dégrade.',
              ),
              ClarityOption(
                id: 'b', label: 'Je refuse de donner un avis pour ne pas me mouiller',
                explanation: 'Refuser de contribuer quand on vous consulte est perçu comme un manque d\'engagement.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -10, efficiency: -10, stress: 5),
                consequence: ' Vous manquez l\'occasion de démontrer votre valeur ajoutée.',
              ),
              ClarityOption(
                id: 'c', label: 'Je présente objectivement les enjeux des deux options et propose un planning séquencé',
                explanation: 'Apporter de la structure factuelle permet aux décideurs de trancher en confiance.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 20, stress: -20),
                consequence: ' Votre analyse est appréciée. Patrick et Sylvie choisissent votre planning.',
              ),
              ClarityOption(
                id: 'd', label: 'Je dis que je fais confiance à leur jugement et attends leur décision',
                explanation: 'Renvoyer la décision sans apporter de valeur n\'aide pas à résoudre le problème.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: 0, efficiency: 0, stress: 0),
                consequence: '️ Vous êtes perçu comme passif. La décision se prend sans votre contribution.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — La procédure anti-conflit',
            narrative:
                'La crise est résolue. Sylvie vous remercie en privé et vous demande : '
                '"Alex, comment on évite ça à l\'avenir ?"',
            characterMessage: 'Tu as bien géré. Comment on fait pour que ça ne se reproduise plus ?',
            characterName: 'Sylvie — Manager',
            characterEmoji: '',
            roleContext: 'Quelle procédure proposez-vous pour les conflits de priorité futurs ?',
            toolTask:
                'Rédigez une procédure simple en 4 étapes que vous proposerez formellement à votre équipe '
                'pour gérer les futurs conflits de consignes entre N+1 et N+2.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je propose que chaque consultant choisisse lui-même sa priorité selon son jugement',
                explanation: 'Sans cadre commun, chaque consultant décidera différemment — source d\'incohérence.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -5, efficiency: -10, stress: 10),
                consequence: ' Chaque consultant fait ses propres choix — l\'organisation devient incohérente.',
              ),
              ClarityOption(
                id: 'b', label: 'Je propose une matrice de priorité validée par la direction + escalade automatique en cas de conflit',
                explanation: 'Un outil partagé + procédure claire = décisions prévisibles et justes.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 25, stress: -20),
                consequence: ' La direction valide votre proposition. La procédure est adoptée par toute l\'équipe.',
              ),
              ClarityOption(
                id: 'c', label: 'Je propose que le N+2 ait toujours priorité sur le N+1',
                explanation: 'Une règle trop rigide ignore les contextes opérationnels du N+1 qui connaît le terrain.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: -5, efficiency: 5, stress: 5),
                consequence: '️ Simple mais les N+1 se sentent dévalorisés dans leur rôle managérial.',
              ),
              ClarityOption(
                id: 'd', label: 'Je ne propose rien — ces situations sont trop rares pour créer une procédure',
                explanation: 'Les conflits de priorité sont fréquents dans les organisations matricielles.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -10, efficiency: -5, stress: 10),
                consequence: ' Le problème se reproduit 3 semaines plus tard avec de nouveaux acteurs.',
              ),
            ],
          ),
        ],
        debriefTitle: 'Conflit de consignes = signal d\'organisation défaillante',
        keyLessons: [
          'Face à deux consignes contradictoires, escalader vers les décideurs est toujours la bonne démarche',
          'Votre rôle n\'est pas de choisir entre vos supérieurs mais de les informer du conflit',
          'Apporter une analyse factuelle en réunion d\'arbitrage démontre votre valeur',
          'Une procédure écrite prévient 80% des conflits de priorité futurs',
        ],
        commonMistakes: [
          'Choisir une priorité sans en informer l\'autre supérieur',
          'Faire semblant de travailler sur les deux sujets simultanément',
          'Rester passif pendant la réunion d\'arbitrage au lieu d\'apporter des solutions',
        ],
        ficheRef: 'Fiche 16',
      ),
    ),

    // ── CHALLENGE 3 ── Fiche 17 : Déléguer efficacement ──
    ClarityChallenge(
      id: 'cz_d3_c3',
      dayNumber: 3,
      orderInDay: 3,
      title: 'La délégation parfaite',
      subtitle: 'Confier une mission complexe sans perdre le contrôle',
      emoji: '',
      color: const Color(0xFF4CAF50),
      ficheRef: 'Fiche 17',
      scenario: ClarityScenario(
        context:
            'Vous êtes directrice associée chez CLARTÉ CONSEIL. '
            'Débordée, vous devez déléguer la gestion d\'un client important à Nadia, '
            'consultante junior prometteuse mais inexpérimentée sur ce type de mission.',
        urgencyMessage: ' Nadia prend en charge le client Martinez dès demain matin.',
        roleInstruction:
            ' Vous jouez CAMILLE, directrice associée. '
            'Vous avez 30 min pour briefer Nadia complètement.',
        acts: [
          ClarityAct(
            title: 'Acte 1 — Le brief de délégation',
            narrative:
                'Nadia arrive avec son carnet. Elle est enthousiaste mais vous sentez qu\'elle ne mesure pas '
                'encore tous les enjeux du client Martinez, qui est exigeant et particulier.',
            characterMessage: 'Je suis prête ! Dites-moi juste ce que je dois faire.',
            characterName: 'Nadia — Consultante junior',
            characterEmoji: '',
            roleContext: 'Comment structurez-vous votre briefing pour qu\'il soit vraiment efficace ?',
            toolTask:
                'Rédigez le plan de votre briefing à Nadia en 5 points : '
                'contexte client, mission précise, périmètre d\'autonomie, '
                'points de vigilance spécifiques à Martinez, modalités de reporting.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je lui explique rapidement ce qu\'il faut faire et lui dis de m\'appeler si problème',
                explanation: 'Un brief minimal pour une mission complexe garantit l\'échec ou le retravail.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -15, trust: -10, efficiency: -20, stress: 20),
                consequence: ' Nadia fait des erreurs prévisibles que vous aurez à réparer.',
              ),
              ClarityOption(
                id: 'b', label: 'Je lui donne tous mes fichiers clients + mon carnet de contacts et lui fais confiance',
                explanation: 'Trop d\'information sans cadre désoriente autant que trop peu.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: -5, trust: 5, efficiency: -10, stress: 15),
                consequence: '️ Nadia est submergée par l\'information et ne sait pas par où commencer.',
              ),
              ClarityOption(
                id: 'c', label: 'Je structure : contexte  objectifs  périmètre  points de vigilance  reporting',
                explanation: 'Un brief structuré en 5 temps donne à Nadia tout ce dont elle a besoin pour réussir.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 25, stress: -15),
                consequence: ' Nadia repart avec une feuille de route claire. Elle gère Martinez avec assurance.',
              ),
              ClarityOption(
                id: 'd', label: 'Je lui demande de préparer ses propres questions et on en reparlera demain',
                explanation: 'Demain c\'est trop tard — Martinez attend des réponses dès demain matin.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -5, efficiency: -15, stress: 20),
                consequence: ' Nadia rencontre Martinez sans préparation. Le client est déçu de l\'accueil.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — La première crise terrain',
            narrative:
                'Le lendemain, Nadia vous appelle : "Martinez veut une remise de 15% non prévue dans le contrat. '
                'Je ne sais pas si je peux accepter." Vous êtes en réunion importante.',
            characterMessage: 'Martinez insiste. Il dit que vous l\'avez toujours accordé cette remise avant.',
            characterName: 'Nadia — par téléphone',
            characterEmoji: '',
            roleContext: 'Comment répondez-vous depuis votre réunion, rapidement et clairement ?',
            toolTask:
                'Rédigez le message de 3 lignes maximum que vous envoyez à Nadia : '
                'décision sur la remise, alternative proposable, et niveau d\'autonomie pour la suite.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je lui dis de refuser catégoriquement — les remises ce n\'est pas notre politique',
                explanation: 'Une réponse rigide sans alternative met Nadia dans une position difficile face au client.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -10, efficiency: -10, stress: 15),
                consequence: ' Martinez est froissé du refus sec. Nadia gère une situation tendue sans soutien.',
              ),
              ClarityOption(
                id: 'b', label: 'Je lui dis de faire comme elle le sent — c\'est sa mission maintenant',
                explanation: 'Abandonner Nadia sur une décision contractuelle dépasse son niveau d\'autonomie actuel.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -15, efficiency: -10, stress: 25),
                consequence: ' Nadia prend une décision risquée seule. Erreur contractuelle potentielle.',
              ),
              ClarityOption(
                id: 'c', label: 'Je donne : "Pas 15%, max 8% avec validation. Alternative : service additionnel gratuit."',
                explanation: 'Message court, décision claire, alternative préparée = Nadia peut agir efficacement.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 20, efficiency: 20, stress: -15),
                consequence: ' Nadia négocie avec confiance. Martinez accepte l\'alternative. Relation préservée.',
              ),
              ClarityOption(
                id: 'd', label: 'Je rappelle Nadia après ma réunion dans 2h',
                explanation: 'Faire attendre une décision urgente en cours de négociation client est très risqué.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -5, efficiency: -15, stress: 20),
                consequence: ' Martinez s\'impatiente et appelle directement. Nadia perd sa crédibilité.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — Le bilan de délégation',
            narrative:
                'Une semaine plus tard, la mission est terminée. Martinez est satisfait. '
                'Nadia vous demande un retour sur sa performance.',
            characterMessage: 'Comment j\'ai géré ? Est-ce que je peux prendre d\'autres clients à ce niveau ?',
            characterName: 'Nadia — Bilan',
            characterEmoji: '',
            roleContext: 'Comment conduisez-vous ce feedback de développement ?',
            toolTask:
                'Structurez votre feedback à Nadia en 4 parties : '
                'ce qu\'elle a réussi (2 exemples précis), ce qu\'elle peut améliorer (1 exemple), '
                'votre recommandation pour la suite, le prochain niveau d\'autonomie.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je lui dis que c\'était bien et qu\'elle peut gérer d\'autres clients au même niveau',
                explanation: 'Le feedback vague n\'aide pas Nadia à progresser et la responsabilise insuffisamment.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: 5, efficiency: 0, stress: -5),
                consequence: '️ Nadia se sent bien mais ne sait pas précisément ce qu\'elle doit développer.',
              ),
              ClarityOption(
                id: 'b', label: 'Je liste tous les points d\'amélioration car je veux qu\'elle progresse vite',
                explanation: 'Un feedback uniquement correctif après une réussite démotive et manque l\'objectif.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: 5, trust: -15, efficiency: 5, stress: 15),
                consequence: ' Nadia repart découragée malgré le succès. Elle doute de ses compétences.',
              ),
              ClarityOption(
                id: 'c', label: 'Je structure : 2 réussites précises + 1 axe d\'amélioration + plan de progression clair',
                explanation: 'Le feedback équilibré et structuré est le plus efficace pour le développement.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 25, efficiency: 15, stress: -15),
                consequence: ' Nadia comprend ses forces et son prochain objectif. Elle est motivée pour progresser.',
              ),
              ClarityOption(
                id: 'd', label: 'Je lui dis d\'attendre l\'entretien annuel pour avoir un vrai bilan',
                explanation: 'Remettre le feedback à plus tard supprime le bénéfice de l\'apprentissage en contexte.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -10, efficiency: -5, stress: 5),
                consequence: ' L\'occasion d\'apprentissage est manquée. Nadia reste dans l\'incertitude des mois.',
              ),
            ],
          ),
        ],
        debriefTitle: 'Déléguer c\'est briefer, soutenir et évaluer',
        keyLessons: [
          'Un brief de délégation en 5 points (contexte/mission/périmètre/vigilance/reporting) prévient 90% des problèmes',
          'Définir le périmètre d\'autonomie avant la délégation évite les hésitations terrain',
          'Un message décisionnel court et précis vaut mieux qu\'une longue conversation retardée',
          'Le feedback post-délégation est l\'investissement le plus rentable pour la montée en compétences',
        ],
        commonMistakes: [
          'Brief trop court ou trop dense sans cadre clair',
          'Laisser le collaborateur seul sur une décision dépassant son niveau d\'autonomie',
          'Oublier le feedback final — occasion manquée de développement',
        ],
        ficheRef: 'Fiche 17',
      ),
    ),

    // ── CHALLENGE 4 ── Fiche 18 : Consignes en situation de crise ──
    ClarityChallenge(
      id: 'cz_d3_c4',
      dayNumber: 3,
      orderInDay: 4,
      title: 'La crise totale',
      subtitle: 'Maintenir la clarté des consignes quand tout s\'accélère',
      emoji: '',
      color: const Color(0xFFFF5722),
      ficheRef: 'Fiche 18',
      scenario: ClarityScenario(
        context:
            'Chez CLARTÉ CONSEIL, un client majeur (30% du CA) menace de résilier son contrat. '
            'Il a reçu un rapport erroné. Le PDG vous appelle. Vous avez 2 heures pour réagir.',
        urgencyMessage: ' ALERTE ROUGE — Client majeur, 2 heures, toute l\'équipe mobilisée !',
        roleInstruction:
            ' Vous jouez VÉRONIQUE, directrice des opérations. '
            'Vous coordonnez la cellule de crise.',
        acts: [
          ClarityAct(
            title: 'Acte 1 — Activation de la cellule de crise',
            narrative:
                'Il est 14h. Le PDG a raccroché. Quatre collaborateurs vous regardent, '
                'attendant vos instructions. Chaque minute compte.',
            characterMessage: 'Véronique, qu\'est-ce qu\'on fait ? On attend quoi ?',
            characterName: 'David — Responsable qualité',
            characterEmoji: '️',
            roleContext: 'Première consigne : comment organisez-vous la réponse ?',
            toolTask:
                'Rédigez le message de crise que vous envoyez immédiatement à toute l\'équipe : '
                'situation en une phrase, 4 rôles assignés, deadline, point de contact unique.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je demande à tout le monde de faire quelque chose sans organiser les rôles',
                explanation: 'L\'action sans coordination en crise crée plus de chaos qu\'elle n\'en résout.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -15, efficiency: -25, stress: 35),
                consequence: ' Doublons, oublis, contradictions — la crise s\'aggrave.',
              ),
              ClarityOption(
                id: 'b', label: 'Je prends tout en charge seule pour contrôler la situation',
                explanation: 'Une seule personne ne peut pas gérer une crise multi-dimensionnelle seule.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -10, efficiency: -15, stress: 40),
                consequence: ' Vous êtes submergée. Des actions critiques sont oubliées.',
              ),
              ClarityOption(
                id: 'c', label: 'J\'attribue immédiatement 4 missions précises : analyse erreur, contact client, correction, communication',
                explanation: 'Organisation claire + rôles définis = crise gérée efficacement sous pression.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 30, stress: -20),
                consequence: ' Chaque membre de l\'équipe sait exactement quoi faire. La crise est sous contrôle.',
              ),
              ClarityOption(
                id: 'd', label: 'Je consulte le manuel de crise avant de donner des consignes',
                explanation: 'En situation de crise réelle, les manuels sont secondaires — l\'action prime.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -10, efficiency: -15, stress: 20),
                consequence: ' Quinze minutes perdues pendant lesquelles la situation se dégrade.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — La communication client',
            narrative:
                'Votre équipe travaille. Dans 45 min vous devez appeler le client. '
                'Vous avez l\'erreur identifiée et la correction préparée. '
                'Comment formulez-vous vos excuses et votre plan d\'action ?',
            characterMessage: 'Il attend votre appel. Il est en colère. Préparez bien votre discours.',
            characterName: 'Assistante du PDG',
            characterEmoji: '',
            roleContext: 'Comment préparez-vous votre message au client ?',
            toolTask:
                'Rédigez les 4 points clés de votre message téléphonique au client : '
                'reconnaissance de l\'erreur, cause précise, correction immédiate, garantie pour l\'avenir.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je minimise l\'erreur et explique que c\'est exceptionnel',
                explanation: 'Minimiser une erreur reconnue par le client aggrave la perte de confiance.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -30, efficiency: -10, stress: 25),
                consequence: ' Le client perçoit un manque d\'honnêteté. Il confirme la résiliation.',
              ),
              ClarityOption(
                id: 'b', label: 'Je m\'excuse abondamment sans proposer de solution concrète',
                explanation: 'Les excuses sans action concrète sont insuffisantes pour un client professionnel.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -10, efficiency: -5, stress: 10),
                consequence: '️ Le client apprécie l\'humilité mais reste insatisfait sans plan d\'action.',
              ),
              ClarityOption(
                id: 'c', label: 'Je reconnais l\'erreur précisément + cause + correction + 3 garanties futures',
                explanation: 'Transparence + solution + garanties = message professionnel qui restaure la confiance.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 30, efficiency: 20, stress: -20),
                consequence: ' Le client est impressionné par la réactivité et la transparence. Il maintient le contrat.',
              ),
              ClarityOption(
                id: 'd', label: 'Je demande à mon PDG de faire l\'appel à ma place',
                explanation: 'Déléguer vers le haut en crise abdique votre responsabilité managériale.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -15, efficiency: -5, stress: 10),
                consequence: ' Le PDG est déçu de votre manque d\'initiative en situation critique.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — Le rapport REX',
            narrative:
                'La crise est résolue. Le client reste. Le PDG vous demande un rapport de retour d\'expérience '
                'pour que cela ne se reproduise plus.',
            characterMessage: 'Excellent travail. Maintenant écrivez-moi un plan pour éviter ça à l\'avenir.',
            characterName: 'PDG',
            characterEmoji: '',
            roleContext: 'Comment structurez-vous votre retour d\'expérience ?',
            toolTask:
                'Rédigez les 5 rubriques de votre rapport REX : '
                'cause racine identifiée, défaillances de processus, actions correctives immédiates, '
                'indicateurs de suivi, délai de revue.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je rédige un rapport qui désigne les responsables de l\'erreur',
                explanation: 'Un rapport de crise qui blâme des individus n\'améliore pas les processus.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -20, efficiency: -5, stress: 15),
                consequence: ' L\'équipe se divise. Les mêmes erreurs se reproduiront dans un autre contexte.',
              ),
              ClarityOption(
                id: 'b', label: 'Je propose d\'améliorer la communication interne globalement sans plan précis',
                explanation: 'Une recommandation vague ne produit aucun changement réel dans les processus.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: 0, efficiency: -5, stress: 0),
                consequence: '️ Le rapport est bien reçu mais rien ne change concrètement.',
              ),
              ClarityOption(
                id: 'c', label: 'Je structure : cause racine  défaillance processus  5 actions datées  KPI de suivi',
                explanation: 'Un REX structuré avec des actions datées et des KPI est immédiatement actionnable.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 25, stress: -20),
                consequence: ' Le PDG valide le plan. Les 5 actions sont mises en œuvre dans les 30 jours.',
              ),
              ClarityOption(
                id: 'd', label: 'Je propose une formation générale à tous les collaborateurs',
                explanation: 'La formation seule sans correction des processus ne résout pas la cause racine.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 5, efficiency: 5, stress: -5),
                consequence: '️ Bonne intention mais les mêmes failles de processus subsistent.',
              ),
            ],
          ),
        ],
        debriefTitle: 'En crise, la clarté des consignes fait la différence',
        keyLessons: [
          'En situation de crise, l\'organisation prime sur l\'action individuelle',
          'Attribuer des rôles clairs dès la première minute évite le chaos',
          'La communication de crise efficace = erreur reconnue + cause + solution + garantie',
          'Un REX structuré transforme chaque crise en opportunité d\'amélioration',
        ],
        commonMistakes: [
          'Mobiliser tout le monde sans attribuer de rôles précis',
          'Minimiser ou nier l\'erreur devant le client',
          'Chercher des coupables plutôt que des améliorations de processus',
        ],
        ficheRef: 'Fiche 18',
      ),
    ),

    // ── CHALLENGE 5 ── Fiches 19–20 : Grand final ──
    ClarityChallenge(
      id: 'cz_d3_c5',
      dayNumber: 3,
      orderInDay: 5,
      title: 'Le Grand Tournoi',
      subtitle: 'Challenge final — Maîtrisez l\'art complet des consignes',
      emoji: '',
      color: const Color(0xFFFF8F00),
      ficheRef: 'Fiches 19–20',
      scenario: ClarityScenario(
        context:
            'Vous êtes DRH de CLARTÉ CONSEIL. '
            'Vous organisez le bilan annuel de la politique de communication interne. '
            'Trois situations complexes vous sont soumises simultanément.',
        urgencyMessage: ' Challenge final — Toutes compétences mobilisées !',
        roleInstruction:
            ' Vous jouez le rôle du DRH. '
            'Chaque décision impactera l\'ensemble de l\'organisation.',
        acts: [
          ClarityAct(
            title: 'Acte 1 — L\'audit des consignes',
            narrative:
                'L\'audit interne révèle que 60% des consignes données dans l\'entreprise '
                'ne sont pas comprises du premier coup par leurs destinataires. '
                'Coût estimé : 3 semaines de productivité perdues par an.',
            characterMessage: 'DRH, on doit agir. Par quoi commence-t-on ?',
            characterName: 'Directeur général',
            characterEmoji: '',
            roleContext: 'Quelle est votre priorité d\'action face à cet audit ?',
            toolTask:
                'Rédigez le plan d\'action en 3 phases sur 6 mois : '
                'Phase 1 (mois 1–2) : diagnostic terrain, Phase 2 (mois 3–4) : formation et outils, '
                'Phase 3 (mois 5–6) : mesure d\'impact. Pour chaque phase : 2 actions concrètes.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je déploie immédiatement une formation obligatoire pour tous',
                explanation: 'Agir sans diagnostic préalable conduit à des solutions mal ciblées.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -10, efficiency: -5, stress: 15),
                consequence: ' La formation ne cible pas les bons problèmes. L\'impact est minimal.',
              ),
              ClarityOption(
                id: 'b', label: 'Je crée un groupe de travail pour étudier le sujet pendant 6 mois',
                explanation: 'Six mois d\'étude sans action représente encore plus de coût.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: -5, efficiency: -10, stress: 5),
                consequence: '️ Bonne démarche mais trop lente — le coût continue de s\'accumuler.',
              ),
              ClarityOption(
                id: 'c', label: 'Je propose un plan en 3 phases : diagnostic  formation ciblée  mesure d\'impact',
                explanation: 'Une approche systémique avec mesure d\'impact est la plus efficace et démontrable.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 30, trust: 25, efficiency: 30, stress: -20),
                consequence: ' Le plan est approuvé. Dans 6 mois, le taux de compréhension passe à 90%.',
              ),
              ClarityOption(
                id: 'd', label: 'Je propose un guide PDF de bonnes pratiques envoyé par email',
                explanation: 'Un document seul sans accompagnement est rarement lu et encore moins appliqué.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: 5, trust: -10, efficiency: -5, stress: 0),
                consequence: ' 12% des collaborateurs lisent le guide. Aucun impact mesurable.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — La situation difficile',
            narrative:
                'Un collaborateur vous signale avoir reçu des "consignes" abusives de son manager : '
                'objectifs impossibles, délais irréalistes, humiliation en public. '
                'Il craint des représailles s\'il dépose une plainte formelle.',
            characterMessage: 'Je ne sais pas quoi faire. Si je me plains officiellement, ça va empirer.',
            characterName: 'Paul — Collaborateur',
            characterEmoji: '',
            roleContext: 'Comment gérez-vous cette situation délicate en tant que DRH ?',
            toolTask:
                'Rédigez les 4 étapes de votre protocole d\'intervention : '
                'accueil et protection du collaborateur, investigation, mesures immédiates, '
                'prévention des représailles.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je conseille à Paul de régler ça directement avec son manager',
                explanation: 'Renvoyer une victime potentielle vers son agresseur présumé est une faute grave.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -30, efficiency: -10, stress: 30),
                consequence: ' Paul est exposé à des représailles. Risque juridique majeur pour l\'entreprise.',
              ),
              ClarityOption(
                id: 'b', label: 'Je convoque immédiatement le manager pour confrontation',
                explanation: 'Une confrontation immédiate sans investigation préalable peut détruire des preuves.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -10, efficiency: -5, stress: 20),
                consequence: ' Le manager nie tout. Paul se retrouve dans une position encore plus difficile.',
              ),
              ClarityOption(
                id: 'c', label: 'Je sécurise Paul (confidentialité + protection), investigate discrètement, puis agis',
                explanation: 'Protection d\'abord, investigation rigoureuse, puis action = gestion exemplaire.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 30, efficiency: 15, stress: -25),
                consequence: ' Paul se sent protégé. L\'investigation révèle les faits. Une action appropriée est prise.',
              ),
              ClarityOption(
                id: 'd', label: 'Je classe le dossier en attendant d\'avoir plus d\'éléments',
                explanation: 'L\'inaction face à une situation de harcèlement potentiel engage la responsabilité de l\'entreprise.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -15, trust: -25, efficiency: -5, stress: 20),
                consequence: ' La situation s\'aggrave. Paul démissionne. L\'entreprise fait face à un litige.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — La vision annuelle',
            narrative:
                'L\'année se termine. Vous présentez au CODIR le bilan de la politique des consignes. '
                'Les indicateurs sont au vert. Vous proposez la vision pour l\'année suivante.',
            characterMessage: 'Excellent bilan ! Quelle est votre ambition pour l\'an prochain ?',
            characterName: 'PDG — Comité de direction',
            characterEmoji: '',
            roleContext: 'Comment concluez-vous avec une vision inspirante et concrète ?',
            toolTask:
                'Rédigez votre discours de 5 phrases pour le CODIR : '
                'bilan chiffré (1 phrase), cause racine adressée (1 phrase), '
                'vision 2026 (1 phrase), 2 engagements mesurables, invitation à l\'action collective.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je présente uniquement les succès sans mentionner les axes d\'amélioration',
                explanation: 'Un bilan incomplet perd en crédibilité et empêche l\'apprentissage organisationnel.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: -10, efficiency: 0, stress: -5),
                consequence: '️ Bonne communication mais le CODIR sait que vous omettez des points importants.',
              ),
              ClarityOption(
                id: 'b', label: 'Je liste les problèmes restants pour montrer qu\'il y a encore du travail',
                explanation: 'Finir sur les problèmes après une bonne année nuit à la motivation collective.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: 5, trust: -5, efficiency: -5, stress: 10),
                consequence: ' L\'équipe repart avec le moral en berne malgré d\'excellents résultats.',
              ),
              ClarityOption(
                id: 'c', label: 'Je présente : bilan chiffré  cause adressée  vision inspirante  2 engagements  appel à l\'action',
                explanation: 'Un discours équilibré qui célèbre le passé et inspire le futur est le plus mobilisateur.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 30, trust: 30, efficiency: 25, stress: -25),
                consequence: ' Le CODIR vote un budget augmenté. L\'équipe repart enthousiaste et engagée.',
              ),
              ClarityOption(
                id: 'd', label: 'Je propose simplement de reconduire le même plan pour l\'année suivante',
                explanation: 'Reconduire sans adaptation ignore les nouvelles opportunités et besoins.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: 0, stress: 0),
                consequence: '️ Plan approuvé mais sans enthousiasme. Manque de vision d\'évolution.',
              ),
            ],
          ),
        ],
        debriefTitle: ' Félicitations — Maître des Consignes !',
        keyLessons: [
          'La clarté des consignes est une compétence managériale stratégique qui se mesure et se développe',
          'Un plan d\'amélioration systémique (diagnostic  formation  mesure) donne les meilleurs résultats',
          'Protéger un collaborateur en difficulté est un devoir légal et éthique du RH',
          'Le discours de clôture qui équilibre bilan et vision mobilise mieux que l\'un ou l\'autre seul',
          'Chaque challenge de ce jeu vous a donné un outil concret applicable dès demain matin',
        ],
        commonMistakes: [
          'Agir sans diagnostic préalable — les solutions génériques ne fonctionnent pas',
          'Minimiser une situation de harcèlement potentiel par peur du conflit',
          'Finir une période sur les problèmes plutôt que sur la vision et l\'enthousiasme',
        ],
        ficheRef: 'Fiches 19–20',
      ),
    ),
  ];
}
