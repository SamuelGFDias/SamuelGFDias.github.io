import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:portifolio/app/providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);
    try {
      await ref
          .read(authControllerProvider.notifier)
          .signIn(
            _emailController.text.trim(),
            _passwordController.text.trim(),
          );
      if (!mounted) return;
      
      // Sucesso: aguardar claim ser carregado
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        const SnackBar(
          content: Text('Login efetuado com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Aguardar token com claim admin ser processado
      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      
      // Navegar para admin - router vai validar permissões
      context.go('/admin');
    } catch (e) {
      if (!mounted) return;
      
      // Erro: mostrar mensagem e NÃO redirecionar
      String errorMessage = 'Erro ao fazer login';
      
      if (e.toString().contains('user-not-found')) {
        errorMessage = 'Usuário não encontrado';
      } else if (e.toString().contains('wrong-password')) {
        errorMessage = 'Senha incorreta';
      } else if (e.toString().contains('invalid-email')) {
        errorMessage = 'Email inválido';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = 'Erro de conexão. Verifique sua internet.';
      }
      
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: RadialGradient(
            center: const Alignment(0.1, -0.8),
            radius: 1.2,
            colors: isDark
                ? [
                    const Color(0xFF111827).withOpacity(0.8),
                    theme.scaffoldBackgroundColor,
                  ]
                : [
                    const Color(0xFFF6F7FB),
                    theme.scaffoldBackgroundColor,
                  ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Card(
                  elevation: 8,
                  shadowColor: Colors.black.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Logo/Brand
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Color(0xFF7c3aed),
                                  Color(0xFF38bdf8),
                                  Color(0xFF10b981),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          
                          // Título
                          Text(
                            'Entrar',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Acesse o painel administrativo',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.textTheme.bodySmall?.color,
                            ),
                          ),
                          const SizedBox(height: 32),
                          
                          // Campo Email
                          TextFormField(
                            controller: _emailController,
                            decoration: InputDecoration(
                              labelText: 'Email',
                              hintText: 'seu@email.com',
                              prefixIcon: const Icon(LucideIcons.mail),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            autofillHints: const [AutofillHints.email],
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Informe o email' : null,
                          ),
                          const SizedBox(height: 16),
                          
                          // Campo Senha
                          TextFormField(
                            controller: _passwordController,
                            decoration: InputDecoration(
                              labelText: 'Senha',
                              hintText: '••••••••',
                              prefixIcon: const Icon(LucideIcons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            obscureText: true,
                            autofillHints: const [AutofillHints.password],
                            validator: (v) =>
                                (v == null || v.isEmpty) ? 'Informe a senha' : null,
                          ),
                          const SizedBox(height: 24),
                          
                          // Botão Entrar
                          FilledButton.icon(
                            onPressed: _isLoading ? null : _submit,
                            style: FilledButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            icon: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(LucideIcons.logIn),
                            label: Text(
                              _isLoading ? 'Entrando...' : 'Entrar',
                              style: const TextStyle(fontSize: 16),
                            ),
                          ),
                          const SizedBox(height: 16),
                          
                          // Link voltar
                          TextButton.icon(
                            onPressed: () => context.go('/'),
                            icon: const Icon(LucideIcons.arrowLeft, size: 16),
                            label: const Text('Voltar para o site'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
