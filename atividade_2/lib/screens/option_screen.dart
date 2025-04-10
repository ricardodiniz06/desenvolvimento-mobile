import 'package:flutter/material.dart';
import 'package:flutter_app/theme/app.theme.dart';
import 'user_search_screen.dart';
import 'user_list_screen.dart';
import '../widgets/gradient_button.dart';

class OptionScreen extends StatelessWidget {
  const OptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final gradient =
        Theme.of(context).extension<GradientExtension>()!.primaryGradient;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: BoxDecoration(gradient: gradient)),
        title: const Text('Escolha uma Opção',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GradientButton(
                text: 'Atividade 2: API',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserSearchScreen()),
                  );
                },
                isLoading: false,
              ),
              const SizedBox(height: 20),
              GradientButton(
                text: 'List Users',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const UserListScreen()),
                  );
                },
                isLoading: false,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
