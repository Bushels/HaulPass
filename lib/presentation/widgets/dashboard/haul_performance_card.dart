import 'package:flutter/material.dart';

class HaulPerformanceCard extends StatefulWidget {
  final Duration averageLoadTime;
  final double weightDifference;
  final double averageMoisture;
  final double averageDockage;
  final double binMoisture;

  const HaulPerformanceCard({
    super.key,
    required this.averageLoadTime,
    required this.weightDifference,
    required this.averageMoisture,
    required this.averageDockage,
    required this.binMoisture,
  });

  @override
  State<HaulPerformanceCard> createState() => _HaulPerformanceCardState();
}

class _HaulPerformanceCardState extends State<HaulPerformanceCard> {
  String _selectedGrainType = 'All Grains';

  // Mock data for different grain types
  final Map<String, Map<String, dynamic>> _grainData = {
    'All Grains': {
      'loadTime': 23,
      'driveTime': 17,
      'waitTime': 22,
      'roundTrip': 85,
      'moisture': 14.2,
      'dockage': 1.8,
    },
    'Wheat': {
      'loadTime': 25,
      'driveTime': 17,
      'waitTime': 20,
      'roundTrip': 82,
      'moisture': 13.5,
      'dockage': 1.5,
    },
    'Canola': {
      'loadTime': 21,
      'driveTime': 17,
      'waitTime': 24,
      'roundTrip': 88,
      'moisture': 9.8,
      'dockage': 2.1,
    },
    'Barley': {
      'loadTime': 22,
      'driveTime': 17,
      'waitTime': 25,
      'roundTrip': 87,
      'moisture': 14.8,
      'dockage': 1.6,
    },
  };

  @override
  Widget build(BuildContext context) {
    final data = _grainData[_selectedGrainType]!;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF667EEA).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.speed_rounded,
                      color: Color(0xFF667EEA),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'Performance',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              _buildGrainTypeSelector(),
            ],
          ),
          const SizedBox(height: 20),

          // Timing Metrics
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildMetricRow(
                  icon: Icons.agriculture,
                  label: 'Avg Binyard Load Time',
                  value: '${data['loadTime']} min',
                  color: const Color(0xFF10B981),
                ),
                const SizedBox(height: 12),
                _buildMetricRow(
                  icon: Icons.directions_car,
                  label: 'Avg Drive Time',
                  value: '${data['driveTime']} min',
                  color: const Color(0xFF3B82F6),
                ),
                const SizedBox(height: 12),
                _buildMetricRow(
                  icon: Icons.timer_outlined,
                  label: 'Avg Wait Time',
                  value: '${data['waitTime']} min',
                  color: const Color(0xFFF59E0B),
                ),
                const SizedBox(height: 16),
                const Divider(height: 1),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF667EEA), Color(0xFF764BA2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.loop,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      const Expanded(
                        child: Text(
                          'Avg Round Trip',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        '${data['roundTrip']} min',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Quality Metrics
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.water_drop_outlined,
                            color: const Color(0xFF059669),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Avg Moisture',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFF059669),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${data['moisture']}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF065F46),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.grain_outlined,
                            color: const Color(0xFFD97706),
                            size: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Avg Dockage',
                            style: TextStyle(
                              fontSize: 12,
                              color: const Color(0xFFD97706),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${data['dockage']}%',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGrainTypeSelector() {
    return PopupMenuButton<String>(
      onSelected: (value) {
        setState(() {
          _selectedGrainType = value;
        });
      },
      itemBuilder: (context) => [
        'All Grains',
        'Wheat',
        'Canola',
        'Barley',
      ].map((grain) {
        return PopupMenuItem<String>(
          value: grain,
          child: Row(
            children: [
              Icon(
                Icons.grain,
                size: 18,
                color: _selectedGrainType == grain
                    ? const Color(0xFF667EEA)
                    : Colors.grey,
              ),
              const SizedBox(width: 12),
              Text(
                grain,
                style: TextStyle(
                  fontWeight: _selectedGrainType == grain
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: _selectedGrainType == grain
                      ? const Color(0xFF667EEA)
                      : Colors.black,
                ),
              ),
            ],
          ),
        );
      }).toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF667EEA).withOpacity(0.1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF667EEA).withOpacity(0.3),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.grain,
              size: 16,
              color: const Color(0xFF667EEA),
            ),
            const SizedBox(width: 6),
            Text(
              _selectedGrainType,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF667EEA),
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.arrow_drop_down,
              size: 18,
              color: const Color(0xFF667EEA),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
          ),
        ),
      ],
    );
  }
}
