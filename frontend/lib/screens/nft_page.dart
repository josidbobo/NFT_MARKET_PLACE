import "package:flutter/material.dart";
import 'package:nft_minting_app/provider/upload_provider.dart';
import 'package:provider/provider.dart';

class NftPage extends StatefulWidget {
  NftPage({Key? key}) : super(key: key);

  @override
  State<NftPage> createState() => _NftPageState();
}

class _NftPageState extends State<NftPage> {
  
void _showDialog(context) {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (_) {
          return ChangeNotifierProvider(
              create: (context) => UploadProvider(),
              builder: (context, child) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Consumer<UploadProvider>(
                      builder: ((context, provider, child) {
                        late Widget title;
                        provider.isUnAssigned
                            ? title = Image.asset("assets/market.png")
                            : provider.isWeb
                                ? title = Image.memory(
                                    context.watch<UploadProvider>().webImage)
                                : title = Image.file(
                                    context.watch<UploadProvider>().getFile);
                  return ListTile(
                          leading: ElevatedButton(
                            onPressed: () => context.read<UploadProvider>().uploadImage(),
                            child: const Text("Upload"),
                          ),
                          title: title,
                        );
                      }),
                    ),
                  ],
                );
              });
        });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            padding: EdgeInsets.only(
                right: MediaQuery.of(context).size.width * 0.21,
                left: MediaQuery.of(context).size.width * 0.21),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.21,
                      height: 24,
                      padding: const EdgeInsets.only(top: 5, bottom: 5),
                      child: const Text("0x32455644474636372928h3hh3x321"),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.03,
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width * 0.07,
                      padding: const EdgeInsets.only(top: 4, bottom: 5),
                      child: ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary: const Color.fromRGBO(33, 150, 243, 1)),
                        child: const Text('Disconnect'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    ElevatedButton(
                      onPressed: () => _showDialog(context),
                      style: ElevatedButton.styleFrom(
                          primary: Color.fromRGBO(41, 162, 91, 1)),
                      child: const Text('Create NFT'),
                    ),
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.width * 0.09,
                ),
                // Expanded(
                //      child: Text('hola')
                //      //GridView(
                // //   padding: const EdgeInsets.all(8),
                // //   gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                // //     // width of the Grid.
                // //     maxCrossAxisExtent:
                // //         MediaQuery.of(context).size.width * 0.18,
                // //     // How the items should be sized regarding their height and width relation.
                // //     childAspectRatio: 4 / 2,
                // //     // spacing between them cross wise.
                // //     crossAxisSpacing: 15,
                // //     // spacing between them main wise ie down the GRID.
                // //     mainAxisSpacing: 15,
                // //   ),
                // //   children: [Text("Na here we dey my boss"), Text("Oya turn up o")],
                // // )
                // )
              ],
            )),
      ),
    );
  }
}
