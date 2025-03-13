import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:koul_network/UI/global_widget/snackbar_customwidget.dart';
import 'package:koul_network/UI/home/pay_to_koul_id/screens/previous_transactions_screen.dart';
import 'package:koul_network/bloc/koul_account_bloc/koul_account_bloc/koul_account_bloc.dart';
import 'package:koul_network/core/enums/route_path.dart';
import 'package:koul_network/core/enums/show_phone.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QRScanner extends StatefulWidget {
  static const routeName = "QRScanner";
  const QRScanner({super.key});

  @override
  State<QRScanner> createState() => _QRScannerState();
}

class _QRScannerState extends State<QRScanner> {
  bool flash = false;

  late MobileScannerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = MobileScannerController(
      facing: CameraFacing.back,
      torchEnabled: flash,
      detectionSpeed: DetectionSpeed.noDuplicates,
    );
  }

  void _toggleFlash() {
    setState(() {
      flash = !flash;
      _controller.toggleTorch();
    });
  }

  void _switchCamera() {
    _controller.switchCamera();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);
    return PopScope(
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          title: Text(
            "Scan and Pay",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          actions: [
            IconButton(
              onPressed: () {
                _toggleFlash();
              },
              icon: Icon(flash ? Icons.flash_on : Icons.flash_off),
            ),
            IconButton(
              onPressed: () {
                _switchCamera();
              },
              icon: const Icon(Icons.cameraswitch_rounded),
            ),
          ],
        ),
        body: BlocConsumer<KoulAccountBloc, KoulAccountState>(
          listener: (context, state) {
            if (state is KoulIdSuccessState) {
              Navigator.of(context).pushReplacementNamed(
                  PreviousTransactionsScreen.routeName,
                  arguments: {
                    "showphone": ShowPhone.phoneNotVisible,
                    "route": RoutePath.payToQRCode
                  });
            } else if (state is FailureState) {
              Navigator.of(context).pop();
              buildSnackBar(context, state.error);
            }
          },
          builder: (context, state) {
            if (state is LoadingState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              );
            }
            return Center(
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.060),
                    child: Text(
                      "Place the QR code in the box",
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  SizedBox(
                    height: screenSize.height * 0.5135,
                    width: screenSize.height * 0.4608,
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.circular(screenSize.height * 0.0329),
                      child: LayoutBuilder(
                        builder: (context, constraints) => MobileScanner(
                          onScannerStarted: (arguments) {},
                          controller: _controller,
                          onDetect: (barcode) {
                            BarcodeCapture qrCode = barcode;

                            final koulId = qrCode.barcodes[0].rawValue!;
                            context
                                .read<KoulAccountBloc>()
                                .add(KoulAccountExistEvent(toKoulId: koulId));
                          },
                          scanWindow: Rect.fromCenter(
                            center: Offset(constraints.maxWidth / 2,
                                constraints.maxHeight / 2),
                            height: screenSize.height * 0.5135,
                            width: screenSize.height * 0.4608,
                          ),
                          overlay: Stack(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                height: screenSize.height * 0.5135,
                                width: screenSize.height * 0.4608,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(
                                      screenSize.height * 0.0329),
                                  border: Border.all(
                                    width: screenSize.height * 0.00495,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 0,
                                right: screenSize.height * 0.1119,
                                left: screenSize.height * 0.1119,
                                child: Container(
                                  width: screenSize.height * 0.1317,
                                  height: screenSize.height * 0.00495,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                right: screenSize.height * 0.1119,
                                left: screenSize.height * 0.1119,
                                child: Container(
                                  width: screenSize.height * 0.1317,
                                  height: screenSize.height * 0.00495,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                              Positioned(
                                top: screenSize.height * 0.1119,
                                bottom: screenSize.height * 0.1119,
                                right: 0,
                                child: Container(
                                  width: screenSize.height * 0.00495,
                                  height: screenSize.height * 0.1317,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                              Positioned(
                                top: screenSize.height * 0.1119,
                                bottom: screenSize.height * 0.1119,
                                left: 0,
                                child: Container(
                                  width: screenSize.height * 0.00495,
                                  height: screenSize.height * 0.1317,
                                  color: Colors.grey.shade900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: screenSize.height * 0.0658),
                    child: Text(
                      "Only KOUL NETWORK QR codes are valid",
                      style: Theme.of(context).textTheme.displayMedium,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
      onPopInvoked: (_) {
        context.read<KoulAccountBloc>().add(GetAllTransactionsListEvent());
      },
    );
  }
}
