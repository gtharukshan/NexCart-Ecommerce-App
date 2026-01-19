//
// import 'package:ecommerce_app/controllers/auth_service.dart';
// import 'package:flutter/material.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});
//
//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//     final formKey = GlobalKey<FormState>();
//   TextEditingController _emailController = TextEditingController();
//   TextEditingController _passwordController = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Form(
//           key:  formKey,
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
//                         "Login",
//                         style:
//                             TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
//                       ),
//                   Text("Get started with your account"),
//                   SizedBox(
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
//                 Row(  mainAxisAlignment: MainAxisAlignment.end,children: [
//                   TextButton(onPressed: (){
//                   showDialog(context: context, builder:  (builder) {
//                   return AlertDialog(
//                     title:  Text("Forget Password"),
//                     content: Column(
//                       mainAxisSize: MainAxisSize.min,
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text("Enter you email"),
//                         SizedBox(height: 10,),
//                         TextFormField (controller:  _emailController, decoration: InputDecoration(label: Text("Email"), border: OutlineInputBorder()),),
//                       ],
//                     ),
//                     actions: [
//                       TextButton(onPressed: (){
//                         Navigator.pop(context);}, child: Text("Cancel")),
//                       TextButton(onPressed: ()async{
//                         if(_emailController.text.isEmpty){
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Email cannot be empty")));
//                           return;
//                         }
//                        await AuthService().resetPassword(_emailController.text).then( (value) {
//                         if(value=="Mail Sent"){
//                           ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password reset link sent to your email")));
//                           Navigator.pop(context);
//                         }
//                         else{
// ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value,style: TextStyle( color:  Colors.white),), backgroundColor: Colors.red.shade400,));
//                         }
//                         });
//                       }, child: Text("Submit")),
//                     ]
//
//                   );
//                 });
//                   }, child: Text("Forget Password")),
//                 ],),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 SizedBox(
//                     height: 60,
//                     width: MediaQuery.of(context).size.width * .9,
//                     child: ElevatedButton(
//                         onPressed: () {
//                            if (formKey.currentState!.validate()) {
//                               AuthService()
//                               .loginWithEmail(
//                                   _emailController.text, _passwordController.text)
//                               .then((value) {
//                             if (value == "Login Successful") {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(content: Text("Login Successful")));
//                              Navigator.restorablePushNamedAndRemoveUntil(context, "/home" , (route) => false);
//                             } else {
//                               ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                 content: Text(
//                                   value,
//                                   style: TextStyle(color: Colors.white),
//                                 ),
//                                 backgroundColor: Colors.red.shade400,
//                               ));
//                             }
//                           });
//
//                         }
//                         },
//                         style:  ElevatedButton.styleFrom(
//                           backgroundColor: Theme.of(context).primaryColor,
//                           foregroundColor: Colors.white
//                         ),
//                         child: Text(
//                           "Login",
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
//                     Text("Don't have and account?"),
//                     TextButton(
//                         onPressed: () {
//                           Navigator.pushNamed(context, "/signup");
//                         },
//                         child: Text("Sign Up"))
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

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
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
                SizedBox(height: 100),

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
                      "Welcome Back",
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      "Sign in to continue shopping",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 48),

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
                  hint: "Enter your password",
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),

                SizedBox(height: 12),

                // Forgot Password
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            "Reset Password",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Enter your email to reset password"),
                              SizedBox(height: 16),
                              TextFormField(
                                controller: _emailController,
                                decoration: InputDecoration(
                                  labelText: "Email",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: Text("Cancel"),
                            ),
                            TextButton(
                              onPressed: () async {
                                if (_emailController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text("Email cannot be empty"),
                                      backgroundColor: Colors.red.shade600,
                                    ),
                                  );
                                  return;
                                }
                                await AuthService().resetPassword(_emailController.text).then((value) {
                                  if (value == "Mail Sent") {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text("Password reset link sent to your email"),
                                        backgroundColor: Colors.green.shade600,
                                      ),
                                    );
                                    Navigator.pop(context);
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(value),
                                        backgroundColor: Colors.red.shade600,
                                      ),
                                    );
                                  }
                                });
                              },
                              child: Text("Submit"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 24),

                // Login Button
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
                            .loginWithEmail(
                          _emailController.text,
                          _passwordController.text,
                        )
                            .then((value) {
                          setState(() => _isLoading = false);
                          if (value == "Login Successful") {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text("Login Successful"),
                                backgroundColor: Colors.green.shade600,
                              ),
                            );
                            Navigator.restorablePushNamedAndRemoveUntil(
                              context,
                              "/home",
                                  (route) => false,
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(value),
                                backgroundColor: Colors.red.shade600,
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
                      "Sign In",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),

                Spacer(),

                // Sign Up Link
                Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, "/signup");
                        },
                        child: Text(
                          "Sign Up",
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