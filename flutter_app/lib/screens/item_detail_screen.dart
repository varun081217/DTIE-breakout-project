import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/item_provider.dart';

class ItemDetailScreen extends StatelessWidget {
  final LostFoundItem item;

  const ItemDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('EEEE, MMMM dd, yyyy • h:mm a');
    final itemProvider = Provider.of<ItemProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(item.title),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image Stack with Status Tag
            Stack(
              children: [
                Image.network(
                  item.photoUrl,
                  height: 260,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 260,
                    color: Colors.grey.shade300,
                    child: const Center(
                      child: Icon(Icons.broken_image, size: 64, color: Colors.grey),
                    ),
                  ),
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                    decoration: BoxDecoration(
                      color: item.status == ItemStatus.lost
                          ? Colors.red
                          : item.status == ItemStatus.found
                              ? Colors.green
                              : Colors.grey.shade800,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Text(
                      item.status == ItemStatus.lost
                          ? '🔴 LOST ITEM'
                          : item.status == ItemStatus.found
                              ? '🟢 FOUND ITEM'
                              : '⚪ CLAIMED / RETURNED',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                  ),
                ),
              ],
            ),

            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title & Category Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          item.title,
                          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                        ),
                      ),
                      Chip(
                        label: Text(item.category.label),
                        backgroundColor: Colors.indigo.shade50,
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Reported on: ${dateFormat.format(item.dateReported)}',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 20),

                  // Remarks Section
                  const Text('Remarks & Description', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Text(
                      item.description,
                      style: const TextStyle(fontSize: 14, height: 1.4),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Location Cards
                  Card(
                    elevation: 0,
                    color: Colors.blue.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          const Icon(Icons.location_on, color: Colors.indigo, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Place Lost / Found', style: TextStyle(fontSize: 12, color: Colors.indigo, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(item.locationLostOrFound, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  Card(
                    elevation: 0,
                    color: Colors.teal.shade50,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: Row(
                        children: [
                          const Icon(Icons.pin_drop, color: Colors.teal, size: 28),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Current Storage Location (Right Now)', style: TextStyle(fontSize: 12, color: Colors.teal, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text(item.currentLocationStorage, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Designated Contact Card
                  const Text('Designated Contact to Retrieve Item', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          ListTile: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.indigo.shade100,
                              child: const Icon(Icons.person, color: Colors.indigo),
                            ),
                            title: Text(item.designatedContactName, style: const TextStyle(fontWeight: FontWeight.bold)),
                            subtitle: Text('${item.designatedContactPhone}\n${item.designatedContactEmail}'),
                            isThreeLine: true,
                          ),
                          const Divider(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              TextButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Calling ${item.designatedContactPhone}...')),
                                  );
                                },
                                icon: const Icon(Icons.phone, color: Colors.green),
                                label: const Text('Call', style: TextStyle(color: Colors.green)),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Messaging ${item.designatedContactPhone}...')),
                                  );
                                },
                                icon: const Icon(Icons.chat, color: Colors.blue),
                                label: const Text('WhatsApp/SMS', style: TextStyle(color: Colors.blue)),
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Emailing ${item.designatedContactEmail}...')),
                                  );
                                },
                                icon: const Icon(Icons.email, color: Colors.amber),
                                label: const Text('Email', style: TextStyle(color: Colors.amber)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Action Button to Mark as Claimed
                  if (item.status != ItemStatus.claimed)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          itemProvider.markAsClaimed(item.id);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Item marked as RESOLVED & CLAIMED!'),
                              backgroundColor: Colors.teal,
                            ),
                          );
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.check_circle_outline, color: Colors.white),
                        label: const Text(
                          'MARK AS CLAIMED / RETURNED',
                          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white, fontSize: 15),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
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
