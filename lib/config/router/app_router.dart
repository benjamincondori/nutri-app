import 'package:go_router/go_router.dart';
import 'package:nutrition_ai_app/screens/screens.dart';

import '../../models/food.dart';
import '../../models/meal.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: SplashScreen.name,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/login',
      name: LoginScreen.name,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/',
      name: MainScreen.name,
      builder: (context, state) => const MainScreen(),
    ),
    GoRoute(
      path: '/main-screen-1',
      name: MainScreen1.name,
      builder: (context, state) => const MainScreen1(),
    ),
    GoRoute(
      path: '/home',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/home1',
      name: HomeScreen1.name,
      builder: (context, state) => const HomeScreen1(),
    ),
    GoRoute(
      path: '/profile-nutritionist',
      name: ProfileScreen1.name,
      builder: (context, state) => const ProfileScreen1(),
    ),
    GoRoute(
      path: '/user-register',
      name: UserRegisterScreen.name,
      builder: (context, state) => const UserRegisterScreen(),
    ),
    GoRoute(
      path: '/user-profile',
      name: RegisterProfileScreen.name,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return RegisterProfileScreen(
          userId: extra['user_id'] as int,
        );
      },
    ),
    GoRoute(
      path: '/meal/list',
      name: MealListScreen.name,
      builder: (context, state) => const MealListScreen(),
    ),
    GoRoute(
      path: '/meal/create',
      name: MealCreateScreen.name,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return MealCreateScreen(
          mealToEdit: extra?['meal'] as Meal?,
        ); // Pasa el parámetro opcional
      },
    ),
    GoRoute(
      path: '/meal/detail',
      name: MealDetailScreen.name,
      builder: (context, state) => const MealDetailScreen(),
    ),
    GoRoute(
      path: '/meal-plan/create',
      name: CreateMealPlanScreen.name,
      builder: (context, state) => const CreateMealPlanScreen(),
    ),
    GoRoute(
      path: '/meal-plan/detail',
      name: MealPlanDetailScreen.name,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return MealPlanDetailScreen(
          mealType: extra['mealType'] as String,
          mealName: extra['mealName'] as String,
          calories: extra['calories'] as int,
          fats: extra['fats'] as double,
          proteins: extra['proteins'] as double,
          carbs: extra['carbs'] as double,
        );
      },
    ),
    GoRoute(
      path: '/food/create',
      name: FoodCreateScreen.name,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return FoodCreateScreen(
          foodToEdit: extra?['food'] as Food?,
        ); // Pasa el parámetro opcional
      },
    ),
    GoRoute(
      path: '/food/list',
      name: FoodListScreen.name,
      builder: (context, state) => const FoodListScreen(),
    ),
    GoRoute(
      path: '/food/detail',
      name: FoodDetailScreen.name,
      builder: (context, state) {
        return const FoodDetailScreen();
      },
    ),
    GoRoute(
      path: '/notifications',
      name: NotificationsScreen.name,
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/plan/list',
      name: PlanListScreen.name,
      builder: (context, state) => const PlanListScreen(),
    ),
    GoRoute(
      path: '/plan/detail',
      name: PlanDetailScreen.name,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return PlanDetailScreen(
          planTitle: extra?['planTitle'] as String,
        ); 
      },
    ),
    GoRoute(
      path: '/reports',
      name: ReportsScreen.name,
      builder: (context, state) => const ReportsScreen(),
    ),
    GoRoute(
      path: '/payment',
      name: PaymentMethodsScreen.name,
      builder: (context, state) => const PaymentMethodsScreen(),
    ),
  ],
);
