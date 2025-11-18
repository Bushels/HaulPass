import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Quick-start haul workflow with optional data collection
/// Designed for easy farmer use with skip options
class StartHaulScreen extends ConsumerStatefulWidget {
  const StartHaulScreen({super.key});

  @override
  ConsumerState<StartHaulScreen> createState() => _StartHaulScreenState();
}

class _StartHaulScreenState extends ConsumerState<StartHaulScreen> {
  final _pageController = PageController();
  int _currentPage = 0;

  // Form controllers
  final _grainTypeController = TextEditingController();
  final _weightController = TextEditingController();
  final _notesController = TextEditingController();

  // Form values
  String? _selectedTruck;
  String? _selectedElevator;
  String? _moistureSource;
  bool _skipOptionalFields = false;

  @override
  void dispose() {
    _pageController.dispose();
    _grainTypeController.dispose();
    _weightController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Start Load'),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (_currentPage > 0)
            TextButton(
              onPressed: _handleSkipAll,
              child: const Text('Skip All'),
            ),
        ],
      ),
      body: Column(
        children: [
          _buildProgressIndicator(),
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (page) => setState(() => _currentPage = page),
              children: [
                _buildTruckSelectionPage(),
                _buildElevatorSelectionPage(),
                _buildLoadDetailsPage(),
                _buildConfirmationPage(),
              ],
            ),
          ),
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: List.generate(4, (index) {
          final isActive = index <= _currentPage;
          final isCompleted = index < _currentPage;

          return Expanded(
            child: Row(
              children: [
                Expanded(
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    height: 4,
                    decoration: BoxDecoration(
                      color: isActive
                          ? const Color(0xFF667EEA)
                          : const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                if (index < 3) const SizedBox(width: 8),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTruckSelectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Select Your Truck',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose which truck you\'re using for this load',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          // Mock truck list - TODO: Replace with actual truck data
          _buildTruckOption('Truck 1', 'Ford F-350', true),
          const SizedBox(height: 12),
          _buildTruckOption('Truck 2', 'Chevy Silverado 3500', false),
          const SizedBox(height: 24),

          OutlinedButton.icon(
            onPressed: () {
              // TODO: Add new truck
            },
            icon: const Icon(Icons.add),
            label: const Text('Add New Truck'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTruckOption(String name, String model, bool isSelected) {
    return GestureDetector(
      onTap: () => setState(() => _selectedTruck = name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (_selectedTruck == name) ? const Color(0xFF667EEA).withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (_selectedTruck == name)
                ? const Color(0xFF667EEA)
                : const Color(0xFFE2E8F0),
            width: 2,
          ),
          boxShadow: (_selectedTruck == name)
              ? [
                  BoxShadow(
                    color: const Color(0xFF667EEA).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (_selectedTruck == name)
                    ? const Color(0xFF667EEA)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.local_shipping,
                color: (_selectedTruck == name) ? Colors.white : const Color(0xFF64748B),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: (_selectedTruck == name)
                          ? const Color(0xFF667EEA)
                          : const Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    model,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedTruck == name)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF667EEA),
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildElevatorSelectionPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Where are you hauling?',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select your destination elevator',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          // Favorite elevators section
          const Text(
            'Favorites',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),

          _buildElevatorOption(
            'Prairie Gold Co-op',
            '18 min wait • 3 trucks',
            true,
          ),
          const SizedBox(height: 12),
          _buildElevatorOption(
            'Viterra - Brandon',
            '25 min wait • 5 trucks',
            false,
          ),
          const SizedBox(height: 24),

          OutlinedButton.icon(
            onPressed: () {
              // TODO: Search for elevator
              context.push('/elevators');
            },
            icon: const Icon(Icons.search),
            label: const Text('Search All Elevators'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildElevatorOption(String name, String info, bool isFavorite) {
    return GestureDetector(
      onTap: () => setState(() => _selectedElevator = name),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: (_selectedElevator == name)
              ? const Color(0xFF10B981).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: (_selectedElevator == name)
                ? const Color(0xFF10B981)
                : const Color(0xFFE2E8F0),
            width: 2,
          ),
          boxShadow: (_selectedElevator == name)
              ? [
                  BoxShadow(
                    color: const Color(0xFF10B981).withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: (_selectedElevator == name)
                    ? const Color(0xFF10B981)
                    : const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.business,
                color: (_selectedElevator == name) ? Colors.white : const Color(0xFF64748B),
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: (_selectedElevator == name)
                                ? const Color(0xFF10B981)
                                : const Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      if (isFavorite)
                        Icon(
                          Icons.star,
                          color: const Color(0xFFFBBF24),
                          size: 20,
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    info,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (_selectedElevator == name)
              const Icon(
                Icons.check_circle,
                color: Color(0xFF10B981),
                size: 28,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadDetailsPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Load Details',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Optional - but helps improve your insights',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _skipOptionalFields = true),
                child: const Text('Skip'),
              ),
            ],
          ),
          const SizedBox(height: 32),

          TextFormField(
            controller: _grainTypeController,
            decoration: InputDecoration(
              labelText: 'Grain Type',
              hintText: 'e.g., Wheat, Canola, Barley',
              prefixIcon: const Icon(Icons.agriculture),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _weightController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Estimated Weight (tonnes)',
              hintText: 'e.g., 11.5',
              prefixIcon: const Icon(Icons.scale),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),

          Text(
            'Moisture Source',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildMoistureOption('From Bin', 'bin'),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildMoistureOption('At Elevator', 'elevator'),
              ),
            ],
          ),
          const SizedBox(height: 16),

          TextFormField(
            controller: _notesController,
            maxLines: 3,
            decoration: InputDecoration(
              labelText: 'Notes (Optional)',
              hintText: 'Any additional notes about this load',
              prefixIcon: const Icon(Icons.note),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoistureOption(String label, String value) {
    final isSelected = _moistureSource == value;

    return GestureDetector(
      onTap: () => setState(() => _moistureSource = value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF667EEA).withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF667EEA)
                : const Color(0xFFE2E8F0),
            width: 2,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: isSelected
                  ? const Color(0xFF667EEA)
                  : const Color(0xFF64748B),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmationPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(
            Icons.check_circle,
            size: 64,
            color: Color(0xFF10B981),
          ),
          const SizedBox(height: 16),
          const Text(
            'Ready to Start!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Review your load details below',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 32),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                _buildSummaryRow('Truck', _selectedTruck ?? 'Not selected'),
                const Divider(height: 24),
                _buildSummaryRow('Elevator', _selectedElevator ?? 'Not selected'),
                if (_grainTypeController.text.isNotEmpty) ...[
                  const Divider(height: 24),
                  _buildSummaryRow('Grain Type', _grainTypeController.text),
                ],
                if (_weightController.text.isNotEmpty) ...[
                  const Divider(height: 24),
                  _buildSummaryRow('Weight', '${_weightController.text} tonnes'),
                ],
              ],
            ),
          ),
          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.info_outline,
                  color: Color(0xFF059669),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Tap "Start Load" when you begin loading grain onto your truck',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF065F46),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            if (_currentPage > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Back'),
                ),
              ),
            if (_currentPage > 0) const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: FilledButton(
                onPressed: _handleNext,
                style: FilledButton.styleFrom(
                  backgroundColor: _currentPage == 3
                      ? const Color(0xFF10B981)
                      : const Color(0xFF667EEA),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(
                  _currentPage == 3 ? 'Start Load' : 'Continue',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleNext() {
    if (_currentPage < 3) {
      // Validate current page
      if (_currentPage == 0 && _selectedTruck == null) {
        _showError('Please select a truck');
        return;
      }
      if (_currentPage == 1 && _selectedElevator == null) {
        _showError('Please select an elevator');
        return;
      }

      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      _handleStartLoad();
    }
  }

  void _handleSkipAll() {
    _pageController.animateToPage(
      3,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _handleStartLoad() {
    // TODO: Create haul session and navigate to timer
    context.go('/timer');
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFFEF4444),
      ),
    );
  }
}
