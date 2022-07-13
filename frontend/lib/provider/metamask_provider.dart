import 'package:flutter_web3/flutter_web3.dart';
import 'package:flutter/material.dart';

class MetaMaskProvider extends ChangeNotifier {
  static const operatingChain = 4;

  String currentAddress = "";

  int currentChain = -1;

  bool get isEnabled => ethereum != null;

  bool get isOperatingChain => currentChain == operatingChain;

  bool get isConnected => isEnabled && currentAddress.isNotEmpty;

  Future<void> connect() async {
    if (isEnabled) {
      final accounts = await ethereum!.requestAccount();

      if (accounts.isNotEmpty) {
        currentAddress = accounts.first;
        currentChain = await ethereum!.getChainId();
      }
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    clear();
    notifyListeners();
  }

  clear() {
    currentAddress = "";
    currentChain = -1;
    notifyListeners();
  }

  init() {
    if (isEnabled) {
      ethereum!.onAccountsChanged((accounts) {
        clear();
      });
      ethereum!.onChainChanged((accounts) {
        clear();
      });
    }
  }
}
