import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/pages/edit_page.dart';
import 'package:whatsapp/providers/products.dart';

class ListTileProd extends StatelessWidget {
  final String id, title, gaji;
  final DateTime createdAt;
  const ListTileProd(
      {super.key,
      required this.id,
      required this.title,
      required this.createdAt,
      required this.gaji});

  @override
  Widget build(BuildContext context) {
    final provItem = Provider.of<Products>(context, listen: false);
    final dateUpdate = DateFormat('EEEE, d MMMM y').format(createdAt);

    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, EditPage.nameRoute, arguments: id);
      },
      leading: CircleAvatar(
        child: Text(gaji),
      ),
      title: Text(title),
      subtitle: Text(dateUpdate),
      trailing: IconButton(
          onPressed: () {
            provItem.deleteprod(id).then((value) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text('Berhasil Dihapus'),
                duration: Duration(milliseconds: 500),
              ));
            });
          },
          icon: const Icon(Icons.delete)),
    );
  }
}
