import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../logics/auth_logic.dart';
import 'main_screen.dart';


class LoginScreen extends StatefulWidget{
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();

}

class _LoginScreenState extends State<LoginScreen> {
  final _emailCtrl =TextEditingController(text: "john@mail.com");
  final _passCtrl =TextEditingController(text: "changeme");

  @override
  Widget build (BuildContext context){
    bool loading = context.watch<AuthLogic>().loading;

    return Scaffold(
      body: Center (
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column
          ( mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_person, size: 80, color: Colors.cyan),
              
              const SizedBox(height: 20),
              const Text("Welcome Back!" , style :TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 40),

              TextField( 
                controller: _emailCtrl,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ) 
                ),
              ),
              const SizedBox(height: 16,),

              TextField( 
                controller: _passCtrl,
                obscureText: true,

                decoration: InputDecoration(
                  labelText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)
                  ) 
                ),
              ),
              const SizedBox(height:24,),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyan,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: loading ? null : () async {
                      bool success = await context.read<AuthLogic>().login(
                        _emailCtrl.text.trim(),
                        _passCtrl.text.trim(),
                      );
                      if (success){
                        if(!mounted) return; 
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context)=> const MainScreen()),

                        );
                        }else {
                          if(!mounted) return;
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Login Failed Check Credentials"))
                          );
                        }
                      },
                      child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        :const Text("Login",
                          style: TextStyle(
                            fontSize: 16, fontWeight:  FontWeight.bold)),
                )
              )
            ],
          )
        ),
      )
    );
  }
}
