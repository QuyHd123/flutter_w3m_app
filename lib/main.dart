import 'package:flutter/material.dart';
import 'package:web3modal_flutter/web3modal_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late W3MService _w3mService;

  @override
  void initState() {
    super.initState();
    initW3mService();
  }

  Future<void> initW3mService() async {
    W3MChainPresets.chains.putIfAbsent(_sepolia.chainId, () => _sepolia);
    _w3mService = W3MService(
      projectId: '535c336346993cc7665f4ceb985a829e',
      metadata: const PairingMetadata(
        name: 'Web3Modal Flutter Example',
        description: 'Web3Modal Flutter Example',
        url: 'https://www.walletconnect.com/',
        icons: ['https://walletconnect.com/walletconnect-logo.png'],
        redirect: Redirect(
          native: 'flutter_w3m_app://', // your own custom scheme
          universal: 'https://www.walletconnect.com',
        ),
      ),
    );
    await _w3mService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Web3Modal Test'),
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            W3MConnectWalletButton(service: _w3mService),
            const SizedBox(height: 24.0),
            W3MNetworkSelectButton(service: _w3mService),
            const SizedBox(height: 24.0),
            W3MAccountButton(service: _w3mService),
            const SizedBox(height: 24.0),
            OutlinedButton(
              onPressed: _handlePersonalSign,
              child: const Text('Sign Message'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handlePersonalSign() async {
    await _w3mService.launchConnectedWallet();
    final signature = await _w3mService.web3App!.request(
      topic: _w3mService.session!.topic!,
      chainId: 'eip155:1',
      request: const SessionRequestParams(
        method: 'personal_sign',
        params: [
          'Sign this', // Message to sign
          '0x2A9eF57a69931726047d0643C11FAda1C47Bf08e' // Wallet address to sign message,
        ],
      ),
    );
    print('Returned data: $signature');
  }
}

final _sepolia = W3MChainInfo(
  chainName: 'Sepolia Testnet',
  chainId: '11155111',
  namespace: 'eip155:11155111',
  tokenName: 'SEP',
  rpcUrl: 'https://ethereum-sepolia.publicnode.com',
  blockExplorer: W3MBlockExplorer(
    name: 'Sepolia Etherscan',
    url: 'https://sepolia.etherscan.io/',
  ),
);
