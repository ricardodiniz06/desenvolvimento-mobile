import 'package:flutter/material.dart';
import 'package:flutter_app/theme/app.theme.dart';
import '../models/user.dart';
import '../widgets/gradient_button.dart';
import '../widgets/custom_text_field.dart';
import 'add_user_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<User> users = [
    User(
        id: 1,
        firstName: 'George',
        lastName: 'Bluth',
        email: 'george@example.com',
        phone: '123-456-7890',
        avatar: 'https://reqres.in/img/faces/1-image.jpg'),
    User(
        id: 2,
        firstName: 'Janet',
        lastName: 'Weaver',
        email: 'janet@example.com',
        phone: '987-654-3210',
        avatar: 'https://reqres.in/img/faces/2-image.jpg'),
  ];

  void _showEditDialog(User user) {
    final nameController =
        TextEditingController(text: '${user.firstName} ${user.lastName}');
    final emailController = TextEditingController(text: user.email);
    final phoneController = TextEditingController(text: user.phone);
    final avatarController = TextEditingController(text: user.avatar);

    showDialog(
      context: context,
      builder: (context) {
        final gradient =
            Theme.of(context).extension<GradientExtension>()!.primaryGradient;
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 5)),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Editar Usuário',
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    shadows: [
                      Shadow(
                          color: Colors.black45,
                          blurRadius: 5,
                          offset: Offset(1, 1))
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                    hintText: 'Nome Completo', controller: nameController),
                const SizedBox(height: 12),
                CustomTextField(hintText: 'Email', controller: emailController),
                const SizedBox(height: 12),
                CustomTextField(
                    hintText: 'Telefone',
                    controller: phoneController,
                    keyboardType: TextInputType.phone),
                const SizedBox(height: 12),
                CustomTextField(
                    hintText: 'URL da Foto', controller: avatarController),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 120,
                      child: GradientButton(
                        text: 'Cancelar',
                        onPressed: () => Navigator.pop(context),
                        isLoading: false,
                      ),
                    ),
                    SizedBox(
                      width: 120,
                      child: GradientButton(
                        text: 'Salvar',
                        onPressed: () {
                          setState(() {
                            final updatedUser = user.copyWith(
                              firstName: nameController.text.split(' ').first,
                              lastName:
                                  nameController.text.split(' ').length > 1
                                      ? nameController.text.split(' ').last
                                      : '',
                              email: emailController.text,
                              phone: phoneController.text,
                              avatar: avatarController.text,
                            );
                            final index = users.indexOf(user);
                            users[index] = updatedUser;
                          });
                          Navigator.pop(context);
                        },
                        isLoading: false,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _deleteUser(User user) {
    setState(() {
      users.remove(user);
    });
  }

  @override
  Widget build(BuildContext context) {
    final gradient =
        Theme.of(context).extension<GradientExtension>()!.primaryGradient;
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(decoration: BoxDecoration(gradient: gradient)),
        title: const Text('Listagem de Usuários',
            style: TextStyle(fontSize: 20, color: Colors.white)),
      ),
      body: Container(
        decoration: BoxDecoration(gradient: gradient),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  final user = users[index];
                  return Card(
                    color: Colors.white.withOpacity(0.1),
                    margin:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15)),
                    elevation: 5,
                    child: ListTile(
                      leading: CircleAvatar(
                        radius: 25,
                        backgroundImage: (user.avatar.isNotEmpty &&
                                Uri.tryParse(user.avatar)?.hasAbsolutePath ==
                                    true)
                            ? NetworkImage(user.avatar)
                            : null,
                        child: (user.avatar.isEmpty ||
                                Uri.tryParse(user.avatar)?.hasAbsolutePath !=
                                    true)
                            ? const Icon(Icons.person,
                                color: Colors.white, size: 30)
                            : null,
                      ),
                      title: Text('${user.firstName} ${user.lastName}',
                          style: const TextStyle(color: Colors.white)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user.email,
                              style: const TextStyle(color: Colors.white70)),
                          Text(user.phone,
                              style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.white),
                            onPressed: () => _showEditDialog(user),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteUser(user),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GradientButton(
                text: 'Adicionar Usuário',
                onPressed: () async {
                  final newUser = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddUserScreen()),
                  );
                  if (newUser != null) {
                    setState(() {
                      users.add(newUser);
                    });
                  }
                },
                isLoading: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
