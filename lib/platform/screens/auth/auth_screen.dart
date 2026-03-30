import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/platform_provider.dart';
import '../../models/platform_theme.dart';

// ═══════════════════════════════════════════════════════════════
// ÉCRAN D'AUTHENTIFICATION — Connexion / Inscription / Formateur
// ═══════════════════════════════════════════════════════════════

class AuthScreen extends StatefulWidget {
  final bool initialRegister;
  const AuthScreen({super.key, this.initialRegister = false});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // Apprenant — Connexion
  final _loginEmailCtrl = TextEditingController();
  final _loginPasswordCtrl = TextEditingController();
  final _formKeyLogin = GlobalKey<FormState>();
  bool _loginPasswordVisible = false;

  // Apprenant — Inscription
  final _registerNameCtrl = TextEditingController();
  final _registerEmailCtrl = TextEditingController();
  final _registerPasswordCtrl = TextEditingController();
  final _registerConfirmCtrl = TextEditingController();
  final _formKeyRegister = GlobalKey<FormState>();
  bool _registerPasswordVisible = false;

  // Formateur
  final _profNameCtrl = TextEditingController();
  final _profPasswordCtrl = TextEditingController();
  final _formKeyProf = GlobalKey<FormState>();
  bool _profPasswordVisible = false;

  // FocusNodes pour navigation clavier
  final _loginPasswordFocus = FocusNode();
  final _registerEmailFocus = FocusNode();
  final _registerPasswordFocus = FocusNode();
  final _registerConfirmFocus = FocusNode();
  final _profPasswordFocus = FocusNode();

  bool _isLoading = false;
  String? _errorMsg;

  // 0 = Connexion, 1 = Inscription, 2 = Formateur
  int _mode = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    if (widget.initialRegister) _mode = 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _loginEmailCtrl.dispose();
    _loginPasswordCtrl.dispose();
    _registerNameCtrl.dispose();
    _registerEmailCtrl.dispose();
    _registerPasswordCtrl.dispose();
    _registerConfirmCtrl.dispose();
    _profNameCtrl.dispose();
    _profPasswordCtrl.dispose();
    _loginPasswordFocus.dispose();
    _registerEmailFocus.dispose();
    _registerPasswordFocus.dispose();
    _registerConfirmFocus.dispose();
    _profPasswordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0E1A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back
              if (Navigator.canPop(context))
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(40, 40),
                  ),
                  child: const Text('<', style: TextStyle(color: Colors.white54, fontSize: 22)),
                ),

              const SizedBox(height: 16),

              // Logo
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        gradient: MxCTheme.primaryGradient,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Text('MxC',
                          style: TextStyle(color: Colors.black, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'MxC Formations',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Serious games en situation professionnelle',
                      style:
                          TextStyle(color: Colors.white54, fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 32),

              // Sélecteur de mode
              _buildModeSelector(),

              const SizedBox(height: 24),

              // Erreur
              if (_errorMsg != null) _buildError(),

              // Formulaire selon le mode
              if (_mode == 0) _buildLoginForm(),
              if (_mode == 1) _buildRegisterForm(),
              if (_mode == 2) _buildFormatorForm(),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  // ─── SÉLECTEUR DE MODE ──────────────────────────────────────

  Widget _buildModeSelector() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF151B2E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          _modeTab(0, 'Connexion'),
          _modeTab(1, 'Inscription'),
          _modeTab(2, 'Formateur'),
        ],
      ),
    );
  }

  Widget _modeTab(int index, String label) {
    final isActive = _mode == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() {
          _mode = index;
          _errorMsg = null;
        }),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isActive ? MxCTheme.primaryGradient : null,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isActive ? Colors.black : Colors.white54,
              fontSize: 13,
              fontWeight:
                  isActive ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // ─── ERREUR ─────────────────────────────────────────────────

  Widget _buildError() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFF4D6D).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
            color: const Color(0xFFFF4D6D).withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          const Text('!', style: TextStyle(color: Color(0xFFFF4D6D), fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Expanded(
            child: Text(_errorMsg!,
                style: const TextStyle(
                    color: Color(0xFFFF4D6D), fontSize: 13)),
          ),
        ],
      ),
    );
  }

  // ─── FORMULAIRE CONNEXION ────────────────────────────────────

  Widget _buildLoginForm() {
    return Form(
      key: _formKeyLogin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Adresse e-mail'),
          _textField(
            controller: _loginEmailCtrl,
            hint: 'votre@email.com',
            keyboardType: TextInputType.emailAddress,
            validator: _emailValidator,
            textInputAction: TextInputAction.next,
            onSubmitted: () => FocusScope.of(context).requestFocus(_loginPasswordFocus),
          ),
          const SizedBox(height: 16),
          _label('Mot de passe'),
          _passwordField(
            controller: _loginPasswordCtrl,
            hint: 'Votre mot de passe',
            visible: _loginPasswordVisible,
            onToggle: () => setState(
                () => _loginPasswordVisible = !_loginPasswordVisible),
            validator: (v) => (v == null || v.isEmpty)
                ? 'Mot de passe requis'
                : null,
            textInputAction: TextInputAction.done,
            focusNode: _loginPasswordFocus,
            onSubmitted: _login,
          ),
          const SizedBox(height: 28),
          _submitButton(
            label: 'Se connecter',
            onTap: _login,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () =>
                  setState(() => _mode = 1),
              child: const Text(
                'Pas encore de compte ? S\'inscrire',
                style:
                    TextStyle(color: Color(0xFF00D4FF), fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── FORMULAIRE INSCRIPTION ──────────────────────────────────

  Widget _buildRegisterForm() {
    return Form(
      key: _formKeyRegister,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _label('Prénom et nom'),
          _textField(
            controller: _registerNameCtrl,
            hint: 'Ex : Marie Dupont',
            validator: (v) => (v == null || v.trim().length < 2)
                ? 'Nom requis (min. 2 caractères)'
                : null,
            textInputAction: TextInputAction.next,
            onSubmitted: () => FocusScope.of(context).requestFocus(_registerEmailFocus),
          ),
          const SizedBox(height: 16),
          _label('Adresse e-mail'),
          _textField(
            controller: _registerEmailCtrl,
            hint: 'votre@email.com',
            keyboardType: TextInputType.emailAddress,
            validator: _emailValidator,
            textInputAction: TextInputAction.next,
            focusNode: _registerEmailFocus,
            onSubmitted: () => FocusScope.of(context).requestFocus(_registerPasswordFocus),
          ),
          const SizedBox(height: 16),
          _label('Mot de passe'),
          _passwordField(
            controller: _registerPasswordCtrl,
            hint: 'Min. 6 caractères',
            visible: _registerPasswordVisible,
            onToggle: () => setState(() =>
                _registerPasswordVisible = !_registerPasswordVisible),
            validator: (v) => (v == null || v.length < 6)
                ? 'Minimum 6 caractères'
                : null,
            textInputAction: TextInputAction.next,
            focusNode: _registerPasswordFocus,
            onSubmitted: () => FocusScope.of(context).requestFocus(_registerConfirmFocus),
          ),
          const SizedBox(height: 16),
          _label('Confirmer le mot de passe'),
          _passwordField(
            controller: _registerConfirmCtrl,
            hint: 'Répétez le mot de passe',
            visible: _registerPasswordVisible,
            onToggle: () => setState(() =>
                _registerPasswordVisible = !_registerPasswordVisible),
            validator: (v) =>
                v != _registerPasswordCtrl.text
                    ? 'Les mots de passe ne correspondent pas'
                    : null,
            textInputAction: TextInputAction.done,
            focusNode: _registerConfirmFocus,
            onSubmitted: _register,
          ),
          const SizedBox(height: 28),
          _submitButton(
            label: 'Créer mon compte',
            onTap: _register,
          ),
          const SizedBox(height: 16),
          Center(
            child: TextButton(
              onPressed: () =>
                  setState(() => _mode = 0),
              child: const Text(
                'Déjà un compte ? Se connecter',
                style:
                    TextStyle(color: Color(0xFF00D4FF), fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── FORMULAIRE FORMATEUR ────────────────────────────────────

  Widget _buildFormatorForm() {
    return Form(
      key: _formKeyProf,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: MxCTheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: MxCTheme.primary.withValues(alpha: 0.25)),
            ),
            child: const Row(
              children: [
                const Text('[F]', style: TextStyle(color: MxCTheme.primary, fontSize: 12, fontWeight: FontWeight.bold)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Espace réservé aux formateurs et coachs MxC Formations.',
                    style: TextStyle(
                        color: MxCTheme.primary, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _label('Votre nom'),
          _textField(
            controller: _profNameCtrl,
            hint: 'Ex : Marie Dupont',
            validator: (v) => (v == null || v.trim().isEmpty)
                ? 'Nom requis'
                : null,
            textInputAction: TextInputAction.next,
            onSubmitted: () => FocusScope.of(context).requestFocus(_profPasswordFocus),
          ),
          const SizedBox(height: 16),
          _label('Code d\'accès formateur'),
          _passwordField(
            controller: _profPasswordCtrl,
            hint: 'Code confidentiel',
            visible: _profPasswordVisible,
            onToggle: () => setState(
                () => _profPasswordVisible = !_profPasswordVisible),
            validator: (v) {
              if (v == null || v.isEmpty) return 'Code requis';
              if (v.trim() != 'mxc2025') return 'Code incorrect';
              return null;
            },
            textInputAction: TextInputAction.done,
            focusNode: _profPasswordFocus,
            onSubmitted: _loginFormator,
          ),
          const SizedBox(height: 28),
          _submitButton(
            label: 'Accéder au dashboard',
            color: MxCTheme.accentWarm,
            onTap: _loginFormator,
          ),
        ],
      ),
    );
  }

  // ─── WIDGETS COMMUNS ─────────────────────────────────────────

  Widget _label(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(text,
          style: const TextStyle(
              color: Colors.white70,
              fontSize: 13,
              fontWeight: FontWeight.w500)),
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    VoidCallback? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onSubmitted != null ? (_) => onSubmitted() : null,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30),
        prefixIcon: icon != null ? Icon(icon, color: Colors.white38, size: 20) : null,
        filled: true,
        fillColor: const Color(0xFF151B2E),
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
          borderSide: const BorderSide(color: Color(0xFF00D4FF)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFF4D6D)),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFF4D6D)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool visible,
    required VoidCallback onToggle,
    String? Function(String?)? validator,
    TextInputAction? textInputAction,
    FocusNode? focusNode,
    VoidCallback? onSubmitted,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: !visible,
      validator: validator,
      textInputAction: textInputAction,
      focusNode: focusNode,
      onFieldSubmitted: onSubmitted != null ? (_) => onSubmitted() : null,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.white30),
        prefixIcon: const Padding(padding: EdgeInsets.all(12), child: Text('*', style: TextStyle(color: Colors.white38, fontSize: 16))),
        suffixIcon: IconButton(
          icon: Text(visible ? 'masquer' : 'voir',
              style: const TextStyle(color: Colors.white38, fontSize: 10)),
          onPressed: onToggle,
        ),
        filled: true,
        fillColor: const Color(0xFF151B2E),
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
          borderSide: const BorderSide(color: Color(0xFF00D4FF)),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFFF4D6D)),
        ),
        errorStyle: const TextStyle(color: Color(0xFFFF4D6D)),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _submitButton({
    required String label,
    IconData? icon,
    required VoidCallback onTap,
    Color? color,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? const Color(0xFF00D4FF),
          foregroundColor: Colors.black,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          disabledBackgroundColor: Colors.white12,
        ),
        child: _isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.black54),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label,
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold)),
                ],
              ),
      ),
    );
  }

  // ─── VALIDATEURS ────────────────────────────────────────────

  String? _emailValidator(String? v) {
    if (v == null || v.trim().isEmpty) return 'E-mail requis';
    if (!v.contains('@') || !v.contains('.')) return 'E-mail invalide';
    return null;
  }

  // ─── ACTIONS ────────────────────────────────────────────────

  Future<void> _login() async {
    if (!_formKeyLogin.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    final provider =
        Provider.of<PlatformProvider>(context, listen: false);
    final success = await provider.loginWithEmail(
      _loginEmailCtrl.text.trim(),
      _loginPasswordCtrl.text,
    );
    if (mounted) {
      setState(() => _isLoading = false);
      if (!success) {
        setState(() =>
            _errorMsg = 'E-mail ou mot de passe incorrect.');
      } else {
        if (Navigator.canPop(context)) Navigator.pop(context);
      }
    }
  }

  Future<void> _register() async {
    if (!_formKeyRegister.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    final provider =
        Provider.of<PlatformProvider>(context, listen: false);
    final success = await provider.registerWithEmail(
      name: _registerNameCtrl.text.trim(),
      email: _registerEmailCtrl.text.trim(),
      password: _registerPasswordCtrl.text,
    );
    if (mounted) {
      setState(() => _isLoading = false);
      if (!success) {
        setState(() =>
            _errorMsg = 'Un compte existe déjà avec cet e-mail.');
      } else {
        if (Navigator.canPop(context)) Navigator.pop(context);
      }
    }
  }

  Future<void> _loginFormator() async {
    if (!_formKeyProf.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });
    final provider =
        Provider.of<PlatformProvider>(context, listen: false);
    await provider.loginAsProfessor(_profNameCtrl.text.trim());
    if (mounted) {
      setState(() => _isLoading = false);
      if (Navigator.canPop(context)) Navigator.pop(context);
    }
  }
}
