import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pi_block/blocs/auth/auth_bloc.dart';
import 'package:pi_block/components/global_banner.dart';
import 'package:pi_block/components/pi_validators.dart';
import 'package:pi_block/config/app_config.dart';
import 'package:pi_block/widgets/circular_loader_in_button.dart';
import 'package:pi_block/widgets/info_icon_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _passwordController = TextEditingController(text: AppConfig.apiToken);
  final _serverUrlController = TextEditingController(text: AppConfig.serverUrl);
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
      appBar: AppBar(title: Text("Login"), elevation: 0, leading: BackButton()),
      body: SafeArea(
        child: Center(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 900;
              return SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: FractionallySizedBox(
                    widthFactor: isWide ? 0.35 : 1,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Sign In",
                              style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          Form(
                            key: formKey,
                            child: Builder(
                              builder: (context) {
                                return Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: _serverUrlController,
                                            validator: (value) => piValidators
                                                .serverUrlValidator(value),
                                            decoration: InputDecoration(
                                              labelText: "Pi-Hole Server Url",
                                              suffixIcon: IconButton(
                                                onPressed:
                                                    _serverUrlController.clear,
                                                icon: Icon(Icons.clear),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5.0,
                                          ),
                                          child: InfoIconButton(
                                            message: "Pi-Hole server URL.\n\n"
                                            "Examples:\n"
                                            "https://pihole.example.com\n"
                                            "http://pihole.local\n"
                                            "http://192.168.1.2:8053",
                                            title: "Pi-Hole Server Url",
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextFormField(
                                            autovalidateMode: AutovalidateMode
                                                .onUserInteraction,
                                            controller: _passwordController,
                                            obscureText: passwordVisible,
                                            enableSuggestions: false,
                                            autocorrect: false,
                                            validator: (value) => piValidators
                                                .apiTokenValidator(value),
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
                                                    passwordVisible =
                                                        !passwordVisible;
                                                  });
                                                },
                                              ),
                                            ),
                                            keyboardType:
                                                TextInputType.visiblePassword,
                                            textInputAction:
                                                TextInputAction.done,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 5.0,
                                          ),
                                          child: InfoIconButton(
                                            message: "API Token which is used for FTLCONF_webserver_api_password in environment file",
                                            title: "API Token",
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    BlocConsumer<AuthBloc, AuthState>(
                                      /// success case will be handled by AppRouter
                                      listener: (context, state) {
                                        if (state.status ==
                                            AuthStateStatus.failure) {
                                          GlobalBanner.error(
                                            context,
                                            state.error,
                                            state.errorDescription,
                                          );
                                        }
                                      },
                                      builder: (context, state) {
                                        if (state.status ==
                                            AuthStateStatus.loading) {
                                          loading = true;
                                        } else if (state.status ==
                                            AuthStateStatus.failure) {
                                          loading = false;
                                        }
                                        return FilledButton(
                                          onPressed: () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              context.read<AuthBloc>().add(
                                                Login(
                                                  serverUrl:
                                                      _serverUrlController.text,
                                                  apiToken:
                                                      _passwordController.text,
                                                ),
                                              );
                                            }
                                          },
                                          style: ElevatedButton.styleFrom(
                                            minimumSize: Size(
                                              double.infinity,
                                              50,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
            },
          ),
        ),
      ),
    );
  }
}
