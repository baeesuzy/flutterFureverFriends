import 'package:flutter/material.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final usernameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              obscureText: true,
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password')
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                final email = emailCont
                \roller.text.trim();
                final password = passwordController.text.trim();

                // Example: call your auth logic here
                print('Register Completed');
              },
              child: const Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
