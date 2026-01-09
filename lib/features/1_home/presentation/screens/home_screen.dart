import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_flutter/lucide_flutter.dart';
import 'package:portifolio/app/providers/theme_provider.dart';
import 'package:portifolio/app/providers/user_provider.dart';
import 'package:portifolio/app/providers/auth_provider.dart';
import 'package:portifolio/core/services/mixins/validator.dart';
import 'package:portifolio/core/utils/ui_helpers.dart';
import 'package:portifolio/features/1_home/data/repositories/contact_repository.dart';
import 'package:portifolio/features/1_home/presentation/providers/home_content.dart';
import 'package:portifolio/features/1_home/presentation/widgets/hero_card.dart';
import 'package:portifolio/shared/app_scaffold.dart';
import 'package:portifolio/shared/fab_action.dart';
import 'package:portifolio/shared/fab_route.dart';
import 'package:portifolio/shared/project_card.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with Validator {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  // Controladores para os campos de texto
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _messageController;

  // Controlador para o SingleChildScrollView
  late final ScrollController _scrollController;

  // Chaves globais para cada seção
  late final GlobalKey _heroKey;
  late final GlobalKey _aboutKey;
  late final GlobalKey _skillsKey;
  late final GlobalKey _projectsKey;
  late final GlobalKey _contactKey;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _messageController = TextEditingController();

    _scrollController = ScrollController();
    
    // Inicializar GlobalKeys no initState para evitar duplicação
    _heroKey = GlobalKey();
    _aboutKey = GlobalKey();
    _skillsKey = GlobalKey();
    _projectsKey = GlobalKey();
    _contactKey = GlobalKey();
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
    final loggedIn = ref.watch(authStateProvider).valueOrNull != null;

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
      navButtons: () {
        final items = <FabRoute>[
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
          FabRoute(
            label: 'Contato',
            onPressed: () => _scrollToSection(_contactKey),
            icon: LucideIcons.mail,
          ),
        ];
        if (loggedIn) {
          items.add(
            FabRoute(
              label: 'Admin',
              route: '/admin',
              icon: LucideIcons.settings,
            ),
          );
        }
        return items;
      }(),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 48.0,
              ),
              child: ref
                  .watch(homeContentStreamProvider)
                  .when(
                    data: (content) {
                      // Garantir que content não é null e tem estrutura esperada
                      if (content.isEmpty) {
                        return const Center(
                          child: Text('Nenhum conteúdo disponível'),
                        );
                      }
                      
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Seção Hero
                          Padding(
                            key: _heroKey,
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: HeroCard(
                              content: content["hero"] ?? {},
                              onPrimaryPressed: () =>
                                  _scrollToSection(_projectsKey),
                              onSecondaryPressed: () =>
                                  _scrollToSection(_contactKey),
                            ),
                          ),

                          // Seção Sobre
                          Padding(
                            key: _aboutKey,
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: _buildAboutSection(theme, content["about"] ?? {}),
                          ),

                          // Seção Habilidades
                          Padding(
                            key: _skillsKey,
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: _buildSkillsSection(theme, content["skills"] ?? {}),
                          ),

                          // Seção Projetos
                          Padding(
                            key: _projectsKey,
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: _buildProjectsSection(
                              theme,
                              content["projects"] ?? {},
                            ),
                          ),

                          // Seção Contato
                          Padding(
                            key: _contactKey,
                            padding: const EdgeInsets.symmetric(vertical: 40),
                            child: _buildContactSection(theme, content["links"] ?? []),
                          ),
                        ],
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (Object error, StackTrace stackTrace) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red,
                            ),
                            const SizedBox(height: 16),
                            const Text(
                              'Erro ao carregar conteúdo',
                              style: TextStyle(fontSize: 18),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              error.toString(),
                              textAlign: TextAlign.center,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkillItem(ThemeData theme, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('- ', style: theme.textTheme.bodyLarge),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  IconData _getIconData(String? iconName) {
    switch (iconName) {
      case "mail":
        return LucideIcons.mail;
      case "linkedin":
        return LucideIcons.linkedin;
      case "github":
        return LucideIcons.github;
      default:
        return LucideIcons.x;
    }
  }

  Widget _buildContactSection(ThemeData theme, List<dynamic> links) {
    final isDark = theme.brightness == Brightness.dark;

    final List<Widget> linkWidgets = links.map((link) {
      return IconButton(
        icon: Icon(
          _getIconData(link["icon"]),
          color: isDark ? theme.primaryColorDark : Colors.black,
        ),
        onPressed: () => _launchURL(link["url"] ?? ''),
        tooltip: link["tooltip"],
      );
    }).toList();

    return Column(
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
                  validator: validateEmail,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _messageController,
                  decoration: InputDecoration().copyWith(
                    hintText: 'Sua mensagem',
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
        // Ãcones de redes sociais
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 12,
          children: linkWidgets,
        ),
      ],
    );
  }

  Widget _buildAboutSection(
    ThemeData theme,
    Map<String, dynamic> aboutContent,
  ) {
    return Column(
      children: [
        const SizedBox(height: 40),
        Text(
          aboutContent["title"] ?? 'Sobre Mim',
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: 16),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Text(
            aboutContent["description"] ?? ' - ',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }

  Widget _buildSkillsSection(
    ThemeData theme,
    Map<String, dynamic> skillsContent,
  ) {
    final title = skillsContent["title"] ?? 'Habilidades';
    final List<dynamic> skills = skillsContent["items"] as List<dynamic>? ?? [];

    return Column(
      children: [
        const SizedBox(height: 40),
        Text(title, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 24),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: skills
                .map(
                  (skill) => _buildSkillItem(
                    theme,
                    '${skill["skill"]}: ${skill["items"]?.join(", ") ?? ""}',
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildProjectsSection(
    ThemeData theme,
    Map<String, dynamic> projectsContent,
  ) {
    final title = projectsContent["title"] ?? 'Projetos';
    final List<dynamic> projects =
        projectsContent["items"] as List<dynamic>? ?? [];

    return Column(
      children: [
        const SizedBox(height: 40),
        Text(title, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 24),

        for (final project in projects)
          ProjectCard(
            title: project["title"] ?? 'TÃ­tulo do Projeto',
            description: project["description"] ?? 'DescriÃ§Ã£o do Projeto',
          ),
      ],
    );
  }

  // Renomeei a funÃ§Ã£o para refletir que ela nÃ£o lida mais diretamente com o Dio
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
