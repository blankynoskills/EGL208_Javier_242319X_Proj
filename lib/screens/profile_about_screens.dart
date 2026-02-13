import 'package:flutter/material.dart';
import '../services.dart'; 
import 'auth_screens.dart'; 
import 'package:url_launcher/url_launcher.dart'; 

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  bool isEditing = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: UserService.storedName);
    emailController = TextEditingController(text: UserService.userEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const CircleAvatar(radius: 50, child: Icon(Icons.person, size: 50)),
            const SizedBox(height: 20),
            
            TextField(
              controller: nameController,
              enabled: isEditing,
              decoration: const InputDecoration(labelText: "Name", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 15),
            
            TextField(
              controller: emailController,
              enabled: isEditing,
              decoration: const InputDecoration(labelText: "Email", border: OutlineInputBorder()),
            ),
            const SizedBox(height: 20),
            
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (isEditing) {
                    UserService.userName = nameController.text;
                    UserService.userEmail = emailController.text;
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Profile Updated")));
                  }
                  isEditing = !isEditing;
                });
              },
              child: Text(isEditing ? "Save Profile" : "Edit Profile"),
            ),
            const SizedBox(height: 20),
             TextButton(
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              child: const Text("Log Out", style: TextStyle(color: Colors.red)),
            )
          ],
        ),
      ),
    );
  }
}

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  
  
  Future<void> _launchURL(Uri url) async {
    
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("About Us")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("SwiftEats", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("SwiftEats bridges the gap between hungry consumers and local eateries in Singapore. We streamline ordering and discovery."),
            const Divider(height: 40),
            
            const Text("Support", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            
            // call button
            ListTile(
              leading: const Icon(Icons.phone, color: Colors.green),
              title: const Text("Call Support"),
              subtitle: const Text("+65 6555 1234"),
              onTap: () {
                
                final Uri phoneUri = Uri(scheme: 'tel', path: '+6595763314');
                _launchURL(phoneUri);
              },
            ),

            // email support button
            ListTile(
              leading: const Icon(Icons.email, color: Colors.blue),
              title: const Text("Email Support"),
              subtitle: const Text("help@swifteats.sg"),
              onTap: () {
                
                final Uri emailUri = Uri(
                  scheme: 'mailto',
                  path: 'help@swifteats.sg',
                  queryParameters: {
                    'subject': 'SwiftEats Support Request',
                    'body': 'Hi, I need help with...\n\n(Sent from account: ${UserService.userEmail})',
                  },
                );
                _launchURL(emailUri);
              },
            ),

            // feedback form
            ListTile(
              leading: const Icon(Icons.feedback, color: Colors.orange),
              title: const Text("Submit Feedback"),
              subtitle: const Text("Rate us in-app"),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                 Navigator.push(context, MaterialPageRoute(builder: (context) => const FeedbackScreen()));
              },
            ),
            
            const Spacer(),
            const Center(child: Text("Developed by Javier")),
            const Center(child: Text("Version 1.0.0")),
          ],
        ),
      ),
    );
  }
}

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final _feedbackController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Submit Feedback")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("We value your feedback! Let us know how we can improve SwiftEats."),
            const SizedBox(height: 20),
            
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: "Type your feedback here...",
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
            ),
            const SizedBox(height: 20),
            
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  if (_feedbackController.text.isNotEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Thank you! Feedback sent."))
                    );
                    Navigator.pop(context); 
                  } else {
                     ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Please enter some text."))
                    );
                  }
                },
                child: const Text("Send Feedback"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}