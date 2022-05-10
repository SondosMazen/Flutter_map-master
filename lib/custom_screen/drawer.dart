// import 'package:flutter/material.dart';
// import 'package:municipality_of_gaza/auth/auth_screens/login_screen.dart';
// import 'package:municipality_of_gaza/auth/model/user_model.dart';
// import 'package:municipality_of_gaza/auth/pref/user_preferences.dart';
//
// Widget _buildMenuItem(
//     BuildContext context, Widget title, String routeName, String currentRoute) {
//   var isSelected = routeName == currentRoute;
//   late User userDrawer = UserPreferences.instance.getUser()!;
//
//   return ListTile(
//     title: title,
//     selected: isSelected,
//     onTap: () {
//       if (isSelected) {
//         Navigator.pop(context);
//       } else {
//         Navigator.pushReplacementNamed(context, routeName);
//       }
//     },
//   );
// }
//
// Drawer buildDrawer(BuildContext context, String currentRoute) {
//   return Drawer(
//     child: ListView(
//       children: <Widget>[
//          DrawerHeader(
//           child: Center(
//             child: SizedBox(
//                 height: 200,
//                 width: 240,
//                 child: Image.asset('assets/images/app_icon.png'),),
//           ),
//         ),
//         _buildMenuItem(
//           context,
//           GestureDetector(
//             onTap: (){
//               UserPreferences.instance.logout();
//               Navigator.pushReplacementNamed(context, LoginScreen.routeName);
//             },
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 Icon(Icons.logout),
//                 Text( "تسجيل الخروج"),
//               ],
//             ),
//           ),
//           LoginScreen.routeName,
//           currentRoute,
//         ),
//       ],
//     ),
//   );
// }
