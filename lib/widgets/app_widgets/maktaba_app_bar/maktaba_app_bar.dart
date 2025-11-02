import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maktaba/providers/auth_provider.dart';
import 'package:maktaba/utils/app_utils.dart';
import 'package:provider/provider.dart';

class MaktabaAppBar extends StatelessWidget {
  const MaktabaAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Material(
        elevation: 1,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 60),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () => context.go('/'),
                child: Image(
                    image: AssetImage("assets/images/alib-hd-shaddow.png"),
                    height: 50),
              ),
              authProvider.isAuthenticated
                  ? ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          AppUtils.mainBlue(context),
                        ),
                      ),
                      onPressed: () => context.go('/dashboard'),
                      icon: const Icon(Icons.dashboard, color: Colors.white),
                      label: const Text('Go to Dashboard',
                          style: TextStyle(color: Colors.white)),
                    )
                  : ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll<Color>(
                          AppUtils.mainBlue(context),
                        ),
                      ),
                      onPressed: () => context.go('/login'),
                      child: const Text('Login',
                          style: TextStyle(color: Colors.white)),
                    )
            ],
          ),
        ));
  }
}
