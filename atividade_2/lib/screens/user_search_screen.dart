import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_app/theme/app.theme.dart';
import '../models/user.dart';
import '../services/api_service.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/gradient_button.dart';

class UserSearchScreen extends StatefulWidget {
  const UserSearchScreen({super.key});

  @override
  State<UserSearchScreen> createState() => _UserSearchScreenState();
}

class _UserSearchScreenState extends State<UserSearchScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _idController = TextEditingController();
  User? _user;
  String? _errorMessage;
  bool _isLoading = false;
  late AnimationController _shakeController;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
  }

  @override
  void dispose() {
    _idController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  Future<void> _fetchUser() async {
    if (_idController.text.isEmpty) {
      _shakeController.forward(from: 0);
      setState(() => _errorMessage = 'Digite um ID!');
      return;
    }

    final id = int.tryParse(_idController.text);
    if (id == null || id < 1 || id > 12) {
      setState(() {
        _errorMessage = 'ID deve ser entre 1 e 12!';
        _user = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _user = null;
    });

    try {
      final user = await _apiService.fetchUser(id);
      setState(() => _user = user);
    } catch (e) {
      setState(() => _errorMessage = e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showUserDetailsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: Theme.of(context)
                  .extension<GradientExtension>()!
                  .primaryGradient,
              borderRadius: BorderRadius.circular(20),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5)),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 60,
                  backgroundImage: NetworkImage(_user!.avatar),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 20),
                Text(
                  '${_user!.firstName} ${_user!.lastName}',
                  style: const TextStyle(
                      fontSize: 28,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  _user!.email,
                  style: const TextStyle(fontSize: 20, color: Colors.white70),
                ),
                const SizedBox(height: 20),
                GradientButton(
                  text: 'Fechar',
                  onPressed: () => Navigator.of(context).pop(),
                  isLoading: false,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final gradient =
        Theme.of(context).extension<GradientExtension>()!.primaryGradient;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: BoxDecoration(gradient: gradient)),
        title: const Text('Buscador de Usuários',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              AnimatedBuilder(
                animation: _shakeController,
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(
                        10 * sin(_shakeController.value * 4 * 3.14159), 0),
                    child: CustomTextField(
                      hintText: 'Digite um ID (1-12)',
                      controller: _idController,
                      keyboardType: TextInputType.number,
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              GradientButton(
                text: 'Buscar',
                onPressed: _fetchUser,
                isLoading: _isLoading,
              ),
              const SizedBox(height: 20),
              if (_isLoading)
                const CircularProgressIndicator(color: Color(0xFF00E5FF)),
              if (_user != null)
                AnimatedOpacity(
                  opacity: _user != null ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: () => _showUserDetailsDialog(context),
                    child: Card(
                      color: Colors.white.withOpacity(0.1),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15)),
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            CircleAvatar(
                                radius: 40,
                                backgroundImage: NetworkImage(_user!.avatar)),
                            const SizedBox(height: 20),
                            Text('${_user!.firstName} ${_user!.lastName}',
                                style: const TextStyle(
                                    fontSize: 20, color: Colors.white)),
                            const SizedBox(height: 10),
                            Text(_user!.email,
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.white70)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              if (_errorMessage != null)
                AnimatedOpacity(
                  opacity: _errorMessage != null ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Text(_errorMessage!,
                      style: const TextStyle(
                          fontSize: 16, color: Color(0xFFFF4081))),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
