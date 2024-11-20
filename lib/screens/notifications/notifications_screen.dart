import 'package:flutter/material.dart';

import '../../config/theme/my_colors.dart';
import '../../shared/appbar_with_back.dart';

class NotificationsScreen extends StatefulWidget {
  static const String name = 'notifications_screen';

  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final ScrollController _scrollController = ScrollController();

  Color _appBarColor = Colors.white;
  Color _textColor = Colors.black;
  Color _iconColor = MyColors.primaryColor;
  Color _iconBackgroundColor = MyColors.primarySwatch[50]!;

  // Ejemplo de datos de notificaciones
  final List<Map<String, String>> _notifications = [
    {
      'image': 'https://via.placeholder.com/50', // URL de la imagen
      'title': 'Notificación 1',
      'description': 'Esta es la descripción de la notificación 1.'
    },
    {
      'image': 'https://via.placeholder.com/50',
      'title': 'Notificación 2',
      'description': 'Esta es la descripción de la notificación 2.'
    },
    {
      'image': 'https://via.placeholder.com/50',
      'title': 'Notificación 3',
      'description': 'Esta es la descripción de la notificación 3.'
    },
    {
      'image': 'https://via.placeholder.com/50',
      'title': 'Notificación 4',
      'description': 'Esta es la descripción de la notificación 4.'
    },
    {
      'image': 'https://via.placeholder.com/50',
      'title': 'Notificación 5',
      'description': 'Esta es la descripción de la notificación 5.'
    },
    {
      'image': 'https://via.placeholder.com/50',
      'title': 'Notificación 6',
      'description': 'Esta es la descripción de la notificación 6.'
    },
    {
      'image': 'https://via.placeholder.com/50',
      'title': 'Notificación 7',
      'description': 'Esta es la descripción de la notificación 7.'
    },
    {
      'image': 'https://via.placeholder.com/50',
      'title': 'Notificación 8',
      'description': 'Esta es la descripción de la notificación 8.'
    },
    {
      'image': 'https://via.placeholder.com/50',
      'title': 'Notificación 9',
      'description': 'Esta es la descripción de la notificación 9.'
    },
    {
      'image': 'https://via.placeholder.com/50',
      'title': 'Notificación 10',
      'description': 'Esta es la descripción de la notificación 10.'
    },
  ];

  @override
  void initState() {
    super.initState();
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
        title: 'Notificaciones',
        backgroundColor: _appBarColor,
        textColor: _textColor,
        iconColor: _iconColor,
        iconBackgroundColor: _iconBackgroundColor,
      ),
      // body: ListView.builder(
      //   padding: const EdgeInsets.all(15.0),
      //   itemCount: _notifications.length,
      //   itemBuilder: (context, index) {
      //     return _buildNotificationItem(
      //       _notifications[index]['image']!,
      //       _notifications[index]['title']!,
      //       _notifications[index]['description']!,
      //     );
      //   },
      // ),
      body: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0),
        child: ListView.separated(
          controller: _scrollController,
          padding: const EdgeInsets.all(15.0),
          itemCount: _notifications.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            return _buildNotificationItem(
              _notifications[index]['image']!,
              _notifications[index]['title']!,
              _notifications[index]['description']!,
            );
          },
        ),
      ),
    );
  }

  // Widget _buildNotificationCard(
  //     String imageUrl, String title, String description) {
  //   return Card(
  //     margin: const EdgeInsets.symmetric(vertical: 10.0),
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(15.0), // Bordes redondeados
  //     ),
  //     elevation: 3, // Sombra en el card
  //     child: ListTile(
  //       contentPadding: const EdgeInsets.all(15.0),
  //       leading: CircleAvatar(
  //         backgroundImage: NetworkImage(imageUrl),
  //         radius: 30, // Tamaño de la imagen
  //       ),
  //       title: Text(
  //         title,
  //         style: const TextStyle(
  //           fontWeight: FontWeight.bold,
  //           fontSize: 16,
  //         ),
  //       ),
  //       subtitle: Text(
  //         description,
  //         style: const TextStyle(
  //           fontSize: 14,
  //           color: Colors.grey,
  //         ),
  //       ),
  //       onTap: () {
  //         // Acción cuando se presiona la notificación
  //       },
  //     ),
  //   );
  // }

  Widget _buildNotificationItem(
      String imageUrl, String title, String description) {
    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: () {},
      // splashColor: MyColors.primarySwatch[50],
      // highlightColor: MyColors.primarySwatch[50],
      // focusColor: MyColors.primarySwatch[50],
      // hoverColor: MyColors.primarySwatch[50],
      child: ListTile(
        dense: true,
        // contentPadding: const EdgeInsets.only(left: 12, right: 8),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(imageUrl),
          radius: 30, // Tamaño de la imagen
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          description,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert), // Icono de tres puntos
          onPressed: () {
            // Acción cuando se presiona el ícono de tres puntos
          },
        ),
      ),
    );
  }
}
