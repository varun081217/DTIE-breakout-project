import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/models.dart';
import '../providers/circle_provider.dart';
import '../providers/item_provider.dart';

class ReportItemScreen extends StatefulWidget {
  const ReportItemScreen({Key? key}) : super(key: key);

  @override
  State<ReportItemScreen> createState() => _ReportItemScreenState();
}

class _ReportItemScreenState extends State<ReportItemScreen> {
  final _formKey = GlobalKey<FormState>();

  ItemStatus _status = ItemStatus.found;
  ItemCategory _category = ItemCategory.electronics;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _currentSpotController = TextEditingController();
  final TextEditingController _contactNameController = TextEditingController();
  final TextEditingController _contactPhoneController = TextEditingController();
  final TextEditingController _contactEmailController = TextEditingController();
  final TextEditingController _photoUrlController = TextEditingController(
    text: 'https://images.unsplash.com/photo-1541807084-5c52b6b3adef?w=500',
  );

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final circleProvider = Provider.of<CircleProvider>(context, listen: false);
      final itemProvider = Provider.of<ItemProvider>(context, listen: false);

      final newItem = LostFoundItem(
        id: 'item_${DateTime.now().millisecondsSinceEpoch}',
        title: _titleController.text.trim(),
        description: _descController.text.trim(),
        category: _category,
        status: _status,
        photoUrl: _photoUrlController.text.trim().isEmpty
            ? 'https://images.unsplash.com/photo-1584438784894-089d6a62b8fa?w=500'
            : _photoUrlController.text.trim(),
        dateReported: DateTime.now(),
        locationLostOrFound: _locationController.text.trim(),
        currentLocationStorage: _currentSpotController.text.trim(),
        designatedContactName: _contactNameController.text.trim(),
        designatedContactPhone: _contactPhoneController.text.trim(),
        designatedContactEmail: _contactEmailController.text.trim(),
        universityCircleId: circleProvider.activeCircle?.id ?? '',
        reporterStudentName: _contactNameController.text.trim(),
      );

      itemProvider.addItem(newItem);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 8),
              Text('${newItem.status == ItemStatus.lost ? "Lost" : "Found"} item reported successfully!'),
            ],
          ),
          backgroundColor: Colors.green.shade700,
        ),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report Lost or Found Item'),
        backgroundColor: Colors.indigo,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Type Selector: LOST vs FOUND
              Card(
                color: Colors.indigo.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      Expanded(
                        child: RadioListTile<ItemStatus>(
                          title: const Text('🔴 I LOST This Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          value: ItemStatus.lost,
                          groupValue: _status,
                          activeColor: Colors.red,
                          onChanged: (val) => setState(() => _status = val!),
                        ),
                      ),
                      Expanded(
                        child: RadioListTile<ItemStatus>(
                          title: const Text('🟢 I FOUND This Item', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          value: ItemStatus.found,
                          groupValue: _status,
                          activeColor: Colors.green,
                          onChanged: (val) => setState(() => _status = val!),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Title Field
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Item Name / Short Title *',
                  hintText: 'e.g. Silver AirPods Pro with Black Case',
                  prefixIcon: Icon(Icons.title),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Please enter item title' : null,
              ),
              const SizedBox(height: 16),

              // Category Dropdown
              DropdownButtonFormField<ItemCategory>(
                value: _category,
                decoration: const InputDecoration(
                  labelText: 'Item Category *',
                  prefixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(),
                ),
                items: ItemCategory.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Text(cat.label),
                  );
                }).toList(),
                onChanged: (val) => setState(() => _category = val!),
              ),
              const SizedBox(height: 16),

              // Description & Remarks
              TextFormField(
                controller: _descController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description / Remarks / Identifying Details *',
                  hintText: 'Describe colors, marks, stickers, or specific condition...',
                  prefixIcon: Icon(Icons.description),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Please enter description' : null,
              ),
              const SizedBox(height: 16),

              // Location Lost or Found
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(
                  labelText: 'Place Where Lost / Found *',
                  hintText: 'e.g. Student Center Cafeteria, Table 4',
                  prefixIcon: Icon(Icons.place),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Please specify place' : null,
              ),
              const SizedBox(height: 16),

              // Current Storage Spot
              TextFormField(
                controller: _currentSpotController,
                decoration: const InputDecoration(
                  labelText: 'Where is the item right now? *',
                  hintText: 'e.g. Handed to Main Security Desk / Held by me',
                  prefixIcon: Icon(Icons.pin_drop),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Please specify current item location' : null,
              ),
              const SizedBox(height: 20),

              const Text(
                'Designated Contact Information to Claim/Return',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.indigo),
              ),
              const SizedBox(height: 12),

              // Contact Name
              TextFormField(
                controller: _contactNameController,
                decoration: const InputDecoration(
                  labelText: 'Contact Person Name *',
                  hintText: 'e.g. Officer James / Student Alex',
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Contact Phone
              TextFormField(
                controller: _contactPhoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Contact Phone / WhatsApp *',
                  hintText: 'e.g. +1 (555) 019-2831',
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),

              // Contact Email
              TextFormField(
                controller: _contactEmailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Contact Email Address *',
                  hintText: 'e.g. james.security@university.edu',
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),

              // Photo URL
              TextFormField(
                controller: _photoUrlController,
                decoration: const InputDecoration(
                  labelText: 'Item Photo URL (Optional)',
                  hintText: 'https://...',
                  prefixIcon: Icon(Icons.image),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'PUBLISH REPORT TO CAMPUS CIRCLE',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
