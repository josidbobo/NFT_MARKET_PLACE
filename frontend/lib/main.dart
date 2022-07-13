import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/metamask_provider.dart';
import './provider/upload_provider.dart';
import './screens/nft_page.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MetaMaskProvider()),
        ChangeNotifierProvider(create: (_) => UploadProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'JOSHUA NFT MARKETPLACE',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(),
        initialRoute: '/',
        routes: {
          '/': (context) => const MyHomePage(),
          '/home': (context) => NftPage()
        });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MetaMaskProvider()..init(),
        builder: (context, child) {
          return Scaffold(
            body: SafeArea(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                      padding: const EdgeInsets.all(25),
                      child: Consumer<MetaMaskProvider>(
                        builder: ((context, provider, child) {
                          late String text;
                          if (provider.isConnected &&
                              provider.isOperatingChain) {
                            Navigator.of(context).pushReplacementNamed("/home");
                          }
                          if (provider.isConnected &&
                              !provider.isOperatingChain) {
                            text =
                                "Wrong Chain ${context.watch<MetaMaskProvider>().currentChain}. Please connect to Rinkeby!";
                          } else if (provider.isEnabled &&
                              !provider.isConnected) {
                            return Column(
                              children: [
                                const Text(
                                  "Welcome to Oasis NFT marketplace, Explore beyond limits! 🤖",
                                  style: TextStyle(fontSize: 32),
                                ),
                                const SizedBox(
                                  height: 12,
                                ),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: const Color.fromRGBO(
                                          33, 150, 243, 1)),
                                  onPressed: () => context
                                      .read<MetaMaskProvider>()
                                      .connect(),
                                  child: const Text("Connect"),
                                )
                              ],
                            );
                          } else {
                            text =
                                "Please use an ethereum enabled Browser or extension";
                          }
                          return ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                    colors: [
                                      Colors.purpleAccent,
                                      Colors.blue,
                                      Colors.red
                                    ],
                                  ).createShader(bounds),
                              child: Text(
                                text,
                                textAlign: TextAlign.center,
                              ));
                        }),
                      )),
                )
              ],
            )),
          );
        });
  }
}
