import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final String userName = "Lucas Maia";
  final String companyName = "EijiPay - Sistema de Folha de Pagamento";
  final String currentPeriod = "Julho 2025";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header do sistema
              _buildHeader(),
              const SizedBox(height: 32),

              // Três módulos principais
              _buildMainModules(),
              const SizedBox(height: 32),

              // Dashboard com informações essenciais
              // Row(
              //   crossAxisAlignment: CrossAxisAlignment.start,
              //   children: [
              //     Expanded(flex: 2, child: _buildPayrollOverview()),
              //     const SizedBox(width: 24),
              //     Expanded(flex: 1, child: _buildQuickStats()),
              //   ],
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF1E40AF), Color(0xFF3B82F6), Color(0xFF60A5FA)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.3)),
            ),
            child: const Icon(Icons.business_center, color: Colors.white, size: 40),
          ),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EijiPay',
                  style: TextStyle(color: Colors.white, fontSize: 32, fontWeight: FontWeight.bold, letterSpacing: 1.2),
                ),
                const SizedBox(height: 8),
                Text(
                  'Sistema Completo de Folha de Pagamento',
                  style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 18, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                Text('Responsável: $userName • $currentPeriod', style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14)),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [BoxShadow(color: const Color(0xFF10B981).withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))],
            ),
            child: const Text(
              'SISTEMA ATIVO',
              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold, letterSpacing: 0.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainModules() {
    return Row(
      children: [
        Expanded(
          child: _buildModuleCard('CALCULAR FOLHA', 'Processamento completo da folha de pagamento', Icons.calculate, const Color(0xFF059669), [
            'Cálculo automático de salários',
            'Descontos e benefícios',
            'Horas extras e faltas',
            'Geração de holerites',
          ]),
        ),
        const SizedBox(width: 24),
        Expanded(
          child: _buildModuleCard('CONTROLAR FUNCIONÁRIOS', 'Gestão completa do quadro de pessoal', Icons.people, const Color(0xFF3B82F6), [
            'Cadastro de funcionários',
            'Controle de admissões',
            'Gestão de demissões',
            'Histórico trabalhista',
          ]),
        ),
        const SizedBox(width: 24),
        Expanded(child: _buildModuleCard('OBRIGAÇÕES ACESSÓRIAS', 'Envio de documentos fiscais e trabalhistas', Icons.send, const Color(0xFF7C3AED), ['eSocial e SEFIP', 'FGTS e INSS', 'RAIS e CAGED', 'Relatórios fiscais'])),
      ],
    );
  }

  Widget _buildModuleCard(String title, String description, IconData icon, Color color, List<String> features) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [BoxShadow(color: color.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 8))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(16)),
            child: Icon(icon, color: color, size: 32),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color, letterSpacing: 0.5),
          ),
          const SizedBox(height: 12),
          Text(description, style: const TextStyle(fontSize: 14, color: Color(0xFF64748B), height: 1.4)),
          const SizedBox(height: 20),
          ...features.map(
            (feature) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(fontSize: 13, color: Color(0xFF475569), fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text('ACESSAR MÓDULO', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 0.5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayrollOverview() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(color: const Color(0xFF3B82F6).withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.dashboard, color: Color(0xFF3B82F6), size: 24),
              ),
              const SizedBox(width: 16),
              const Text(
                'Visão Geral da Folha',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
              ),
            ],
          ),
          const SizedBox(height: 28),

          // Métricas principais
          Row(
            children: [
              Expanded(child: _buildOverviewMetric('Funcionários Ativos', '247', Icons.people, const Color(0xFF3B82F6))),
              const SizedBox(width: 20),
              Expanded(child: _buildOverviewMetric('Custo Total Mensal', 'R\$ 156.840', Icons.attach_money, const Color(0xFF059669))),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(child: _buildOverviewMetric('Horas Trabalhadas', '45.680h', Icons.schedule, const Color(0xFF7C3AED))),
              const SizedBox(width: 20),
              Expanded(child: _buildOverviewMetric('Pendências', '12', Icons.warning, const Color(0xFFDC2626))),
            ],
          ),

          const SizedBox(height: 28),

          // Status da folha atual
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [const Color(0xFF059669).withOpacity(0.1), const Color(0xFF10B981).withOpacity(0.1)]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFF059669).withOpacity(0.2)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: const Color(0xFF059669).withOpacity(0.2), borderRadius: BorderRadius.circular(10)),
                  child: const Icon(Icons.check_circle, color: Color(0xFF059669), size: 20),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Folha de Julho 2025',
                        style: TextStyle(color: Color(0xFF059669), fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text('Processamento concluído • Holerites gerados', style: TextStyle(color: const Color(0xFF059669).withOpacity(0.8), fontSize: 13)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF059669),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    elevation: 0,
                  ),
                  child: const Text('Ver Detalhes', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewMetric(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(color: Color(0xFF64748B), fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 15, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ações Rápidas',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF0F172A)),
          ),
          const SizedBox(height: 24),

          _buildQuickAction('Novo Funcionário', 'Cadastrar funcionário', Icons.person_add, const Color(0xFF3B82F6)),
          const SizedBox(height: 16),

          _buildQuickAction('Calcular Folha', 'Processar folha atual', Icons.calculate, const Color(0xFF059669)),
          const SizedBox(height: 16),

          _buildQuickAction('Enviar eSocial', 'Transmitir eventos', Icons.cloud_upload, const Color(0xFF7C3AED)),

          const SizedBox(height: 28),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFBBF24).withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, color: Color(0xFFD97706), size: 20),
                    const SizedBox(width: 8),
                    const Text(
                      'Próximos Vencimentos',
                      style: TextStyle(color: Color(0xFFD97706), fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text('• FGTS: 07/07/2025\n• INSS: 15/07/2025\n• eSocial: 20/07/2025', style: TextStyle(color: Color(0xFFD97706), fontSize: 12, height: 1.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickAction(String title, String subtitle, IconData icon, Color color) {
    return InkWell(
      onTap: () {},
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withOpacity(0.1)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(color: color, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  Text(subtitle, style: TextStyle(color: color.withOpacity(0.7), fontSize: 11)),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: color, size: 16),
          ],
        ),
      ),
    );
  }
}
