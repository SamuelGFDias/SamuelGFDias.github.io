import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:portifolio/app/providers/theme_provider.dart';
import 'package:portifolio/app/providers/user_provider.dart';
import 'package:portifolio/core/utils/ui_helpers.dart';
import 'package:portifolio/features/1_home/data/repositories/contact_repository.dart';
import 'package:portifolio/shared/app_scaffold.dart';
import 'package:portifolio/shared/fab_action.dart';
import 'package:portifolio/shared/fab_route.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _messageController;

  // Controlador para o SingleChildScrollView
  late final ScrollController _scrollController;

  // Chaves globais para cada seção
  final GlobalKey _heroKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _skillsKey = GlobalKey();
  final GlobalKey _projectsKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();

    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();

    _scrollController.dispose();

    super.dispose();
  }

  Future<void> _launchURL(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri) && mounted) {
      UiHelpers.showSnackBar('Could not launch $url', isError: true);
    }
  }

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;

    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfile = ref.watch(userProfileProvider.select((u) => u?.name));
    final themeColor = ref.watch(themeColorProvider.select((t) => t));
    final ThemeData theme = Theme.of(context);

    return AppScaffold(
      title: userProfile ?? 'Home',
      onTitlePressed: () => _scrollToSection(_heroKey),
      actions: [
        FabAction(
          onPressed: () {
            ref.read(themeColorProvider.notifier).toggleTheme();
          },
          label: 'Alterar Tema',
          icon: themeColor == Brightness.light
              ? LucideIcons.sun
              : LucideIcons.moon,
        ),
      ],
      navButtons: [
        FabRoute(
          label: 'Sobre',
          onPressed: () => _scrollToSection(_aboutKey),
          icon: LucideIcons.user,
        ),
        FabRoute(
          label: 'Habilidades',
          onPressed: () => _scrollToSection(_skillsKey),
          icon: LucideIcons.brain,
        ),
        FabRoute(
          label: 'Projetos',
          onPressed: () => _scrollToSection(_projectsKey),
          icon: LucideIcons.folder,
        ),
        // FabRoute(
        //   label: 'Experiências',
        //   onPressed: () {},
        //   icon: LucideIcons.briefcase,
        // ),
        FabRoute(
          label: 'Contato',
          onPressed: () => _scrollToSection(_contactKey),
          icon: LucideIcons.mail,
        ),
      ],
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 48.0,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Seção Hero
                  Padding(
                    key: _heroKey,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: _buildHeroSection(theme),
                  ),

                  // Seção Sobre
                  Padding(
                    key: _aboutKey,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: _buildAboutSection(theme),
                  ),

                  // Seção Habilidades
                  Padding(
                    key: _skillsKey,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: _buildSkillsSection(theme),
                  ),

                  // Seção Projetos
                  Padding(
                    key: _projectsKey,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: _buildProjectsSection(theme),
                  ),

                  // Seção Contato
                  Padding(
                    key: _contactKey,
                    padding: const EdgeInsets.symmetric(vertical: 40),
                    child: _buildContactSection(theme),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroSection(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Desenvolvedor Full Stack',
          style: theme.textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Especialista em .NET, Flutter, BI e integrações',
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _scrollToSection(_projectsKey),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text('Ver Projetos'),
              ),
            ),
            const SizedBox(width: 16),
            ElevatedButton(
              onPressed: () => _scrollToSection(_contactKey),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: const Text('Entrar em Contato'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSkillItem(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('• ', style: theme.textTheme.bodyLarge),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildContactSection(ThemeData theme) {
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      key: _contactKey,
      children: [
        Text('Contato', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration().copyWith(hintText: 'Seu nome'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, insira seu nome';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration().copyWith(hintText: 'Seu email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        !value.contains('@')) {
                      return 'Por favor, insira um email válido';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration().copyWith(
                    hintText: 'Sua mensagem',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear, size: 20),
                      onPressed: () => _messageController.clear(),
                    ),
                  ),
                  maxLines: 5,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, escreva uma mensagem';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitContactForm,
                    child: const Text('Enviar'),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),
        // Ícones de redes sociais
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(
                LucideIcons.mail,
                color: isDark ? theme.primaryColorDark : Colors.black,
              ),
              onPressed: () => _launchURL('mailto:samudias48@gmail.com'),
              tooltip: 'Email',
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(
                LucideIcons.linkedin,
                color: isDark ? theme.primaryColorDark : Colors.black,
              ),
              onPressed: () =>
                  _launchURL('https://www.linkedin.com/in/SamuelGFDias'),
              tooltip: 'LinkedIn',
            ),
            const SizedBox(width: 12),
            IconButton(
              icon: Icon(
                LucideIcons.github,
                color: isDark ? theme.primaryColorDark : Colors.black,
              ),
              onPressed: () => _launchURL('https://github.com/samuelgfdias'),
              tooltip: 'GitHub',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAboutSection(ThemeData theme) {
    return Column(
      key: _aboutKey,
      children: [
        const SizedBox(height: 40),
        Text('Sobre Mim', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            'Sou desenvolvedor full stack com experiência sólida em backend C# (.NET), frontend com Flutter, automações com Python e BI com Power BI e Excel avançado.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(ThemeData theme) {
    return Column(
      key: _skillsKey,
      children: [
        const SizedBox(height: 40),
        Text('Habilidades Técnicas', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSkillItem(
                theme,
                'Backend: .NET, APIs REST, Entity Framework',
              ),
              _buildSkillItem(theme, 'Frontend: Flutter + Riverpod'),
              _buildSkillItem(theme, 'Banco de Dados: SQL Server'),
              _buildSkillItem(theme, 'Automações: Python, Integrações'),
              _buildSkillItem(theme, 'BI: Power BI, Excel avançado'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildProjectsSection(ThemeData theme) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text('Projetos', style: theme.textTheme.headlineMedium),
        const SizedBox(height: 24),
        _buildProjectCard(
          theme,
          'Gestor de Ordens de Serviço',
          'Sistema .NET com API REST, autenticação JWT, persistência em SQL Server e interface Flutter para controle de ordens e tarefas.',
        ),
        _buildProjectCard(
          theme,
          'Dashboard Logístico',
          'Dashboard em Power BI com análise de suprimentos, performance de entregas e indicadores financeiros com base em dados SQL Server.',
        ),
        _buildProjectCard(
          theme,
          'Automação de PDFs e E-mails',
          'Script Python para ler PDFs de pedidos, extrair dados e enviar resumos automatizados via e-mail.',
        ),
      ],
    );
  }

  Widget _buildProjectCard(ThemeData theme, String title, String description) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.10),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.headlineSmall),
          const SizedBox(height: 12),
          Text(description, style: theme.textTheme.bodyMedium),
        ],
      ),
    );
  }

  // Renomeei a função para refletir que ela não lida mais diretamente com o Dio
  Future<void> _submitContactForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final contactRepo = ref.read(contactRepositoryProvider);
      contactRepo.sendContactMessage(
        name: _nameController.text,
        email: _emailController.text,
        message: _messageController.text,
      );

      // Sucesso!
      UiHelpers.showSnackBar('Mensagem enviada com sucesso!');

      _formKey.currentState?.reset();
      _nameController.clear();
      _emailController.clear();
      _messageController.clear();
    } catch (e) {
      UiHelpers.showSnackBar(
        'Erro ao enviar. Tente novamente mais tarde.',
        isError: true,
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }
}
