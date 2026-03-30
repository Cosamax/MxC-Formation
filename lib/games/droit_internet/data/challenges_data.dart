import 'package:flutter/material.dart';
import '../models/game_models.dart';

class ChallengesData {
  // ═══════════════════════════════════════════════════════════════
  // RÔLES ÉQUIPE
  // ═══════════════════════════════════════════════════════════════
  static List<TeamRole> get roles => [
    TeamRole(
      id: 'ceo',
      title: 'CEO',
      emoji: '',
      description: 'Directeur Général',
      color: const Color(0xFF00D4FF),
      responsibilities: [
        'Décisions stratégiques finales',
        'Arbitrage budgétaire',
        'Communication externe',
        'Validation des engagements',
      ],
    ),
    TeamRole(
      id: 'juriste',
      title: 'Dir. Juridique',
      emoji: '️',
      description: 'Directeur Juridique',
      color: const Color(0xFF9C27B0),
      responsibilities: [
        'Conformité légale',
        'Rédaction contrats',
        'Gestion des litiges',
        'Veille juridique',
      ],
    ),
    TeamRole(
      id: 'dpo',
      title: 'DPO',
      emoji: '',
      description: 'Délégué Protection des Données',
      color: const Color(0xFFFF6B35),
      responsibilities: [
        'Conformité RGPD',
        'Registre des traitements',
        'Gestion violations données',
        'Interlocuteur CNIL',
      ],
    ),
    TeamRole(
      id: 'marketing',
      title: 'Dir. Marketing',
      emoji: '',
      description: 'Directeur Marketing',
      color: const Color(0xFF00FF88),
      responsibilities: [
        'Campagnes publicitaires',
        'Emailing & réseaux sociaux',
        'Partenariats influenceurs',
        'E-réputation',
      ],
    ),
    TeamRole(
      id: 'ecommerce',
      title: 'Dir. E-commerce',
      emoji: '',
      description: 'Directeur E-commerce',
      color: const Color(0xFFFFB800),
      responsibilities: [
        'CGV & processus commande',
        'Gestion avis clients',
        'Contenu UGC',
        'Expérience client',
      ],
    ),
  ];

  // ═══════════════════════════════════════════════════════════════
  // JOUR 1 — "Les fondations qui tremblent"
  // ═══════════════════════════════════════════════════════════════

  static Challenge get c1 => Challenge(
    id: 'c1',
    dayNumber: 1,
    orderInDay: 1,
    title: 'Le site qui fait peur',
    subtitle: 'Audit d\'urgence — Mentions légales & conformité de base',
    emoji: '',
    color: const Color(0xFFFF4D6D),
    fichesRef: ['Fiche 1', 'Fiche 7'],
    toolName: 'Google Search Console',
    toolUrl: 'https://search.google.com/search-console',
    status: ChallengeStatus.available,
    scenario: CrisisScenario(
      legalReference: 'LCEN art. 6 — Mentions légales obligatoires (sanctions : jusqu\'à 375 000 €)',
      context: '''
Votre entreprise vient d\'être créée. Vous avez lancé votre site e-commerce il y a 3 semaines, 
pressé(e) par les délais. Ce matin, vous recevez un email d\'un client mécontent qui menace 
de vous signaler à la DGCCRF car il ne trouve aucune information légale sur votre site. 
En parallèle, un concurrent a publié un post LinkedIn : "Ce site vend sans aucune mention légale, 
méfiez-vous !" avec 47 partages en 2 heures.
      ''',
      urgencyMessage: ' ALERTE — Signalement DGCCRF imminent + bad buzz en cours',
      roleInstructions: '''
 CEO : Décidez si vous communiquez publiquement ou gérez en silence
️ Dir. Juridique : Rédigez la liste exacte des mentions manquantes
 DPO : Vérifiez si la politique de confidentialité est présente
 Dir. Marketing : Gérez la crise sur LinkedIn
 Dir. E-commerce : Identifiez où placer les mentions sur le site
      ''',
      acts: [
        CrisisAct(
          title: 'Acte 1 — La découverte',
          narrative: '''
Vous ouvrez votre site en catastrophe. En 30 secondes, vous constatez :
aucune page "Mentions légales", aucun SIRET visible, 
l'hébergeur n'est nulle part mentionné.
Un client vient de laisser un avis 1 étoile : "Site louche, pas d'informations légales."

Votre concurrent continue de partager le post. Le téléphone sonne — c'est votre banquier 
qui a vu le post et s'inquiète pour votre crédibilité.
          ''',
          characterName: 'Marc Lefebvre — Banquier',
          characterEmoji: '',
          characterMessage: 'J\'ai vu ce qui circule sur LinkedIn. Votre dossier de financement est en cours... pouvez-vous me rassurer sur la conformité de votre site ?',
          toolTask: 'Listez les 4 informations obligatoires d\'une page "Mentions légales" selon la LCEN : nom de l\'éditeur, adresse, SIRET, hébergeur.',
          options: [
            DecisionOption(
              id: 'a1_1',
              label: 'Ignorer le post LinkedIn et corriger discrètement',
              explanation: 'Laisser le bad buzz se propager sans répondre aggrave la situation.',
              isCorrect: false,
              impact: DecisionImpact.negative,
              effect: IndicatorEffect(reputation: -15, compliance: 0, legalRisk: 5),
              consequence: 'Le post cumule 120 partages. Trois journalistes vous contactent.',
            ),
            DecisionOption(
              id: 'a1_2',
              label: 'Publier immédiatement une réponse professionnelle + corriger le site sous 2h',
              explanation: 'Répondre avec transparence et agir vite est la bonne approche.',
              isCorrect: true,
              impact: DecisionImpact.positive,
              effect: IndicatorEffect(reputation: 10, compliance: 5, legalRisk: -10),
              consequence: 'La communauté apprécie la réactivité. Le post perd de l\'impact.',
            ),
            DecisionOption(
              id: 'a1_3',
              label: 'Signaler le post de votre concurrent pour "dénigrement"',
              explanation: 'Si les faits sont vrais, ce n\'est pas du dénigrement. Vous perdriez.',
              isCorrect: false,
              impact: DecisionImpact.negative,
              effect: IndicatorEffect(reputation: -20, legalRisk: 15),
              consequence: 'Votre tentative échoue. La presse s\'empare de l\'histoire.',
            ),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — Le contenu manquant',
          narrative: '''
Vous devez maintenant rédiger les mentions légales. 
Votre juriste liste ce qui est obligatoire selon la LCEN.
Vous avez 45 minutes avant que la DGCCRF ne rappelle.
          ''',
          characterName: 'Inspectrice Morin — DGCCRF',
          characterEmoji: '️',
          characterMessage: 'Suite au signalement reçu ce matin, nous vérifions votre site d\'ici 2 heures. Les mentions légales incomplètes sont passibles de 375 000 € d\'amende.',
          toolTask: 'Rédigez en quelques lignes les mentions légales complètes de NUMÉRIX : nom, adresse, SIRET, hébergeur et directeur de publication.',
          options: [
            DecisionOption(
              id: 'a2_1',
              label: 'Copier les mentions légales d\'un site concurrent',
              explanation: 'Les mentions copiées contiennent les données d\'un autre (faux SIRET, fausse adresse). C\'est une infraction aggravée.',
              isCorrect: false,
              impact: DecisionImpact.critical,
              effect: IndicatorEffect(compliance: -10, legalRisk: 25),
              consequence: 'La DGCCRF constate que votre SIRET est celui d\'une autre entreprise. Procès-verbal immédiat.',
            ),
            DecisionOption(
              id: 'a2_2',
              label: 'Rédiger des mentions complètes : SIRET, adresse, hébergeur, directeur de publication',
              explanation: 'C\'est exactement ce qu\'impose la LCEN art. 6.',
              isCorrect: true,
              impact: DecisionImpact.positive,
              effect: IndicatorEffect(compliance: 20, legalRisk: -20, reputation: 5),
              consequence: 'La DGCCRF constate la mise en conformité. Aucune sanction.',
            ),
            DecisionOption(
              id: 'a2_3',
              label: 'Mettre uniquement l\'email de contact pour aller vite',
              explanation: 'Un email seul ne satisfait pas aux exigences de la LCEN.',
              isCorrect: false,
              impact: DecisionImpact.negative,
              effect: IndicatorEffect(compliance: -5, legalRisk: 15),
              consequence: 'La DGCCRF envoie une mise en demeure avec 72h pour corriger.',
            ),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — La leçon apprise',
          narrative: '''
Le site est maintenant conforme. La DGCCRF a validé.
Votre concurrent a retiré son post.
Votre banquier vous rappelle, rassuré.
Mais une question reste : comment éviter que ça ne se reproduise ?
          ''',
          characterName: 'Sophie Chen — Investisseure',
          characterEmoji: '',
          characterMessage: 'J\'ai suivi l\'incident de ce matin. La rapidité de votre réaction m\'a impressionnée. Mais avez-vous un process pour éviter ce genre de situation à l\'avenir ?',
          toolTask: 'Proposez un plan d\'action en 3 étapes pour éviter qu\'une telle faille se reproduise (checklist juridique, responsable, fréquence).',
          options: [
            DecisionOption(
              id: 'a3_1',
              label: 'Mettre en place un audit juridique annuel avec un avocat spécialisé',
              explanation: 'Excellent réflexe. Un audit annuel coûte moins cher qu\'une amende.',
              isCorrect: true,
              impact: DecisionImpact.positive,
              effect: IndicatorEffect(compliance: 15, legalRisk: -15, reputation: 10),
              consequence: 'L\'investisseure est impressionnée. Elle double sa mise.',
            ),
            DecisionOption(
              id: 'a3_2',
              label: 'Passer à autre chose, la crise est terminée',
              explanation: 'Sans process, le même problème se reproduira à la prochaine mise à jour du site.',
              isCorrect: false,
              impact: DecisionImpact.negative,
              effect: IndicatorEffect(compliance: -5, legalRisk: 10),
              consequence: '6 mois plus tard, une mise à jour du site recrée les mêmes failles.',
            ),
            DecisionOption(
              id: 'a3_3',
              label: 'Former toute l\'équipe aux obligations légales de base',
              explanation: 'Très bonne initiative complémentaire à l\'audit.',
              isCorrect: true,
              impact: DecisionImpact.positive,
              effect: IndicatorEffect(compliance: 20, legalRisk: -20, reputation: 15),
              consequence: 'L\'équipe devient un actif juridique. Zéro incident pendant 2 ans.',
            ),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: [
        'Les mentions légales sont obligatoires dès le premier jour — LCEN art. 6',
        'Absence = jusqu\'à 375 000 € d\'amende pour une société',
        'Copier des mentions légales est une infraction aggravée',
        'Répondre publiquement avec transparence protège la réputation',
        'Un audit juridique annuel est un investissement, pas une dépense',
      ],
      commonMistakes: [
        'Copier les CGV ou mentions légales d\'un concurrent',
        'Mettre uniquement un email sans les autres informations',
        'Oublier de mettre à jour après un changement d\'hébergeur',
        'Cacher la page mentions légales dans un sous-menu profond',
      ],
    ),
  );

  static Challenge get c2 => Challenge(
    id: 'c2',
    dayNumber: 1,
    orderInDay: 2,
    title: 'Qui a volé notre nom ?',
    subtitle: 'Cybersquatting — Nom de domaine & identité numérique',
    emoji: '',
    color: const Color(0xFF00D4FF),
    fichesRef: ['Fiche 2'],
    toolName: 'AFNIC + INPI',
    toolUrl: 'https://www.afnic.fr',
    scenario: CrisisScenario(
      legalReference: 'Procédure UDRP — Cybersquatting sanctionné par les tribunaux français',
      context: '''
Trois mois après le lancement, vous découvrez qu\'un site 
quasi-identique au vôtre existe avec le même nom mais en ".com" 
(le vôtre est en ".fr"). Ce site vend des produits de mauvaise qualité 
et reçoit des avis catastrophiques. Vos clients confondent les deux sites.
Votre service client croule sous les réclamations pour des commandes 
que vous n\'avez jamais traitées.
      ''',
      urgencyMessage: ' ALERTE — Confusion client massive + commandes fantômes + réputation en chute libre',
      roleInstructions: '''
 CEO : Décidez la stratégie de réponse globale
️ Dir. Juridique : Évaluez les recours possibles (UDRP, tribunal)
 DPO : Vérifiez si des données clients ont été volées
 Dir. Marketing : Communiquez pour différencier les deux sites
 Dir. E-commerce : Gérez les réclamations des clients trompés
      ''',
      acts: [
        CrisisAct(
          title: 'Acte 1 — La confusion',
          narrative: '''
Un client furieux vous envoie un email : "J\'ai commandé sur votre site 
il y a 15 jours, rien reçu, impossible de vous joindre, 
j\'ai payé 289€ pour rien !"
Vous vérifiez : il a commandé sur le site concurrent en ".com".
En cherchant sur Google, vous constatez que le faux site apparaît 
AVANT le vôtre dans les résultats.
          ''',
          characterName: 'Thomas Renard — Client lésé',
          characterEmoji: '',
          characterMessage: 'J\'ai commandé sur VOTRE site et je n\'ai rien reçu ! Je vais porter plainte et prévenir tout le monde sur les réseaux !',
          toolTask: 'Expliquez en 2-3 phrases ce qu\'est le cybersquatting et comment identifier un domaine suspect (titulaire, date de dépôt, intention).',
          options: [
            DecisionOption(
              id: 'c2_a1_1',
              label: 'Rembourser le client même si ce n\'est pas votre commande',
              explanation: 'Geste commercial fort qui protège votre réputation.',
              isCorrect: true,
              impact: DecisionImpact.positive,
              effect: IndicatorEffect(reputation: 15, finance: -5),
              consequence: 'Thomas devient un ambassadeur de votre marque sur les réseaux.',
            ),
            DecisionOption(
              id: 'c2_a1_2',
              label: 'Lui dire que ce n\'est pas votre problème',
              explanation: 'Légalement exact mais désastreux pour votre image.',
              isCorrect: false,
              impact: DecisionImpact.negative,
              effect: IndicatorEffect(reputation: -25, legalRisk: 5),
              consequence: 'Thomas publie un thread viral. -120 abonnés en 24h.',
            ),
            DecisionOption(
              id: 'c2_a1_3',
              label: 'Contacter le concurrent pour lui demander de fermer',
              explanation: 'Naïf — un cybersquatteur ne collaborera pas.',
              isCorrect: false,
              impact: DecisionImpact.neutral,
              effect: IndicatorEffect(legalRisk: 5),
              consequence: 'Pas de réponse. Le site continue. Vous perdez du temps précieux.',
            ),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — Le recours juridique',
          narrative: '''
Votre directeur juridique a identifié le titulaire du domaine concurrent :
une société écran enregistrée au Luxembourg, 
créée 2 semaines après votre lancement.
C\'est un cybersquatting classique.
Vous avez trois options de recours.
          ''',
          characterName: 'Maître Dupuis — Avocat spécialisé NDD',
          characterEmoji: '‍️',
          characterMessage: 'J\'ai analysé le dossier. Le dépôt est postérieur au vôtre, l\'intention de nuire est évidente. Nous avons 3 voies possibles. Laquelle choisissez-vous ?',
          toolTask: 'Comparez les 3 recours anti-cybersquatting : UDRP, assignation en justice, rachat amiable. Lequel choisiriez-vous et pourquoi ?',
          options: [
            DecisionOption(
              id: 'c2_a2_1',
              label: 'Procédure UDRP (rapide, 1-3 mois, ~1500€)',
              explanation: 'La procédure UDRP est spécialement conçue pour le cybersquatting. Rapide et efficace.',
              isCorrect: true,
              impact: DecisionImpact.positive,
              effect: IndicatorEffect(compliance: 10, legalRisk: -20, finance: -5),
              consequence: 'La procédure aboutit. Le domaine vous est transféré en 6 semaines.',
            ),
            DecisionOption(
              id: 'c2_a2_2',
              label: 'Assignation en justice (long, 12-18 mois, ~8000€)',
              explanation: 'Possible mais beaucoup plus long et coûteux que l\'UDRP pour ce cas.',
              isCorrect: false,
              impact: DecisionImpact.neutral,
              effect: IndicatorEffect(finance: -20, legalRisk: -10),
              consequence: 'Vous obtenez gain de cause mais 18 mois plus tard. Le mal est fait.',
            ),
            DecisionOption(
              id: 'c2_a2_3',
              label: 'Racheter le domaine directement au cybersquatteur',
              explanation: 'Cela finance le cybersquatting et crée un précédent dangereux.',
              isCorrect: false,
              impact: DecisionImpact.negative,
              effect: IndicatorEffect(finance: -15, legalRisk: 10),
              consequence: 'Le cybersquatteur revient 6 mois après avec 3 nouveaux domaines.',
            ),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — La protection future',
          narrative: '''
La procédure UDRP a abouti. Le domaine vous appartient maintenant.
Mais votre avocat vous avertit : sans marque déposée à l\'INPI,
vous êtes vulnérable pour tous les autres noms de domaine
et dans tous les pays.
          ''',
          characterName: 'Maître Dupuis — Avocat',
          characterEmoji: '‍️',
          characterMessage: 'Bravo pour la victoire. Maintenant protégeons-nous durablement. La marque INPI vous coûte 190€ pour 10 ans. C\'est le meilleur investissement que vous ferez.',
          toolTask: 'Listez les extensions de domaine à sécuriser pour NUMÉRIX (.fr, .com, .eu) et expliquez pourquoi déposer sa marque à l\'INPI est indispensable.',
          options: [
            DecisionOption(
              id: 'c2_a3_1',
              label: 'Déposer la marque à l\'INPI + acheter les extensions .com .eu .shop',
              explanation: 'Protection maximale : marque + toutes les extensions pertinentes.',
              isCorrect: true,
              impact: DecisionImpact.positive,
              effect: IndicatorEffect(compliance: 20, legalRisk: -25, reputation: 10),
              consequence: 'Votre identité numérique est blindée. Aucun concurrent ne peut vous imiter.',
            ),
            DecisionOption(
              id: 'c2_a3_2',
              label: 'Acheter uniquement les autres extensions de domaine',
              explanation: 'Utile mais insuffisant sans la marque déposée.',
              isCorrect: false,
              impact: DecisionImpact.neutral,
              effect: IndicatorEffect(legalRisk: -10, finance: -3),
              consequence: 'Un concurrent dépose votre nom en marque et vous attaque légalement.',
            ),
            DecisionOption(
              id: 'c2_a3_3',
              label: 'Ne rien faire — la victoire UDRP suffit',
              explanation: 'La décision UDRP ne protège que ce domaine précis.',
              isCorrect: false,
              impact: DecisionImpact.negative,
              effect: IndicatorEffect(legalRisk: 15),
              consequence: '3 mois plus tard, un nouveau cybersquatteur dépose votre nom en .shop.',
            ),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: [
        'Vérifier la disponibilité du nom avant le lancement — AFNIC pour .fr, INPI pour les marques',
        'La procédure UDRP est l\'arme anti-cybersquatting la plus efficace',
        'Déposer une marque à l\'INPI (190€/10 ans) est l\'investissement le plus rentable',
        'Acheter plusieurs extensions (.fr, .com, .eu) dès le départ évite 90% des problèmes',
        'Un cybersquatteur ne collabore jamais — toujours aller vers le juridique',
      ],
      commonMistakes: [
        'Essayer de racheter le domaine au cybersquatteur (cela l\'encourage)',
        'Choisir l\'assignation en justice avant la procédure UDRP',
        'Ne déposer qu\'une seule extension de domaine',
        'Ne pas déposer sa marque à l\'INPI',
      ],
    ),
  );

  static Challenge get c3 => Challenge(
    id: 'c3',
    dayNumber: 1,
    orderInDay: 3,
    title: 'Les photos qui coûtent cher',
    subtitle: 'Propriété intellectuelle — Droits d\'auteur & contrats créatifs',
    emoji: '',
    color: const Color(0xFF9C27B0),
    fichesRef: ['Fiche 3'],
    toolName: 'Canva',
    toolUrl: 'https://www.canva.com',
    scenario: CrisisScenario(
      legalReference: 'CPI art. L111-1 — Droits d\'auteur automatiques. Contrefaçon : jusqu\'à 150 000 € par œuvre.',
      context: '''
Votre site a été conçu il y a 6 mois. Pour aller vite, 
votre chargé de communication a utilisé des images trouvées sur Google, 
copié des textes de sites concurrents, et utilisé des photos 
d\'un photographe freelance sans clause de cession dans le contrat.
Ce matin, vous recevez TROIS mises en demeure simultanément :
une agence photo (12 images utilisées), un rédacteur web (8 textes copiés),
et le photographe freelance (28 photos produits).
      ''',
      urgencyMessage: ' ALERTE — 3 mises en demeure simultanées. Exposition totale : jusqu\'à 750 000 €',
      roleInstructions: '''
 CEO : Priorisez les réponses et arbitrez le budget de règlement
️ Dir. Juridique : Évaluez chaque mise en demeure et les risques réels
 DPO : Vérifiez si des licences ont été archivées
 Dir. Marketing : Retirez immédiatement les contenus litigieux
 Dir. E-commerce : Identifiez quelles pages sont concernées
      ''',
      acts: [
        CrisisAct(
          title: 'Acte 1 — L\'inventaire des dégâts',
          narrative: '''
Vous réunissez l\'équipe en urgence.
Votre chargé de comm avoue : "J\'ai pris des images sur Google Images, 
je pensais que c\'était libre de droits..."
Votre juriste blêmit : 12 images d\'une agence stock (Getty Images), 
8 textes copiés-collés d\'un concurrent, 
28 photos du photographe sans cession de droits.
Total maximum théorique : 48 œuvres × 15 000€ = 720 000€.
          ''',
          characterName: 'Julien Mora — Photographe freelance',
          characterEmoji: '',
          characterMessage: 'Vous utilisez mes 28 photos produits depuis 6 mois sans mon autorisation. Le paiement de la séance ne vous donne pas les droits. Je réclame 42 000€ ou je saisis le tribunal.',
          toolTask: 'Citez 3 sources d\'images libres de droits (ex : Unsplash, Pixabay, Pexels) et expliquez la différence entre licence CC0 et licence commerciale.',
          options: [
            DecisionOption(
              id: 'c3_a1_1',
              label: 'Retirer immédiatement tout le contenu litigieux du site',
              explanation: 'Action prioritaire absolue. Chaque heure d\'exposition aggrave le préjudice.',
              isCorrect: true,
              impact: DecisionImpact.positive,
              effect: IndicatorEffect(legalRisk: -20, compliance: 10),
              consequence: 'Les demandeurs constatent votre bonne foi. Les montants réclamés baissent.',
            ),
            DecisionOption(
              id: 'c3_a1_2',
              label: 'Contester toutes les mises en demeure en bloc',
              explanation: 'Contester sans avoir retiré le contenu est une stratégie perdante.',
              isCorrect: false,
              impact: DecisionImpact.negative,
              effect: IndicatorEffect(legalRisk: 25, finance: -15),
              consequence: 'Les trois parties saisissent le tribunal. Coût explosif.',
            ),
            DecisionOption(
              id: 'c3_a1_3',
              label: 'Négocier un règlement global avec les trois parties',
              explanation: 'Bonne approche mais seulement APRÈS avoir retiré le contenu.',
              isCorrect: false,
              impact: DecisionImpact.neutral,
              effect: IndicatorEffect(legalRisk: 5, finance: -5),
              consequence: 'Le contenu toujours en ligne pendant la négociation aggrave votre position.',
            ),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — La négociation',
          narrative: '''
Le contenu est retiré. Maintenant la négociation.
Le photographe réclame 42 000€.
L\'agence Getty Images réclame 18 000€.
Le rédacteur réclame 12 000€.
Votre juriste a analysé chaque dossier.
          ''',
          characterName: 'Maître Leclerc — Avocate en PI',
          characterEmoji: '‍️',
          characterMessage: 'Pour le photographe : le contrat mentionne une "session photo" sans cession. Il a raison juridiquement mais son montant est excessif. Je peux négocier à 8-12 000€ + un nouveau contrat avec cession.',
          toolTask: 'Rédigez les 4 clauses indispensables dans un contrat prestataire créatif : objet, rémunération, cession de droits patrimoniaux, durée et territoire.',
          options: [
            DecisionOption(
              id: 'c3_a2_1',
              label: 'Négocier avec chacun séparément + proposer un nouveau contrat avec cession',
              explanation: 'Approche professionnelle qui règle le présent ET protège le futur.',
              isCorrect: true,
              impact: DecisionImpact.positive,
              effect: IndicatorEffect(finance: -10, legalRisk: -30, compliance: 15),
              consequence: 'Règlement global à 22 000€ au lieu de 72 000€. Relations préservées.',
            ),
            DecisionOption(
              id: 'c3_a2_2',
              label: 'Payer les montants réclamés sans négocier pour aller vite',
              explanation: 'Coûteux inutilement. La négociation est toujours possible.',
              isCorrect: false,
              impact: DecisionImpact.neutral,
              effect: IndicatorEffect(finance: -30, legalRisk: -25),
              consequence: 'Vous payez 72 000€ quand 22 000€ aurait suffi.',
            ),
            DecisionOption(
              id: 'c3_a2_3',
              label: 'Tout nier et attendre qu\'ils prouvent le préjudice',
              explanation: 'Les captures d\'écran constituent une preuve suffisante. Stratégie perdante.',
              isCorrect: false,
              impact: DecisionImpact.critical,
              effect: IndicatorEffect(legalRisk: 35, reputation: -20, finance: -25),
              consequence: 'Procès. Condamnation à 95 000€ + couverture dans la presse pro.',
            ),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — Le registre des droits',
          narrative: '''
La crise est résolue. 22 000€ de règlement global.
Une leçon chèrement payée.
Votre investisseure demande un rapport sur les mesures prises
pour qu\'une telle situation ne se reproduise jamais.
          ''',
          characterName: 'Sophie Chen — Investisseure',
          characterEmoji: '',
          characterMessage: 'Cette crise m\'inquiète. Votre actif principal c\'est votre contenu. Si vous ne le protégez pas, votre valorisation s\'effondre. Montrez-moi votre plan.',
          toolTask: 'Décrivez le contenu d\'un registre des droits : informations à noter pour chaque contenu (source, licence, auteur, date d\'utilisation).',
          options: [
            DecisionOption(
              id: 'c3_a3_1',
              label: 'Créer un registre des droits + former l\'équipe + charte des sources autorisées',
              explanation: 'Triple protection : traçabilité, compétence, et prévention.',
              isCorrect: true,
              impact: DecisionImpact.positive,
              effect: IndicatorEffect(compliance: 25, legalRisk: -20, reputation: 15),
              consequence: 'L\'investisseure valide. Votre contenu devient un actif valorisé.',
            ),
            DecisionOption(
              id: 'c3_a3_2',
              label: 'Interdire tout contenu externe — tout créer en interne',
              explanation: 'Impossible en pratique et contre-productif.',
              isCorrect: false,
              impact: DecisionImpact.negative,
              effect: IndicatorEffect(compliance: 5, finance: -10),
              consequence: 'L\'équipe est paralysée. La productivité chute de 40%.',
            ),
            DecisionOption(
              id: 'c3_a3_3',
              label: 'Souscrire à une banque d\'images payante (Adobe Stock, Getty)',
              explanation: 'Bonne solution partielle mais insuffisante sans formation et registre.',
              isCorrect: false,
              impact: DecisionImpact.neutral,
              effect: IndicatorEffect(compliance: 10, finance: -5),
              consequence: 'Le problème des textes copiés et des contrats prestataires reste entier.',
            ),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: [
        'Payer un prestataire ne transfère PAS les droits — clause de cession obligatoire',
        'Une image "trouvée sur Google" est protégée dans 95% des cas',
        'Retirer le contenu immédiatement = preuve de bonne foi = réduction des sanctions',
        'Un registre des droits = protection juridique + actif valorisable',
        'Les licences Creative Commons ne signifient pas "libre de droits"',
      ],
      commonMistakes: [
        'Croire que le paiement d\'une prestation transfère les droits',
        'Utiliser des images Google Images sans vérifier la licence',
        'Nier les faits quand les captures d\'écran constituent une preuve',
        'Ne pas former l\'équipe aux règles de base du droit d\'auteur',
      ],
    ),
  );

  // ─── Getters pour tous les challenges ───

  // Liste mémorisée pour permettre les modifications en mémoire via l'éditeur
  static List<Challenge>? _allChallengesCache;

  static List<Challenge> get allChallenges {
    _allChallengesCache ??= [
      c1, c2, c3,
      _c4, _c5, _c6, _c7, _c8, _c9, _c10,
      _c11, _c12, _c13, _c14, _c15,
    ];
    return _allChallengesCache!;
  }

  static List<Challenge> challengesForDay(int day) =>
      allChallenges.where((c) => c.dayNumber == day).toList()
        ..sort((a, b) => a.orderInDay.compareTo(b.orderInDay));

  // ─── Challenges Jour 1 (suite) ───
  static Challenge get _c4 => Challenge(
    id: 'c4', dayNumber: 1, orderInDay: 4,
    title: 'L\'alerte CNIL',
    subtitle: 'RGPD — Plainte client & registre des traitements',
    emoji: '', color: const Color(0xFFFF6B35),
    fichesRef: ['Fiche 4'],
    toolName: 'CNIL.fr', toolUrl: 'https://www.cnil.fr',
    scenario: CrisisScenario(
      legalReference: 'RGPD art. 13-14 — Information. Art. 30 — Registre. Sanctions : 4% CA mondial ou 20M€.',
      context: 'Un client exige la suppression de toutes ses données (droit à l\'effacement). Votre équipe découvre qu\'il n\'existe aucun registre des traitements et que les données sont gardées indéfiniment.',
      urgencyMessage: ' ALERTE — Plainte CNIL déposée. Contrôle possible sous 30 jours.',
      roleInstructions: ' CEO : Arbitrez les ressources pour la mise en conformité\n️ Dir. Juridique : Évaluez l\'exposition réelle\n DPO : Créez le registre des traitements en urgence\n Dir. Marketing : Vérifiez les consentements de la newsletter\n Dir. E-commerce : Identifiez toutes les données collectées',
      acts: [
        CrisisAct(
          title: 'Acte 1 — La demande d\'effacement',
          narrative: 'M. Durand exige par email recommandé la suppression de toutes ses données. Vous avez 30 jours pour répondre. Vous découvrez que ses données sont dans 7 systèmes différents.',
          characterName: 'Antoine Durand — Client', characterEmoji: '',
          characterMessage: 'J\'exerce mon droit à l\'effacement selon le RGPD art. 17. Vous avez 30 jours. Passé ce délai, je saisis la CNIL.',
          toolTask: 'Rédigez un email de réponse à M. Durand confirmant la suppression de ses données dans tous vos systèmes, sous 30 jours (RGPD art. 17).',
          options: [
            DecisionOption(id: 'c4_1', label: 'Répondre sous 30 jours en confirmant la suppression dans tous les systèmes', explanation: 'Obligation légale RGPD art. 17.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 20, legalRisk: -25), consequence: 'M. Durand retire sa plainte. La CNIL classe le dossier.'),
            DecisionOption(id: 'c4_2', label: 'Ignorer la demande — il n\'a qu\'à relancer', explanation: 'L\'absence de réponse sous 30 jours = infraction automatique.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 30, compliance: -15), consequence: 'La CNIL ouvre une enquête. Mise en demeure officielle.'),
            DecisionOption(id: 'c4_3', label: 'Supprimer ses données sans en informer les sous-traitants', explanation: 'La suppression doit être complète dans TOUS les systèmes, y compris chez les sous-traitants.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 15, compliance: -5), consequence: 'L\'email marketing continue d\'envoyer des messages à M. Durand. Plainte aggravée.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — Le contrôle CNIL',
          narrative: 'La CNIL vous contacte suite à la plainte. Un inspecteur veut voir votre registre des traitements, votre politique de confidentialité et les preuves de consentement.',
          characterName: 'Inspectrice Blanc — CNIL', characterEmoji: '️',
          characterMessage: 'Suite à la plainte de M. Durand, nous avons besoin de votre registre des traitements, de votre politique de confidentialité et des preuves de consentement pour les 500 abonnés de votre newsletter.',
          toolTask: 'Listez les 5 informations minimales que doit contenir un registre des traitements RGPD (art. 30) pour une entreprise e-commerce.',
          options: [
            DecisionOption(id: 'c4_4', label: 'Présenter un registre complet + politique de confidentialité + preuves de consentement', explanation: 'Réponse complète et conforme.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 25, legalRisk: -30), consequence: 'La CNIL classe le dossier avec un simple rappel à la loi.'),
            DecisionOption(id: 'c4_5', label: 'Créer le registre en urgence la veille du contrôle', explanation: 'Un registre créé en catastrophe sera lacunaire et peu crédible.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 10, compliance: 5), consequence: 'L\'inspectrice détecte les incohérences. Mise en demeure de 3 mois pour corriger.'),
            DecisionOption(id: 'c4_6', label: 'Contester la légitimité du contrôle', explanation: 'La CNIL a tout pouvoir de contrôle. Contester est une faute grave.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 40, reputation: -30), consequence: 'Amende de 50 000€ pour obstruction + publication de la sanction.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — La conformité durable',
          narrative: 'La crise est passée. Votre DPO propose un plan de conformité RGPD sur 3 mois. Le budget est limité.',
          characterName: 'Emma Rousseau — DPO', characterEmoji: '',
          characterMessage: 'Nous avons évité le pire. Maintenant construisons une vraie conformité RGPD. J\'ai identifié 5 chantiers prioritaires. Votre budget pour les 3 prochains mois ?',
          toolTask: 'Citez les 5 actions prioritaires d\'un plan de conformité RGPD pour une PME e-commerce (registre, politique de confidentialité, consentements, droits, formation).',
          options: [
            DecisionOption(id: 'c4_7', label: 'Prioriser : registre + politique confid. + formulaires opt-in + procédure réponse droits + formation équipe', explanation: 'Les 5 piliers fondamentaux de la conformité RGPD.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 30, legalRisk: -25, reputation: 10), consequence: 'En 3 mois votre conformité passe de 30% à 85%. L\'investisseure valide.'),
            DecisionOption(id: 'c4_8', label: 'Embaucher un DPO externe (2000€/mois)', explanation: 'Utile mais pas prioritaire pour une PME de cette taille.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(compliance: 15, finance: -15), consequence: 'Le DPO externe fait un bon travail mais le budget pèse sur la trésorerie.'),
            DecisionOption(id: 'c4_9', label: 'Attendre la prochaine plainte pour agir', explanation: 'La conformité RGPD est une obligation continue, pas réactive.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 20, compliance: -10), consequence: 'Nouvelle plainte 2 mois plus tard. La CNIL perd patience. Amende de 15 000€.'),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: ['Le droit à l\'effacement doit être traité sous 30 jours dans TOUS les systèmes', 'Le registre des traitements est obligatoire pour toute entreprise', 'La CNIL peut contrôler à tout moment — la conformité doit être continue', 'Contester un contrôle CNIL = sanction aggravée', 'La politique de confidentialité doit être accessible depuis toutes les pages'],
      commonMistakes: ['Ignorer une demande d\'effacement', 'Créer le registre en catastrophe juste avant un contrôle', 'Ne pas supprimer les données chez les sous-traitants', 'Contester la légitimité d\'un contrôle CNIL'],
    ),
  );

  static Challenge get _c5 => Challenge(
    id: 'c5', dayNumber: 1, orderInDay: 5,
    title: 'La bannière du chaos',
    subtitle: 'Cookies — Conformité CNIL & gestion du consentement',
    emoji: '', color: const Color(0xFF00FF88),
    fichesRef: ['Fiche 5'],
    toolName: 'Cookiebot (audit gratuit)', toolUrl: 'https://www.cookiebot.com',
    scenario: CrisisScenario(
      legalReference: 'Directive ePrivacy + RGPD — Cookies non essentiels : consentement obligatoire. CNIL : 150M€ à Google, 60M€ à Facebook.',
      context: 'Un audit révèle que votre site dépose 23 cookies dès l\'arrivée des visiteurs, sans consentement. Google Analytics, pixel Facebook, chat Intercom, carte Google Maps — tout se déclenche automatiquement. La CNIL a lancé une campagne de contrôle des PME.',
      urgencyMessage: ' ALERTE — 23 cookies déposés sans consentement. Contrôle CNIL en cours dans votre secteur.',
      roleInstructions: ' CEO : Arbitrez entre performance marketing et conformité\n️ Dir. Juridique : Évaluez l\'exposition\n DPO : Auditez tous les cookies présents\n Dir. Marketing : Évaluez l\'impact sur les données Analytics\n Dir. E-commerce : Identifiez les cookies essentiels vs non essentiels',
      acts: [
        CrisisAct(
          title: 'Acte 1 — L\'audit des cookies',
          narrative: 'L\'outil Cookiebot révèle 23 cookies actifs. Seulement 3 sont essentiels. Les 20 autres (Google Analytics, Pixel Facebook, Hotjar, Intercom, Google Maps) se déclenchent avant tout consentement.',
          characterName: 'Lucas Martin — Dev Frontend', characterEmoji: '',
          characterMessage: 'J\'ai intégré Google Analytics et le pixel Facebook comme demandé par le marketing. Je ne savais pas que ça déposait des cookies sans consentement. Qu\'est-ce qu\'on fait ?',
          toolTask: 'Classez les cookies suivants : cookie de session, Google Analytics, pixel Facebook, panier d\'achat. Lesquels nécessitent un consentement ?',
          options: [
            DecisionOption(id: 'c5_1', label: 'Bloquer tous les cookies non essentiels en attendant une CMP conforme', explanation: 'Action d\'urgence correcte. On perd temporairement les données Analytics.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 15, legalRisk: -20, reputation: 5), consequence: 'Perte de données Analytics pendant 2 semaines mais conformité immédiate.'),
            DecisionOption(id: 'c5_2', label: 'Ajouter une bannière "En continuant, vous acceptez les cookies"', explanation: 'Explicitement interdit par la CNIL — la navigation ne vaut pas consentement.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 30, compliance: -20), consequence: 'La CNIL détecte le dark pattern. Mise en demeure immédiate.'),
            DecisionOption(id: 'c5_3', label: 'Mettre une bannière avec uniquement le bouton "Accepter"', explanation: 'Un bouton "Refuser" aussi visible est obligatoire.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 20, compliance: -10), consequence: 'Dark pattern détecté. Amende de 30 000€.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — La CMP conforme',
          narrative: 'Vous devez choisir une solution de gestion du consentement (CMP). Votre DPO présente trois options.',
          characterName: 'Emma Rousseau — DPO', characterEmoji: '',
          characterMessage: 'Pour être conforme, notre bannière doit permettre d\'accepter ET de refuser aussi facilement, sans cases pré-cochées, avec archivage des consentements. J\'ai évalué trois solutions.',
          toolTask: 'Décrivez les 3 règles d\'une bannière de cookies conforme CNIL : bouton refuser visible, pas de case pré-cochée, archivage des consentements.',
          options: [
            DecisionOption(id: 'c5_4', label: 'Axeptio plan gratuit — bannière conforme + archivage basique', explanation: 'Solution française, conforme CNIL, plan gratuit suffisant pour débuter.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 25, legalRisk: -25), consequence: 'Bannière conforme en 2h. Taux d\'acceptation réel : 62%. Données fiables.'),
            DecisionOption(id: 'c5_5', label: 'Coder une bannière maison pour économiser', explanation: 'Risqué sans expertise légale. Les exigences CNIL sont très précises.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 15, finance: -5), consequence: 'La bannière maison a 3 dark patterns. Retravail nécessaire.'),
            DecisionOption(id: 'c5_6', label: 'Désactiver Google Analytics pour simplifier', explanation: 'Perte d\'un outil essentiel. Une CMP est plus intelligente.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(compliance: 10, legalRisk: -10), consequence: 'Conformité améliorée mais perte de données marketing essentielles.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — L\'audit régulier',
          narrative: 'La CMP est en place. Taux d\'acceptation des cookies : 62%. Mais un nouveau plugin de chat vient d\'être installé sans validation.',
          characterName: 'Emma Rousseau — DPO', characterEmoji: '',
          characterMessage: 'Le service client a installé un chatbot sans me prévenir. Il dépose 4 nouveaux cookies. On doit mettre en place un process d\'approbation pour tout nouveau tool.',
          toolTask: 'Rédigez une procédure d\'approbation des nouveaux outils marketing : qui valide, quelles informations sur les cookies, quelle mise à jour de la politique de confidentialité.',
          options: [
            DecisionOption(id: 'c5_7', label: 'Créer un process de validation DPO avant tout nouveau tool + audit trimestriel', explanation: 'Process solide qui empêche les dérives futures.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 20, legalRisk: -20, reputation: 10), consequence: 'Zéro nouveau cookie non déclaré pendant 18 mois. La CNIL valide votre conformité.'),
            DecisionOption(id: 'c5_8', label: 'Interdire tous les nouveaux outils marketing', explanation: 'Trop restrictif. Paralyse l\'équipe marketing.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(compliance: 10, finance: -10), consequence: 'L\'équipe marketing contourne le process. Les problèmes reviennent.'),
            DecisionOption(id: 'c5_9', label: 'Faire confiance à l\'équipe pour gérer seule', explanation: 'Sans process, les erreurs se répètent.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 15, compliance: -10), consequence: '6 mois plus tard : 8 nouveaux cookies non déclarés détectés.'),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: ['Seuls les cookies essentiels peuvent être déposés sans consentement', 'La navigation ne vaut pas consentement — dark patterns sanctionnés', 'Refuser doit être aussi simple qu\'accepter — boutons égaux obligatoires', 'Une CMP archive les consentements — preuve en cas de contrôle', 'Audit régulier des cookies : les plugins tiers en ajoutent à votre insu'],
      commonMistakes: ['Bannière "continuer = accepter"', 'Bouton refuser caché ou absent', 'Cases pré-cochées', 'Oublier les cookies des plugins tiers', 'Ne pas auditer régulièrement'],
    ),
  );

  // ─── Challenges Jour 2 ───
  static Challenge get _c6 => Challenge(
    id: 'c6', dayNumber: 2, orderInDay: 1,
    title: 'Le spam qui détruit',
    subtitle: 'E-mailing — Opt-in, consentement & prospection légale',
    emoji: '', color: const Color(0xFFFF4D6D),
    fichesRef: ['Fiche 6'],
    toolName: 'Brevo', toolUrl: 'https://www.brevo.com',
    scenario: CrisisScenario(
      legalReference: 'Art. L34-5 CPCE — Opt-in obligatoire B2C. Amende : jusqu\'à 750€ par message envoyé.',
      context: 'Votre responsable marketing a acheté une liste de 50 000 emails B2C et envoyé une newsletter promotionnelle. En 48h : 2300 plaintes pour spam, votre domaine est blacklisté par Gmail et Outlook, et vous recevez une mise en demeure de la CNIL.',
      urgencyMessage: ' ALERTE — Domaine email blacklisté + 2300 plaintes spam + mise en demeure CNIL',
      roleInstructions: ' CEO : Gérez la crise publiquement\n️ Dir. Juridique : Évaluez l\'exposition financière (750€ × 50 000)\n DPO : Répondez à la CNIL sous 72h\n Dir. Marketing : Arrêtez tous les envois + plan de déblacklisting\n Dir. E-commerce : Informez les vrais clients de l\'incident',
      acts: [
        CrisisAct(
          title: 'Acte 1 — L\'ampleur du désastre',
          narrative: '50 000 emails envoyés sans opt-in. 2300 signalements spam en 48h. Gmail classe votre domaine comme spam. Vos vrais clients ne reçoivent plus vos emails de confirmation de commande.',
          characterName: 'Karim Benali — Responsable Marketing', characterEmoji: '',
          characterMessage: 'J\'ai acheté la liste pour 800€ sur un site spécialisé. Le vendeur disait que c\'était "opt-in double". Mais depuis l\'envoi c\'est catastrophique. Je ne savais pas...',
          toolTask: 'Rédigez le message d\'urgence à envoyer à votre équipe pour stopper les envois et supprimer la liste achetée. Mentionnez la raison légale (art. L34-5 CPCE).',
          options: [
            DecisionOption(id: 'c6_1', label: 'Arrêter immédiatement tous les envois + supprimer la liste achetée', explanation: 'Action prioritaire absolue. Chaque envoi supplémentaire aggrave l\'exposition.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(legalRisk: -20, compliance: 10), consequence: 'L\'hémorragie s\'arrête. 2300 plaintes au lieu de 15 000 potentielles.'),
            DecisionOption(id: 'c6_2', label: 'Continuer les envois en ajoutant un lien désinscription', explanation: 'Trop tard — l\'envoi sans consentement est déjà illégal.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 35, compliance: -20), consequence: '15 000 plaintes. La CNIL ouvre une procédure formelle.'),
            DecisionOption(id: 'c6_3', label: 'Blâmer le vendeur de liste et lui transférer la responsabilité', explanation: 'Vous êtes responsable de l\'envoi, pas le vendeur.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 20, reputation: -15), consequence: 'La CNIL confirme : vous êtes responsable. Le vendeur n\'est pas poursuivi.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — Le déblacklisting',
          narrative: 'Votre domaine est blacklisté. Vos clients ne reçoivent plus leurs confirmations de commande. Chaque heure coûte des ventes.',
          characterName: 'Nadia Petit — Deliverability Expert', characterEmoji: '',
          characterMessage: 'Pour déblacklister votre domaine vous devez : 1) Contacter Gmail Postmaster Tools, 2) Soumettre une demande de réhabilitation, 3) Prouver que vous avez supprimé la liste achetée et mis en place un process opt-in conforme.',
          toolTask: 'Expliquez en 3 points pourquoi configurer SPF, DKIM et DMARC est essentiel pour la délivrabilité et la protection contre le phishing.',
          options: [
            DecisionOption(id: 'c6_4', label: 'Configurer SPF/DKIM/DMARC + soumettre demande réhabilitation Gmail + prouver la conformité', explanation: 'Process technique et juridique complet pour le déblacklisting.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 20, reputation: 15, legalRisk: -15), consequence: 'Déblacklisting en 5 jours. Taux de délivrabilité restauré à 94%.'),
            DecisionOption(id: 'c6_5', label: 'Changer de nom de domaine pour repartir de zéro', explanation: 'Solution radicale qui détruit l\'historique SEO et la notoriété du domaine.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(reputation: -20, finance: -15), consequence: 'Perte de 3 ans de SEO. Vos clients ne retrouvent plus votre site.'),
            DecisionOption(id: 'c6_6', label: 'Utiliser un domaine secondaire pour les emails pendant la crise', explanation: 'Solution temporaire acceptable mais qui ne règle pas le problème principal.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(legalRisk: 5), consequence: 'Les commandes reprennent mais le domaine principal reste blacklisté 3 mois.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — La liste saine',
          narrative: 'Le domaine est déblaclisté. La CNIL vous demande de prouver que vous avez mis en place un process conforme pour l\'avenir.',
          characterName: 'Inspectrice Blanc — CNIL', characterEmoji: '️',
          characterMessage: 'Nous prenons acte de vos actions correctives. Pour classer définitivement ce dossier, montrez-nous votre nouveau process de collecte de consentements.',
          toolTask: 'Rédigez un email de reconfirmation d\'abonnement à envoyer à vos anciens contacts : objet, contenu, bouton opt-in, et ce qui se passe en cas d\'absence de réponse.',
          options: [
            DecisionOption(id: 'c6_7', label: 'Double opt-in pour tous les nouveaux abonnés + campagne de reconfirmation des anciens', explanation: 'Reconstruction d\'une liste 100% saine et défendable devant la CNIL.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 30, legalRisk: -30, reputation: 15), consequence: 'Liste réduite à 8000 contacts mais 100% opt-in. Taux d\'ouverture : 42%.'),
            DecisionOption(id: 'c6_8', label: 'Garder les anciens contacts sans reconfirmation', explanation: 'Sans preuve de consentement, ces contacts restent un risque.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 15, compliance: -10), consequence: 'Nouvelle plainte 4 mois plus tard sur les anciens contacts.'),
            DecisionOption(id: 'c6_9', label: 'Arrêter l\'emailing définitivement', explanation: 'Décision disproportionnée. L\'emailing est légal avec les bonnes pratiques.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(finance: -15), consequence: 'Perte d\'un canal marketing avec ROI de 4200%. Décision sous-optimale.'),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: ['Liste achetée = illégale pour B2C sans preuve d\'opt-in', 'L\'expéditeur est responsable, pas le vendeur de liste', '750€ par message × 50 000 = exposition théorique de 37,5M€', 'Le double opt-in est la meilleure protection juridique', 'SPF/DKIM/DMARC = les bases techniques de la délivrabilité'],
      commonMistakes: ['Acheter des listes email', 'Continuer les envois après les premiers signalements', 'Croire que le vendeur de liste est responsable', 'Changer de domaine au lieu de réparer'],
    ),
  );

  static Challenge get _c7 => Challenge(
    id: 'c7', dayNumber: 2, orderInDay: 2,
    title: 'L\'influenceur qui dérape',
    subtitle: 'Marketing d\'influence — Transparence & loi influenceurs 2023',
    emoji: '', color: const Color(0xFF9C27B0),
    fichesRef: ['Fiche 12'],
    toolName: 'Meta Business Suite', toolUrl: 'https://business.facebook.com',
    scenario: CrisisScenario(
      legalReference: 'Loi du 9 juin 2023 — Influenceurs : mention #Partenariat obligatoire. Amende : 300 000€ + 2 ans prison.',
      context: 'Un micro-influenceur (85 000 abonnés) que vous avez payé 800€ a publié une vidéo TikTok vantant votre produit sans mentionner le partenariat commercial. La vidéo cumule 2,3M vues. Un journaliste du Parisien vous contacte.',
      urgencyMessage: ' ALERTE — 2,3M vues sans #Partenariat + journaliste en investigation + DGCCRF alertée',
      roleInstructions: ' CEO : Décidez la stratégie de communication de crise\n️ Dir. Juridique : Évaluez la responsabilité partagée\n DPO : Vérifiez les données collectées via la campagne\n Dir. Marketing : Gérez l\'influenceur et la comm de crise\n Dir. E-commerce : Évaluez l\'impact sur les ventes',
      acts: [
        CrisisAct(
          title: 'Acte 1 — La vidéo virale',
          narrative: 'La vidéo TikTok de @TechMaxParis cumule 2,3M vues. Dans les commentaires : "C\'est une pub non déclarée !", "Balec les influenceurs corrompus !". Le journaliste du Parisien vous demande une réaction.',
          characterName: 'Hugo Lefort — Journaliste Le Parisien', characterEmoji: '',
          characterMessage: 'Je prépare un article sur les pratiques de marketing d\'influence non déclarées. Votre marque est citée. Avez-vous un commentaire ? Saviez-vous que la vidéo n\'avait pas la mention #Partenariat ?',
          toolTask: 'Identifiez les éléments à mentionner dans votre réponse publique : reconnaissance du partenariat, mention #Partenariat, et engagement pour les prochaines campagnes.',
          options: [
            DecisionOption(id: 'c7_1', label: 'Reconnaître le partenariat + demander à l\'influenceur d\'ajouter #Partenariat immédiatement', explanation: 'Transparence immédiate = meilleure protection légale et de réputation.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(reputation: 10, legalRisk: -20, compliance: 15), consequence: 'Le journaliste valorise la réactivité. Article nuancé. La DGCCRF classe.'),
            DecisionOption(id: 'c7_2', label: 'Nier tout partenariat commercial', explanation: 'Le virement bancaire de 800€ est une preuve. Le mensonge aggrave tout.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 40, reputation: -35), consequence: 'Le journaliste publie le relevé bancaire. Crise majeure. DGCCRF enquête.'),
            DecisionOption(id: 'c7_3', label: 'Demander à l\'influenceur de supprimer la vidéo', explanation: 'Supprimer une vidéo virale aggrave la crise et constitue une tentative de dissimulation.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(reputation: -20, legalRisk: 15), consequence: 'La suppression est détectée. "Ils cachent quelque chose" — trending Twitter.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — Le contrat influenceur',
          narrative: 'Votre juriste examine le contrat signé avec l\'influenceur. Il ne mentionne aucune obligation de transparence.',
          characterName: 'Maître Leclerc — Avocate', characterEmoji: '‍️',
          characterMessage: 'La loi du 9 juin 2023 est claire : la marque ET l\'influenceur sont co-responsables. Votre contrat ne prévoit pas la mention #Partenariat. Vous êtes exposés tous les deux.',
          toolTask: 'Rédigez les 4 clauses obligatoires d\'un contrat influenceur conforme à la loi du 9 juin 2023 (mention #Partenariat, interdictions, contrôle, conformité).',
          options: [
            DecisionOption(id: 'c7_4', label: 'Ajouter une clause de conformité légale dans tous les futurs contrats influenceurs', explanation: 'La marque est co-responsable — le contrat doit l\'imposer à l\'influenceur.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 25, legalRisk: -20), consequence: 'Votre prochaine campagne est exemplaire. La DGCCRF vous cite en exemple.'),
            DecisionOption(id: 'c7_5', label: 'Arrêter tout marketing d\'influence', explanation: 'Décision disproportionnée. Le marketing d\'influence est légal avec les bonnes pratiques.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(finance: -10, reputation: -5), consequence: 'Vous perdez un canal avec 11x ROI. Vos concurrents en profitent.'),
            DecisionOption(id: 'c7_6', label: 'Faire signer une décharge à l\'influenceur pour vous protéger', explanation: 'Une décharge ne transfère pas la co-responsabilité légale de la marque.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 10, compliance: -5), consequence: 'La décharge est inopposable. La marque reste co-responsable.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — La campagne conforme',
          narrative: 'La crise est gérée. Vous voulez relancer une campagne d\'influence conforme avec 5 micro-influenceurs.',
          characterName: 'Karim Benali — Dir. Marketing', characterEmoji: '',
          characterMessage: 'On a appris la leçon. Pour la prochaine campagne, j\'ai identifié 5 micro-influenceurs avec des audiences engagées. Comment on s\'assure que tout est conforme cette fois ?',
          toolTask: 'Décrivez le process complet d\'une campagne d\'influence conforme : brief, contrat, validation avant publication, suivi des mentions obligatoires.',
          options: [
            DecisionOption(id: 'c7_7', label: 'Brief + contrat conforme + validation contenu avant publication + monitoring mentions', explanation: 'Process complet pour une campagne 100% conforme.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 20, reputation: 20, finance: 10), consequence: 'Campagne exemplaire. 4,2M vues. Aucune plainte. +340% de trafic.'),
            DecisionOption(id: 'c7_8', label: 'Laisser les influenceurs libres pour plus d\'authenticité', explanation: 'L\'authenticité et la conformité légale ne sont pas incompatibles.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 20, compliance: -15), consequence: 'Deux influenceurs font des allégations mensongères. Nouvelle crise.'),
            DecisionOption(id: 'c7_9', label: 'Utiliser uniquement des créateurs certifiés par une agence', explanation: 'Utile mais la certification d\'agence ne dispense pas du contrat conforme.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(finance: -5, compliance: 5), consequence: 'Les certifications agence ne couvrent pas la conformité loi 2023.'),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: ['La marque est co-responsable du contenu publié par l\'influenceur', '#Partenariat ou #Publicité obligatoire — loi du 9 juin 2023', 'Supprimer une vidéo virale aggrave toujours la crise', 'Le contrat influenceur doit imposer la conformité légale', 'Reconnaître rapidement = protection juridique ET de réputation'],
      commonMistakes: ['Nier le partenariat quand des preuves existent', 'Supprimer le contenu en catastrophe', 'Contrat sans clause de conformité légale', 'Croire que la marque n\'est pas responsable des actes de l\'influenceur'],
    ),
  );

  static Challenge get _c8 => Challenge(
    id: 'c8', dayNumber: 2, orderInDay: 3,
    title: 'Le bouton maudit',
    subtitle: 'CGV & vente à distance — Processus de commande légal',
    emoji: '', color: const Color(0xFFFFB800),
    fichesRef: ['Fiche 9', 'Fiche 10', 'Fiche 13'],
    toolName: 'Google Analytics 4', toolUrl: 'https://analytics.google.com',
    scenario: CrisisScenario(
      legalReference: 'Art. L221-14 Code conso — Bouton "Commander avec obligation de payer" obligatoire. Nullité du contrat sinon.',
      context: 'La DGCCRF contrôle votre site. Elle constate : votre bouton final dit "Valider", pas de récapitulatif avant paiement, les frais de livraison n\'apparaissent qu\'après le paiement, et les CGV ne sont pas accessibles pendant le tunnel d\'achat. 100% de vos contrats sont potentiellement nuls.',
      urgencyMessage: ' ALERTE — Contrôle DGCCRF en cours. 100% des contrats potentiellement nuls. Remboursements massifs possibles.',
      roleInstructions: ' CEO : Évaluez l\'impact financier d\'une nullité de contrat en masse\n️ Dir. Juridique : Analysez chaque non-conformité\n DPO : Vérifiez les CGV et leur accessibilité\n Dir. Marketing : Préparez la communication si remboursements\n Dir. E-commerce : Corrigez le tunnel d\'achat en urgence',
      acts: [
        CrisisAct(
          title: 'Acte 1 — L\'audit du tunnel',
          narrative: 'L\'inspectrice de la DGCCRF passe commande sur votre site en direct. Elle note : bouton "Valider" au lieu de "Commander et payer", frais de port révélés après le paiement, cases CGV non cochées, récapitulatif absent.',
          characterName: 'Inspectrice Morin — DGCCRF', characterEmoji: '️',
          characterMessage: 'J\'ai passé une commande test. Votre bouton dit "Valider" — illégal. Les frais de livraison n\'étaient pas affichés avant le paiement. Vos CGV ne sont pas accessibles pendant le tunnel. Ce sont 4 infractions distinctes.',
          toolTask: 'Listez les 6 étapes légales obligatoires du tunnel d\'achat (bouton libellé exact, prix TTC, frais livraison, récapitulatif, CGV, confirmation email).',
          options: [
            DecisionOption(id: 'c8_1', label: 'Suspendre temporairement le tunnel d\'achat + corriger toutes les infractions', explanation: 'Mieux vaut perdre 48h de ventes que d\'aggraver l\'exposition.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 20, legalRisk: -25, finance: -5), consequence: 'La DGCCRF apprécie la réactivité. Simple mise en demeure sans amende.'),
            DecisionOption(id: 'c8_2', label: 'Continuer les ventes et corriger progressivement', explanation: 'Chaque nouvelle vente avec un tunnel illégal aggrave l\'exposition.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 25, compliance: -15), consequence: '347 nouvelles commandes illégales pendant la correction. Amende 45 000€.'),
            DecisionOption(id: 'c8_3', label: 'Contester les conclusions de l\'inspectrice', explanation: 'La loi est claire sur le libellé du bouton final.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 35, reputation: -20), consequence: 'La contestation échoue. Procédure aggravée.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — La refonte légale',
          narrative: 'Tunnel suspendu. 48h pour corriger. Votre dev et votre juriste travaillent ensemble.',
          characterName: 'Lucas Martin — Dev + Maître Leclerc — Avocate', characterEmoji: '',
          characterMessage: 'Voici la checklist complète : 1) Bouton = "Commander avec obligation de payer" 2) Prix TTC + frais livraison affichés AVANT le bouton 3) Récapitulatif complet 4) Case CGV à cocher 5) Email de confirmation immédiat 6) Archivage pendant 10 ans si > 120€',
          toolTask: 'Rédigez le libellé exact du bouton final obligatoire selon l\'art. L221-14 Code conso et listez les informations à afficher avant ce bouton.',
          options: [
            DecisionOption(id: 'c8_4', label: 'Corriger les 6 points + faire valider par un avocat + test utilisateur', explanation: 'Correction complète avec validation juridique et UX.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 30, legalRisk: -30, reputation: 10), consequence: 'Tunnel relancé. Taux de conversion +8% (les clients font plus confiance).'),
            DecisionOption(id: 'c8_5', label: 'Changer uniquement le bouton et relancer', explanation: 'Correction partielle — les autres infractions persistent.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(compliance: 5, legalRisk: -5), consequence: 'La DGCCRF détecte les infractions restantes lors du contrôle de suivi.'),
            DecisionOption(id: 'c8_6', label: 'Copier le tunnel de commande d\'un grand site concurrent', explanation: 'Les grands sites ont des équipes juridiques dédiées — mais copier sans adapter est risqué.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(compliance: 10, legalRisk: -5), consequence: 'Le tunnel copié ne correspond pas à votre activité. CGV inadaptées.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — Les CGV vivantes',
          narrative: 'Le tunnel est conforme. La DGCCRF valide. Mais votre avocate signale que vos CGV contiennent 3 clauses abusives que la DGCCRF peut faire annuler.',
          characterName: 'Maître Leclerc — Avocate', characterEmoji: '‍️',
          characterMessage: 'Vos CGV excluent tout remboursement pour défaut — abusif. Elles imposent un délai de rétractation de 7 jours au lieu de 14 — illégal. Et elles désignent un tribunal à l\'étranger — inapplicable au consommateur français.',
          toolTask: 'Identifiez les 3 clauses abusives présentes dans les CGV fictives et proposez la formulation conforme pour chacune (délai rétractation, remboursement, juridiction).',
          options: [
            DecisionOption(id: 'c8_7', label: 'Faire rédiger des CGV par un avocat spécialisé e-commerce', explanation: 'Investissement unique (500-1500€) qui protège durablement.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 25, legalRisk: -25, reputation: 10), consequence: 'CGV irréprochables. La DGCCRF les cite en exemple lors d\'une conférence.'),
            DecisionOption(id: 'c8_8', label: 'Corriger les 3 clauses identifiées seulement', explanation: 'Peut suffire à court terme mais d\'autres clauses abusives peuvent exister.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(compliance: 10, legalRisk: -10), consequence: '2 autres clauses abusives détectées 6 mois plus tard.'),
            DecisionOption(id: 'c8_9', label: 'Utiliser un générateur de CGV gratuit en ligne', explanation: 'Insuffisant — les CGV génériques ne couvrent pas votre activité spécifique.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(compliance: 5, legalRisk: 5), consequence: 'Les CGV génériques créent une fausse sécurité. 5 nouvelles clauses abusives.'),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: ['Le bouton final doit dire exactement "Commander avec obligation de payer"', 'Prix TTC + frais livraison obligatoires AVANT le paiement', 'Une clause abusive est réputée non écrite mais votre responsabilité reste engagée', 'Le double clic (récapitulatif + validation) est obligatoire', 'Archivage des contrats > 120€ pendant 10 ans'],
      commonMistakes: ['Bouton "Valider", "Confirmer", "Continuer" au lieu du libellé légal', 'Frais de livraison révélés après le paiement', 'CGV copiées d\'un concurrent sans adaptation', 'Délai de rétractation de 7 jours au lieu de 14'],
    ),
  );

  static Challenge get _c9 => Challenge(
    id: 'c9', dayNumber: 2, orderInDay: 4,
    title: '14 jours de cauchemar',
    subtitle: 'Droit de rétractation — Gestion légale des retours',
    emoji: '↩️', color: const Color(0xFF00D4FF),
    fichesRef: ['Fiche 11'],
    toolName: 'HubSpot CRM gratuit', toolUrl: 'https://www.hubspot.com/products/crm',
    scenario: CrisisScenario(
      legalReference: 'Art. L221-18 Code conso — 14 jours de rétractation. Remboursement sous 14 jours dès la demande.',
      context: 'Suite à une promotion virale, vous avez 450 commandes en 48h. 89 clients exercent leur droit de rétractation. Votre équipe gère ça à la main, les remboursements sont en retard, 12 clients ont saisi le médiateur, et 3 ont déposé une plainte DGCCRF.',
      urgencyMessage: ' ALERTE — 89 rétractations en retard + 12 médiations en cours + 3 plaintes DGCCRF',
      roleInstructions: ' CEO : Priorisez les ressources humaines pour gérer la crise\n️ Dir. Juridique : Évaluez chaque dossier de médiation\n DPO : Vérifiez le traitement des données des retours\n Dir. Marketing : Communiquez positivement sur votre politique de retour\n Dir. E-commerce : Mettez en place un process de retour automatisé',
      acts: [
        CrisisAct(
          title: 'Acte 1 — L\'hémorragie des retours',
          narrative: '89 demandes de rétractation. 14 jours pour rembourser à partir de la demande (pas de la réception du produit retourné). Votre équipe est débordée. 23 délais dépassés.',
          characterName: 'Claire Dupont — Cliente', characterEmoji: '',
          characterMessage: 'J\'ai demandé ma rétractation il y a 17 jours. Vous n\'avez toujours pas remboursé. La loi dit 14 jours. Je saisis la DGCCRF et le médiateur.',
          toolTask: 'Expliquez la règle du délai de rétractation : à partir de quand court-il et quel est le délai maximum de remboursement selon l\'art. L221-18 ?',
          options: [
            DecisionOption(id: 'c9_1', label: 'Traiter en urgence les 23 cas dépassés + automatiser le process de remboursement', explanation: 'Priorité absolue aux cas en retard + prévention pour les suivants.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(legalRisk: -25, reputation: 10, compliance: 15), consequence: '23 remboursements effectués. La DGCCRF classe 2 des 3 plaintes.'),
            DecisionOption(id: 'c9_2', label: 'Attendre de recevoir les produits retournés pour rembourser', explanation: 'ILLÉGAL — le délai court dès la demande de rétractation, pas la réception.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 30, compliance: -20), consequence: '89 infractions caractérisées. Amende DGCCRF de 25 000€.'),
            DecisionOption(id: 'c9_3', label: 'Proposer un avoir au lieu d\'un remboursement pour économiser', explanation: 'L\'avoir ne peut être proposé qu\'en accord avec le client. Le remboursement est le droit par défaut.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 20, reputation: -15), consequence: '67 clients refusent l\'avoir et exigent le remboursement légal. Situation aggravée.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — Les exceptions légales',
          narrative: 'Parmi les 89 rétractations, 12 portent sur des produits pour lesquels le droit de rétractation ne s\'applique pas : 8 produits sur mesure, 4 logiciels déscellés.',
          characterName: 'Maître Leclerc — Avocate', characterEmoji: '‍️',
          characterMessage: 'Pour les 12 cas d\'exception, vous pouvez légalement refuser la rétractation. Mais attention : votre site ne mentionne nulle part ces exceptions. En l\'absence d\'information préalable, vous pourriez quand même devoir rembourser.',
          toolTask: 'Listez les 5 catégories de produits pour lesquelles le droit de rétractation ne s\'applique pas (exemples : produits sur mesure, logiciels déscellés, etc.).',
          options: [
            DecisionOption(id: 'c9_4', label: 'Rembourser les 12 cas "par exception" + ajouter les exceptions dans les CGV et fiches produits', explanation: 'Bon sens commercial et correction juridique préventive.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 20, reputation: 15, legalRisk: -15), consequence: 'Les 12 clients satisfaits deviennent des ambassadeurs. Les CGV sont désormais complètes.'),
            DecisionOption(id: 'c9_5', label: 'Refuser les 12 rétractations en invoquant les exceptions', explanation: 'Juridiquement possible MAIS votre site n\'informait pas les clients. Risque de litige.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(reputation: -20, legalRisk: 10), consequence: '9 des 12 clients saisissent le médiateur. Vous perdez 7 des 9 dossiers.'),
            DecisionOption(id: 'c9_6', label: 'Ignorer les exceptions et tout rembourser', explanation: 'Trop généreux financièrement mais crée un précédent problématique.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(finance: -5, reputation: 5), consequence: 'Vous remboursez 12 ventes légitimes. Perte financière non nécessaire.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — Le process automatisé',
          narrative: 'La crise est résolue. Votre directeur e-commerce propose d\'automatiser le process de rétractation pour ne plus jamais être en retard.',
          characterName: 'Amira Zouari — Dir. E-commerce', characterEmoji: '',
          characterMessage: 'J\'ai analysé le process. On peut automatiser 80% des rétractations : email auto à J+0, remboursement déclenché à J+1, relance auto à J+7, alerte manager si pas de retour à J+10. Coût : 0€ avec HubSpot gratuit.',
          toolTask: 'Décrivez les 4 étapes d\'un process de rétractation automatisé : accusé réception (J+0), traitement remboursement, relance J+7, alerte manager J+10.',
          options: [
            DecisionOption(id: 'c9_7', label: 'Automatiser le process + formulaire de rétractation sur le site + informer les clients du délai', explanation: 'Triple protection : automatisation, conformité légale, transparence.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 25, reputation: 20, legalRisk: -20), consequence: 'Délai moyen de remboursement : 3,2 jours. Note Trustpilot : 4,8/5.'),
            DecisionOption(id: 'c9_8', label: 'Recruter un agent dédié aux retours', explanation: 'Coûteux et inefficace face à des pics de volume. L\'automatisation est plus robuste.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(finance: -10, compliance: 10), consequence: 'L\'agent gère le volume normal mais est débordé lors des promotions.'),
            DecisionOption(id: 'c9_9', label: 'Limiter les promotions pour réduire les volumes de retour', explanation: 'Contre-productif. La gestion des retours doit être industrialisée, pas les ventes limitées.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(finance: -15), consequence: 'CA réduit de 23%. Les retours restent proportionnels aux ventes.'),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: ['14 jours de rétractation — délai dès la demande, pas la réception du retour', 'Remboursement sous 14 jours après la demande — pas de retard possible', 'L\'avoir ne remplace pas le remboursement sans accord du client', 'Les exceptions doivent être clairement mentionnées en amont', 'L\'automatisation est la meilleure protection contre les retards'],
      commonMistakes: ['Attendre la réception du produit pour rembourser', 'Proposer un avoir par défaut', 'Ne pas mentionner les exceptions au droit de rétractation', 'Gérer les retours manuellement sans process'],
    ),
  );

  static Challenge get _c10 => Challenge(
    id: 'c10', dayNumber: 2, orderInDay: 5,
    title: 'L\'image volée',
    subtitle: 'Droit à l\'image — Autorisations & vie privée',
    emoji: '', color: const Color(0xFF00FF88),
    fichesRef: ['Fiche 15'],
    toolName: 'Canva', toolUrl: 'https://www.canva.com',
    scenario: CrisisScenario(
      legalReference: 'Art. 9 Code civil — Droit à l\'image. Autorisation écrite obligatoire. Dommages : dizaines de milliers d\'euros.',
      context: 'Votre photographe a pris des photos de l\'équipe pour le site "À propos". Un salarié, depuis licencié dans de mauvais termes, reconnaît sa photo sur la page d\'accueil et vous envoie une mise en demeure. En parallèle, une campagne pub utilise des photos d\'événements clients sans autorisation.',
      urgencyMessage: ' ALERTE — Mise en demeure ex-salarié + 34 photos clients sans autorisation',
      roleInstructions: ' CEO : Gérez la relation avec l\'ex-salarié\n️ Dir. Juridique : Évaluez les deux dossiers\n DPO : Vérifiez les autorisations archivées\n Dir. Marketing : Retirez les photos litigieuses\n Dir. E-commerce : Auditez toutes les photos du site',
      acts: [
        CrisisAct(
          title: 'Acte 1 — La photo de trop',
          narrative: 'Pierre Lecomte, ex-salarié, identifie sa photo sur votre page d\'accueil. Il réclame 15 000€ et le retrait immédiat. Sa photo apparaît aussi dans 3 posts LinkedIn et une publicité Google Ads.',
          characterName: 'Pierre Lecomte — Ex-salarié', characterEmoji: '',
          characterMessage: 'Ma photo est sur votre site, vos réseaux et vos pubs sans mon autorisation. Je n\'ai jamais signé de cession de droits à l\'image. Je réclame le retrait immédiat et 15 000€ de dommages.',
          toolTask: 'Rédigez un formulaire d\'autorisation d\'image pour les salariés : nom, prénom, date, supports autorisés (site web, réseaux sociaux, presse), durée, signature.',
          options: [
            DecisionOption(id: 'c10_1', label: 'Retirer toutes les photos de Pierre immédiatement + négocier un règlement amiable', explanation: 'Action rapide + bonne foi = réduction du préjudice.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(legalRisk: -25, reputation: 5, finance: -5), consequence: 'Accord amiable à 3 000€. Pierre retire sa plainte.'),
            DecisionOption(id: 'c10_2', label: 'Invoquer le contrat de travail qui autorisait les photos', explanation: 'Le contrat de travail seul ne suffit pas — une autorisation expresse est requise.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 20, finance: -10), consequence: 'Le tribunal confirme : contrat de travail ≠ cession de droit à l\'image. 12 000€ accordés.'),
            DecisionOption(id: 'c10_3', label: 'Flouter le visage de Pierre sur toutes les photos et continuer', explanation: 'Bonne action technique mais insuffisante sans réponse juridique.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(legalRisk: -10, compliance: 5), consequence: 'Pierre accepte pour le site mais maintient la plainte pour les pubs déjà diffusées.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — Les photos clients',
          narrative: 'Votre équipe marketing a utilisé des photos d\'événements clients pour une campagne pub. 34 personnes sont identifiables. Aucune autorisation n\'a été recueillie.',
          characterName: 'Karim Benali — Dir. Marketing', characterEmoji: '',
          characterMessage: 'J\'ai trouvé ces photos sur notre Google Photos d\'entreprise. Elles venaient d\'événements clients. Je pensais que comme ils étaient venus à nos événements, ça valait autorisation...',
          toolTask: 'Rédigez le texte du panneau d\'information à afficher à l\'entrée d\'un événement professionnel concernant les prises de photos.',
          options: [
            DecisionOption(id: 'c10_4', label: 'Retirer toutes les 34 photos + contacter les personnes pour autorisation rétroactive', explanation: 'La présence à un événement ne vaut pas autorisation de diffusion commerciale.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 20, legalRisk: -20, reputation: 10), consequence: '28 personnes donnent leur accord rétroactif. 6 refusent — leurs photos sont définitivement supprimées.'),
            DecisionOption(id: 'c10_5', label: 'Continuer — les personnes sont dans un lieu public et y ont consenti', explanation: 'Faux — un événement privé ou professionnel ≠ lieu public. La règle du lieu public est complexe.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 30, compliance: -15), consequence: '8 personnes portent plainte. Procédure collective. 45 000€ de dommages.'),
            DecisionOption(id: 'c10_6', label: 'Flouter tous les visages et garder les photos', explanation: 'Solution rapide et acceptable pour la campagne actuelle.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(legalRisk: -15, compliance: 5), consequence: 'La campagne continue sans risque légal mais perd en impact émotionnel.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — Le process photo conforme',
          narrative: 'Les deux crises sont gérées. Votre DPO propose un process complet pour que cela ne se reproduise plus jamais.',
          characterName: 'Emma Rousseau — DPO', characterEmoji: '',
          characterMessage: 'Je propose trois outils : 1) Autorisation photo dans les contrats salariés, 2) Panneau + formulaire à chaque événement, 3) Registre des droits à l\'image archivé avec les photos.',
          toolTask: 'Décrivez le process complet de protection du droit à l\'image pour les événements : panneau info, formulaire consentement, registre photographique.',
          options: [
            DecisionOption(id: 'c10_7', label: 'Mettre en place les 3 outils + former l\'équipe marketing sur le droit à l\'image', explanation: 'Process complet qui couvre salariés, clients et événements.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 25, legalRisk: -25, reputation: 15), consequence: 'Zéro incident photo pendant 3 ans. Le process est repris par 2 partenaires.'),
            DecisionOption(id: 'c10_8', label: 'Arrêter de prendre des photos aux événements', explanation: 'Décision disproportionnée qui pénalise le marketing.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(finance: -5, reputation: -5), consequence: 'Vos événements ne génèrent plus de contenu. Présence digitale en chute.'),
            DecisionOption(id: 'c10_9', label: 'N\'utiliser que des photos de stock pour le marketing', explanation: 'Acceptable pour certains usages mais les témoignages réels convertissent mieux.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(compliance: 10), consequence: 'Conformité améliorée mais authenticité réduite. Taux de conversion -12%.'),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: ['Le contrat de travail ne vaut pas cession de droit à l\'image', 'La présence à un événement ne vaut pas consentement à la diffusion commerciale', 'Autorisation écrite obligatoire : supports, durée, contexte', 'Retrait immédiat + négociation amiable = réduction du préjudice', 'Panneau + formulaire à chaque événement = protection systématique'],
      commonMistakes: ['Croire que le contrat de travail couvre le droit à l\'image', 'Assimiler présence à un événement et consentement', 'Ne pas archiver les autorisations', 'Continuer d\'utiliser des images après une mise en demeure'],
    ),
  );

  // ─── Challenges Jour 3 ───
  static Challenge get _c11 => Challenge(
    id: 'c11', dayNumber: 3, orderInDay: 1,
    title: 'Le commentaire qui tue',
    subtitle: 'Responsabilité hébergeur — Contenus illicites & modération',
    emoji: '', color: const Color(0xFFFF4D6D),
    fichesRef: ['Fiche 8', 'Fiche 16'],
    toolName: 'Google Alerts', toolUrl: 'https://alerts.google.com',
    scenario: CrisisScenario(
      legalReference: 'LCEN art. 6 + DSA — Hébergeur : retrait rapide après signalement. Éditeur = responsabilité pleine.',
      context: 'Votre forum communautaire contient un commentaire anonyme accusant faussement un concurrent de fraude fiscale. Ce même concurrent vous envoie une mise en demeure. Simultanément, un utilisateur a posté des contenus racistes que vous n\'avez pas modérés depuis 72h.',
      urgencyMessage: ' ALERTE — Mise en demeure concurrent + contenus racistes non modérés depuis 72h',
      roleInstructions: ' CEO : Gérez la crise publiquement et légalement\n️ Dir. Juridique : Qualifiez les infractions et évaluez les risques\n DPO : Vérifiez les données de l\'auteur des commentaires\n Dir. Marketing : Communiquez sur votre politique de modération\n Dir. E-commerce : Mettez en place le système de signalement',
      acts: [
        CrisisAct(
          title: 'Acte 1 — La qualification',
          narrative: 'Deux contenus problématiques : une accusation de fraude fiscale (potentiellement diffamatoire) et des commentaires racistes (contenus haineux illicites). Votre forum ne moderait pas a priori.',
          characterName: 'Maître Dubois — Avocat du concurrent', characterEmoji: '️',
          characterMessage: 'Mon client a été accusé de fraude fiscale sur votre forum. C\'est diffamatoire. Votre responsabilité en tant qu\'hébergeur engage si vous ne retirez pas ce contenu dans les 24h.',
          toolTask: 'Expliquez la différence entre le statut d\'hébergeur (responsabilité limitée) et celui d\'éditeur (responsabilité totale) selon la LCEN art. 6.',
          options: [
            DecisionOption(id: 'c11_1', label: 'Retirer les deux contenus immédiatement + activer un système de signalement', explanation: 'Action prioritaire : retrait rapide = responsabilité hébergeur préservée.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(legalRisk: -30, compliance: 20), consequence: 'Votre statut d\'hébergeur est préservé. Le concurrent retire sa mise en demeure.'),
            DecisionOption(id: 'c11_2', label: 'Ne rien faire — vous n\'avez pas écrit ces commentaires', explanation: 'L\'inaction après signalement fait basculer de l\'hébergeur à l\'éditeur.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 40, compliance: -25), consequence: 'Vous perdez le statut d\'hébergeur. Condamnation comme éditeur. 30 000€.'),
            DecisionOption(id: 'c11_3', label: 'Modérer tous les futurs commentaires avant publication', explanation: 'La modération a priori vous fait passer du statut d\'hébergeur à éditeur — responsabilité totale.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 15, compliance: -10), consequence: 'Vous êtes maintenant éditeur de chaque commentaire. Responsabilité démultipliée.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — La procédure de signalement',
          narrative: 'Les contenus sont retirés. Mais votre juriste constate que votre forum n\'a aucun bouton de signalement — ce qui est illégal selon le DSA.',
          characterName: 'Emma Rousseau — DPO', characterEmoji: '',
          characterMessage: 'Le DSA impose à toutes les plateformes permettant du contenu utilisateur d\'avoir un mécanisme de signalement accessible. Le nôtre est absent. C\'est une infraction supplémentaire.',
          toolTask: 'Rédigez les règles de modération à afficher dans les CGU du forum : types de contenus interdits, délai de traitement des signalements, sanctions.',
          options: [
            DecisionOption(id: 'c11_4', label: 'Ajouter un bouton "Signaler" sur chaque commentaire + traitement sous 24h', explanation: 'Obligation DSA respectée avec process de traitement efficace.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 25, legalRisk: -20, reputation: 10), consequence: 'DSA compliance validée. Votre communauté se modère en partie elle-même.'),
            DecisionOption(id: 'c11_5', label: 'Fermer le forum pour éviter les risques', explanation: 'Décision disproportionnée qui sacrifie un canal de communauté précieux.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(finance: -10, reputation: -15), consequence: 'Votre communauté migre vers un forum concurrent. Perte de 2 300 membres.'),
            DecisionOption(id: 'c11_6', label: 'Ajouter uniquement un email de signalement sans bouton dédié', explanation: 'L\'email seul ne satisfait pas aux exigences d\'accessibilité du DSA.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(compliance: 5, legalRisk: 5), consequence: 'Le DSA exige un mécanisme accessible directement sur le contenu.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — La politique UGC',
          narrative: 'Forum sécurisé. Votre DPO propose des CGU complètes qui encadrent les contenus utilisateurs et vous protègent.',
          characterName: 'Emma Rousseau — DPO', characterEmoji: '',
          characterMessage: 'Nos CGU actuelles ne prévoient pas de licence sur les contenus utilisateurs, pas d\'interdictions explicites, pas de procédure de signalement documentée. On repart sur une base saine ?',
          toolTask: 'Listez les 5 éléments essentiels d\'une CGU de forum conforme : contenus interdits, procédure de signalement, délais, sanctions progressives, licence UGC.',
          options: [
            DecisionOption(id: 'c11_7', label: 'CGU complètes + charte de modération publiée + process documenté', explanation: 'Triple protection : règles claires, transparence, traçabilité.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 30, legalRisk: -25, reputation: 15), consequence: 'Forum exemplaire. Le DSA vous cite dans ses bonnes pratiques PME.'),
            DecisionOption(id: 'c11_8', label: 'Interdire tout contenu négatif dans les CGU', explanation: 'Une interdiction du contenu négatif légitime est elle-même illégale.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 15, reputation: -20), consequence: 'La clause est réputée abusive. Les avis négatifs restent protégés.'),
            DecisionOption(id: 'c11_9', label: 'Copier les CGU de Reddit ou Facebook', explanation: 'Les CGU des grandes plateformes ne sont pas adaptées aux PME.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(compliance: 5, legalRisk: 10), consequence: 'Les CGU copiées contiennent des clauses inapplicables en droit français.'),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: ['Hébergeur = retrait rapide après signalement = responsabilité limitée', 'Modération a priori = statut d\'éditeur = responsabilité totale', 'DSA oblige un bouton de signalement accessible sur chaque contenu', 'CGU complètes = protection juridique + transparence communauté', 'Inaction après signalement = basculement hébergeur  éditeur'],
      commonMistakes: ['Ne pas agir après signalement', 'Modérer a priori sans mesurer l\'impact sur le statut', 'Absence de bouton de signalement', 'CGU copiées sans adaptation'],
    ),
  );

  static Challenge get _c12 => Challenge(
    id: 'c12', dayNumber: 3, orderInDay: 2,
    title: 'Les faux avis',
    subtitle: 'Avis clients — Authenticité, directive Omnibus & e-réputation',
    emoji: '', color: const Color(0xFFFFB800),
    fichesRef: ['Fiche 17'],
    toolName: 'Trustpilot gratuit', toolUrl: 'https://www.trustpilot.com',
    scenario: CrisisScenario(
      legalReference: 'Directive Omnibus 2022 — Avis vérifiés obligatoires. Faux avis : 300 000€ + 2 ans prison.',
      context: 'Un journaliste publie une enquête : votre agence de communication a acheté 150 faux avis 5 étoiles sur Google et Trustpilot. Simultanément, un concurrent organise une campagne de faux avis négatifs contre vous. Et une cliente menacée par votre community manager pour avoir posté un avis négatif légitime menace de saisir la justice.',
      urgencyMessage: ' ALERTE — Enquête journalistique faux avis + campagne avis négatifs concurrent + cliente menacée',
      roleInstructions: ' CEO : Gérez la crise médiatique\n️ Dir. Juridique : Évaluez les 3 dossiers simultanés\n DPO : Vérifiez les données liées aux avis\n Dir. Marketing : Répondez publiquement à l\'enquête\n Dir. E-commerce : Auditez tous les avis existants',
      acts: [
        CrisisAct(
          title: 'Acte 1 — La confession nécessaire',
          narrative: 'L\'enquête est publiée. 150 faux avis achetés pour 2 400€ à une agence spécialisée. Le journaliste a les factures. Cacher est impossible.',
          characterName: 'Lucas Bernard — Journaliste Tech', characterEmoji: '',
          characterMessage: 'J\'ai les factures. 150 faux avis, 2400€ à l\'agence StarBoost. C\'est une infraction pénale depuis la directive Omnibus 2022. Votre réaction avant publication dans 2 heures ?',
          toolTask: 'Rédigez le communiqué de presse de NUMÉRIX reconnaissant les faux avis et s\'engageant à mettre en place un système d\'avis vérifiés.',
          options: [
            DecisionOption(id: 'c12_1', label: 'Reconnaître l\'erreur + supprimer les faux avis + s\'engager publiquement sur la transparence', explanation: 'La transparence immédiate limite les dégâts. Les factures rendent le déni impossible.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(reputation: -5, legalRisk: -20, compliance: 15), consequence: 'Couverture nuancée. La communauté apprécie la transparence. Amende réduite.'),
            DecisionOption(id: 'c12_2', label: 'Nier et accuser l\'agence d\'avoir agi sans votre accord', explanation: 'Les factures prouvent votre commandement. Le déni est impossible et aggravant.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 40, reputation: -40), consequence: 'Le parjure est ajouté aux charges. 180 000€ d\'amende. Couverture nationale.'),
            DecisionOption(id: 'c12_3', label: 'Ne pas répondre au journaliste', explanation: 'Le silence est interprété comme une confirmation. L\'article sera plus sévère.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(reputation: -25, legalRisk: 15), consequence: 'L\'article titre "Société refuse de répondre". Maximum de dégâts.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — La riposte aux faux avis négatifs',
          narrative: 'En parallèle, votre concurrent a organisé une campagne de 80 faux avis 1 étoile. Votre note Google est passée de 4,6 à 3,1 en 3 jours.',
          characterName: 'Maître Leclerc — Avocate', characterEmoji: '‍️',
          characterMessage: 'J\'ai analysé les 80 avis négatifs : même style d\'écriture, mêmes fautes, tous postés depuis des comptes créés cette semaine. C\'est une campagne coordonnée. On peut les attaquer pour concurrence déloyale.',
          toolTask: 'Décrivez comment constituer un dossier de preuve pour des faux avis : captures d\'écran horodatées, similarités stylistiques, timing coordonné des publications.',
          options: [
            DecisionOption(id: 'c12_4', label: 'Signaler à Google + constituer le dossier pour concurrence déloyale + répondre publiquement', explanation: 'Triple action : suppression technique, recours juridique, communication.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(reputation: 15, legalRisk: -15, compliance: 10), consequence: 'Google supprime 71 des 80 avis. Action en concurrence déloyale lancée. Note remontée à 4,3.'),
            DecisionOption(id: 'c12_5', label: 'Acheter des faux avis positifs pour compenser', explanation: 'Aggraver une infraction existante par une nouvelle infraction.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 35, reputation: -30), consequence: 'Détecté par Trustpilot. Double infraction. 250 000€ d\'amende.'),
            DecisionOption(id: 'c12_6', label: 'Menacer les auteurs des avis de poursuites', explanation: 'Les avis négatifs légitimes sont protégés. Ne menacer que les faux avis prouvés.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(reputation: -20, legalRisk: 20), consequence: 'Vous menacez 3 vrais clients par erreur. Crise amplifiée.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — La politique avis conforme',
          narrative: 'La cliente menacée par votre community manager réclame des excuses et une compensation. Votre juriste examine la situation.',
          characterName: 'Marie Fontaine — Cliente', characterEmoji: '',
          characterMessage: 'Votre community manager m\'a envoyé un DM : "Supprimez cet avis ou on vous attaque en justice". C\'est une menace. Mon avis était vrai — mon colis est arrivé cassé. Je vais rendre cette conversation publique.',
          toolTask: 'Rédigez la politique de réponse aux avis de NUMÉRIX : protocole de réponse, interdictions absolues (menaces), modèle de réponse professionnelle à un avis négatif.',
          options: [
            DecisionOption(id: 'c12_7', label: 'S\'excuser auprès de Marie + sanctionner le community manager + publier la politique de réponse aux avis', explanation: 'Réponse complète : humaine, managériale et transparente.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(reputation: 20, legalRisk: -25, compliance: 15), consequence: 'Marie met à jour son avis à 4 étoiles. La politique publiée rassure les clients.'),
            DecisionOption(id: 'c12_8', label: 'Nier que votre équipe a envoyé ce message', explanation: 'Les captures d\'écran constituent une preuve irréfutable.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 30, reputation: -35), consequence: 'Marie publie les captures. Trending sur Twitter. -23% de ventes en 2 semaines.'),
            DecisionOption(id: 'c12_9', label: 'Proposer un bon de réduction à Marie pour qu\'elle supprime l\'avis', explanation: 'Un avis supprimé en échange d\'une compensation est une pratique déloyale.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 15, compliance: -10), consequence: 'Marie refuse et publie l\'offre. "Ils achètent le silence de leurs clients."'),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: ['Faux avis achetés : 300 000€ + 2 ans prison — directive Omnibus 2022', 'Transparence immédiate > déni quand les preuves existent', 'Menacer l\'auteur d\'un avis négatif légitime = infraction', 'Signaler les faux avis à Google = procédure officielle documentée', 'Répondre professionnellement à tous les avis = meilleure stratégie'],
      commonMistakes: ['Acheter des faux avis positifs', 'Nier quand les preuves existent', 'Menacer les clients pour faire supprimer des avis', 'Proposer une compensation pour suppression d\'avis'],
    ),
  );

  static Challenge get _c13 => Challenge(
    id: 'c13', dayNumber: 3, orderInDay: 3,
    title: 'L\'attaque concurrente',
    subtitle: 'Droit pénal — Dénigrement, diffamation & concurrence déloyale',
    emoji: '️', color: const Color(0xFF9C27B0),
    fichesRef: ['Fiche 18'],
    toolName: 'Google Alerts + X (Twitter)', toolUrl: 'https://alerts.google.com',
    scenario: CrisisScenario(
      legalReference: 'Art. 1240 Code civil — Concurrence déloyale. Art. 29 loi 1881 — Diffamation publique : 45 000€ amende.',
      context: 'Un article anonyme sur un blog spécialisé affirme que vos produits sont "fabriqués en conditions indignes" avec des fournisseurs non éthiques. L\'article contient des "preuves" fabriquées. Il est partagé 4 200 fois en 24h. Votre investigation révèle que l\'article vient d\'un concurrent direct.',
      urgencyMessage: ' ALERTE — Article diffamatoire viral (4 200 partages) + preuves de commanditaire concurrent',
      roleInstructions: ' CEO : Gérez la communication de crise\n️ Dir. Juridique : Préparez l\'action en justice\n DPO : Identifiez les éléments probatoires\n Dir. Marketing : Contre-narrative et contenu de réponse\n Dir. E-commerce : Évaluez l\'impact sur les ventes',
      acts: [
        CrisisAct(
          title: 'Acte 1 — La réponse immédiate',
          narrative: 'L\'article accuse vos fournisseurs d\'être non éthiques. Vous avez tous les certificats éthiques. La presse professionnelle relaie l\'article. Vos clients annulent des commandes.',
          characterName: 'Antoine Moreau — Client B2B', characterEmoji: '',
          characterMessage: 'J\'ai vu l\'article sur vos fournisseurs. Notre politique RSE nous interdit de travailler avec des marques impliquées dans ce type de pratique. Je mets notre contrat en suspens.',
          toolTask: 'Rédigez le communiqué de réponse publique de NUMÉRIX : publiez les certifications éthiques, démontez les fausses affirmations, et engagez-vous sur la transparence.',
          options: [
            DecisionOption(id: 'c13_1', label: 'Publier immédiatement les certifications éthiques + communiqué de presse de démenti + contact direct avec les clients', explanation: 'Action tri-frontale : preuve, communication publique, relation client.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(reputation: 15, legalRisk: -15, finance: 5), consequence: 'Antoine maintient le contrat après réception des certifications. Article contré en 6h.'),
            DecisionOption(id: 'c13_2', label: 'Attaquer immédiatement le blog en justice sans communiquer', explanation: 'L\'action juridique prend du temps. La communication de crise ne peut pas attendre.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: -10, reputation: -20, finance: -15), consequence: 'Pendant les 3 mois de procédure, les ventes chutent de 35%.'),
            DecisionOption(id: 'c13_3', label: 'Dénigrer le concurrent sur vos propres réseaux sociaux', explanation: 'Répondre au dénigrement par le dénigrement vous expose à votre tour.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 30, reputation: -25), consequence: 'Vous êtes attaqué en dénigrement à votre tour. Double procédure.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — La constitution du dossier',
          narrative: 'Votre juriste a remonté jusqu\'au concurrent. Preuves : IP du serveur du blog, virements à l\'auteur, ancien salarié du concurrent qui témoigne.',
          characterName: 'Maître Dupuis — Avocat', characterEmoji: '‍️',
          characterMessage: 'Nous avons trois types de preuves : techniques (IP), financières (virements) et testimoniales (ex-salarié). On peut attaquer pour diffamation ET concurrence déloyale. Stratégie ?',
          toolTask: 'Listez les 3 types de preuves à rassembler pour une action en diffamation + concurrence déloyale : techniques, financières et testimoniales.',
          options: [
            DecisionOption(id: 'c13_4', label: 'Action combinée : diffamation + concurrence déloyale + demande en référé pour suppression immédiate', explanation: 'Attaque sur tous les fronts avec urgence pour le retrait.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(legalRisk: -25, reputation: 15, finance: 10), consequence: 'Référé accordé en 48h. Article supprimé. Concurrent condamné à 85 000€.'),
            DecisionOption(id: 'c13_5', label: 'Négocier directement avec le concurrent pour un accord amiable', explanation: 'Possible mais envoie un signal de faiblesse et n\'empêche pas la récidive.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(legalRisk: -10, reputation: -5, finance: -5), consequence: 'Accord à 15 000€. L\'article est supprimé mais le concurrent recommence 1 an plus tard.'),
            DecisionOption(id: 'c13_6', label: 'Attendre le délai de prescription de 3 mois pour rassembler plus de preuves', explanation: 'La diffamation se prescrit en 3 mois — attendre c\'est perdre le droit d\'agir.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 20, reputation: -15), consequence: 'Prescription atteinte. Vous ne pouvez plus agir pour diffamation.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — La veille permanente',
          narrative: 'Le concurrent est condamné. Mais comment éviter d\'être pris par surprise la prochaine fois ?',
          characterName: 'Sophie Chen — Investisseure', characterEmoji: '',
          characterMessage: 'Cette attaque vous a coûté 3 semaines de crise et 35% de ventes. Si vous aviez détecté l\'article dans les 2 premières heures au lieu de 24h, l\'impact aurait été 80% moindre. Qu\'est-ce que vous mettez en place ?',
          toolTask: 'Décrivez un système de veille d\'e-réputation efficace : mots-clés à surveiller, fréquence des alertes, procédure de réponse en cas de crise détectée.',
          options: [
            DecisionOption(id: 'c13_7', label: 'Système de veille automatisé (Google Alerts + Mention) + plan de crise documenté + cellule de crise prête', explanation: 'Triple dispositif : détection précoce, plan préparé, équipe prête.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 15, reputation: 20, legalRisk: -20), consequence: 'La prochaine attaque est détectée en 47 minutes. Neutralisée en 3h.'),
            DecisionOption(id: 'c13_8', label: 'Surveiller manuellement les réseaux chaque matin', explanation: 'Insuffisant — 24h de délai c\'est déjà trop tard pour une crise virale.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(reputation: 5), consequence: 'La prochaine crise est détectée après 18h. Impact modéré.'),
            DecisionOption(id: 'c13_9', label: 'Engager une agence RP pour gérer la réputation', explanation: 'Utile mais coûteux. La veille automatisée est une base indispensable et gratuite.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(reputation: 10, finance: -10), consequence: 'L\'agence est efficace mais facture 2 500€/mois. ROI à calculer.'),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: ['Diffamation publique : prescription 3 mois — agir VITE', 'Répondre au dénigrement par le dénigrement = double exposition', 'Action en référé = suppression rapide en 48h', 'Veille en temps réel = détection en heures, pas en jours', 'Dossier de preuves documenté = action judiciaire possible'],
      commonMistakes: ['Répondre au dénigrement par le dénigrement', 'Attendre la prescription de 3 mois', 'Ne pas communiquer pendant la procédure judiciaire', 'Absence de veille automatisée'],
    ),
  );

  static Challenge get _c14 => Challenge(
    id: 'c14', dayNumber: 3, orderInDay: 4,
    title: 'L\'audit de la DGCCRF',
    subtitle: 'Sanctions & recours — Contrôle, médiation & droits des consommateurs',
    emoji: '️', color: const Color(0xFF00D4FF),
    fichesRef: ['Fiche 14'],
    toolName: 'Economie.gouv.fr', toolUrl: 'https://www.economie.gouv.fr/dgccrf',
    scenario: CrisisScenario(
      legalReference: 'DGCCRF — Pouvoirs d\'enquête et de sanction. Médiation consommation obligatoire dans les CGV.',
      context: 'Contrôle surprise de la DGCCRF. Deux inspecteurs passent 4 heures sur votre site et vos process. Ils identifient 7 infractions, dont l\'absence de médiateur dans vos CGV, des prix barrés fictifs et des délais de livraison trompeurs. Simultanément, 3 clients ont saisi le médiateur que vous n\'avez jamais désigné.',
      urgencyMessage: ' ALERTE — Contrôle DGCCRF en cours (7 infractions) + 3 médiations sans médiateur désigné',
      roleInstructions: ' CEO : Coopérez pleinement avec les inspecteurs\n️ Dir. Juridique : Accompagnez les inspecteurs et documentez\n DPO : Préparez les documents demandés\n Dir. Marketing : Vérifiez les prix barrés et délais affichés\n Dir. E-commerce : Corrigez les infractions identifiées',
      acts: [
        CrisisAct(
          title: 'Acte 1 — Le contrôle',
          narrative: 'Deux inspecteurs de la DGCCRF se présentent à votre bureau avec une lettre de mission. Ils demandent l\'accès à votre site, votre back-office, vos emails clients et vos contrats.',
          characterName: 'Inspecteur Martin — DGCCRF', characterEmoji: '️',
          characterMessage: 'Nous avons reçu 4 signalements clients sur votre site. Notre contrôle porte sur : prix barrés, délais de livraison, droit de rétractation, médiateur. Nous avons besoin de votre coopération totale.',
          toolTask: 'Listez les 7 infractions identifiées par la DGCCRF et priorisez-les par niveau de risque (amende potentielle). Quelle est la plus urgente à corriger ?',
          options: [
            DecisionOption(id: 'c14_1', label: 'Coopérer totalement + mettre à disposition tous les documents demandés + prendre des notes', explanation: 'La coopération totale est à la fois légalement requise et stratégiquement judicieuse.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(legalRisk: -20, compliance: 15), consequence: 'Les inspecteurs notent votre transparence. Procès-verbal avec recommandations, pas d\'amende.'),
            DecisionOption(id: 'c14_2', label: 'Demander à votre avocat de filtrer toutes les communications', explanation: 'Votre avocat peut vous accompagner mais pas bloquer l\'accès à la DGCCRF.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 20, compliance: -10), consequence: 'Les inspecteurs interprètent les obstacles comme une dissimulation. Procédure aggravée.'),
            DecisionOption(id: 'c14_3', label: 'Demander un délai pour "préparer les documents"', explanation: 'La DGCCRF peut saisir les documents sans préavis. Le délai demandé est suspect.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 15, compliance: -5), consequence: 'Refus du délai. Suspicion de dissimulation. Contrôle étendu au stock physique.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — Les 7 infractions',
          narrative: 'Après 4h de contrôle, les inspecteurs listent 7 infractions. Vous avez 30 jours pour corriger et prouver la mise en conformité.',
          characterName: 'Inspecteur Martin — DGCCRF', characterEmoji: '️',
          characterMessage: 'Voici nos 7 constats : 1) Pas de médiateur dans les CGV 2) Prix barrés non basés sur le prix le plus bas des 30 derniers jours 3) Délais de livraison affichés "2-3 jours" mais réels 8-12 jours 4) Formulaire de rétractation absent 5) Garanties légales non mentionnées 6) Frais retour non précisés 7) Identité du médiateur absent',
          toolTask: 'Rédigez un plan d\'action pour corriger les 7 infractions DGCCRF : pour chaque point, action à mener, responsable, délai de correction.',
          options: [
            DecisionOption(id: 'c14_4', label: 'Corriger les 7 infractions en 30 jours avec plan de mise en conformité documenté', explanation: 'Réponse complète dans les délais impartis.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 35, legalRisk: -35, reputation: 10), consequence: 'La DGCCRF valide la mise en conformité. Aucune amende. Certificat de conformité.'),
            DecisionOption(id: 'c14_5', label: 'Corriger uniquement les infractions les plus graves', explanation: 'La mise en demeure porte sur les 7 infractions. Correction partielle = infraction persistante.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(compliance: 15, legalRisk: -10), consequence: 'Contrôle de suivi. Les 3 infractions restantes = amende de 15 000€.'),
            DecisionOption(id: 'c14_6', label: 'Contester les constats — certaines infractions vous semblent contestables', explanation: 'Contestation possible mais risquée sans arguments solides.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(legalRisk: 5), consequence: '2 contestations acceptées, 5 confirmées. Délai global rallongé de 30 jours.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — La médiation',
          narrative: 'Les 3 clients qui avaient saisi "le médiateur" sont dans l\'impasse car vous n\'en avez pas désigné. Ils menacent maintenant le tribunal.',
          characterName: 'Maître Leclerc — Avocate', characterEmoji: '‍️',
          characterMessage: 'L\'absence de médiateur est une infraction mais aussi un vrai problème pratique. Ces 3 clients ont des demandes légitimes. Désigner un médiateur maintenant et les contacter directement peut régler les 3 dossiers sans tribunal.',
          toolTask: 'Rédigez l\'email d\'information à envoyer aux 3 clients en attente : présentation du médiateur, délai de traitement, et proposition de règlement amiable direct.',
          options: [
            DecisionOption(id: 'c14_7', label: 'Désigner un médiateur + contacter les 3 clients + proposer règlement amiable direct', explanation: 'Conformité légale + résolution directe des litiges = double bénéfice.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 20, legalRisk: -25, reputation: 15), consequence: '2 des 3 litiges résolus en médiation. 1 accord direct. Tribunal évité.'),
            DecisionOption(id: 'c14_8', label: 'Laisser les clients saisir le tribunal — vos chances sont bonnes', explanation: 'Le tribunal est plus coûteux (temps + argent) et plus risqué que la médiation.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(legalRisk: 20, finance: -15, reputation: -10), consequence: 'Tribunal : 2 condamnations sur 3. 8 500€ de dommages + frais de justice.'),
            DecisionOption(id: 'c14_9', label: 'Proposer un remboursement immédiat à tous sans médiation', explanation: 'Coûteux inutilement si les demandes ne portent pas sur un remboursement.', isCorrect: false, impact: DecisionImpact.neutral, effect: const IndicatorEffect(finance: -10, legalRisk: -10), consequence: 'Un client accepte. Deux refusent car leur demande n\'est pas financière.'),
          ],
        ),
      ],
      debriefTitle: ' Ce que vous venez d\'apprendre',
      keyLessons: ['Médiateur de la consommation obligatoire dans les CGV', 'Prix barrés = prix le plus bas des 30 derniers jours (directive Omnibus)', 'Coopérer avec la DGCCRF = meilleure stratégie', 'Médiation = 80% moins coûteuse que le tribunal', 'Délais de livraison trompeurs = infraction caractérisée'],
      commonMistakes: ['Tenter d\'entraver un contrôle DGCCRF', 'Omettre le médiateur dans les CGV', 'Prix barrés fictifs', 'Délais de livraison irréalistes'],
    ),
  );

  static Challenge get _c15 => Challenge(
    id: 'c15', dayNumber: 3, orderInDay: 5,
    title: 'Conforme ou coulée ?',
    subtitle: 'Synthèse finale — Audit global & plan de conformité',
    emoji: '', color: const Color(0xFF00FF88),
    fichesRef: ['Fiche 20 — Synthèse'],
    toolName: 'Tous les outils', toolUrl: 'https://www.cnil.fr',
    scenario: CrisisScenario(
      legalReference: 'Synthèse complète — 20 fiches — Audit juridique annuel recommandé.',
      context: '''
Votre entreprise a traversé 14 crises en 3 jours. Vous avez appris, corrigé, progressé.
Aujourd\'hui, un fonds d\'investissement de 5M€ envisage de rentrer à votre capital.
Son cabinet d\'audit juridique passe votre site au crible.
C\'est l\'heure de vérité : votre entreprise est-elle vraiment conforme ?
Tout ce que vous avez mis en place pendant ces 3 jours va être testé.
      ''',
      urgencyMessage: ' OPPORTUNITÉ — Due diligence juridique pour levée de fonds 5M€. Tout se joue maintenant.',
      roleInstructions: '''
 CEO : Présentez la vision et le bilan de conformité
️ Dir. Juridique : Défendez chaque point de l\'audit
 DPO : Présentez le registre RGPD et les process
 Dir. Marketing : Montrez la conformité des campagnes
 Dir. E-commerce : Défendez le tunnel d\'achat et les CGV
      ''',
      acts: [
        CrisisAct(
          title: 'Acte 1 — L\'audit des 20 points',
          narrative: '''
Le cabinet Juridica Partners arrive avec une checklist de 20 points.
Chaque point correspond à une des 20 fiches du cours.
Votre équipe doit défendre chaque aspect.
Ce n\'est pas un quiz — c\'est une simulation de vraie due diligence.
          ''',
          characterName: 'Léa Santos — Senior Associate Juridica', characterEmoji: '',
          characterMessage: 'Nous allons passer en revue 20 points de conformité. Pour chacun, montrez-moi vos documents, vos process et vos décisions. La levée de fonds dépend de votre score.',
          toolTask: 'Créez une checklist de conformité sur 20 points couvrant les thèmes du parcours : mentions légales, RGPD, cookies, CGV, droits clients, avis, etc.',
          options: [
            DecisionOption(id: 'c15_1', label: 'Présenter un bilan honnête : points conformes documentés + points en cours + plan correctif chiffré', explanation: 'Un auditeur préfère l\'honnêteté à la perfection fictive.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(reputation: 20, compliance: 15, legalRisk: -20), consequence: '17/20 points validés. La levée est conditionnée à 3 corrections sous 60 jours.'),
            DecisionOption(id: 'c15_2', label: 'Prétendre que tout est parfaitement conforme', explanation: 'Un audit identifie immédiatement les failles. Le mensonge détruit la confiance.', isCorrect: false, impact: DecisionImpact.critical, effect: const IndicatorEffect(legalRisk: 30, reputation: -30), consequence: 'L\'auditeur identifie 6 incohérences. La levée est abandonnée.'),
            DecisionOption(id: 'c15_3', label: 'Refuser la due diligence pour protéger les informations confidentielles', explanation: 'Refuser une due diligence standard = refuser la levée de fonds.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(finance: -20, reputation: -10), consequence: 'Le fonds se retire. Votre réputation dans l\'écosystème est ternie.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 2 — Les 3 failles restantes',
          narrative: '''
17 points validés. 3 failles identifiées par l\'auditeur :
1) Le registre RGPD n\'est pas mis à jour depuis 6 semaines
2) Les CGV ne mentionnent pas le médiateur sectoriel compétent
3) La politique cookies n\'a pas été mise à jour après l\'ajout d\'un nouveau CRM

Le fonds accorde 60 jours pour corriger.
          ''',
          characterName: 'Léa Santos — Senior Associate', characterEmoji: '',
          characterMessage: '17/20, c\'est bien. Les 3 points restants sont simples à corriger. Montrez-moi votre plan d\'action en 15 minutes.',
          toolTask: 'Rédigez un plan d\'action sur 60 jours pour corriger les 3 failles identifiées : responsable, action précise, document de preuve à produire.',
          options: [
            DecisionOption(id: 'c15_4', label: 'Plan d\'action détaillé avec responsables, dates et KPIs de conformité', explanation: 'Un plan structuré rassure l\'investisseur sur votre maturité opérationnelle.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 20, reputation: 15, finance: 20), consequence: 'L\'investisseur signe. 5M€ levés. Valorisation 18M€.'),
            DecisionOption(id: 'c15_5', label: 'Promettre de corriger sans plan précis', explanation: 'Les promesses vagues ne rassurent pas un investisseur sérieux.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(reputation: -10, finance: -5), consequence: 'L\'investisseur demande un plan détaillé sous 48h ou se retire.'),
            DecisionOption(id: 'c15_6', label: 'Négocier pour réduire le nombre de corrections requises', explanation: 'Négocier sur des obligations légales montre un rapport problématique au droit.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(reputation: -15, legalRisk: 10), consequence: 'L\'investisseur interprète la négociation comme une immaturité juridique. Offre réduite à 2M€.'),
          ],
        ),
        CrisisAct(
          title: 'Acte 3 — Le bilan de formation',
          narrative: '''
La levée de fonds est réussie. 5M€ levés.
Votre entreprise est sur la bonne voie.
Mais surtout : vous êtes passé(e) d\'une conformité à 20% (jour 1) 
à plus de 85% (aujourd\'hui).

Le formateur vous invite à présenter votre bilan : 
ce que vous avez appris, ce que vous avez changé, 
et ce que vous ferez différemment demain.
          ''',
          characterName: 'Votre Formateur', characterEmoji: '',
          characterMessage: 'Bravo pour ces 3 jours. Vous avez traversé 15 crises, pris des décisions difficiles, et bâti une entreprise plus solide. Quel est le point juridique qui vous a le plus surpris ?',
          toolTask: 'Rédigez votre bilan de formation : 3 apprentissages clés, 3 erreurs à ne plus commettre, et 1 action immédiate que vous allez mettre en place.',
          options: [
            DecisionOption(id: 'c15_7', label: 'Présenter un bilan structuré : 3 apprentissages clés + 3 erreurs à ne plus commettre + 1 action immédiate', explanation: 'La réflexivité est la compétence ultime du professionnel juridiquement averti.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 10, reputation: 10), consequence: 'Vous avez transformé 20 fiches de cours en réflexes professionnels. Mission accomplie.'),
            DecisionOption(id: 'c15_8', label: 'Dire que le droit c\'est trop complexe et qu\'il vaut mieux tout déléguer à un avocat', explanation: 'Un professionnel doit comprendre le droit même s\'il s\'appuie sur des experts.', isCorrect: false, impact: DecisionImpact.negative, effect: const IndicatorEffect(compliance: -5), consequence: 'La délégation totale sans compréhension est la source de toutes les crises que vous venez de vivre.'),
            DecisionOption(id: 'c15_9', label: 'Identifier les 3 outils gratuits qui vous ont le plus aidé et expliquer pourquoi', explanation: 'La maîtrise des outils est la clé de l\'autonomie professionnelle.', isCorrect: true, impact: DecisionImpact.positive, effect: const IndicatorEffect(compliance: 15, reputation: 15), consequence: 'Vous maîtrisez maintenant 8 outils professionnels gratuits. Employabilité renforcée.'),
          ],
        ),
      ],
      debriefTitle: ' Félicitations — Vous avez terminé le parcours',
      keyLessons: [
        'La conformité juridique est un actif — elle crée de la valeur',
        'Un audit honnête vaut mieux qu\'une perfection fictive',
        'La conformité est un processus continu, pas un état',
        'Chaque outil gratuit maîtrisé renforce votre autonomie professionnelle',
        'Les crises bien gérées renforcent la confiance des parties prenantes',
      ],
      commonMistakes: [
        'Penser que la conformité ne concerne que les grandes entreprises',
        'Déléguer sans comprendre',
        'Attendre la crise pour se mettre en conformité',
        'Considérer le droit comme une contrainte plutôt qu\'une protection',
      ],
    ),
  );
}
