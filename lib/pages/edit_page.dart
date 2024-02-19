import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:whatsapp/providers/products.dart';
import 'package:whatsapp/widgets/tf_field.dart';

class EditPage extends StatelessWidget {
  const EditPage({super.key});
  static const nameRoute = '/editpage';

  @override
  Widget build(BuildContext context) {
    final provItem = Provider.of<Products>(context, listen: false);
    final idProd = ModalRoute.of(context)!.settings.arguments as String;
    final selectProd = provItem.selectById(idProd);
    TextEditingController namaController =
        TextEditingController(text: selectProd.nama);
    TextEditingController gajiController =
        TextEditingController(text: selectProd.gaji);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Data'),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            SizedBox(
              height: 150,
              width: 150,
              child: CircleAvatar(
                child: Text(selectProd.gaji),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TfField(title: 'Nama Pengguna', itemController: namaController),
            const SizedBox(
              height: 20,
            ),
            TfField(title: 'Gaji', itemController: gajiController),
            const Spacer(),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () {
                    provItem
                        .editProduct(
                            idProd, namaController.text, gajiController.text)
                        .then((value) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Berhasil Diubah'),
                        duration: Duration(milliseconds: 500),
                      ));
                      Navigator.pop(context);
                    });
                  },
                  child: const Text('EDIT')),
            )
          ],
        ),
      ),
    );
  }
}
