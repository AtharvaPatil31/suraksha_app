import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EmergencyContactsScreen extends StatefulWidget {
  const EmergencyContactsScreen({super.key});

  @override
  State<EmergencyContactsScreen> createState() => _EmergencyContactsScreenState();
}

class _EmergencyContactsScreenState extends State<EmergencyContactsScreen> {
  final TextEditingController _controller = TextEditingController();
  final SupabaseClient _supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _contacts = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
    _subscribeRealtime();
  }

  Future<void> _loadContacts() async {
    final user = _supabase.auth.currentUser;
    if (user == null) return;
    final response = await _supabase.from('emergency_contacts').select().eq('user_id', user.id).order('created_at');
    setState(() {
      _contacts = List<Map<String, dynamic>>.from(response);
      _loading = false;
    });
  }

  void _subscribeRealtime() {
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    _supabase.channel('emergency_contacts_channel')
        .onPostgresChanges(
      event: PostgresChangeEvent.insert,
      schema: 'public',
      table: 'emergency_contacts',
      callback: (payload) {
        if (payload.newRecord['user_id'] == user.id) {
          setState(() => _contacts.add(payload.newRecord));
        }
      },
    )
        .onPostgresChanges(
      event: PostgresChangeEvent.delete,
      schema: 'public',
      table: 'emergency_contacts',
      callback: (payload) {
        setState(() => _contacts.removeWhere((c) => c['id'] == payload.oldRecord['id']));
      },
    )
        .subscribe();
  }

  Future<void> _addContact(String contact) async {
    if (contact.isEmpty || !RegExp(r'^\d+$').hasMatch(contact)) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please enter a valid phone number")));
      return;
    }
    final user = _supabase.auth.currentUser;
    if (user == null) return;

    final response = await _supabase.from('emergency_contacts').insert({
      'user_id': user.id,
      'phone_number': contact,
    }).select();

    if (response.isNotEmpty) {
      setState(() => _contacts.add(response.first));
    }
    _controller.clear();
  }

  Future<void> _removeContact(String id) async {
    await _supabase.from('emergency_contacts').delete().eq('id', id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Emergency Contacts"), backgroundColor: const Color(0xFF861FC0)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      hintText: "Enter phone number",
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      prefixIcon: const Icon(Icons.phone),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () => _addContact(_controller.text),
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF861FC0)),
                  child: const Text("Add"),
                ),
              ],
            ),
          ),
          Expanded(
            child: _contacts.isEmpty
                ? const Center(child: Text("No emergency contacts added yet", style: TextStyle(fontSize: 16, color: Colors.grey)))
                : ListView.builder(
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                final contact = _contacts[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.contact_phone, color: Colors.purple),
                    title: Text(contact['phone_number']),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _removeContact(contact['id']),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
