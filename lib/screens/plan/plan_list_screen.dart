import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:iconsax/iconsax.dart';

import '../../config/theme/my_colors.dart';
import '../../controllers/plan/plan_controller.dart';
import '../../models/plan.dart';
import '../../providers/plan_provider.dart';
import '../../shared/appbar_with_back.dart';
import '../../shared/utils/format_date.dart';
import '../screens.dart';

class PlanListScreen extends ConsumerStatefulWidget {
  static const String name = 'plan_list_screen';

  const PlanListScreen({super.key});

  @override
  PlanListScreenState createState() => PlanListScreenState();
}

class PlanListScreenState extends ConsumerState<PlanListScreen> {
  final PlanController _con = PlanController();
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _con.init(context, refresh, ref);
    });

    // _searchController.addListener(_filterFoodItems);
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
    _scrollController.dispose();
    // _searchController.dispose();
    // _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithBack(
        title: 'Mis planes',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
        showBackButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _searchBar(context, ref),
          // const SizedBox(height: 25),
          // _filterCategory(),
          // const SizedBox(height: 15),
          _planList(),
        ],
      ),
    );
  }

  // Lista de planes
  Widget _planList() {
    final plans = ref.watch(planProvider);

    if (plans.isEmpty) {
      // Mostrar un texto cuando no haya comidas con bordes punteados
      return Expanded(
        child: Container(
          margin: const EdgeInsets.all(25),
          child: DottedBorder(
            radius: const Radius.circular(15),
            borderType: BorderType.RRect,
            color: Colors.grey,
            strokeWidth: 1.5,
            dashPattern: const [7, 5],
            child: const Center(
              child: Text(
                'No se encontraron planes',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      );
    }

    // Mostrar la lista de comidas cuando haya elementos
    return Expanded(
      child: ListView.separated(
        padding: const EdgeInsets.all(25),
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: plans.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final plan = plans[index];
          return _planItemCard(plan, index);
        },
      ),
    );
  }

  // Tarjeta de cada alimento
  Widget _planItemCard(Plan plan, int index) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5),
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
          onTap: () async {
            // Seleccionar el plan y navegar a la pantalla de detalle
            await _con.getPlanById(plan.planId);

            if (mounted) {
              context.pushNamed(PlanDetailScreen.name, extra: {
                'planTitle': 'PLAN ${index + 1}',
              });
            }
          },
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                decoration: BoxDecoration(
                  color: MyColors.primaryColor,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  'PLAN ${index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 5),
              Text(
                plan.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ],
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 5),
              Row(
                children: [
                  Icon(
                    Iconsax.calendar_1,
                    size: 20,
                    color: MyColors.primaryColor,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "Creado:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    formatDate(plan.dateGeneration),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                children: [
                  Icon(
                    Iconsax.tick_square,
                    size: 20,
                    color: MyColors.primaryColor,
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    "Estado:",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    plan.status,
                  ),
                ],
              )
            ],
          ),
          trailing: const Icon(
            Iconsax.arrow_circle_right,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  void refresh() {
    setState(() {});
  }
}
