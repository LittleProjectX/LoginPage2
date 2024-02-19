import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/pages/add_page.dart';
import 'package:whatsapp/providers/authn.dart';
import 'package:whatsapp/providers/products.dart';
import 'package:whatsapp/widgets/lt_prod.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static const nameRoute = '/homepage';

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool setStat = false;

  @override
  void didChangeDependencies() {
    if (!setStat) {
      Provider.of<Products>(context).initstate();
      print('didchange');
      setStat = true;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final provItem = Provider.of<Products>(context, listen: false);

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
              onPressed: () =>
                  Provider.of<Authn>(context, listen: false).logOut(),
              icon: const Icon(Icons.logout)),
          title: const Text('Daftar Whatsapp'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, AddPage.nameRoute);
                },
                icon: const Icon(Icons.add))
          ],
        ),
        body: (provItem.jmlhData == 0)
            ? Center(
                child: Text(
                  'No Data',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            : ListView.builder(
                itemCount: provItem.jmlhData,
                itemBuilder: (context, index) => ListTileProd(
                    id: provItem.allData[index].id,
                    title: provItem.allData[index].nama,
                    createdAt: provItem.allData[index].createdAt,
                    gaji: provItem.allData[index].gaji),
              ));
  }
}
