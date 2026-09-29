import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/circle_provider.dart';
import 'dashboard_screen.dart';

class PasscodeEntryScreen extends StatefulWidget {
  const PasscodeEntryScreen({Key? key}) : super(key: key);

  @override
  State<PasscodeEntryScreen> createState() => _PasscodeEntryScreenState();
}

class _PasscodeEntryScreenState extends State<PasscodeEntryScreen> {
  final TextEditingController _passcodeController = TextEditingController();
  final _createFormKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _newPasscodeController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _adminEmailController = TextEditingController();

  void _submitPasscode() {
    final provider = Provider.of<CircleProvider>(context, listen: false);
    final success = provider.joinCircle(_passcodeController.text);
    if (success) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const DashboardScreen()),
      );
    }
  }

  void _showCreateCircleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.add_location_alt, color: Colors.indigo),
            SizedBox(width: 8),
            Text('Create University Circle'),
          ],
        ),
        content: SingleChildScrollView(
          child: Form(
            key: _createFormKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'University Name',
                    hintText: 'e.g. Harvard University',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _newPasscodeController,
                  decoration: const InputDecoration(
                    labelText: 'Create Circle Passcode',
                    hintText: 'e.g. HARVARD-2026',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _locationController,
                  decoration: const InputDecoration(
                    labelText: 'Campus City / Location',
                    hintText: 'e.g. Cambridge, MA',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _adminEmailController,
                  decoration: const InputDecoration(
                    labelText: 'Admin Contact Email',
                    hintText: 'e.g. admin@harvard.edu',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (_createFormKey.currentState!.validate()) {
                final provider = Provider.of<CircleProvider>(context, listen: false);
                provider.createCircle(
                  name: _nameController.text,
                  passcode: _newPasscodeController.text,
                  location: _locationController.text,
                  adminEmail: _adminEmailController.text,
                );
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const DashboardScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.indigo),
            child: const Text('Create Circle', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final circleProvider = Provider.of<CircleProvider>(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.indigo.shade800, Colors.indigo.shade900],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.school_rounded, size: 72, color: Colors.amberAccent),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'UniFind',
                    style: TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Text(
                    'Campus Circle Lost & Found Portal',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                  const SizedBox(height: 40),

                  // Passcode Input Card
                  Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Enter University Passcode',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Enter the secret passcode provided by your university admin to access your campus lost & found items.',
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),

                          TextField(
                            controller: _passcodeController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: InputDecoration(
                              prefixIcon: const Icon(Icons.key, color: Colors.indigo),
                              labelText: 'Passcode',
                              hintText: 'e.g. MIT-FOUND',
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            onSubmitted: (_) => _submitPasscode(),
                          ),

                          if (circleProvider.errorMessage != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              circleProvider.errorMessage!,
                              style: const TextStyle(color: Colors.red, fontSize: 13),
                              textAlign: TextAlign.center,
                            ),
                          ],

                          const SizedBox(height: 20),

                          ElevatedButton(
                            onPressed: _submitPasscode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            ),
                            child: const Text(
                              'JOIN CAMPUS CIRCLE',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Demo Passcode Quick Buttons
                  const Text(
                    'Demo Campus Passcodes (Tap to test):',
                    style: TextStyle(color: Colors.white70, fontSize: 13),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    alignment: WrapAlignment.center,
                    children: circleProvider.availableCircles.map((circle) {
                      return ActionChip(
                        avatar: Text(circle.logoBadge),
                        label: Text('${circle.name} (${circle.passcode})'),
                        backgroundColor: Colors.white.withOpacity(0.9),
                        onPressed: () {
                          _passcodeController.text = circle.passcode;
                          _submitPasscode();
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 30),
                  OutlinedButton.icon(
                    onPressed: _showCreateCircleDialog,
                    icon: const Icon(Icons.add_business_rounded, color: Colors.white),
                    label: const Text(
                      'Create a New University Circle',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.white54),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
