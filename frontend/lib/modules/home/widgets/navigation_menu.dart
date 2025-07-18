import 'package:flutter/material.dart';

class NavigationMenu extends StatelessWidget {
  final VoidCallback onFuncionariosPressed;
  final VoidCallback onFolhaPressed;

  const NavigationMenu({super.key, required this.onFuncionariosPressed, required this.onFolhaPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: const Color(0xFF3B82F6).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                child: const Icon(Icons.dashboard, color: Color(0xFF3B82F6), size: 20),
              ),
              const SizedBox(width: 12),
              const Text(
                'Menu Principal',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),

          const SizedBox(height: 24),

          _NavigationCard(title: 'Funcionários', subtitle: 'Gerenciar funcionários da empresa', icon: Icons.people_alt, color: const Color(0xFF3B82F6), onTap: onFuncionariosPressed),

          const SizedBox(height: 16),

          _NavigationCard(title: 'Folha de Pagamento', subtitle: 'Calcular e processar folha', icon: Icons.receipt_long, color: const Color(0xFF059669), isWip: true, onTap: onFolhaPressed),
        ],
      ),
    );
  }
}

class _NavigationCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final bool isWip;
  final VoidCallback onTap;

  const _NavigationCard({required this.title, required this.subtitle, required this.icon, required this.color, required this.onTap, this.isWip = false});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 28),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
                        ),
                        if (isWip) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(color: const Color(0xFFEA580C).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
                            child: const Text(
                              'WIP',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Color(0xFFEA580C)),
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(subtitle, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B))),
                  ],
                ),
              ),

              Icon(Icons.arrow_forward_ios, color: color.withValues(alpha: 0.6), size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
