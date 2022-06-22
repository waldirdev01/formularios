import 'package:flutter/material.dart';
import 'package:formularios/pages/product_over_view_page.dart';
import 'package:provider/provider.dart';

import '../models/auth.dart';
import 'auth_page.dart';

class AuthOrHomePage extends StatelessWidget {
  const AuthOrHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Auth auth = Provider.of(context);
    return auth.isAuth ? ProductsOverViewPage() : AuthPage();
  }
}
