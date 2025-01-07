import 'package:flutter/material.dart';
import 'package:nutrition_ai_app/shared/utils/my_toastbar.dart';

import '../../config/theme/my_colors.dart';
import '../../shared/appbar_with_back.dart';

class PaymentMethodsScreen extends StatefulWidget {
  static const String name = 'payment_screen';

  const PaymentMethodsScreen({super.key});

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  @override
  void initState() {
    super.initState();

    // SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
    //   _con.init(context, refresh, ref);
    // });

    _scrollController.addListener(() {
      // Cambiar el color del AppBar cuando se haga scroll
      setState(() {
        if (_scrollController.position.pixels > 1) {
          _appBarColor = MyColors.primarySwatch; // Color al hacer scroll
          _textColor = Colors.white;
          _iconColor = MyColors.primaryColor;
          _iconBackgroundColor = Colors.white;
        } else {
          _appBarColor = Colors.white; // Color inicial
          _textColor = Colors.black;
          _iconColor = MyColors.primaryColor;
          _iconBackgroundColor = MyColors.primarySwatch[50]!;
        }
      });
    });
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Limpiar el controlador
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithBack(
        title: 'Métodos de Pago',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
      ),
      body: ListView(
        controller: _scrollController,
        padding: const EdgeInsets.all(25.0),
        children: [
          PaymentMethodCard(
            title: "Pagar con Stripe",
            description:
                "Utiliza tu tarjeta de crédito o débito para realizar el pago de manera segura.",
            icon: Icons.credit_card,
            onTap: () {
              // Lógica para redirigir a Stripe
            },
          ),
          const SizedBox(height: 16.0),
          PaymentMethodCard(
            title: "Pagar con PayPal",
            description: "Realiza tu pago utilizando tu cuenta de PayPal.",
            icon: Icons.account_balance_wallet,
            onTap: () {
              // Lógica para redirigir a PayPal
              MyToastBar.showInfo(context, 'No disponible');
            },
          ),
          const SizedBox(height: 16.0),
          PaymentMethodCard(
            title: "Pagar con Transferencia Bancaria",
            description:
                "Realiza una transferencia directamente desde tu banco.",
            icon: Icons.account_balance,
            onTap: () {
              // Lógica para redirigir a Transferencia Bancaria
              MyToastBar.showInfo(context, 'No disponible');
            },
          ),
        ],
      ),
    );
  }

}

class PaymentMethodCard extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback onTap;

  const PaymentMethodCard({
    super.key,
    required this.title,
    required this.description,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
        // border: Border.all(color: MyColors.primarySwatch),
      ),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: ListTile(
          splashColor: MyColors.primarySwatch[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          leading: Icon(icon, size: 36.0),
          title: Text(title),
          subtitle: Text(description),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: onTap,
        ),
      ),
    );
  }
}
