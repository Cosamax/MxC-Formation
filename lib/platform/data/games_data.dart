import 'package:flutter/material.dart';
import '../models/platform_models.dart';
import '../models/platform_theme.dart';

// ═══════════════════════════════════════════════════════════════
// CATALOGUE DE JEUX (extensible)
// ═══════════════════════════════════════════════════════════════

class GamesData {
  static final List<GameInfo> catalog = [
    // ─── JEUX DISPONIBLES ───
    GameInfo(
      id: 'nexova',
      title: 'NUMÉRIX',
      subtitle: 'Droit de l\'Internet — Business Game',
      description:
          'Vous êtes directeur·rice d\'une scale-up en pleine croissance. En équipe ou en solo, naviguez 15 challenges immersifs : alertes CNIL, litiges clients, crises d\'e-réputation, audits DGCCRF… Chaque décision a des conséquences réelles.',
      domain: 'droit',
      color: const Color(0xFF00BCD4),
      icon: Icons.business_center,
      status: GameStatus.published,
      totalQuestions: 15,
      estimatedMinutes: 900,
      difficulty: 'Intermédiaire',
      skills: [
        'Droit e-commerce',
        'RGPD & CNIL',
        'E-réputation & avis',
        'Contrats & CGV',
        'Outils gratuits (Canva, Brevo…)',
      ],
      targets: ['Apprenants en situation pro', 'Managers', 'Entrepreneurs'],
      playCount: 0,
      avgScore: 0.0,
      authorName: 'MxC Formations',
      price: 49.0,
      pricingLabel: '49 € / apprenant',
      stripeProductId: 'prod_nexova_placeholder',
      stripePriceId: 'price_nexova_placeholder',
    ),

    GameInfo(
      id: 'clarity_zone',
      title: 'ZONE CLARTÉ',
      subtitle: 'Consignes Professionnelles — Business Game',
      description:
          'Chez CLARTÉ CONSEIL, les consignes floues coûtent 3 semaines de productivité par an. '
          'En solo ou en équipe, jouez 15 challenges immersifs de jeux de rôle : '
          'consignes floues, présupposés cachés, conflits de priorité, délégation, crise… '
          'Chaque décision fait évoluer la clarté, la confiance et l\'efficacité.',
      domain: 'management',
      color: const Color(0xFF7B1FA2),
      icon: Icons.psychology_alt,
      status: GameStatus.published,
      totalQuestions: 15,
      estimatedMinutes: 900,
      difficulty: 'Intermédiaire',
      skills: [
        'Consignes claires (méthode SMART)',
        'Communication professionnelle',
        'Gestion des conflits',
        'Délégation efficace',
        'Leadership en situation de crise',
      ],
      targets: ['Managers', 'Collaborateurs', 'RH & DRH', 'Formateurs'],
      playCount: 0,
      avgScore: 0.0,
      authorName: 'MxC Formations',
      price: 49.0,
      pricingLabel: '49 € / apprenant',
      stripeProductId: 'prod_clarity_placeholder',
      stripePriceId: 'price_clarity_placeholder',
    ),

    // ─── JEUX À VENIR ───
    GameInfo(
      id: 'rgpd_survivor',
      title: 'RGPD Survivor',
      subtitle: 'Protection des données',
      description:
          'Mettez en conformité une entreprise avec le RGPD : registre de traitement, privacy by design, gestion des violations, relations DPO.',
      domain: 'gdpr',
      color: MxCTheme.gdpr,
      icon: Icons.security,
      status: GameStatus.draft,
      totalQuestions: 15,
      estimatedMinutes: 900,
      difficulty: 'Avancé',
      skills: [
        'Registre de traitement',
        'Droits des personnes',
        'DPO & CNIL',
        'Privacy by Design',
      ],
      targets: ['DPO', 'DSI', 'Juristes', 'Apprenants Master'],
      playCount: 0,
      avgScore: 0.0,
      price: 59.0,
      pricingLabel: '59 € / apprenant',
      stripeProductId: 'prod_rgpd_placeholder',
      stripePriceId: 'price_rgpd_placeholder',
    ),
    GameInfo(
      id: 'pitch_master',
      title: 'Pitch Master',
      subtitle: 'Startup & Entrepreneuriat',
      description:
          'Simulez la création d\'une startup : business model, pitch investisseurs, levée de fonds, statuts juridiques et obligations fiscales.',
      domain: 'startup',
      color: MxCTheme.accent,
      icon: Icons.rocket_launch,
      status: GameStatus.draft,
      totalQuestions: 15,
      estimatedMinutes: 900,
      difficulty: 'Expert',
      skills: [
        'Business Model Canvas',
        'Statuts juridiques',
        'Levée de fonds',
        'Fiscalité startup',
      ],
      targets: ['Apprenants business', 'Entrepreneurs', 'MBA'],
      playCount: 0,
      avgScore: 0.0,
      price: 69.0,
      pricingLabel: '69 € / apprenant',
      stripeProductId: 'prod_pitch_placeholder',
      stripePriceId: 'price_pitch_placeholder',
    ),
    GameInfo(
      id: 'marketing_quest',
      title: 'Marketing Quest',
      subtitle: 'Marketing Digital',
      description:
          'Maîtrisez les règles du marketing digital : publicité en ligne, influenceurs, emailing, SEO légal et protection du consommateur.',
      domain: 'marketing',
      color: MxCTheme.marketing,
      icon: Icons.campaign,
      status: GameStatus.draft,
      totalQuestions: 15,
      estimatedMinutes: 900,
      difficulty: 'Intermédiaire',
      skills: [
        'Publicité en ligne',
        'Marketing d\'influence',
        'Email marketing',
        'Protection consommateur',
      ],
      targets: ['Marketeurs', 'Community managers', 'Apprenants marketing'],
      playCount: 0,
      avgScore: 0.0,
      price: 39.0,
      pricingLabel: '39 € / apprenant',
      stripeProductId: 'prod_marketing_placeholder',
      stripePriceId: 'price_marketing_placeholder',
    ),
    GameInfo(
      id: 'budget_boss',
      title: 'Budget Boss',
      subtitle: 'Finance & Comptabilité',
      description:
          'Gérez les finances d\'une PME : trésorerie, TVA, bilans comptables, analyse financière et décisions d\'investissement.',
      domain: 'finance',
      color: MxCTheme.accentWarm,
      icon: Icons.account_balance,
      status: GameStatus.draft,
      totalQuestions: 15,
      estimatedMinutes: 900,
      difficulty: 'Avancé',
      skills: [
        'Trésorerie & cash-flow',
        'Comptabilité',
        'Analyse financière',
        'Fiscalité entreprise',
      ],
      targets: ['Contrôleurs de gestion', 'Dirigeants PME', 'Apprenants finance'],
      playCount: 0,
      avgScore: 0.0,
      price: 55.0,
      pricingLabel: '55 € / apprenant',
      stripeProductId: 'prod_budget_placeholder',
      stripePriceId: 'price_budget_placeholder',
    ),
    GameInfo(
      id: 'hr_challenge',
      title: 'HR Challenge',
      subtitle: 'Ressources Humaines',
      description:
          'Naviguez dans le droit du travail : recrutement légal, contrats, rupture, discriminations, harcèlement et CSE.',
      domain: 'rh',
      color: MxCTheme.reputation,
      icon: Icons.people_alt,
      status: GameStatus.draft,
      totalQuestions: 15,
      estimatedMinutes: 900,
      difficulty: 'Intermédiaire',
      skills: [
        'Droit du travail',
        'Recrutement légal',
        'Rupture de contrat',
        'Discrimination & harcèlement',
      ],
      targets: ['RH & DRH', 'Managers', 'Apprenants RH'],
      playCount: 0,
      avgScore: 0.0,
      price: 45.0,
      pricingLabel: '45 € / apprenant',
      stripeProductId: 'prod_hr_placeholder',
      stripePriceId: 'price_hr_placeholder',
    ),
  ];

  static GameInfo? getById(String id) {
    try {
      return catalog.firstWhere((g) => g.id == id);
    } catch (_) {
      return null;
    }
  }

  static List<GameInfo> get published =>
      catalog.where((g) => g.status == GameStatus.published).toList();

  static List<GameInfo> get comingSoon =>
      catalog.where((g) => g.status == GameStatus.draft).toList();
}

// ═══════════════════════════════════════════════════════════════
// CATALOGUE BADGES
// ═══════════════════════════════════════════════════════════════

class BadgesData {
  static const List<GameBadge> all = [
    GameBadge(
      id: 'first_game',
      name: 'Premier Jeu',
      description: 'Vous avez joué pour la première fois',
      icon: Icons.star,
      color: MxCTheme.accentWarm,
      condition: 'Jouer une première partie',
    ),
    GameBadge(
      id: 'perfect_score',
      name: 'Score Parfait',
      description: '100% de bonnes réponses',
      icon: Icons.military_tech,
      color: MxCTheme.primary,
      condition: 'Obtenir 100% dans un module',
    ),
    GameBadge(
      id: 'legal_expert',
      name: 'Expert Légal',
      description: 'Compléter les 15 challenges NUMÉRIX',
      icon: Icons.gavel,
      color: MxCTheme.law,
      condition: 'Compléter NUMÉRIX',
    ),
    GameBadge(
      id: 'speed_demon',
      name: 'Speed Run',
      description: 'Finir un module en moins de 5 minutes',
      icon: Icons.bolt,
      color: MxCTheme.accentWarm,
      condition: 'Module complété en < 5 min',
    ),
    GameBadge(
      id: 'high_score',
      name: 'Top Scorer',
      description: 'Dépasser 90% dans un jeu',
      icon: Icons.emoji_events,
      color: MxCTheme.accent,
      condition: 'Score > 90% dans un jeu',
    ),
    GameBadge(
      id: 'persistent',
      name: 'Persévérant',
      description: '5 parties jouées',
      icon: Icons.repeat,
      color: MxCTheme.gdpr,
      condition: 'Jouer 5 parties',
    ),
  ];
}

// ═══════════════════════════════════════════════════════════════
// CATÉGORIES DE COMPÉTENCES
// ═══════════════════════════════════════════════════════════════

class CompetencesData {
  static final List<CompetenceCategory> categories = [
    CompetenceCategory(
      id: 'juridique',
      name: 'Juridique & Compliance',
      description: 'Droit des affaires, RGPD, contrats',
      icon: Icons.balance,
      color: MxCTheme.law,
      gameIds: ['nexova', 'rgpd_survivor'],
    ),
    CompetenceCategory(
      id: 'entrepreneuriat',
      name: 'Entrepreneuriat',
      description: 'Création d\'entreprise, startup',
      icon: Icons.rocket_launch,
      color: MxCTheme.accent,
      gameIds: ['pitch_master'],
    ),
    CompetenceCategory(
      id: 'marketing',
      name: 'Marketing Digital',
      description: 'Marketing, publicité, e-commerce',
      icon: Icons.campaign,
      color: MxCTheme.marketing,
      gameIds: ['marketing_quest'],
    ),
    CompetenceCategory(
      id: 'finance',
      name: 'Finance & Comptabilité',
      description: 'Gestion financière, comptabilité',
      icon: Icons.account_balance,
      color: MxCTheme.accentWarm,
      gameIds: ['budget_boss'],
    ),
    CompetenceCategory(
      id: 'rh',
      name: 'Ressources Humaines',
      description: 'Droit du travail, management',
      icon: Icons.people_alt,
      color: MxCTheme.reputation,
      gameIds: ['hr_challenge'],
    ),
  ];
}
