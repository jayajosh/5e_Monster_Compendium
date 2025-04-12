import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class StatblockGenerator extends StatefulWidget {
  @override
  _StatblockGeneratorState createState() => _StatblockGeneratorState();
}

class _StatblockGeneratorState extends State<StatblockGenerator> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _crController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String _statblockResult = '';
  bool _isLoading = false;

  Future<void> _callGenerateStatblock() async {
    setState(() {
      _isLoading = true;
      _statblockResult = 'Loading...'; // Show loading indicator
    });

    final String name = _nameController.text;
    final double cr = double.tryParse(_crController.text) ?? 1.0; // Default to 1.0 if no cr provided
    final String description = _descriptionController.text;

    // Construct the data to send to the Cloud Function
    Map<String, dynamic> requestData = {
      'name': name,
      'cr': cr,
      'description': description,
    };

    final Uri cloudFunctionUrl = Uri.parse('https://generate-statblock-4paocvy6jq-uc.a.run.app');

    try {
      final response = await http.post(
        cloudFunctionUrl,
        headers: {'Content-Type': 'application/json'},
        body: json.encode(requestData),
      ).timeout(const Duration(seconds: 300));
      // Check for errors
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        setState(() {
          _statblockResult = responseData['statblock'] ?? 'No statblock found'; // Display result
        });
      } else {
        setState(() {
          _statblockResult = 'Error: ${response.statusCode} - ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _statblockResult = 'Error: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Statblock Generator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Monster Name'),
            ),
            TextField(
              controller: _crController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Challenge Rating (CR)'),
            ),
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: 'Description'),
            ),
            const SizedBox(height: 20),
            InkWell(
              onTap: _isLoading ? null : _callGenerateStatblock, // Disable tap when loading
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _isLoading ? 'Generating...' : 'Generate Statblock',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(_statblockResult),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
