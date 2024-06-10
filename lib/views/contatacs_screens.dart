import 'package:flutter/material.dart';
import 'package:uyishi_6_iyun/models/contacts.dart';
import 'package:uyishi_6_iyun/sql/contacts_save_sqlflite.dart';
class ContactListScreen extends StatefulWidget {
  @override
  _ContactListScreenState createState() => _ContactListScreenState();
}

class _ContactListScreenState extends State<ContactListScreen> {
  late DatabaseHelper _dbHelper;
  List<Contact> _contacts = [];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dbHelper = DatabaseHelper();
    _fetchContacts();
    
  }

  void _fetchContacts() async {
    final contacts = await _dbHelper.getContacts();
    setState(() {
      _contacts = contacts;
    });
  }

  void _addOrUpdateContact({Contact? contact, int? index}) {
    _nameController.text = contact?.name ?? '';
    _phoneController.text = contact?.phoneNumber ?? '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(contact == null ? 'Add Contact' : 'Edit Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Phone Number'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (contact == null) {
                  await _dbHelper.insertContact(Contact(
                    name: _nameController.text,
                    phoneNumber: _phoneController.text,
                  ));
                } else {
                  await _dbHelper.updateContact(Contact(
                    id: contact.id,
                    name: _nameController.text,
                    phoneNumber: _phoneController.text,
                  ));
                }
                _fetchContacts();
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _deleteContact(int id) async {
    await _dbHelper.deleteContact(id);
    _fetchContacts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contacts'),
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue,
            ),
            title: Text(contact.name),
            subtitle: Text(contact.phoneNumber),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () =>
                      _addOrUpdateContact(contact: contact, index: index),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () => _deleteContact(contact.id!),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _addOrUpdateContact(),
        child: Icon(Icons.add),
      ),
    );
  }
}
