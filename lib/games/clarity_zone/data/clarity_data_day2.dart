import 'package:flutter/material.dart';
import '../models/clarity_models.dart';

// ═══════════════════════════════════════════════════════════════
// CLARITY ZONE — JOUR 2 : L'oral, le numérique et le groupe
// Fiches 9 à 14 — CLARTÉ CONSEIL
// ═══════════════════════════════════════════════════════════════

class ClarityDataDay2 {
  static List<ClarityChallenge> get challenges => [

    // ── CHALLENGE 1 ── Fiche 9 : Recevoir une consigne orale ──
    ClarityChallenge(
      id: 'cz_d2_c1',
      dayNumber: 2,
      orderInDay: 1,
      title: 'La consigne qui s\'évapore',
      subtitle: 'Écoute active et méthode QQR pour ne rien perdre à l\'oral',
      emoji: '',
      color: const Color(0xFF3F51B5),
      ficheRef: 'Fiche 9',
      scenario: ClarityScenario(
        context:
            'Réunion de lancement chez CLARTÉ CONSEIL. '
            'Le directeur distribue les missions à voix haute, rapidement, '
            'sans support visuel. Vous avez 45 secondes par mission. '
            'Pas de retour en arrière possible.',
        urgencyMessage: ' Le directeur parle vite — prenez des notes maintenant !',
        roleInstruction:
            ' Vous jouez PIERRE, consultant qui reçoit une mission orale. '
            'Appliquez la méthode QQR (Qui fait Quoi, Quand, Résultat) '
            'pour ne perdre aucune information.',
        acts: [
          ClarityAct(
            title: 'Acte 1 — 45 secondes pour tout capturer',
            narrative:
                'Alexandre parle pendant 45 secondes : mission, équipe, délai, objectif. '
                'Vous avez votre carnet. Que notez-vous ?',
            characterMessage: 'Pierre, tu prends le dossier Lemaire. Avec Inès. Vous préparez l\'audit de conformité RH. Délai : rapport final vendredi prochain, 9h, format Word, envoyé à moi ET à la DRH. Objectif : identifier les 3 risques prioritaires. Des questions ?',
            characterName: 'Alexandre — Directeur',
            characterEmoji: '‍',
            roleContext: 'Appliquez la méthode QQR : notez Quoi, Quand, Résultat attendu.',
            toolTask:
                'Rédigez vos notes QQR complètes pour cette mission orale. '
                'Format : QUI / QUOI / QUAND / RÉSULTAT ATTENDU / DESTINATAIRES',
            options: [
              ClarityOption(
                id: 'a', label: 'Je note tout mot pour mot — 45 secondes c\'est court mais je peux.',
                explanation: 'Vouloir tout noter mot pour mot ralentit l\'écoute. On rate l\'essentiel en cherchant à tout capturer.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: -5, efficiency: -10, stress: 15),
                consequence: 'Vous avez des notes abondantes mais désorganisées. Difficile de savoir quoi faire en priorité.',
              ),
              ClarityOption(
                id: 'b', label: 'Je note : QUI=Pierre+Inès / QUOI=Audit conformité RH Lemaire / QUAND=Vendredi 9h / RÉSULTAT=Rapport Word, 3 risques prioritaires / ENVOI=Alexandre+DRH.',
                explanation: 'Méthode QQR appliquée parfaitement. Notes structurées, actionnables, complètes.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 15, efficiency: 25, stress: -20),
                consequence: 'En 5 mots par item, vous avez tout capturé. Inès et vous pouvez démarrer immédiatement.',
              ),
              ClarityOption(
                id: 'c', label: 'Je mémorise sans noter — j\'ai une bonne mémoire.',
                explanation: 'On retient 30 à 50% d\'une consigne orale entendue une fois. La mémoire reconstruit et transforme.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -15, efficiency: -20, stress: 25),
                consequence: 'Le lendemain, vous avez oublié les destinataires et cru que la deadline était lundi. Catastrophe.',
              ),
              ClarityOption(
                id: 'd', label: 'Je note le sujet général et demanderai les détails à Inès.',
                explanation: 'Dépendre d\'Inès pour vos propres notes est un risque inutile.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: -10, efficiency: -10, stress: 10),
                consequence: 'Inès n\'a pas tout noté non plus. Vous vous retrouvez avec des informations fragmentées.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — La reformulation finale en réunion',
            narrative:
                'Alexandre a terminé. Il demande : "Des questions ?" '
                'Vous avez vos notes QQR. Le moment de reformuler pour valider.',
            characterMessage: 'Donc, si j\'ai bien noté : Pierre et Inès préparent l\'audit conformité RH du dossier Lemaire, rapport Word vendredi 9h à toi et à la DRH, avec les 3 risques prioritaires identifiés. C\'est bien ça ?',
            characterName: 'Pierre — Vous',
            characterEmoji: '',
            roleContext: 'Quelle est la réaction idéale d\'Alexandre ? Et que faire s\'il corrige ?',
            toolTask:
                'Décrivez le protocole complet : comment réagir si Alexandre confirme, '
                'et comment noter si Alexandre corrige un point.',
            options: [
              ClarityOption(
                id: 'a', label: 'Si confirmation : je ferme mon carnet et démarre. Si correction : je dis "Ah oui, merci" et continue.',
                explanation: 'La correction est une information clé. Elle doit être notée précisément, pas juste acquittée.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: 0, efficiency: -5, stress: 5),
                consequence: 'Alexandre corrige le format (PDF pas Word). Vous l\'avez entendu mais oublié le lendemain.',
              ),
              ClarityOption(
                id: 'b', label: 'Si confirmation : je coche et signe mes notes pour valider. Si correction : je raye l\'ancien item et note le nouveau immédiatement.',
                explanation: 'Protocole rigoureux. La correction est intégrée dans les notes au bon moment.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 20, efficiency: 20, stress: -15),
                consequence: 'Alexandre confirme et précise "PDF pas Word". Vous le notez. Vendredi, tout est parfait.',
              ),
              ClarityOption(
                id: 'c', label: 'Si confirmation : je redis "merci". Si correction : je pose une question supplémentaire sur chaque détail.',
                explanation: 'Trop de questions après la confirmation ralentit la réunion et agace les autres participants.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: -10, efficiency: -10, stress: 10),
                consequence: 'Vos 4 questions supplémentaires irritent les 8 autres participants. Alexandre abrège.',
              ),
              ClarityOption(
                id: 'd', label: 'J\'envoie un email récapitulatif à Alexandre après la réunion.',
                explanation: 'Bonne pratique complémentaire, mais la validation doit se faire en réunion, pas après.',
                isCorrect: false,
                impact: ClarityImpact.good,
                effect: ClarityEffect(clarity: 10, trust: 5, efficiency: 5, stress: -5),
                consequence: 'Alexandre répond 2h plus tard avec la correction. Vous avez déjà commencé dans le mauvais format.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — Transmettre la consigne à Inès',
            narrative:
                'Vous sortez de réunion. Inès n\'y était pas — elle est en déplacement. '
                'Vous devez lui transmettre la consigne orale que vous venez de recevoir. '
                'Comment la transformer en consigne écrite parfaite ?',
            characterMessage: 'Pierre, je suis en déplacement jusqu\'à 14h. Tu peux me récapituler par message ?',
            characterName: 'Inès — Collègue',
            characterEmoji: '',
            roleContext: 'Transformez votre note QQR en consigne écrite claire pour Inès.',
            toolTask:
                'Rédigez le message exact que vous envoyez à Inès. '
                'Appliquez la structure 4 blocs : contexte bref / action / délai / contact.',
            options: [
              ClarityOption(
                id: 'a', label: '"Inès, on a une mission : audit Lemaire. Rappelle-moi quand tu rentres."',
                explanation: 'Trop vague. Inès ne sait ni quoi préparer ni la deadline.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -15, trust: -10, efficiency: -15, stress: 20),
                consequence: 'Inès rappelle à 14h, vous passez 20 minutes à tout réexpliquer. Temps perdu.',
              ),
              ClarityOption(
                id: 'b', label: '"Mission : Audit conformité RH dossier Lemaire. Tu prends les données RH (je prends la conformité). Rendu : rapport PDF, vendredi 9h à Alexandre + DRH. Objectif : 3 risques prioritaires. Questions avant 16h."',
                explanation: 'Message complet, structuré, actionnable. Inès peut démarrer dès 14h.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 25, stress: -20),
                consequence: 'Inès démarre dès son retour. Vous livrez le rapport vendredi à 8h45.',
              ),
              ClarityOption(
                id: 'c', label: 'Je lui envoie une photo de mes notes QQR.',
                explanation: 'Pratique pour la rapidité mais peu professionnel — une photo de notes est moins lisible qu\'un message structuré.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: 0, stress: 5),
                consequence: 'Inès décrypte vos abréviations. Elle comprend l\'essentiel mais rate la répartition des tâches.',
              ),
              ClarityOption(
                id: 'd', label: 'J\'attends son retour pour lui expliquer à l\'oral.',
                explanation: 'Vous perdez 3h pendant lesquelles Inès ne peut pas préparer.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -10, efficiency: -20, stress: 15),
                consequence: 'Inès rentre à 14h, briefing à 15h. Il ne reste que 4h pour un audit qui en demande 8.',
              ),
            ],
          ),
        ],
        debriefTitle: 'La consigne orale ne pardonne pas',
        keyLessons: [
          'Méthode QQR : noter Qui / Quoi / Quand / Résultat en 5 mots max par item',
          'On retient 30 à 50% d\'une consigne orale sans notes — jamais de mémoire seule',
          'Reformuler en fin de réunion pour valider — noter les corrections immédiatement',
          'Transcrire une consigne orale reçue = la structurer en 4 blocs pour la transmettre',
        ],
        commonMistakes: [
          'Vouloir tout noter mot pour mot — on rate l\'essentiel',
          'Ne rien noter et compter sur sa mémoire',
          'Ne jamais interrompre même quand un point crucial est flou',
        ],
        ficheRef: 'Fiche 9',
      ),
    ),

    // ── CHALLENGE 2 ── Fiche 11 : Consigne de groupe ──
    ClarityChallenge(
      id: 'cz_d2_c2',
      dayNumber: 2,
      orderInDay: 2,
      title: 'Personne ne s\'en occupe',
      subtitle: 'Diffusion de responsabilité : le piège du groupe',
      emoji: '',
      color: const Color(0xFFFF9800),
      ficheRef: 'Fiche 11',
      scenario: ClarityScenario(
        context:
            'Vous êtes manager d\'une équipe de 6 consultants chez CLARTÉ CONSEIL. '
            'Vous devez transmettre 3 consignes pour préparer la semaine. '
            'Problème : la semaine dernière, rien n\'a été fait car tout le monde '
            'pensait que quelqu\'un d\'autre s\'en occupait.',
        urgencyMessage: ' 6 personnes, 3 missions — si personne n\'est nommé, rien ne sera fait.',
        roleInstruction:
            ' Vous jouez SONIA, manager senior. '
            'Vous êtes en réunion d\'équipe avec 6 consultants. '
            'Appliquez la structure en 5 étapes pour transmettre 3 consignes de groupe efficacement.',
        acts: [
          ClarityAct(
            title: 'Acte 1 — Nommer un responsable par action',
            narrative:
                'La semaine dernière, vous avez dit : '
                '"Il faudrait que quelqu\'un prépare le rapport hebdo." '
                'Personne ne l\'a fait. Tout le monde pensait que c\'était l\'autre.',
            characterMessage: 'Donc la semaine dernière... personne n\'a préparé le rapport. Chacun attendait l\'autre. C\'est le problème de la consigne de groupe.',
            characterName: 'Sonia — Vous',
            characterEmoji: '‍',
            roleContext: 'Comment reformuler la même consigne pour qu\'elle soit exécutée cette semaine ?',
            toolTask:
                'Reformulez la consigne "Quelqu\'un prépare le rapport hebdo" '
                'en appliquant : 1 responsable nommé + 1 délai concret + 1 format précis.',
            options: [
              ClarityOption(
                id: 'a', label: '"Cette fois, tout le monde doit s\'impliquer dans le rapport hebdo."',
                explanation: 'Même erreur : personne de nommé. "Tout le monde" = personne en pratique.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -15, efficiency: -20, stress: 25),
                consequence: 'Même résultat que la semaine dernière. Le rapport n\'est pas rendu.',
              ),
              ClarityOption(
                id: 'b', label: '"Marc, tu prends le rapport hebdo cette semaine. Format Excel, 1 onglet par client, à moi par email vendredi 17h."',
                explanation: 'Parfait. 1 responsable nommé, format précis, délai concret, destinataire clair.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 25, stress: -20),
                consequence: 'Marc confirme et livre le rapport vendredi à 16h45. Mission accomplie.',
              ),
              ClarityOption(
                id: 'c', label: '"Qui peut faire le rapport hebdo cette semaine ?"',
                explanation: 'Vous demandez un volontaire. Si personne ne répond, le problème reste entier.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: -5, efficiency: -5, stress: 10),
                consequence: 'Silence dans la salle. Vous finissez par nommer Marc de toute façon — 2 minutes perdues.',
              ),
              ClarityOption(
                id: 'd', label: '"Marc et Inès, vous co-gérez le rapport hebdo pour cette semaine."',
                explanation: 'Deux responsables = dilution de responsabilité. Chacun pensera que l\'autre fait.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -5, efficiency: -10, stress: 15),
                consequence: 'Marc fait la moitié. Inès fait la moitié. Les deux moitiés ne sont pas compatibles.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — La structure en 5 étapes devant le groupe',
            narrative:
                'Vous avez 3 consignes à transmettre à vos 6 consultants. '
                'Appliquez la structure : Capter l\'attention  Annoncer le nombre  '
                'Transmettre une par une  Nommer  Tour de table.',
            characterMessage: 'J\'ai 3 points importants pour cette semaine. Je vais les donner un par un. Pour chacun, j\'ai besoin d\'un accusé de réception.',
            characterName: 'Sonia — Vous',
            characterEmoji: '‍',
            roleContext: 'Démontrez la structure en 5 étapes en action.',
            toolTask:
                'Rédigez le script complet de votre prise de parole pour transmettre '
                'les 3 consignes selon la structure en 5 étapes.',
            options: [
              ClarityOption(
                id: 'a', label: 'Je dis les 3 consignes d\'affilée rapidement pour ne pas perdre de temps.',
                explanation: 'Trop rapide = surcharge cognitive. L\'équipe ne peut pas traiter 3 consignes simultanément.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -15, trust: -10, efficiency: -15, stress: 20),
                consequence: 'L\'équipe retient la première et la dernière consigne. La deuxième disparaît.',
              ),
              ClarityOption(
                id: 'b', label: '"3 points ce matin. Point 1 [pause + nommer + délai]. Vous avez noté ? Point 2 [pause + nommer + délai]. OK ? Point 3... Tour de table pour confirmer."',
                explanation: 'Structure en 5 étapes appliquée. Pauses, confirmation, tour de table. Rien ne peut être oublié.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 25, stress: -20),
                consequence: 'L\'équipe répète ses missions. Un consultant signale un conflit avec une autre deadline. Vous l\'ajustez en direct.',
              ),
              ClarityOption(
                id: 'c', label: 'J\'envoie les 3 consignes par email après la réunion — c\'est plus fiable.',
                explanation: 'L\'email peut compléter mais la réunion est déjà là. Pourquoi ne pas en profiter ?',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: -5, efficiency: -5, stress: 5),
                consequence: 'L\'email arrive. 2 consultants ne l\'ont pas lu avant le déjeuner. Retard de 3h.',
              ),
              ClarityOption(
                id: 'd', label: 'Je projette un slide avec les 3 consignes — pas besoin de les dire.',
                explanation: 'Le visuel seul sans explications orales ne garantit pas la compréhension.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: 0, stress: 5),
                consequence: 'Un consultant interprète différemment son action. Il n\'y avait personne pour clarifier.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — Récapitulatif écrit post-réunion',
            narrative:
                'La réunion se termine bien. Chacun sait sa mission. '
                'Mais vous savez que sans trace écrite, '
                'les détails s\'évaporeront dans les prochaines heures.',
            characterMessage: 'Super réunion. Mais on envoie un récap écrit ?',
            characterName: 'Marc — Consultant',
            characterEmoji: '‍',
            roleContext: 'Quel récapitulatif envoyer et dans quel délai ?',
            toolTask:
                'Rédigez le récapitulatif écrit post-réunion. '
                'Format : une ligne par mission avec responsable, action, délai.',
            options: [
              ClarityOption(
                id: 'a', label: 'J\'envoie le récap dans les 30 minutes avec : NOM  ACTION  DÉLAI pour chaque mission.',
                explanation: 'Délai court + format condensé. Le récap arrive quand les missions sont encore fraîches.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 20, trust: 15, efficiency: 20, stress: -15),
                consequence: 'Tout le monde répond "reçu". La semaine se passe sans relance ni oubli.',
              ),
              ClarityOption(
                id: 'b', label: 'J\'envoie le compte-rendu complet de la réunion avec tout le contexte.',
                explanation: 'Trop long. Personne ne relit un CR complet. L\'essentiel se noie dans le contexte.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: -5, stress: 5),
                consequence: 'Le CR fait 2 pages. 3 consultants ne lisent que le titre et les premiers mots.',
              ),
              ClarityOption(
                id: 'c', label: 'Je n\'envoie rien — chacun a ses notes.',
                explanation: 'Risque élevé. Les notes individuelles peuvent différer. Pas de référence commune.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -15, trust: -10, efficiency: -15, stress: 20),
                consequence: 'Jeudi, un consultant a noté "vendredi soir" au lieu de "vendredi 17h". Retard.',
              ),
              ClarityOption(
                id: 'd', label: 'J\'envoie le récap 2 jours après — quand j\'ai le temps.',
                explanation: 'Trop tard. Les missions sont en cours depuis 2 jours sans référence commune.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -10, efficiency: -10, stress: 15),
                consequence: 'Inès a commencé sur la mauvaise base depuis 2 jours. Le récap arrive trop tard pour corriger.',
              ),
            ],
          ),
        ],
        debriefTitle: 'Le groupe sans responsable ne livre rien',
        keyLessons: [
          '"Tout le monde" = personne. Toujours nommer 1 responsable par action',
          'Structure en 5 étapes : capter  annoncer le nombre  une par une  nommer  tour de table',
          'Récapitulatif écrit dans les 30 min post-réunion : format condensé NOM  ACTION  DÉLAI',
          'Laisser le temps de noter entre chaque consigne — pas tout à la suite',
        ],
        commonMistakes: [
          'Adresser une consigne à "l\'équipe" sans nommer de responsable',
          'Ne pas faire de pauses entre chaque consigne — surcharge cognitive',
          'Ne pas envoyer de trace écrite après la réunion',
        ],
        ficheRef: 'Fiche 11',
      ),
    ),

    // ── CHALLENGE 3 ── Fiche 13 : L\'email de consigne ──
    ClarityChallenge(
      id: 'cz_d2_c3',
      dayNumber: 2,
      orderInDay: 3,
      title: 'L\'objet qui dit tout',
      subtitle: 'Maîtriser l\'email de consigne avec la méthode LANA',
      emoji: '',
      color: const Color(0xFFE91E63),
      ficheRef: 'Fiche 13',
      scenario: ClarityScenario(
        context:
            'CLARTÉ CONSEIL reçoit en moyenne 80 emails par jour par consultant. '
            'La moitié ne sera jamais lue correctement. '
            'Vous êtes responsable de la communication projet — '
            'vos emails doivent être lus ET compris du premier coup.',
        urgencyMessage: ' 80 emails par jour — le vôtre doit sortir du lot.',
        roleInstruction:
            ' Vous jouez CLAIRE, responsable communication projet. '
            'Vous allez rédiger et analyser des emails selon la méthode LANA '
            '(Lire  Analyser  Noter  Agir) et la structure en 4 blocs.',
        acts: [
          ClarityAct(
            title: 'Acte 1 — L\'objet qui change tout',
            narrative:
                'Deux emails arrivent dans votre boîte. '
                'Objet 1 : "Réunion". Objet 2 : "Réunion vendredi — Confirmer présence avant 16h". '
                'Lequel allez-vous lire en premier ? Et lequel générera une action ?',
            characterMessage: 'Votre boîte de réception : 12 emails avec "Réunion" comme objet, 3 avec "URGENT", 1 avec "Validation livrables Lemaire — avant jeudi 14h".',
            characterName: 'Votre boîte de réception',
            characterEmoji: '',
            roleContext: 'Quelle règle appliquer pour un objet d\'email efficace ?',
            toolTask:
                'Transformez ces 3 objets flous en objets actionnables : '
                '1) "Réunion" 2) "Question" 3) "Dossier client"',
            options: [
              ClarityOption(
                id: 'a', label: '1) "Réunion projet Alpha — Confirmer présence avant vendredi 12h" 2) "Question sur devis Lemaire — Répondre avant jeudi" 3) "Dossier client Martin — Valider version finale avant lundi 9h"',
                explanation: 'Objets actionnables parfaits : sujet + action + deadline. Chacun sait quoi faire sans ouvrir l\'email.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 15, efficiency: 25, stress: -20),
                consequence: 'Taux de réponse : 95% avant la deadline. Aucune relance nécessaire.',
              ),
              ClarityOption(
                id: 'b', label: '1) "URGENT - Réunion" 2) "IMPORTANT - Question" 3) "Action requise - Dossier"',
                explanation: 'Le mot "URGENT" est sur-utilisé et ignoré. L\'objet doit être actionnable, pas alarmiste.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -10, efficiency: -10, stress: 15),
                consequence: 'L\'équipe a désactivé les alertes "URGENT" après 3 semaines de fausses urgences.',
              ),
              ClarityOption(
                id: 'c', label: '1) "Réunion vendredi" 2) "Question devis" 3) "Dossier Martin mise à jour"',
                explanation: 'Mieux que les originaux mais il manque l\'action et la deadline dans chaque objet.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 10, trust: 5, efficiency: 5, stress: -5),
                consequence: 'Amélioration partielle. Le taux de réponse passe de 60% à 75% avant deadline.',
              ),
              ClarityOption(
                id: 'd', label: 'L\'objet n\'a pas d\'importance — les gens lisent les emails de toute façon.',
                explanation: 'L\'objet est la première décision de tri. Un mauvais objet = email ignoré ou mal priorisé.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -10, efficiency: -20, stress: 20),
                consequence: 'Vos emails sont lus en dernier ou jamais. Vos deadlines sont systématiquement ratées.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — Appliquer la méthode LANA en réception',
            narrative:
                'Vous recevez un email complexe de 10 lignes. '
                'Appliquez la méthode LANA : Lire  Analyser  Noter  Agir.',
            characterMessage: 'Bonjour Claire, suite à la réunion de jeudi (que vous n\'avez pas pu rejoindre), plusieurs décisions ont été prises concernant le projet Fontaine. Nous avons convenu de replanifier la phase 2 (initialement prévue en mars) au mois d\'avril, en raison des contraintes client. Par ailleurs, le budget a été réajusté à la hausse de 15%. Merci de mettre à jour le tableau de bord projet et d\'informer les parties prenantes externes avant vendredi. Vous trouverez le CR complet en pièce jointe.',
            characterName: 'Email — Direction de projet',
            characterEmoji: '',
            roleContext: 'Appliquez LANA : extrayez les 2 actions cachées dans cet email.',
            toolTask:
                'Appliquez la méthode LANA à cet email : '
                'L=résumé en 1 ligne, A=actions identifiées, N=notes actionnables, A=planification.',
            options: [
              ClarityOption(
                id: 'a', label: 'L=Projet Fontaine modifié. A=1) MAJ tableau de bord 2) Informer parties externes. N=Deadline vendredi, budget +15%, phase 2 reportée avril. A=Faire les 2 actions avant vendredi.',
                explanation: 'LANA appliqué parfaitement. Vous avez extrait les 2 actions cachées dans 10 lignes de contexte.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 15, efficiency: 25, stress: -20),
                consequence: 'Vous traitez l\'email en 3 minutes. Les 2 actions sont planifiées avant la fin de journée.',
              ),
              ClarityOption(
                id: 'b', label: 'Je lis l\'email, je lis le CR en PJ, et je commence par le tableau de bord.',
                explanation: 'Vous agissez sur la première action vue sans planifier la seconde.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: -5, stress: 10),
                consequence: 'Vous finissez le tableau de bord et oubliez les parties prenantes externes. Relance vendredi matin.',
              ),
              ClarityOption(
                id: 'c', label: 'Je mets l\'email en "à traiter plus tard" — c\'est informatif, pas urgent.',
                explanation: 'Mauvaise lecture. L\'email contient une deadline concrète (vendredi) et 2 actions.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -15, efficiency: -20, stress: 25),
                consequence: 'Vous retrouvez l\'email le vendredi à 16h. Il est trop tard pour informer les parties externes.',
              ),
              ClarityOption(
                id: 'd', label: 'Je réponds en demandant quelles sont les actions attendues.',
                explanation: 'Les actions sont dans l\'email. Cette question montre que vous ne l\'avez pas lu correctement.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -15, efficiency: -10, stress: 15),
                consequence: 'La direction perd confiance dans votre capacité à lire les emails professionnels.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — Le CC abusif',
            narrative:
                'Votre collègue Nicolas met systématiquement toute l\'équipe en copie (CC) '
                'de tous ses emails. Résultat : 20 emails par jour que personne ne lit vraiment. '
                'Vous devez lui expliquer la règle du CC.',
            characterMessage: 'Je mets tout le monde en copie pour que tout le monde soit informé. Comme ça personne ne peut dire qu\'il ne savait pas.',
            characterName: 'Nicolas — Collègue',
            characterEmoji: '‍',
            roleContext: 'Expliquez à Nicolas les 3 règles du CC professionnel.',
            toolTask:
                'Rédigez les 3 règles du CC que vous expliquez à Nicolas. '
                'Pour chacune, donnez un exemple concret.',
            options: [
              ClarityOption(
                id: 'a', label: '"À" = destinataire qui doit agir. CC = pour info uniquement, action non requise. BCC = pour les externes discrets. Règle : si tu mets quelqu\'un en CC, il ne doit pas avoir à répondre."',
                explanation: 'Règles claires et mémorisables. Nicolas comprend la distinction fondamentale.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 15, efficiency: 20, stress: -20),
                consequence: 'Nicolas réduit les CC de 80%. L\'équipe retrouve une boîte de réception gérable.',
              ),
              ClarityOption(
                id: 'b', label: '"C\'est mieux de mettre moins de gens en copie pour ne pas polluer les boîtes."',
                explanation: 'Conseil sans règle claire. Nicolas ne sait pas comment décider qui mettre en CC.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: 0, stress: 5),
                consequence: 'Nicolas réduit un peu les CC mais sans critère précis. Le problème persiste à 50%.',
              ),
              ClarityOption(
                id: 'c', label: '"Je transmettrai ta question à l\'équipe — c\'est elle qui décide des règles."',
                explanation: 'Evitement. Vous avez les connaissances pour répondre directement.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -10, efficiency: -10, stress: 10),
                consequence: 'La réunion d\'équipe sur les règles CC prend 45 minutes pour conclure ce que vous saviez déjà.',
              ),
              ClarityOption(
                id: 'd', label: '"Tu as raison de tout mettre en copie — mieux vaut trop informer que pas assez."',
                explanation: 'Faux. Le sur-CC crée du bruit et nuit à la qualité de lecture des vrais emails importants.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -5, efficiency: -20, stress: 25),
                consequence: 'Nicolas continue et aggrave le phénomène. L\'équipe finit par ignorer tous ses emails.',
              ),
            ],
          ),
        ],
        debriefTitle: 'L\'email qui agit',
        keyLessons: [
          'Objet actionnable = sujet + action + deadline : le destinataire sait quoi faire sans ouvrir',
          'Méthode LANA : Lire (résumé 1 ligne)  Analyser (actions)  Noter (actionnables)  Agir (planifier)',
          'CC = pour information uniquement, jamais d\'action requise des destinataires en copie',
          'Les actions importantes se cachent souvent dans la deuxième moitié d\'un email long',
        ],
        commonMistakes: [
          'Objet vague comme "Réunion" ou "Question" — ne dit pas quoi faire',
          'Mettre toute l\'équipe en CC par précaution — crée du bruit, nuit à la lecture',
          'Agir sur la première action vue sans lire l\'email jusqu\'au bout',
        ],
        ficheRef: 'Fiche 13',
      ),
    ),

    // ── CHALLENGE 4 ── Fiche 17 : Consignes contradictoires ──
    ClarityChallenge(
      id: 'cz_d2_c4',
      dayNumber: 2,
      orderInDay: 4,
      title: 'Deux chefs, deux ordres opposés',
      subtitle: 'Gérer les consignes contradictoires sans se mettre à dos',
      emoji: '',
      color: const Color(0xFFF44336),
      ficheRef: 'Fiche 17',
      scenario: ClarityScenario(
        context:
            'Situation de crise chez CLARTÉ CONSEIL. '
            'Un client important menace de résilier. '
            'Votre responsable direct et le directeur général vous donnent '
            'deux instructions contradictoires. Vous êtes pris en sandwich.',
        urgencyMessage: ' Deux ordres contradictoires — choisir le mauvais = conséquence directe.',
        roleInstruction:
            ' Vous jouez STÉPHANE, consultant senior. '
            'Vous venez de recevoir deux consignes incompatibles. '
            'Appliquez la méthode en 4 étapes pour gérer la contradiction sans créer de conflit.',
        acts: [
          ClarityAct(
            title: 'Acte 1 — Identifier et formuler la contradiction',
            narrative:
                'La DG dit : "Proposez au client une réduction de 20% pour sauver le contrat." '
                'Votre manager dit : "Ne touchez pas aux tarifs sans validation du comité." '
                'Vous devez rencontrer le client dans 2 heures.',
            characterMessage: 'DG : "Proposez 20% de réduction." — Manager : "Ne touchez pas aux tarifs sans comité."',
            characterName: ' Contradiction détectée',
            characterEmoji: '',
            roleContext: 'Étape 1 : formulez la contradiction clairement avant d\'agir.',
            toolTask:
                'Rédigez la formulation exacte de la contradiction '
                'que vous allez présenter aux deux parties pour arbitrage. '
                'Elle doit être neutre, précise et non accusatoire.',
            options: [
              ClarityOption(
                id: 'a', label: '"J\'ai deux instructions incompatibles : la DG autorise une remise de 20%, mon manager exige une validation comité préalable. Lequel des deux prévaut pour ce cas ?"',
                explanation: 'Neutre, précis, non accusatoire. Vous exposez le problème sans désigner un coupable.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 20, stress: -20),
                consequence: 'La DG et le manager discutent entre eux. Vous obtenez une décision claire en 15 minutes.',
              ),
              ClarityOption(
                id: 'b', label: 'Je suis l\'ordre du manager — il est mon chef direct.',
                explanation: 'Automatisme hiérarchique sans discernement. Le contexte détermine quelle autorité prévaut.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -15, efficiency: -10, stress: 20),
                consequence: 'La DG apprend que vous avez ignoré son instruction. Tension au sommet.',
              ),
              ClarityOption(
                id: 'c', label: 'Je suis l\'ordre de la DG — elle est plus haute dans la hiérarchie.',
                explanation: 'Hiérarchie ≠ autorité sur cette décision. Votre manager a peut-être une raison valable (légale, contractuelle).',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -15, efficiency: -10, stress: 20),
                consequence: 'Vous accordez la remise. Le comité découvre une violation de procédure. Audit interne.',
              ),
              ClarityOption(
                id: 'd', label: 'Je propose une remise de 10% — un compromis entre les deux.',
                explanation: 'Initiative non mandatée. Un compromis non autorisé n\'est pas une solution — c\'est une troisième consigne que vous inventez.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -20, efficiency: -15, stress: 30),
                consequence: 'Ni la DG ni le manager n\'avaient autorisé 10%. Vous avez outrepassé vos attributions.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — Escalader sans accuser',
            narrative:
                'Vous avez formulé la contradiction. '
                'Maintenant vous devez l\'escalader pour obtenir un arbitrage. '
                'Comment contacter les deux parties sans créer de conflit ?',
            characterMessage: 'Avant la réunion client dans 2h, j\'ai besoin d\'un arbitrage rapide sur un point.',
            characterName: 'Stéphane — Vous',
            characterEmoji: '',
            roleContext: 'Escaladez la contradiction de façon professionnelle. Par quel canal et en quels termes ?',
            toolTask:
                'Rédigez le message d\'escalade que vous envoyez simultanément '
                'à la DG et à votre manager. Il doit être neutre et orienté solution.',
            options: [
              ClarityOption(
                id: 'a', label: '"J\'ai reçu deux instructions différentes sur la remise client : votre autorisation de 20% et la procédure comité. Pour ma réunion dans 2h, quelle instruction prévaut ? Merci de vous aligner."',
                explanation: 'Neutre, factuel, orienté résolution. Vous posez le problème sans pointer de responsable.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 20, stress: -20),
                consequence: 'La DG et le manager se téléphonent. Décision prise en 10 minutes : réduction de 15% avec validation orale.',
              ),
              ClarityOption(
                id: 'b', label: '"Mon manager bloque la réduction que vous avez autorisée. Pouvez-vous lui parler ?"',
                explanation: 'Vous désignez un coupable et créez un conflit hiérarchique. Ce n\'est pas votre rôle.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -20, efficiency: -15, stress: 30),
                consequence: 'La DG convoque votre manager. Ambiance dégradée pour les 3 prochains mois.',
              ),
              ClarityOption(
                id: 'c', label: 'Je contacte uniquement mon manager — la DG n\'a pas à être mêlée à ça.',
                explanation: 'La DG est co-auteur de la contradiction. Elle doit être dans la boucle pour l\'arbitrage.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -10, efficiency: -10, stress: 15),
                consequence: 'Votre manager décide seul. La DG apprend qu\'elle a été exclue et le prend mal.',
              ),
              ClarityOption(
                id: 'd', label: 'J\'attends qu\'ils se parlent d\'eux-mêmes.',
                explanation: 'Ils ne savent pas qu\'il y a contradiction si vous ne les en informez pas.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -15, trust: -10, efficiency: -15, stress: 20),
                consequence: 'Personne ne sait qu\'il y a un problème. Vous arrivez à la réunion sans instruction claire.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — Documenter par écrit',
            narrative:
                'L\'arbitrage est rendu : 15% de réduction avec validation orale de la DG. '
                'Avant d\'aller voir le client, vous documentez la décision. '
                'C\'est votre protection en cas de contestation future.',
            characterMessage: 'Stéphane, tu as notre accord verbal. Va voir le client.',
            characterName: 'DG — Alexandre',
            characterEmoji: '‍',
            roleContext: 'Comment documenter une décision orale avant d\'agir ?',
            toolTask:
                'Rédigez le message de confirmation que vous envoyez à la DG et à votre manager '
                'pour tracer la décision avant la réunion client.',
            options: [
              ClarityOption(
                id: 'a', label: '"Pour confirmation : suite à votre accord, je propose au client une réduction de 15% avec validation orale de la DG ce jour. Merci de confirmer si j\'ai bien compris."',
                explanation: 'Trace écrite neutre avant action. Protège tout le monde en cas de contestation future.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 25, efficiency: 20, stress: -25),
                consequence: 'La DG répond "confirmé". Vous avez une trace. La réunion se passe bien. Aucun problème futur.',
              ),
              ClarityOption(
                id: 'b', label: 'Je pars directement — ils m\'ont dit oui à l\'oral, c\'est suffisant.',
                explanation: 'Risque en cas de désaccord futur. L\'accord oral n\'est pas traçable.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 0, trust: 5, efficiency: 5, stress: 5),
                consequence: '6 mois plus tard, un audit questionne cette remise. Vous n\'avez aucune trace de l\'accord.',
              ),
              ClarityOption(
                id: 'c', label: 'Je prends une photo de la décision écrite sur le tableau blanc de la salle.',
                explanation: 'Initiative créative mais peu professionnelle. Un email traçable est bien meilleur.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: 0, stress: 5),
                consequence: 'La photo est illisible. Vous n\'avez pas de trace utilisable.',
              ),
              ClarityOption(
                id: 'd', label: 'Je note la décision dans mon carnet personnel.',
                explanation: 'Utile pour vous mais pas opposable — votre carnet n\'est pas une source officielle.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -5, efficiency: 0, stress: 5),
                consequence: 'En cas de contestation, votre carnet ne suffit pas à prouver l\'accord.',
              ),
            ],
          ),
        ],
        debriefTitle: 'La contradiction escaladée et documentée',
        keyLessons: [
          'Face à 2 consignes contradictoires : formuler  vérifier la hiérarchie  escalader  documenter',
          'Escalader sans accuser : exposer les faits, ne pas désigner de coupable',
          'Toujours obtenir une trace écrite d\'un accord oral avant d\'agir',
          'Choisir seul entre deux ordres contradictoires est une prise de risque professionnelle',
        ],
        commonMistakes: [
          'Choisir seul la consigne à suivre sans signaler la contradiction',
          'Suivre systématiquement le plus récent ou le plus haut hiérarchiquement',
          'Agir sur un accord oral sans tracer la décision par écrit',
        ],
        ficheRef: 'Fiche 17',
      ),
    ),

    // ── CHALLENGE 5 ── Fiche 19 : Adapter sa consigne ──
    ClarityChallenge(
      id: 'cz_d2_c5',
      dayNumber: 2,
      orderInDay: 5,
      title: 'La bonne consigne au bon interlocuteur',
      subtitle: 'Adapter le niveau de détail à l\'expérience du destinataire',
      emoji: '',
      color: const Color(0xFF00BCD4),
      ficheRef: 'Fiche 19',
      scenario: ClarityScenario(
        context:
            'CLARTÉ CONSEIL recrute en permanence. '
            'Vous gérez simultanément un stagiaire, un consultant confirmé '
            'et un expert senior. Même mission pour les 3 — '
            'mais la consigne doit être différente pour chacun.',
        urgencyMessage: ' 3 profils, 3 consignes différentes — même objectif.',
        roleInstruction:
            ' Vous jouez MARC, directeur de mission. '
            'Vous devez demander la même chose à 3 collaborateurs différents. '
            'Adaptez votre consigne à chaque profil.',
        acts: [
          ClarityAct(
            title: 'Acte 1 — La consigne pour le stagiaire',
            narrative:
                'Emma est stagiaire, 3ème mois. Elle est motivée mais n\'a jamais '
                'fait d\'analyse de risque. Vous devez lui expliquer comment analyser '
                'les contrats fournisseurs pour identifier les risques juridiques.',
            characterMessage: 'Emma, j\'ai besoin que tu analyses les contrats fournisseurs pour les risques juridiques.',
            characterName: 'Marc — Vous',
            characterEmoji: '‍',
            roleContext: 'Niveau débutant : Étapes détaillées + Exemple + Format imposé.',
            toolTask:
                'Rédigez la consigne complète pour Emma (stagiaire). '
                'Incluez : les étapes une par une, un exemple concret, le format de rendu.',
            options: [
              ClarityOption(
                id: 'a', label: '"Emma, voici comment faire : 1) Lis chaque contrat. 2) Souligne les clauses de résiliation et de pénalités. 3) Note-les dans ce tableau Excel (je t\'envoie le modèle). 4) Pour chaque clause, note si c\'est favorable ou risqué. Exemple : clause p.3 du contrat Dupont : résiliation sans préavis = risqué. Rendu : tableau complété vendredi 17h."',
                explanation: 'Parfait pour un débutant. Étapes détaillées + exemple concret + modèle fourni + deadline.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 15, efficiency: 25, stress: -20),
                consequence: 'Emma livre un tableau parfaitement rempli vendredi. Elle a pu travailler en autonomie grâce aux étapes claires.',
              ),
              ClarityOption(
                id: 'b', label: '"Emma, analyse les contrats et dis-moi ce que tu en penses juridiquement."',
                explanation: 'Consigne de niveau expert donnée à un débutant. Emma sera perdue.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -20, trust: -10, efficiency: -20, stress: 25),
                consequence: 'Emma vous relance 8 fois. Elle finit par rendre un document sans structure ni analyse utile.',
              ),
              ClarityOption(
                id: 'c', label: '"Emma, je t\'ai préparé un tutoriel de 20 pages sur l\'analyse contractuelle. Lis-le d\'abord."',
                explanation: 'Trop théorique. Emma ne sait toujours pas quoi faire concrètement.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 0, efficiency: -10, stress: 10),
                consequence: 'Emma lit le tutoriel. Elle en comprend 60%. Elle ne sait toujours pas par où commencer.',
              ),
              ClarityOption(
                id: 'd', label: '"Emma, observe comment je fais et ensuite fais pareil."',
                explanation: 'Apprentissage par observation — utile mais chronophage pour vous et non scalable.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 10, trust: 5, efficiency: -5, stress: 5),
                consequence: 'Emma apprend bien mais vous avez perdu 2h à faire sa mission à sa place.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 2 — La consigne pour le consultant confirmé',
            narrative:
                'Karim est consultant depuis 4 ans. Il connaît l\'analyse contractuelle. '
                'Trop de détails l\'irriteraient — trop peu et il manquera des spécificités du dossier.',
            characterMessage: 'Karim, analyse contractuelle risques juridiques fournisseurs. Deadline vendredi.',
            characterName: 'Marc — Vous',
            characterEmoji: '‍',
            roleContext: 'Niveau intermédiaire : Résultat attendu + Format + Spécificités du contexte.',
            toolTask:
                'Rédigez la consigne pour Karim (consultant confirmé, 4 ans d\'expérience). '
                'Elle doit être plus courte que celle d\'Emma mais avec les spécificités du dossier.',
            options: [
              ClarityOption(
                id: 'a', label: '"Karim, analyse les contrats fournisseurs du dossier Lemaire. Focus sur les clauses de résiliation et de pénalités en contexte international. Rendu : rapport synthèse 2 pages + tableau récapitulatif, vendredi 17h."',
                explanation: 'Juste assez de contexte (dossier Lemaire, clauses cibles, contexte international) sans sur-expliquer le "comment".',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 20, efficiency: 25, stress: -20),
                consequence: 'Karim apprécie la confiance accordée. Il livre un rapport qui dépasse les attentes.',
              ),
              ClarityOption(
                id: 'b', label: '"Karim, même consigne qu\'Emma : 1) Lis chaque contrat. 2) Souligne les clauses..."',
                explanation: 'Consigne de débutant pour un confirmé. Karim va se sentir infantilisé.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -20, efficiency: 0, stress: 15),
                consequence: 'Karim répond froidement "je sais comment faire". La relation de travail se tend.',
              ),
              ClarityOption(
                id: 'c', label: '"Karim, tu gères — tu connais ça par cœur."',
                explanation: 'Trop vague. Karim n\'a pas les spécificités du dossier Lemaire ni la deadline.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 5, efficiency: -5, stress: 5),
                consequence: 'Karim suppose que c\'est pour la fin de la semaine et utilise le format standard. Pas le bon format.',
              ),
              ClarityOption(
                id: 'd', label: '"Karim, tu fais l\'analyse contractuelle et tu m\'expliques comment tu vas procéder avant de commencer."',
                explanation: 'Inutile pour un confirmé. Vous consommez son temps et le vôtre sans valeur ajoutée.',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -5, trust: -15, efficiency: -10, stress: 10),
                consequence: 'Karim passe 30 minutes à préparer un plan que vous validez en 5 minutes. Temps gâché.',
              ),
            ],
          ),
          ClarityAct(
            title: 'Acte 3 — La consigne pour l\'expert senior',
            narrative:
                'Dr. Fontaine est expert en droit des contrats avec 20 ans d\'expérience. '
                'Lui donner des étapes serait condescendant. '
                'Mais lui donner carte blanche sans objectif serait contre-productif.',
            characterMessage: 'Dr. Fontaine, j\'ai besoin de votre expertise sur les contrats fournisseurs du dossier Lemaire.',
            characterName: 'Marc — Vous',
            characterEmoji: '‍',
            roleContext: 'Niveau expert : Objectif stratégique + Deadline + Carte blanche sur la méthode.',
            toolTask:
                'Rédigez la consigne pour le Dr. Fontaine (expert senior). '
                'Elle doit être courte, centrée sur l\'objectif, et respecter son expertise.',
            options: [
              ClarityOption(
                id: 'a', label: '"Dr. Fontaine, objectif : identifier les 3 risques juridiques majeurs qui pourraient bloquer l\'exécution du contrat Lemaire en contexte franco-belge. Rendu libre, vendredi 17h. Votre analyse guidera nos recommandations client."',
                explanation: 'Parfait pour un expert : objectif clair, contexte stratégique, liberté de méthode, deadline.',
                isCorrect: true,
                impact: ClarityImpact.excellent,
                effect: ClarityEffect(clarity: 25, trust: 25, efficiency: 25, stress: -25),
                consequence: 'Dr. Fontaine livre une analyse qui révèle un risque que personne n\'avait vu. Mission dépassée.',
              ),
              ClarityOption(
                id: 'b', label: '"Dr. Fontaine, voici les étapes : 1) Lisez les contrats. 2) Identifiez les clauses risquées..."',
                explanation: 'Gravissime erreur de condescendance avec un expert de 20 ans.',
                isCorrect: false,
                impact: ClarityImpact.critical,
                effect: ClarityEffect(clarity: -25, trust: -25, efficiency: -20, stress: 35),
                consequence: 'Dr. Fontaine vous rappelle poliment qu\'il a 20 ans d\'expérience et décline la mission.',
              ),
              ClarityOption(
                id: 'c', label: '"Dr. Fontaine, je vous laisse faire ce que vous pensez être le mieux sur les contrats Lemaire."',
                explanation: 'Trop vague même pour un expert. Il n\'a ni l\'objectif ni la deadline ni le contexte.',
                isCorrect: false,
                impact: ClarityImpact.neutral,
                effect: ClarityEffect(clarity: 5, trust: 5, efficiency: -5, stress: 5),
                consequence: 'Dr. Fontaine produit un audit complet de 40 pages. Vous vouliez 3 risques prioritaires.',
              ),
              ClarityOption(
                id: 'd', label: '"Dr. Fontaine, vous avez jusqu\'à vendredi pour les contrats Lemaire. Merci."',
                explanation: 'Deadline présente mais objectif absent. Qu\'est-ce qu\'il doit livrer exactement ?',
                isCorrect: false,
                impact: ClarityImpact.bad,
                effect: ClarityEffect(clarity: -10, trust: -5, efficiency: -10, stress: 10),
                consequence: 'Dr. Fontaine suppose l\'objectif et livre un document qui ne correspond pas au besoin.',
              ),
            ],
          ),
        ],
        debriefTitle: 'Adapter c\'est respecter',
        keyLessons: [
          'Débutant : Étapes détaillées + Exemple + Format imposé',
          'Confirmé : Résultat attendu + Format + Spécificités contextuelles',
          'Expert : Objectif stratégique + Deadline + Liberté de méthode',
          'Trop de détails pour un expert = condescendance. Trop peu pour un débutant = abandon.',
        ],
        commonMistakes: [
          'Rédiger la même consigne pour tout le monde quelle que soit l\'expérience',
          'Confondre adaptation et condescendance pour les profils expérimentés',
          'Donner carte blanche à un débutant sans jalons ni exemples',
        ],
        ficheRef: 'Fiche 19',
      ),
    ),
  ];
}
