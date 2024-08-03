import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  final String eventName;

  RegisterPage({required this.eventName});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  DateTime? _selectedDate;
  String? _gender;

  Future<void> _submitForm() async {
    if (_formKey.currentState!.validate()) {
      final formData = {
        'first_name': _nameController.text,
        'last_name': _surnameController.text,
        'email': _emailController.text,
        'phone': _phoneController.text,
        'date_of_birth': DateFormat('yyyy-MM-dd').format(_selectedDate!),
        'gender': _gender,
        'event_model': '1',
      };

      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/register/'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(formData),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Kayıt başarılı')));
        // Kayıttan sonra yönlendirme veya başka işlemler yapılabilir
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Kayıt işlemi sırasında bir hata oluştu')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.eventName} için Kayıt'),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'İsim'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'İsim boş olamaz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _surnameController,
                decoration: InputDecoration(labelText: 'Soyisim'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Soyisim boş olamaz';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: 'E-posta'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'E-posta boş olamaz';
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Geçerli bir e-posta adresi girin';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: InputDecoration(labelText: 'Telefon Numarası'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Telefon numarası boş olamaz';
                  }
                  return null;
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Text('Doğum Tarihi:'),
                  SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () async {
                      final DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now(),
                      );
                      if (pickedDate != null && pickedDate != _selectedDate) {
                        setState(() {
                          _selectedDate = pickedDate;
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                    child: Text(_selectedDate == null
                        ? 'Tarih Seç'
                        : DateFormat('dd/MM/yyyy').format(_selectedDate!)),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text('Cinsiyet:'),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Erkek'),
                      leading: Radio<String>(
                        value: 'Male',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('Kadın'),
                      leading: Radio<String>(
                        value: 'Female',
                        groupValue: _gender,
                        onChanged: (value) {
                          setState(() {
                            _gender = value;
                          });
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Mavi buton rengi
                    foregroundColor: Colors.white),
                child: Text(
                  'Kayıt Ol',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
