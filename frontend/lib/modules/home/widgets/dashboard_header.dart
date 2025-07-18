import 'package:flutter/material.dart';
import 'package:frontend/core/models/usuario.dart';

class DashboardHeader extends StatelessWidget {
  final Usuario? currentUser;
  final VoidCallback onLogout;

  const DashboardHeader({super.key, required this.currentUser, required this.onLogout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E293B), Color(0xFF334155), Color(0xFF475569)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF22C55E).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF22C55E).withValues(alpha: 0.3)),
            ),
            child: const Icon(Icons.account_balance_wallet, color: Color(0xFF22C55E), size: 32),
          ),

          const SizedBox(width: 24),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EijiPay - Sistema de Folha de Pagamento',
                  style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 8),

                Text(
                  'Responsável: ${currentUser?.nome ?? "Usuário"}',
                  style: TextStyle(color: const Color(0xFF22C55E).withValues(alpha: 0.9), fontSize: 16, fontWeight: FontWeight.w500),
                ),

                const SizedBox(height: 4),

                Text('Sistema de gestão empresarial', style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 14)),
              ],
            ),
          ),

          Container(
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(12)),
            child: IconButton(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, color: Colors.white),
              tooltip: 'Sair do sistema',
            ),
          ),
        ],
      ),
    );
  }
}
