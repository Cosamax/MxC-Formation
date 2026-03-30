import 'package:flutter/material.dart';
import '../models/clarity_models.dart';
import 'clarity_data_day1.dart';
import 'clarity_data_day2.dart';
import 'clarity_data_day3.dart';

// ═══════════════════════════════════════════════════════════════
// ZONE CLARTÉ — Données centralisées
// Agrège tous les challenges des 3 jours + rôles + config
// ═══════════════════════════════════════════════════════════════

class ClarityData {

  // ── Rôles disponibles en mode équipe ──────────────────────
  static List<ClarityRole> get roles => [
    ClarityRole(
      id: 'manager',
      title: 'Manager de proximité',
      emoji: '',
      description: 'Vous donnez les consignes à votre équipe et assurez le suivi.',
      responsibilities:
          'Formuler des consignes SMART • Lever les ambiguïtés • Faire les debriefs',
      color: const Color(0xFF1976D2),
    ),
    ClarityRole(
      id: 'collaborateur',
      title: 'Collaborateur expert',
      emoji: '‍',
      description: 'Vous recevez des consignes et devez les clarifier avant d\'agir.',
      responsibilities:
          'Identifier les présupposés • Reformuler • Signaler les blocages',
      color: const Color(0xFF388E3C),
    ),
    ClarityRole(
      id: 'rh',
      title: 'Responsable RH',
      emoji: '',
      description: 'Vous facilitez la communication et gérez les conflits de consignes.',
      responsibilities:
          'Médiation • Procédures • Formation aux bonnes pratiques',
      color: const Color(0xFF7B1FA2),
    ),
    ClarityRole(
      id: 'drh',
      title: 'Directeur des opérations',
      emoji: '',
      description: 'Vous arbitrez les priorités et coordonnez en situation de crise.',
      responsibilities:
          'Arbitrage priorités • Cellule de crise • Vision stratégique',
      color: const Color(0xFFE64A19),
    ),
  ];

  // ── Tous les challenges (3 jours × 5 = 15 challenges) ─────
  static List<ClarityChallenge>? _allChallengesCache;

  static List<ClarityChallenge> get allChallenges {
    _allChallengesCache ??= [
      ...ClarityDataDay1.challenges,
      ...ClarityDataDay2.challenges,
      ...ClarityDataDay3.challenges,
    ];
    return _allChallengesCache!;
  }

  // ── Challenges filtrés par jour ───────────────────────────
  static List<ClarityChallenge> challengesForDay(int day) =>
      allChallenges.where((c) => c.dayNumber == day).toList()
        ..sort((a, b) => a.orderInDay.compareTo(b.orderInDay));

  // ── Nombre total d\'actes ──────────────────────────────────
  static int get totalActs =>
      allChallenges.fold(0, (sum, c) => sum + c.scenario.acts.length);

  // ── Configuration de l\'entreprise ────────────────────────
  static const String companyName = 'CLARTÉ CONSEIL';
  static const String companySector = 'Cabinet de conseil en organisation';
  static const String companyTagline = 'Clarifier pour mieux agir';
  static const String companyEmoji = '';

  // ── Couleurs par jour ─────────────────────────────────────
  static Color dayColor(int day) {
    switch (day) {
      case 1: return const Color(0xFF1565C0);
      case 2: return const Color(0xFF2E7D32);
      case 3: return const Color(0xFF6A1B9A);
      default: return const Color(0xFF37474F);
    }
  }

  // ── Titre par jour ────────────────────────────────────────
  static String dayTitle(int day) {
    switch (day) {
      case 1: return 'Fondamentaux';
      case 2: return 'Pratiques avancées';
      case 3: return 'Leadership';
      default: return 'Séance $day';
    }
  }

  // ── Emoji par jour ────────────────────────────────────────
  static String dayEmoji(int day) {
    switch (day) {
      case 1: return '';
      case 2: return '';
      case 3: return '';
      default: return '';
    }
  }

  // ── Description par jour ──────────────────────────────────
  static String dayDescription(int day) {
    switch (day) {
      case 1:
        return 'Reconnaître une consigne floue, identifier les présupposés, '
            'reformuler efficacement et gérer les urgences.';
      case 2:
        return 'Consignes écrites percutantes, réunions décisives, '
            'feedback constructif et gestion des malentendus.';
      case 3:
        return 'Management à distance, conflits de priorité, '
            'délégation maîtrisée et leadership en situation de crise.';
      default: return '';
    }
  }

  // ── Outils pédagogiques référencés ───────────────────────
  static const List<String> tools = [
    'MÉTHODE SMART',
    'QQOQCCP',
    'DESC (Décrire / Exprimer / Spécifier / Conséquences)',
    'SBI (Situation / Comportement / Impact)',
    'MATRICE EISENHOWER',
    'MODÈLE REX',
    'PYRAMIDE DE MASLOW PROFESSIONNEL',
    'MÉTHODE OSBD (CNV)',
  ];
}
