import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/circle_provider.dart';
import '../providers/item_provider.dart';
import '../widgets/item_card.dart';
import 'passcode_entry_screen.dart';
import 'report_item_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final circleProvider = Provider.of<CircleProvider>(context);
    final itemProvider = Provider.of<ItemProvider>(context);
    final activeCircle = circleProvider.activeCircle;

    if (activeCircle == null) {
      return const PasscodeEntryScreen();
    }

    final items = itemProvider.getItemsForCircle(activeCircle.id);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade800,
        elevation: 0,
        title: Row(
          children: [
            Text(activeCircle.logoBadge, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activeCircle.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Passcode: ${activeCircle.passcode} • ${activeCircle.memberCount} members',
                    style: const TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.swap_horiz_rounded, color: Colors.white),
            tooltip: 'Switch Campus Circle',
            onPressed: () {
              circleProvider.leaveCircle();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PasscodeEntryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search & Filter Header Container
          Container(
            color: Colors.indigo.shade800,
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Column(
              children: [
                // Search TextField
                TextField(
                  controller: _searchController,
                  onChanged: (val) => itemProvider.setSearchQuery(val),
                  decoration: InputDecoration(
                    hintText: 'Search reported items or locations...',
                    prefixIcon: const Icon(Icons.search, color: Colors.indigo),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, color: Colors.grey),
                            onPressed: () {
                              _searchController.clear();
                              itemProvider.setSearchQuery('');
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                // Status Chips + Today Switch Row
                Row(
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildFilterChip('ALL', 'All Items', itemProvider),
                            _buildFilterChip('LOST', '🔴 Lost', itemProvider),
                            _buildFilterChip('FOUND', '🟢 Found', itemProvider),
                            _buildFilterChip('CLAIMED', '⚪ Claimed', itemProvider),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Today Toggle Button
                    FilterChip(
                      selected: itemProvider.onlyToday,
                      label: const Text('⚡ Today'),
                      selectedColor: Colors.amber,
                      labelStyle: TextStyle(
                        color: itemProvider.onlyToday ? Colors.black : Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                      backgroundColor: Colors.white.withOpacity(0.2),
                      onSelected: (val) => itemProvider.toggleOnlyToday(val),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Categories Horizontal Filter Bar
          Container(
            height: 48,
            color: Colors.white,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                ChoiceChip(
                  label: const Text('All Categories'),
                  selected: itemProvider.selectedCategory == null,
                  onSelected: (_) => itemProvider.setCategoryFilter(null),
                  selectedColor: Colors.indigo.shade100,
                  visualDensity: VisualDensity.compact,
                ),
                const SizedBox(width: 8),
                ...ItemCategory.values.map((cat) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ChoiceChip(
                      label: Text(cat.label),
                      selected: itemProvider.selectedCategory == cat,
                      onSelected: (_) => itemProvider.setCategoryFilter(cat),
                      selectedColor: Colors.indigo.shade100,
                      visualDensity: VisualDensity.compact,
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          // Feed List
          Expanded(
            child: items.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
                          const SizedBox(height: 16),
                          Text(
                            'No items found in this Circle feed!',
                            style: TextStyle(fontSize: 18, color: Colors.grey.shade700, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Try changing filters or be the first student to report a lost or found item.',
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return ItemCard(item: items[index]);
                    },
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ReportItemScreen()),
          );
        },
        backgroundColor: Colors.indigo,
        icon: const Icon(Icons.add_a_photo_rounded, color: Colors.white),
        label: const Text(
          'REPORT ITEM',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFilterChip(String key, String label, ItemProvider provider) {
    final isSelected = provider.selectedStatusFilter == key;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ChoiceChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => provider.setStatusFilter(key),
        selectedColor: Colors.white,
        backgroundColor: Colors.white.withOpacity(0.2),
        labelStyle: TextStyle(
          color: isSelected ? Colors.indigo.shade900 : Colors.white,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          fontSize: 12,
        ),
      ),
    );
  }
}
