import 'package:flutter/material.dart';
import 'package:flutter_app/theme/app.theme.dart';
import '../models/user.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';

class AddUserScreen extends StatefulWidget {
  const AddUserScreen({super.key});

  @override
  State<AddUserScreen> createState() => _AddUserScreenState();
}

class _AddUserScreenState extends State<AddUserScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _avatarController = TextEditingController();

  
  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  void _addUser() {
    if (_nameController.text.isEmpty || _emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nome e email são obrigatórios!')),
      );
      return;
    }

    if (!_isValidEmail(_emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, insira um email válido!')),
      );
      return;
    }

    final newUser = User(
      id: DateTime.now().millisecondsSinceEpoch, 
      firstName: _nameController.text.split(' ').first,
      lastName: _nameController.text.split(' ').length > 1
          ? _nameController.text.split(' ').last
          : '',
      email: _emailController.text,
      phone: _phoneController.text.isEmpty
          ? 'Não informado'
          : _phoneController.text,
      avatar: _avatarController.text,
    );
    Navigator.pop(context, newUser);
  }

  @override
  Widget build(BuildContext context) {
    final gradient =
        Theme.of(context).extension<GradientExtension>()!.primaryGradient;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: BoxDecoration(gradient: gradient)),
        title: const Text('Adicionar Usuário',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              CustomTextField(
                  hintText: 'Nome Completo', controller: _nameController),
              const SizedBox(height: 20),
              CustomTextField(hintText: 'Email', controller: _emailController),
              const SizedBox(height: 20),
              CustomTextField(
                  hintText: 'Telefone',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 20),
              CustomTextField(
                  hintText: 'URL da Foto (opcional)',
                  controller: _avatarController),
              const SizedBox(height: 40),
              GradientButton(
                text: 'Cadastrar',
                onPressed: _addUser,
                isLoading: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
