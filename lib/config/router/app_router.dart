import 'package:go_router/go_router.dart';
import 'package:nutrition_ai_app/screens/screens.dart';

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
      path: '/home',
      name: HomeScreen.name,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/user-register',
      name: UserRegisterScreen.name,
      builder: (context, state) => const UserRegisterScreen(),
    ),
    GoRoute(
      path: '/user-profile',
      name: RegisterProfileScreen.name,
      builder: (context, state) => const RegisterProfileScreen(),
    ),
    GoRoute(
      path: '/meal-plan/create',
      name: CreateMealPlanScreen.name,
      builder: (context, state) => const CreateMealPlanScreen(),
    ),
    GoRoute(
      path: '/meal-plan/detail',
      name: MealDetailScreen.name,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return MealDetailScreen(
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
      path: '/food-list',
      name: FoodListScreen.name,
      builder: (context, state) => const FoodListScreen(),
    ),
    GoRoute(
      path: '/food-detail',
      name: FoodDetailScreen.name,
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return FoodDetailScreen(
          title: extra['title'] as String,
          description: extra['description'] as String,
          imagePath: extra['imagePath'] as String,
        );
      },
    ),
    GoRoute(
      path: '/notifications',
      name: NotificationsScreen.name,
      builder: (context, state) => NotificationsScreen(),
    ),
  ],
);
