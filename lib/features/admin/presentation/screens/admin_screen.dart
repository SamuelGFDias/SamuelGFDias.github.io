// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_flutter/lucide_flutter.dart';

import 'package:portifolio/app/providers/auth_provider.dart';
import 'package:portifolio/core/repositories/content_repository.dart';
import 'package:portifolio/core/repositories/firestore_content_repository.dart';
import 'package:portifolio/features/1_home/presentation/providers/home_content.dart';
import 'package:portifolio/shared/app_scaffold.dart';
import 'package:portifolio/shared/fab_action.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen> {
  final _aboutDescription = TextEditingController();
  final _aboutTitle = TextEditingController();
  Map<String, dynamic> _form = {
    'hero': {'title': '', 'subtitle': ''},
    'about': {'title': '', 'description': ''},
    'skills': {'title': '', 'items': <Map<String, dynamic>>[]},
    'projects': {'title': '', 'items': <Map<String, dynamic>>[]},
    'links': <Map<String, dynamic>>[],
  };

  final _heroSubtitle = TextEditingController();
  final _heroTitle = TextEditingController();
  bool _loading = true;

  @override
  void dispose() {
    _heroTitle.dispose();
    _heroSubtitle.dispose();
    _aboutTitle.dispose();
    _aboutDescription.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadContent();
  }

  Future<void> _loadContent() async {
    setState(() => _loading = true);
    try {
      // Admin SEMPRE carrega do Firestore (ou via Functions)
      final repo = ref.read(firestoreContentRepositoryProvider);
      final data = await repo.getHome();

      if (data != null) {
        _applyData(data);
      } else {
        // Fallback: carregar de assets se Firestore vazio
        final localData = await ref.read(homeContentProvider.future);
        _applyData(localData);
      }
    } catch (e) {
      if (!mounted) return;

      // Erro ao carregar: tentar fallback
      try {
        final localData = await ref.read(homeContentProvider.future);
        _applyData(localData);
      } catch (fallbackError) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: $fallbackError'),
            backgroundColor: Colors.orange,
          ),
        );

        if (kDebugMode) {
          print('Erro ao carregar dados do Firestore: $e');
          print('Erro ao carregar dados locais: $fallbackError');
        }
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  void _applyData(Map<String, dynamic> data) {
    if (!mounted) return;

    _form = {
      'hero': Map<String, dynamic>.from(data['hero'] ?? {}),
      'about': Map<String, dynamic>.from(data['about'] ?? {}),
      'skills': {
        'title': (data['skills'] ?? const {})['title'] ?? '',
        'items': List<Map<String, dynamic>>.from(
          ((data['skills'] ?? const {})['items'] ?? const <dynamic>[])
              .map<Map<String, dynamic>>(
                (e) => Map<String, dynamic>.from(e as Map),
              ),
        ),
      },
      'projects': {
        'title': (data['projects'] ?? const {})['title'] ?? '',
        'items': List<Map<String, dynamic>>.from(
          ((data['projects'] ?? const {})['items'] ?? const <dynamic>[])
              .map<Map<String, dynamic>>(
                (e) => Map<String, dynamic>.from(e as Map),
              ),
        ),
      },
      'links': List<Map<String, dynamic>>.from(
        (data['links'] ?? const <dynamic>[]).map<Map<String, dynamic>>(
          (e) => Map<String, dynamic>.from(e as Map),
        ),
      ),
    };

    _heroTitle.text = _form['hero']['title'] ?? '';
    _heroSubtitle.text = _form['hero']['subtitle'] ?? '';
    _aboutTitle.text = _form['about']['title'] ?? '';
    _aboutDescription.text = _form['about']['description'] ?? '';
    setState(() {});
  }

  Map<String, dynamic> _buildPayload() {
    return {
      'hero': {
        'title': _heroTitle.text.trim(),
        'subtitle': _heroSubtitle.text.trim(),
      },
      'about': {
        'title': _aboutTitle.text.trim(),
        'description': _aboutDescription.text.trim(),
      },
      'skills': {
        'title': (_form['skills']['title'] ?? '').toString(),
        'items': List<Map<String, dynamic>>.from(
          _form['skills']['items'] as List,
        ),
      },
      'projects': {
        'title': (_form['projects']['title'] ?? '').toString(),
        'items': List<Map<String, dynamic>>.from(
          _form['projects']['items'] as List,
        ),
      },
      'links': List<Map<String, dynamic>>.from(_form['links'] as List),
    };
  }

  Future<void> _publish() async {
    // Admin SEMPRE usa Firestore para salvar, nunca assets locais
    final repo = ref.read(firestoreContentRepositoryProvider);
    final payload = _buildPayload();

    setState(() => _loading = true);

    try {
      await repo.setHome(payload);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✅ Conteúdo publicado no Firestore com sucesso!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 3),
        ),
      );

      // Recarregar dados para confirmar
      await _loadContent();
    } catch (e) {
      if (!mounted) return;

      String errorMessage = 'Falha ao publicar: $e';

      // Mensagens específicas para erros comuns
      if (e.toString().contains('permission-denied')) {
        errorMessage = 'Sem permissão. Verifique se você é admin.';
      } else if (e.toString().contains('network-request-failed')) {
        errorMessage = 'Erro de conexão. Verifique sua internet.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Widget _buildAdminContent(BuildContext context) {
    return AppScaffold(
      title: 'Admin',
      actions: [
        FabAction(
          onPressed: () => _importJson(),
          label: 'Importar JSON',
          icon: LucideIcons.download,
        ),
        FabAction(
          onPressed: () => _exportJson(),
          label: 'Exportar JSON',
          icon: LucideIcons.cloudUpload,
        ),
        FabAction(
          onPressed: _loading ? null : () => _loadContent(),
          label: 'Recarregar',
          icon: LucideIcons.refreshCw,
        ),
        FabAction(
          onPressed: _loading ? null : () => _publish(),
          label: 'Publicar',
          icon: LucideIcons.cloudUpload,
        ),
        FabAction(
          onPressed: () async {
            await ref.read(authControllerProvider.notifier).signOut();
            if (context.mounted) {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text('Logout efetuado')));
            }
          },
          label: 'Sair',
          icon: LucideIcons.logOut,
        ),
      ],
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: ListView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 20,
                  ),
                  children: [
                    Text(
                      'Painel Administrativo',
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    const SizedBox(height: 16),

                    _SectionCard(
                      title: 'Hero',
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _heroTitle,
                              decoration: const InputDecoration(
                                labelText: 'Título',
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextField(
                              controller: _heroSubtitle,
                              decoration: const InputDecoration(
                                labelText: 'Subtítulo',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    _SectionCard(
                      title: 'Sobre',
                      child: Column(
                        children: [
                          TextField(
                            controller: _aboutTitle,
                            decoration: const InputDecoration(
                              labelText: 'Título',
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _aboutDescription,
                            maxLines: 5,
                            decoration: const InputDecoration(
                              labelText: 'Descrição',
                            ),
                          ),
                        ],
                      ),
                    ),

                    _SectionCard(
                      title: 'Habilidades',
                      actions: [
                        IconButton(
                          tooltip: 'Adicionar grupo',
                          onPressed: () {
                            final groups = List<Map<String, dynamic>>.from(
                              _form['skills']['items'] as List,
                            );
                            groups.add({
                              'skill': 'Novo grupo',
                              'items': <String>['Item'],
                            });
                            setState(() => _form['skills']['items'] = groups);
                          },
                          icon: const Icon(LucideIcons.plus),
                        ),
                      ],
                      child: _SkillsEditor(
                        title: (_form['skills']['title'] ?? '').toString(),
                        groups: List<Map<String, dynamic>>.from(
                          _form['skills']['items'] as List,
                        ),
                        onTitleChanged: (v) => _form['skills']['title'] = v,
                        onChanged: (groups) =>
                            setState(() => _form['skills']['items'] = groups),
                      ),
                    ),

                    _SectionCard(
                      title: 'Projetos',
                      actions: [
                        IconButton(
                          tooltip: 'Adicionar projeto',
                          onPressed: () {
                            final items = List<Map<String, dynamic>>.from(
                              _form['projects']['items'] as List,
                            );
                            items.add({
                              'title': 'Novo projeto',
                              'description': '',
                            });
                            setState(() => _form['projects']['items'] = items);
                          },
                          icon: const Icon(LucideIcons.plus),
                        ),
                      ],
                      child: _ProjectsEditor(
                        title: (_form['projects']['title'] ?? '').toString(),
                        projects: List<Map<String, dynamic>>.from(
                          _form['projects']['items'] as List,
                        ),
                        onTitleChanged: (v) => _form['projects']['title'] = v,
                        onChanged: (items) =>
                            setState(() => _form['projects']['items'] = items),
                      ),
                    ),

                    _SectionCard(
                      title: 'Links',
                      actions: [
                        IconButton(
                          tooltip: 'Adicionar link',
                          onPressed: () {
                            final items = List<Map<String, dynamic>>.from(
                              _form['links'] as List,
                            );
                            items.add({
                              'icon': 'github',
                              'url': 'https://',
                              'tooltip': 'GitHub',
                            });
                            setState(() => _form['links'] = items);
                          },
                          icon: const Icon(LucideIcons.plus),
                        ),
                      ],
                      child: _LinksEditor(
                        links: List<Map<String, dynamic>>.from(
                          _form['links'] as List,
                        ),
                        onChanged: (items) =>
                            setState(() => _form['links'] = items),
                      ),
                    ),

                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FilledButton.icon(
                        onPressed: _loading ? null : () => _publish(),
                        icon: const Icon(LucideIcons.save),
                        label: const Text('Publicar alterações'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Future<void> _importJson() async {
    final uploadInput = html.FileUploadInputElement()
      ..accept = 'application/json';
    uploadInput.click();
    await uploadInput.onChange.first;
    final file = uploadInput.files?.first;
    if (file == null) return;
    final reader = html.FileReader()..readAsText(file);
    await reader.onLoad.first;
    try {
      final text = reader.result as String;
      final data = jsonDecode(text) as Map;
      _applyData(Map<String, dynamic>.from(data));
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Importado com sucesso.')));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Falha ao importar: $e')));
    }
  }

  void _exportJson() {
    final payload = _buildPayload();
    final content = const JsonEncoder.withIndent('  ').convert(payload);
    final bytes = html.Blob([content], 'application/json');
    final url = html.Url.createObjectUrlFromBlob(bytes);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute('download', 'home.json')
      ..click();
    html.Url.revokeObjectUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    // Defense in depth: verificar se é admin mesmo que o router permita
    final isAdminAsync = ref.watch(isAdminProvider);

    return isAdminAsync.when(
      data: (isAdmin) {
        if (!isAdmin) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    LucideIcons.shieldAlert,
                    size: 64,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Acesso Negado',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text('Você não tem permissão para acessar esta área.'),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    onPressed: () async {
                      await ref.read(authControllerProvider.notifier).signOut();
                      if (context.mounted) {
                        context.go('/');
                      }
                    },
                    icon: const Icon(LucideIcons.logOut),
                    label: const Text('Voltar'),
                  ),
                ],
              ),
            ),
          );
        }

        return _buildAdminContent(context);
      },
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) => Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                LucideIcons.circleAlert,
                size: 64,
                color: Colors.orange,
              ),
              const SizedBox(height: 16),
              Text('Erro ao verificar permissões: $error'),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text('Voltar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.actions});

  final List<Widget>? actions;
  final Widget child;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(title, style: Theme.of(context).textTheme.titleLarge),
                const Spacer(),
                if (actions != null) ...actions!,
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

class _SkillsEditor extends StatelessWidget {
  const _SkillsEditor({
    required this.title,
    required this.groups,
    required this.onTitleChanged,
    required this.onChanged,
  });

  final List<Map<String, dynamic>> groups;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;
  final ValueChanged<String> onTitleChanged;
  final String title;

  @override
  Widget build(BuildContext context) {
    final editable = groups.map((g) => Map<String, dynamic>.from(g)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: TextEditingController(text: title),
          onChanged: onTitleChanged,
          decoration: const InputDecoration(labelText: 'Título da seção'),
        ),
        const SizedBox(height: 12),
        ...editable.asMap().entries.map((entry) {
          final i = entry.key;
          final g = entry.value;
          final items = List<String>.from(
            g['items']?.cast<String>() ?? <String>[],
          );
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(
                            text: g['skill']?.toString() ?? '',
                          ),
                          onChanged: (v) => g['skill'] = v,
                          decoration: const InputDecoration(
                            labelText: 'Nome do grupo',
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remover grupo',
                        onPressed: () {
                          final next = List<Map<String, dynamic>>.from(
                            editable,
                          );
                          next.removeAt(i);
                          onChanged(next);
                        },
                        icon: const Icon(LucideIcons.trash2, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ...items.asMap().entries.map((e) {
                    final idx = e.key;
                    final text = e.value;
                    return Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: TextEditingController(text: text),
                            onChanged: (v) {
                              items[idx] = v;
                              g['items'] = items;
                            },
                            decoration: const InputDecoration(
                              labelText: 'Item',
                            ),
                          ),
                        ),
                        IconButton(
                          tooltip: 'Remover item',
                          onPressed: () {
                            final next = List<Map<String, dynamic>>.from(
                              editable,
                            );
                            items.removeAt(idx);
                            g['items'] = items;
                            next[i] = g;
                            onChanged(next);
                          },
                          icon: const Icon(LucideIcons.x, color: Colors.black),
                        ),
                      ],
                    );
                  }),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () {
                        final next = List<Map<String, dynamic>>.from(editable);
                        items.add('Novo item');
                        g['items'] = items;
                        next[i] = g;
                        onChanged(next);
                      },
                      icon: const Icon(LucideIcons.plus, color: Colors.black),
                      label: const Text('Adicionar item'),
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _ProjectsEditor extends StatelessWidget {
  const _ProjectsEditor({
    required this.title,
    required this.projects,
    required this.onTitleChanged,
    required this.onChanged,
  });

  final ValueChanged<List<Map<String, dynamic>>> onChanged;
  final ValueChanged<String> onTitleChanged;
  final List<Map<String, dynamic>> projects;
  final String title;

  @override
  Widget build(BuildContext context) {
    final editable = projects.map((p) => Map<String, dynamic>.from(p)).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: TextEditingController(text: title),
          onChanged: onTitleChanged,
          decoration: const InputDecoration(labelText: 'Título da seção'),
        ),
        const SizedBox(height: 12),
        ...editable.asMap().entries.map((entry) {
          final i = entry.key;
          final p = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(
                            text: p['title']?.toString() ?? '',
                          ),
                          onChanged: (v) => p['title'] = v,
                          decoration: const InputDecoration(
                            labelText: 'Título',
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remover projeto',
                        onPressed: () {
                          final next = List<Map<String, dynamic>>.from(
                            editable,
                          );
                          next.removeAt(i);
                          onChanged(next);
                        },
                        icon: const Icon(LucideIcons.trash2, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(
                      text: p['description']?.toString() ?? '',
                    ),
                    onChanged: (v) => p['description'] = v,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}

class _LinksEditor extends StatelessWidget {
  const _LinksEditor({required this.links, required this.onChanged});

  final List<Map<String, dynamic>> links;
  final ValueChanged<List<Map<String, dynamic>>> onChanged;

  @override
  Widget build(BuildContext context) {
    final editable = links.map((l) => Map<String, dynamic>.from(l)).toList();
    return Column(
      children: [
        ...editable.asMap().entries.map((entry) {
          final i = entry.key;
          final l = entry.value;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: TextEditingController(
                            text: l['icon']?.toString() ?? '',
                          ),
                          onChanged: (v) => l['icon'] = v,
                          decoration: const InputDecoration(
                            labelText: 'Ícone (mail, linkedin, github)',
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: 'Remover dd',
                        onPressed: () {
                          final next = List<Map<String, dynamic>>.from(
                            editable,
                          );
                          next.removeAt(i);
                          onChanged(next);
                        },
                        icon: const Icon(LucideIcons.trash2, color: Colors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(
                      text: l['url']?.toString() ?? '',
                    ),
                    onChanged: (v) => l['url'] = v,
                    decoration: const InputDecoration(labelText: 'URL'),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: TextEditingController(
                      text: l['tooltip']?.toString() ?? '',
                    ),
                    onChanged: (v) => l['tooltip'] = v,
                    decoration: const InputDecoration(labelText: 'Tooltip'),
                  ),
                ],
              ),
            ),
          );
        }),
      ],
    );
  }
}
