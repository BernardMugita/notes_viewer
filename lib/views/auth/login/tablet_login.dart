import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:note_viewer/providers/auth_provider.dart';
import 'package:note_viewer/providers/toggles_provider.dart';
import 'package:note_viewer/utils/app_utils.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/failed_widget.dart';
import 'package:note_viewer/widgets/app_widgets/alert_widgets/success_widget.dart';
import 'package:provider/provider.dart';

class TabletLogin extends StatelessWidget {
  const TabletLogin({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            padding:
                const EdgeInsets.only(top: 20, bottom: 20, left: 40, right: 40),
            decoration: const BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/images/mobile_banner.png'),
              ),
            ),
            child: Column(
              children: [
                const Expanded(
                  flex: 1,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "WELCOME",
                          style: TextStyle(
                            fontSize: 50,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "This platform was designed under the visionary leadership of Francis Flynn Chacha",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text("Powered by Labs"),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Gap(MediaQuery.of(context).size.height / 4),
                        TabBar(
                          labelColor: AppUtils.mainBlue(context),
                          unselectedLabelColor: AppUtils.mainBlack(context),
                          indicatorColor: Colors.blue,
                          labelStyle: TextStyle(fontSize: 18),
                          tabs: const [
                            Tab(text: "Sign in"),
                            Tab(text: "Sign up"),
                          ],
                        ),
                        const Gap(20),
                        Expanded(
                          child: TabBarView(
                            children: [
                              SignInTab(),
                              SignUpTab(),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (context.watch<AuthProvider>().success)
            Positioned(
                top: 20,
                right: 20,
                child: SuccessWidget(
                    message: context.watch<AuthProvider>().message))
          else if (context.watch<AuthProvider>().error)
            Positioned(
              top: 20,
              right: 20,
              child:
                  FailedWidget(message: context.watch<AuthProvider>().message),
            )
        ],
      ),
    );
  }
}

class SignInTab extends StatelessWidget {
  const SignInTab({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            "Use your email and password to sign in",
            style: TextStyle(fontSize: 16),
          ),
          Gap(10),
          TextField(
            controller: emailController,
            decoration: InputDecoration(
              prefixIcon: const Icon(FluentIcons.mail_24_regular),
              floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
              filled: true,
              fillColor: AppUtils.mainWhite(context),
              labelText: 'Email',
              border: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 212, 212, 212))),
              focusColor: AppUtils.mainBlue(context),
            ),
          ),
          const Gap(20),
          TextField(
            controller: passwordController,
            obscureText: !context.watch<TogglesProvider>().showPassword,
            decoration: InputDecoration(
              prefixIcon: const Icon(FluentIcons.lock_closed_24_regular),
              floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
              filled: true,
              fillColor: AppUtils.mainWhite(context),
              suffixIcon: GestureDetector(
                onTap: () {
                  context.read<TogglesProvider>().togglePassword();
                },
                child: Icon(context.watch<TogglesProvider>().showPassword
                    ? FluentIcons.eye_24_regular
                    : FluentIcons.eye_off_24_regular),
              ),
              labelText: 'Password',
              border: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 212, 212, 212))),
              focusColor: AppUtils.mainBlue(context),
            ),
          ),
          const Gap(20),
          Consumer<AuthProvider>(
            builder: (context, authProvider, child) {
              return ElevatedButton(
                onPressed: authProvider.isLoading
                    ? null
                    : () {
                        authProvider.login(
                          emailController.text,
                          passwordController.text,
                        );
                      },
                style: ButtonStyle(
                  backgroundColor: WidgetStatePropertyAll(
                    authProvider.isLoading
                        ? Colors.grey
                        : AppUtils.mainBlue(context),
                  ),
                  padding: WidgetStatePropertyAll(
                    const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  ),
                ),
                child: authProvider.isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2.5,
                        ),
                      )
                    : Text(
                        'Sign In',
                        style: TextStyle(
                            fontSize: 16, color: AppUtils.mainWhite(context)),
                      ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class SignUpTab extends StatelessWidget {
  const SignUpTab({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController usernameController = TextEditingController();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    TextEditingController regNoController = TextEditingController();
    // TextEditingController imageController = TextEditingController();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text("Use your Registration Number to create an account",
              style: TextStyle(fontSize: 16)),
          const Gap(10),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(FluentIcons.person_24_regular),
              floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
              filled: true,
              fillColor: AppUtils.mainWhite(context),
              labelText: 'Full Name',
              border: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 212, 212, 212))),
              focusColor: AppUtils.mainBlue(context),
            ),
          ),
          const Gap(10),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(FluentIcons.book_24_regular),
              floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
              filled: true,
              fillColor: AppUtils.mainWhite(context),
              labelText: 'Course',
              border: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 212, 212, 212))),
              focusColor: AppUtils.mainBlue(context),
            ),
          ),
          const Gap(10),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(FluentIcons.clipboard_24_regular),
              floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
              filled: true,
              fillColor: AppUtils.mainWhite(context),
              labelText: 'Registration Number',
              border: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 212, 212, 212))),
              focusColor: AppUtils.mainBlue(context),
            ),
          ),
          const Gap(20),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(FluentIcons.mail_24_regular),
              floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
              filled: true,
              fillColor: AppUtils.mainWhite(context),
              labelText: 'Email',
              border: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 212, 212, 212))),
              focusColor: AppUtils.mainBlue(context),
            ),
          ),
          const Gap(20),
          TextField(
            decoration: InputDecoration(
              prefixIcon: const Icon(FluentIcons.lock_closed_24_regular),
              floatingLabelStyle: TextStyle(color: AppUtils.mainBlack(context)),
              filled: true,
              fillColor: AppUtils.mainWhite(context),
              suffixIcon: GestureDetector(
                child: Icon(FluentIcons.eye_24_regular),
              ),
              labelText: 'Password',
              border: const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: Color.fromARGB(255, 212, 212, 212))),
              focusColor: AppUtils.mainBlue(context),
            ),
          ),
          const Gap(20),
          Consumer<AuthProvider>(builder: (context, authProvider, child) {
            return ElevatedButton(
              onPressed: authProvider.isLoading
                  ? null
                  : () {
                      authProvider.register(
                          usernameController.text,
                          emailController.text,
                          passwordController.text,
                          phoneController.text,
                          regNoController.text,
                          'test.jpg');
                    },
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(
                  authProvider.isLoading
                      ? Colors.grey
                      : AppUtils.mainBlue(context),
                ),
                padding: WidgetStatePropertyAll(
                    EdgeInsets.only(top: 20, bottom: 20, left: 10, right: 10)),
              ),
              child: authProvider.isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2.5,
                      ),
                    )
                  : Text('Sign Up',
                      style: TextStyle(
                          fontSize: 16, color: AppUtils.mainWhite(context))),
            );
          })
        ],
      ),
    );
  }
}
