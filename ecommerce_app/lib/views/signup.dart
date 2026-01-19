//
// import 'package:ecommerce_app/controllers/auth_service.dart';
// import 'package:flutter/material.dart';
//
// class SingupPage extends StatefulWidget {
//   const SingupPage({super.key});
//
//   @override
//   State<SingupPage> createState() => _SingupPageState();
// }
//
// class _SingupPageState extends State<SingupPage> {
//     final formKey = GlobalKey<FormState>();
//   TextEditingController _nameController = TextEditingController();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Form(
//           key: formKey,
//           child: Column(children: [
//              SizedBox(
//                   height: 120,
//                 ),
//                   SizedBox(
//                   width: MediaQuery.of(context).size.width * .9,
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text(
//                         "Sign Up",
//                         style:
//                             TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
//                       ),
//                   Text("Create a new account and get started"),
//                   SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                     width: MediaQuery.of(context).size.width * .9,
//                     child: TextFormField(
//                       validator: (value) =>
//                           value!.isEmpty ? "Name cannot be empty." : null,
//                       controller: _nameController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         label: Text("Name"),
//                       ),
//                     )),
//                                       SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                     width: MediaQuery.of(context).size.width * .9,
//                     child: TextFormField(
//                       validator: (value) =>
//                           value!.isEmpty ? "Email cannot be empty." : null,
//                       controller: _emailController,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         label: Text("Email"),
//                       ),
//                     )),
//                     ],
//                   ),
//                 ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                     width: MediaQuery.of(context).size.width * .9,
//                     child: TextFormField(
//                       validator: (value) => value!.length < 8
//                           ? "Password should have atleast 8 characters."
//                           : null,
//                       controller: _passwordController,
//                       obscureText: true,
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(),
//                         label: Text("Password"),
//                       ),
//                     )),
//                      SizedBox(
//                   height: 10,
//                 ),
//
//                 SizedBox(
//                     height: 60,
//                     width: MediaQuery.of(context).size.width * .9,
//                     child: ElevatedButton(
//
//
//                         onPressed: () {
//                            if (formKey.currentState!.validate()) {
//                             AuthService()
//                                 .createAccountWithEmail(
//                                   _nameController.text,
//                                     _emailController.text, _passwordController.text)
//                                 .then((value) {
//                                   print("REGISTRATION RESULT: $value"); // Debug log
//                               if (value == "Account Created") {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                     SnackBar(content: Text("Account Created")));
//                                 Navigator.restorablePushNamedAndRemoveUntil(context, "/home" , (route) => false);
//                               } else {
//                                 showDialog(
//                                   context: context,
//                                   builder: (context) => AlertDialog(
//                                     title: Text("Registration Error"),
//                                     content: Text(value),
//                                     actions: [
//                                       TextButton(onPressed: () => Navigator.pop(context), child: Text("OK"))
//                                     ],
//                                   )
//                                 );
//                               }
//                             });
//                           }
//                         },
//                           style:  ElevatedButton.styleFrom(
//                           backgroundColor: Theme.of(context).primaryColor,
//                           foregroundColor: Colors.white
//                         ),
//                         child: Text(
//                           "Sign Up",
//                           style: TextStyle(fontSize: 16),
//                         ))),
//
//                         SizedBox(
//                   height: 10,
//                 ),
//
//
//                  Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     Text("Already have and account?"),
//                     TextButton(
//                         onPressed: () {
//                           Navigator.pop(context);
//                         },
//                         child: Text("Login"))
//                   ],
//                 )
//
//           ],),
//         ),
//       ),
//     );
//   }
// }

import 'package:ecommerce_app/controllers/auth_service.dart';
import 'package:flutter/material.dart';

class SingupPage extends StatefulWidget {
  const SingupPage({super.key});

  @override
  State<SingupPage> createState() => _SingupPageState();
}

class _SingupPageState extends State<SingupPage> {
  final formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                SizedBox(height: 80),

                // Logo and Welcome Text
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade600,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Icon(
                        Icons.shopping_bag_outlined,
                        color: Colors.white,
                        size: 32,
                      ),
                    ),
                    SizedBox(height: 24),
                    Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Sign up to start shopping",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 48),

                // Name Field
                _buildTextField(
                  controller: _nameController,
                  label: "Full Name",
                  hint: "Enter your full name",
                  icon: Icons.person_outline,
                ),

                SizedBox(height: 20),

                // Email Field
                _buildTextField(
                  controller: _emailController,
                  label: "Email",
                  hint: "Enter your email",
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                ),

                SizedBox(height: 20),

                // Password Field
                _buildTextField(
                  controller: _passwordController,
                  label: "Password",
                  hint: "Create a password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                SizedBox(height: 32),

                // Sign Up Button
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : () {
                      if (formKey.currentState!.validate()) {
                        setState(() => _isLoading = true);
                        AuthService()
                            .createAccountWithEmail(
                          _nameController.text,
                          _emailController.text,
                          _passwordController.text,
                        )
                            .then((value) {
                          setState(() => _isLoading = false);
                          if (value == "Account Created") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Account Created Successfully"),
                                backgroundColor: Colors.green.shade600,
                              ),
                            );
                            Navigator.restorablePushNamedAndRemoveUntil(
                              context,
                              "/home",
                                  (route) => false,
                            );
                          } else {
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text(
                                  "Registration Error",
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                content: Text(value),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text("OK"),
                                  ),
                                ],
                              ),
                            );
                          }
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade600,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : Text(
                      "Create Account",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Spacer(),

                // Login Link
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(
                            color: Colors.blue.shade600,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue.shade600),
        ),
        prefixIcon: Icon(icon, color: Colors.grey.shade600),
        contentPadding: EdgeInsets.all(16),
      ),
      validator: isPassword
          ? (value) => value!.length < 8
          ? "Password must be at least 8 characters"
          : null
          : (value) => value!.isEmpty ? "$label cannot be empty" : null,
    );
  }
}