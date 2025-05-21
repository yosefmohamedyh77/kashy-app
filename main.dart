import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kashy',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: AuthGate(),
    );
  }
}

class AuthGate extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return HomePage();
        } else {
          return LoginPage();
        }
      },
    );
  }
}

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void signIn(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim());
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: ' + e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('تسجيل الدخول')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: 'البريد الإلكتروني')),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: 'كلمة المرور'), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => signIn(context), child: Text('دخول')),
          ],
        ),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Map<String, String>> offers = [
    {
      'company': 'Shell',
      'offer': 'ادفع 500، استلم 1000',
      'duration': '30 يوم',
      'profit': '+100%'
    },
    {
      'company': 'Emaar',
      'offer': 'ادفع 1000، استلم 2000',
      'duration': '60 يوم',
      'profit': '+100%'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('كاشي - العروض الاستثمارية')),
      body: ListView.builder(
        itemCount: offers.length,
        itemBuilder: (context, index) {
          final offer = offers[index];
          return Card(
            margin: EdgeInsets.all(12),
            child: ListTile(
              title: Text(offer['company']!),
              subtitle: Text('${offer['offer']} - مدة: ${offer['duration']} - ربح: ${offer['profit']}'),
              trailing: ElevatedButton(onPressed: () {}, child: Text('ابدأ الآن')),
            ),
          );
        },
      ),
    );
  }
}
