import 'package:flutter/material.dart';
import '../../../data/models/elevator_models.dart';
import '../../../data/services/mock_data_service.dart';

/// Dialog for searching and selecting an elevator
class ElevatorSearchDialog extends StatefulWidget {
  final Elevator? initialElevator;

  const ElevatorSearchDialog({
    super.key,
    this.initialElevator,
  });

  @override
  State<ElevatorSearchDialog> createState() => _ElevatorSearchDialogState();
}

class _ElevatorSearchDialogState extends State<ElevatorSearchDialog> {
  final _searchController = TextEditingController();
  List<Elevator> _filteredElevators = [];
  List<Elevator> _allElevators = [];
  Elevator? _selectedElevator;

  @override
  void initState() {
    super.initState();
    _selectedElevator = widget.initialElevator;
    _loadElevators();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _loadElevators() {
    // Load from mock data - in production, this would load from Supabase
    _allElevators = MockDataService.mockElevators;
    _filteredElevators = _allElevators;
  }

  void _filterElevators(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredElevators = _allElevators;
      } else {
        _filteredElevators = _allElevators.where((elevator) {
          final nameLower = elevator.name.toLowerCase();
          final companyLower = elevator.company.toLowerCase();
          final cityLower = (elevator.city ?? '').toLowerCase();
          final queryLower = query.toLowerCase();

          return nameLower.contains(queryLower) ||
              companyLower.contains(queryLower) ||
              cityLower.contains(queryLower);
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 600, maxHeight: 700),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(28),
                  topRight: Radius.circular(28),
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Search Grain Elevators',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimaryContainer,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ],
              ),
            ),

            // Search field
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Type elevator name, company, or city...',
                  prefixIcon: const Icon(Icons.search),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _searchController.clear();
                            _filterElevators('');
                          },
                        )
                      : null,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                ),
                onChanged: _filterElevators,
              ),
            ),

            // Info banner
            if (_searchController.text.isEmpty)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Showing ${_filteredElevators.length} elevators',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ),
                  ],
                ),
              ),

            const SizedBox(height: 8),

            // Elevator list
            Expanded(
              child: _filteredElevators.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search_off,
                            size: 64,
                            color: Theme.of(context).colorScheme.outline,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No elevators found',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try a different search term',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _filteredElevators.length,
                      itemBuilder: (context, index) {
                        final elevator = _filteredElevators[index];
                        final isSelected = _selectedElevator?.id == elevator.id;

                        return ListTile(
                          selected: isSelected,
                          leading: CircleAvatar(
                            backgroundColor: isSelected
                                ? Theme.of(context).colorScheme.primary
                                : Theme.of(context).colorScheme.primaryContainer,
                            child: Icon(
                              Icons.location_city,
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                          ),
                          title: Text(
                            elevator.name,
                            style: TextStyle(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            ),
                          ),
                          subtitle: Text(
                            '${elevator.company}${elevator.city != null ? ' • ${elevator.city}' : ''}',
                          ),
                          trailing: isSelected
                              ? Icon(
                                  Icons.check_circle,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : null,
                          onTap: () {
                            setState(() {
                              _selectedElevator = elevator;
                            });
                          },
                        );
                      },
                    ),
            ),

            // Action buttons
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: _selectedElevator != null
                          ? () => Navigator.of(context).pop(_selectedElevator)
                          : null,
                      child: const Text('Select'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
