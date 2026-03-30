import 'package:flutter/material.dart';
import '../models/platform_models.dart';

// ═══════════════════════════════════════════════════════════════
// SERVICE STRIPE — Intégration paiement (mode simulation)
// En production : remplacer par l'API Stripe réelle
// ═══════════════════════════════════════════════════════════════

class StripeService {
  // ─── CONFIGURATION STRIPE (à remplacer en production) ───
  static const String _publishableKey = 'pk_test_VOTRE_CLE_STRIPE_ICI';
  static const String _secretKey = 'sk_test_VOTRE_CLE_SECRETE_ICI'; // Jamais côté client en prod!
  static const String _webhookSecret = 'whsec_VOTRE_WEBHOOK_SECRET_ICI';

  // ─── URL du backend (à configurer en production) ───
  static const String _backendUrl = 'https://votre-backend.mxc-formations.fr';

  /// Créer une session de paiement Stripe
  /// En production : appeler votre backend qui crée une Stripe Checkout Session
  static Future<StripeCheckoutResult> createCheckoutSession({
    required GameInfo game,
    required String customerEmail,
  }) async {
    // Simulation : 2 secondes de délai (réel = appel API)
    await Future.delayed(const Duration(seconds: 2));

    // En PRODUCTION, cette fonction devrait :
    // 1. Appeler votre backend : POST /api/stripe/checkout
    // 2. Passer : priceId, customerEmail, successUrl, cancelUrl
    // 3. Recevoir : sessionId, checkoutUrl
    // 4. Ouvrir checkoutUrl dans un WebView ou lancer url_launcher

    // EXEMPLE PRODUCTION :
    // final response = await http.post(
    //   Uri.parse('$_backendUrl/api/stripe/checkout'),
    //   headers: {'Content-Type': 'application/json'},
    //   body: jsonEncode({
    //     'price_id': game.stripePriceId,
    //     'customer_email': customerEmail,
    //     'success_url': '$_backendUrl/success?session_id={CHECKOUT_SESSION_ID}',
    //     'cancel_url': '$_backendUrl/cancel',
    //   }),
    // );
    // final data = jsonDecode(response.body);
    // return StripeCheckoutResult(
    //   success: true,
    //   checkoutUrl: data['checkout_url'],
    //   sessionId: data['session_id'],
    // );

    // SIMULATION (à remplacer) :
    return StripeCheckoutResult(
      success: true,
      checkoutUrl: 'https://checkout.stripe.com/pay/${game.stripePriceId}',
      sessionId: 'cs_test_${DateTime.now().millisecondsSinceEpoch}',
      gameId: game.id,
      amount: game.price,
    );
  }

  /// Vérifier le statut d'un paiement
  static Future<bool> verifyPayment(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    // En PRODUCTION : vérifier via webhook ou appel API backend
    // Le webhook Stripe enverrait une confirmation à votre backend
    return true; // Simulation : toujours succès
  }
}

/// Résultat d'une session de paiement Stripe
class StripeCheckoutResult {
  final bool success;
  final String? checkoutUrl;
  final String? sessionId;
  final String? gameId;
  final double? amount;
  final String? errorMessage;

  StripeCheckoutResult({
    required this.success,
    this.checkoutUrl,
    this.sessionId,
    this.gameId,
    this.amount,
    this.errorMessage,
  });
}

// ═══════════════════════════════════════════════════════════════
// DIALOG PAIEMENT SIMULÉ
// ═══════════════════════════════════════════════════════════════

class StripePaymentDialog extends StatefulWidget {
  final GameInfo game;
  final String customerEmail;
  final VoidCallback onSuccess;

  const StripePaymentDialog({
    super.key,
    required this.game,
    required this.customerEmail,
    required this.onSuccess,
  });

  @override
  State<StripePaymentDialog> createState() => _StripePaymentDialogState();
}

class _StripePaymentDialogState extends State<StripePaymentDialog> {
  _PaymentStep _step = _PaymentStep.info;
  final _cardNumberCtrl = TextEditingController(text: '4242 4242 4242 4242');
  final _expiryCtrl = TextEditingController(text: '12/28');
  final _cvvCtrl = TextEditingController(text: '123');
  final _nameCtrl = TextEditingController();
  bool _isProcessing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameCtrl.text = widget.customerEmail.split('@').first;
  }

  @override
  void dispose() {
    _cardNumberCtrl.dispose();
    _expiryCtrl.dispose();
    _cvvCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF0D1322),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      insetPadding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Stripe
            _buildStripeHeader(),
            const SizedBox(height: 24),

            if (_step == _PaymentStep.info) _buildInfoStep(),
            if (_step == _PaymentStep.payment) _buildPaymentStep(),
            if (_step == _PaymentStep.success) _buildSuccessStep(),
          ],
        ),
      ),
    );
  }

  Widget _buildStripeHeader() {
    return Column(
      children: [
        // Stripe logo simulé
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF635BFF).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: const Color(0xFF635BFF).withValues(alpha: 0.4)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.lock, color: Color(0xFF635BFF), size: 14),
                  const SizedBox(width: 6),
                  Text(
                    'Paiement sécurisé · Stripe',
                    style: TextStyle(
                      color: const Color(0xFF635BFF).withValues(alpha: 0.9),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Jeu acheté
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: widget.game.color.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: widget.game.color.withValues(alpha: 0.25)),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.game.color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.game.icon,
                    color: widget.game.color, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.game.title,
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    Text(widget.game.subtitle,
                        style: const TextStyle(
                            color: Colors.white54, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    widget.game.displayPrice,
                    style: TextStyle(
                      color: widget.game.color,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text('par apprenant',
                      style:
                          TextStyle(color: Colors.white38, fontSize: 10)),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoStep() {
    return Column(
      children: [
        // Récapitulatif
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF151B2E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              _infoRow('E-mail', widget.customerEmail),
              _divider(),
              _infoRow('Jeu', widget.game.title),
              _divider(),
              _infoRow('Accès', 'Illimité — 1 apprenant'),
              _divider(),
              _infoRow('Total', widget.game.displayPrice,
                  highlight: true),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Note sandbox
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFFFB800).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
                color: const Color(0xFFFFB800).withValues(alpha: 0.3)),
          ),
          child: const Row(
            children: [
              Icon(Icons.info_outline,
                  color: Color(0xFFFFB800), size: 16),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Mode démo — aucun débit réel. '
                  'En production, Stripe sécurise votre paiement.',
                  style: TextStyle(
                      color: Color(0xFFFFB800), fontSize: 11),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Bouton continuer
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () => setState(() => _step = _PaymentStep.payment),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF635BFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Continuer vers le paiement',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
        const SizedBox(height: 10),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler',
              style: TextStyle(color: Colors.white38)),
        ),
      ],
    );
  }

  Widget _buildPaymentStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _fieldLabel('Numéro de carte'),
        _cardTextField(
          controller: _cardNumberCtrl,
          hint: '4242 4242 4242 4242',
          icon: Icons.credit_card,
          keyboardType: TextInputType.number,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('Expiration'),
                  _cardTextField(
                    controller: _expiryCtrl,
                    hint: 'MM/AA',
                    icon: Icons.calendar_month_outlined,
                    keyboardType: TextInputType.number,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _fieldLabel('CVV'),
                  _cardTextField(
                    controller: _cvvCtrl,
                    hint: '123',
                    icon: Icons.lock_outline,
                    keyboardType: TextInputType.number,
                    obscure: true,
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _fieldLabel('Nom sur la carte'),
        _cardTextField(
          controller: _nameCtrl,
          hint: 'Prénom Nom',
          icon: Icons.person_outline,
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFFF4D6D).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: const Color(0xFFFF4D6D).withValues(alpha: 0.4)),
            ),
            child: Text(_error!,
                style: const TextStyle(
                    color: Color(0xFFFF4D6D), fontSize: 12)),
          ),
        ],
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _processPayment,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF635BFF),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              disabledBackgroundColor: Colors.white12,
            ),
            child: _isProcessing
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white60)),
                      SizedBox(width: 10),
                      Text('Traitement en cours…',
                          style: TextStyle(
                              fontSize: 14, color: Colors.white60)),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.lock, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        'Payer ${widget.game.displayPrice}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.security, size: 12, color: Colors.white38),
            const SizedBox(width: 4),
            const Text('Paiement crypté 256-bit SSL',
                style: TextStyle(color: Colors.white38, fontSize: 11)),
          ],
        ),
        const SizedBox(height: 8),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _step = _PaymentStep.info),
            child: const Text('Retour',
                style: TextStyle(color: Colors.white38, fontSize: 12)),
          ),
        ),
      ],
    );
  }

  Widget _buildSuccessStep() {
    return Column(
      children: [
        const SizedBox(height: 8),
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: const Color(0xFF00FF88).withValues(alpha: 0.12),
            shape: BoxShape.circle,
            border: Border.all(
                color: const Color(0xFF00FF88).withValues(alpha: 0.4),
                width: 2),
          ),
          child: const Icon(Icons.check_rounded,
              color: Color(0xFF00FF88), size: 40),
        ),
        const SizedBox(height: 20),
        const Text(
          'Paiement réussi !',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Accès à ${widget.game.title} débloqué.',
          style: const TextStyle(color: Colors.white70, fontSize: 14),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Confirmation envoyée à ${widget.customerEmail}',
          style: const TextStyle(color: Colors.white38, fontSize: 12),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 28),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              widget.onSuccess();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00FF88),
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text(
              'Accéder au jeu',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
          ),
        ),
      ],
    );
  }

  // ─── HELPERS UI ─────────────────────────────────────────────

  Widget _infoRow(String label, String value, {bool highlight = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: const TextStyle(
                  color: Colors.white54, fontSize: 13)),
          Text(
            value,
            style: TextStyle(
              color: highlight ? const Color(0xFF00D4FF) : Colors.white,
              fontSize: highlight ? 15 : 13,
              fontWeight:
                  highlight ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() =>
      const Divider(color: Colors.white12, height: 1);

  Widget _fieldLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white60, fontSize: 12)),
    );
  }

  Widget _cardTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white, fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
        prefixIcon: Icon(icon, color: Colors.white38, size: 18),
        filled: true,
        fillColor: const Color(0xFF0A0E1A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.white12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF635BFF)),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      ),
    );
  }

  // ─── LOGIQUE PAIEMENT ────────────────────────────────────────

  Future<void> _processPayment() async {
    if (_nameCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Veuillez saisir le nom sur la carte.');
      return;
    }

    setState(() {
      _isProcessing = true;
      _error = null;
    });

    try {
      // Simuler traitement Stripe
      final result = await StripeService.createCheckoutSession(
        game: widget.game,
        customerEmail: widget.customerEmail,
      );

      if (result.success) {
        if (mounted) {
          setState(() {
            _step = _PaymentStep.success;
            _isProcessing = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _error = result.errorMessage ?? 'Paiement refusé. Veuillez réessayer.';
            _isProcessing = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = 'Erreur de connexion. Vérifiez votre réseau.';
          _isProcessing = false;
        });
      }
    }
  }
}

enum _PaymentStep { info, payment, success }
