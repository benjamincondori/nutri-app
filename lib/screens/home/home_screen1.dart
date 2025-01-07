import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nutrition_ai_app/controllers/user/user_controller.dart';

import '../../config/theme/my_colors.dart';
import '../../providers/totals_provider.dart';
import '../../providers/user_provider.dart';
import '../../shared/appbar.dart';

class HomeScreen1 extends ConsumerStatefulWidget {
  static const String name = 'home_screen_1';

  const HomeScreen1({super.key});

  @override
  HomeScreen1State createState() => HomeScreen1State();
}

class HomeScreen1State extends ConsumerState<HomeScreen1> {
  final UserController _con = UserController();
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white; // Color inicial del AppBar
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, ref: ref);
    });

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
    _con.getTotals(ref);

    final user = ref.watch(userNutritionistProvider);
    final totals = ref.watch(totalsProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        userName: '${user?.name} ${user?.lastname}',
        profileImageUrl: user?.urlImage ??
            'https://img.lovepik.com/png/20231128/3d-illustration-avatar-profile-man-collection-guy-cheerful_716220_wh860.png',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            _buildStatisticsCard(
              'Usuarios',
              totals?.totalUsers.toString() ?? '0',
              Icons.people,
              MyColors.primaryColor,
            ),
            const SizedBox(height: 20),
            _buildStatisticsCard(
              'Planes Generados',
              totals?.totalPlans.toString() ?? '0',
              Icons.calendar_today,
              MyColors.primaryColor,
            ),
            const SizedBox(height: 20),
            _buildStatisticsCard(
              'Comidas',
              totals?.totalMeals.toString() ?? '0',
              Icons.fastfood,
              MyColors.primaryColor,
            ),
            const SizedBox(height: 20),
            _buildStatisticsCard(
              'Alimentos',
              totals?.totalFoods.toString() ?? '0',
              Icons.food_bank,
              MyColors.primaryColor,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatisticsCard(
      String title, String count, IconData icon, Color color) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: MyColors.primarySwatch[50],
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.6),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: MyColors.primarySwatch),
      ),
      child: Card(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(10),
          onTap: () {
            // Acciones al hacer clic, si es necesario.
            print('$title Card clicked');
          },
          splashColor: MyColors.primarySwatch[10],
          highlightColor: MyColors.primarySwatch[50],
          focusColor: MyColors.primarySwatch[50],
          hoverColor: MyColors.primarySwatch[50],
          child: ListTile(
            leading: Icon(
              icon,
              color: color,
            ),
            title: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            trailing: Text(
              count,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
