import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/components/global_snackbar.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/widgets/circular_loader_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordController = TextEditingController(
    text: dotenv.env['API_TOKEN'] ?? '',
  );
  final _serverUrlController = TextEditingController(
    text: dotenv.env['SERVER_URL'] ?? '',
  );
  bool loading = false;
  bool passwordVisible = true;
  PiValidators piValidators = PiValidators();
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _passwordController.dispose();
    _serverUrlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            context.go("/");
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.15),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    "Sign In",
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: formKey,
                  child: Builder(
                    builder: (context) {
                      return Column(
                        children: [
                          Tooltip(
                            message:
                                "Pi-Hole server url. \nExamples \nhttps://pihole.example.com \nhttp://pihole.local \nhttp://192.168.1.2:8053",
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.all(20),
                            verticalOffset: 10,
                            preferBelow: false,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _serverUrlController,
                              validator: (value) =>
                                  piValidators.serverUrlValidator(value),
                              decoration: InputDecoration(
                                labelText: "Pi-Hole Server Url",
                                suffixIcon: IconButton(
                                  onPressed: _serverUrlController.clear,
                                  icon: Icon(Icons.clear),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Tooltip(
                            message:
                                "API Token which is used for FTLCONF_webserver_api_password in environment file",
                            padding: EdgeInsets.all(10.0),
                            margin: EdgeInsets.all(20),
                            verticalOffset: 10,
                            preferBelow: false,
                            child: TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              controller: _passwordController,
                              obscureText: passwordVisible,
                              enableSuggestions: false,
                              autocorrect: false,
                              validator: (value) =>
                                  piValidators.apiTokenValidator(value),
                              decoration: InputDecoration(
                                labelText: "API Token",
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      passwordVisible = !passwordVisible;
                                    });
                                  },
                                ),
                              ),
                              keyboardType: TextInputType.visiblePassword,
                              textInputAction: TextInputAction.done,
                            ),
                          ),
                          const SizedBox(height: 20),
                          BlocConsumer<AuthBloc, AuthState>(
                            listener: (context, state) {
                              if (state.status == AuthStateStatus.loggedIn) {
                                context.go("/home");
                              } else if (state.status ==
                                  AuthStateStatus.failure) {
                                GlobalSnackbar.error(
                                  context,
                                  state.error,
                                  state.errorDescription,
                                );
                              }
                            },
                            builder: (context, state) {
                              if (state.status == AuthStateStatus.loading) {
                                loading = true;
                              } else if (state.status ==
                                  AuthStateStatus.failure) {
                                loading = false;
                              }
                              return FilledButton(
                                onPressed: () {
                                  if (formKey.currentState!.validate()) {
                                    context.read<AuthBloc>().add(
                                      Login(
                                        serverUrl: _serverUrlController.text,
                                        apiToken: _passwordController.text,
                                      ),
                                    );
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  minimumSize: Size(double.infinity, 50),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: loading
                                    ? CircularLoaderInButton()
                                    : Text("Login"),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
