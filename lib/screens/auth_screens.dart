import 'package:flutter/material.dart';
import '../services.dart'; 
import '../main.dart'; 


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(); 
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Center(
        
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey, 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, 
              children: [
                const Icon(Icons.fastfood, size: 80, color: Colors.orange),
                const SizedBox(height: 20),
                const Text("SwiftEats", style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
                const SizedBox(height: 40),
                
                // Email Field
                TextFormField(
                  controller: _emailController, 
                  decoration: const InputDecoration(labelText: "Email ID", border: OutlineInputBorder()),
                  validator: (value) => value!.isEmpty ? "Enter email" : null,
                ),
                const SizedBox(height: 16),
                
                // Password Field
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                  obscureText: true, 
                  validator: (value) => value!.isEmpty ? "Enter password" : null,
                ),
                const SizedBox(height: 24),
                
                // Login Button
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Check for match
                      if (UserService.storedEmail == null || UserService.storedPassword == null) {
                         ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("No account found. Please Register first!"), backgroundColor: Colors.red)
                        );
                        return;
                      }

                      if (_emailController.text == UserService.storedEmail && 
                          _passwordController.text == UserService.storedPassword) {
                        UserService.userEmail = _emailController.text;
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const MainNavigation()),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Invalid Email or Password"), backgroundColor: Colors.red)
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  child: const Text("LOGIN"),
                ),
                
                // go to register screen
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context, 
                      MaterialPageRoute(builder: (context) => const RegistrationScreen())
                    );
                  },
                  child: const Text("New user? Register here"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.person_add, size: 80, color: Colors.orange),
                const SizedBox(height: 20),
                const Text("Create Account", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                const SizedBox(height: 30),
                
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: "Name", border: OutlineInputBorder()),
                ),
                const SizedBox(height: 16),

                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: "Email ID", border: OutlineInputBorder()),
                  validator: (value) => !value!.contains('@') ? "Enter a valid email" : null,
                ),
                const SizedBox(height: 16),

                
                
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: "Password", border: OutlineInputBorder()),
                  obscureText: true,
                  validator: (value) => value!.length < 6 ? "Password must be 6+ chars" : null,
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _confirmPasswordController,
                  decoration: const InputDecoration(labelText: "Confirm Password", border: OutlineInputBorder()),
                  obscureText: true,
                  validator: (value) {
                    if (value != _passwordController.text) return "Passwords do not match";
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                
                
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      
                      // Save inputs to UserService
                      UserService.storedName = _nameController.text;
                      UserService.storedEmail = _emailController.text;
                      UserService.storedPassword = _passwordController.text;

                      
                      // update the Profile display email
                      UserService.storedName = _nameController.text;
                      UserService.userEmail = _emailController.text;

                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Account Created! You are now logged in.")));
                      
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const MainNavigation()),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 50)),
                  child: const Text("REGISTER"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}