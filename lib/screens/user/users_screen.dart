import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:nutrition_ai_app/controllers/user/user_controller.dart';
import 'package:nutrition_ai_app/models/user.dart'; // Cambiar el modelo Food por User

import '../../config/theme/my_colors.dart';
import '../../providers/users_provider.dart';
import '../../shared/appbar_with_back.dart';

class UsersListScreen extends ConsumerStatefulWidget {
  static const String name = 'users_list_screen';

  const UsersListScreen({super.key});

  @override
  UsersListScreenState createState() => UsersListScreenState();
}

class UsersListScreenState extends ConsumerState<UsersListScreen> {
  final UserController _userCon = UserController();
  final ScrollController _scrollController = ScrollController();
  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocus = FocusNode();

  List<User> _filteredUsers = [];

  @override
  void initState() {
    super.initState();

    SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
      _userCon.init(context, refresh, ref: ref);
    });

    _searchController.addListener(_filterUserItems);
    _scrollController.addListener(() {
      setState(() {
        if (_scrollController.position.pixels > 1) {
          _appBarColor = MyColors.primarySwatch;
          _textColor = Colors.white;
          _iconColor = MyColors.primaryColor;
          _iconBackgroundColor = Colors.white;
        } else {
          _appBarColor = Colors.white;
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
    _searchController.dispose();
    _searchFocus.dispose();
    super.dispose();
  }

  void _filterUserItems({bool isFiltering = false}) {
    setState(() {
      String searchTerm = _searchController.text.toLowerCase();
      _filteredUsers = ref.watch(usersProvider).where((user) {
        bool matchesSearchTerm = user.name.toLowerCase().contains(searchTerm) ||
            user.lastname.toLowerCase().contains(searchTerm);
        return matchesSearchTerm;
      }).toList();
    });

    if (isFiltering) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _filterUserItems();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBarWithBack(
        title: 'Usuarios',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
        showBackButton: false,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _searchBar(),
          const SizedBox(height: 25),
          _userList(),
        ],
      ),
    );
  }

  // Campo de Búsqueda
  Widget _searchBar() {
    return Container(
      margin: const EdgeInsets.only(left: 25, right: 25, top: 25),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: TextField(
        controller: _searchController,
        focusNode: _searchFocus,
        decoration: const InputDecoration(
          hintText: 'Buscar usuario...',
          prefixIcon: Icon(Icons.search),
          border: InputBorder.none,
          contentPadding: EdgeInsets.all(15),
        ),
      ),
    );
  }

  // Lista de Usuarios Filtrados
  Widget _userList() {
    if (_filteredUsers.isEmpty) {
      return Expanded(
        child: Container(
          margin: const EdgeInsets.only(
            left: 25,
            right: 25,
            top: 15,
            bottom: 25,
          ),
          child: DottedBorder(
            radius: const Radius.circular(15),
            borderType: BorderType.RRect,
            color: Colors.grey,
            strokeWidth: 1.5,
            dashPattern: const [7, 5],
            child: const Center(
              child: Text(
                'No se encontraron usuarios',
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

    return Expanded(
      child: ListView.separated(
        padding:
            const EdgeInsets.only(left: 25, right: 25, top: 15, bottom: 30),
        shrinkWrap: true,
        controller: _scrollController,
        itemCount: _filteredUsers.length,
        separatorBuilder: (context, index) => const SizedBox(height: 15),
        itemBuilder: (context, index) {
          final user = _filteredUsers[index];
          return _userItemCard(user: user);
        },
      ),
    );
  }

  // Tarjeta de cada usuario
  Widget _userItemCard({
    required User user,
  }) {
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
      ),
      child: Card(
        color: Colors.white,
        elevation: 0,
        child: ListTile(
          splashColor: MyColors.primarySwatch[50],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          onTap: () {
            // ref.read(selectedUserProvider.notifier).state = user;
            // context.pushNamed(
            //   UserDetailScreen.name, // Cambia a la pantalla de detalles de usuario
            // );
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(5), // Bordes redondeados
            child: Image.network(
              user.urlImage, // Usa la URL proporcionada o una cadena vacía
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                // Si ocurre un error en la carga de la imagen, muestra una imagen predeterminada
                return Image.asset(
                  'assets/img/user_profile.png', // Imagen predeterminada
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                );
              },
            ),
          ),
          title: Text(
            '${user.name} ${user.lastname}', // Mostrar nombre completo
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(user.email),
              const SizedBox(height: 5),
              Text(
                'Telf. ${user.telephone}', // Mostrar teléfono u otro dato relevante
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              Text(
                'Edad: ${user.healthProfile.age} años', // Mostrar dirección u otro dato relevante
                style: const TextStyle(
                  color: Colors.grey,
                ),
              ),
              // Text(
              //   'Peso: ${user.healthProfile.weight} kg', // Mostrar dirección u otro dato relevante
              //   style: const TextStyle(
              //     color: Colors.grey,
              //   ),
              // ),
              // Text(
              //   'Altura: ${user.healthProfile.height} cm', // Mostrar dirección u otro dato relevante
              //   style: const TextStyle(
              //     color: Colors.grey,
              //   ),
              // )
            ],
          ), // Mostrar correo u otro dato relevante
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
