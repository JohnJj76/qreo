import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:qreo/auth/auth_service.dart';
import 'package:qreo/custom/constants.dart';
import 'package:qreo/custom/library.dart';
import 'package:qreo/models/qre_models.dart';
import 'package:qreo/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart.';

class VerifEros extends StatefulWidget {
  const VerifEros({super.key});

  @override
  State<VerifEros> createState() => _VerifErosState();
}

class _VerifErosState extends State<VerifEros> {
  final authService = AuthService();
  Qress mQres = Qress();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(FocusNode());
      getQrEros();
    });
  }

  void loggout() async {
    await authService.signOut();
  }

  getQrEros() async {
    final mSupabase = Supabase.instance.client;
    final mResult = await mSupabase
        .from('erosqr')
        .select()
        .eq('revisado', true)
        .order('fecha', ascending: true);
    mQres = Qress.fromJsonList(mResult);
    setState(() {});
  }

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.colorFondo1,
      appBar: AppBar(
        backgroundColor: Constants.colorFondo1,
        leading: Container(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Image.asset(
            'assets/imagenes/logo1.png',
            width: 50,
            fit: BoxFit.contain,
          ),
        ),
        title: Text("Revisados"),
        leadingWidth: 140,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                color: Colors.transparent,
                width: 40,
                callback: () async {
                  /*globalContext = context;
                  deleteConfirmation(
                    context: globalContext!,
                    mQr:
                        Provider.of<ErosQrProvider>(
                          context,
                          listen: false,
                        ).mQre.mIdx!,
                  );*/
                },
                child: Icon(
                  TablerIcons.trash,
                  color: Constants.colorBlack,
                  size: 30,
                ),
              ),
              CustomButton(
                color: Colors.transparent,
                width: 40,
                callback: loggout,
                child: Icon(
                  TablerIcons.logout,
                  color: Constants.colorBlack,
                  size: 30,
                ),
              ),

              /*Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: loggout,
                  child: Icon(Icons.logout),
                ),
              ),*/
            ],
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: RefreshIndicator(
          backgroundColor: Constants.colorDark,
          color: Constants.colorLight,
          strokeWidth: 3,
          displacement: 80,
          onRefresh: () async {
            if (mounted) {
              globalContext = context;
              getQrEros();
            }
          },
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: SizedBox(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    mQres.items.isEmpty
                        ? Container(
                          margin: const EdgeInsets.only(
                            top: 20,
                            left: 20,
                            right: 20,
                          ),
                          width: double.infinity,
                          child: Text(
                            "No hay registros para mostrar",
                            style: Constants.textStyleGrayBold,
                            textAlign: TextAlign.center,
                          ),
                        )
                        : ListView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: mQres.items.length,
                          itemBuilder: (context, index) {
                            NumberFormat f = NumberFormat("#,##0", "es_CO");
                            f.format(mQres.items[index].mValor!);
                            return Card(
                              margin: const EdgeInsets.only(
                                left: 24,
                                right: 24,
                                bottom: 10,
                              ),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              color: Constants.revisadoEros,
                              surfaceTintColor: Colors.white,
                              child: InkWell(
                                onTap: () {
                                  /*globalContext = context;
                                  Provider.of<ErosQrProvider>(
                                        context,
                                        listen: false,
                                      ).mQre =
                                      mQres.items[index];
                                  navigate(
                                    globalContext!,
                                    CustomPage.formNotas,
                                  );*/
                                },
                                borderRadius: BorderRadius.circular(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 50,
                                      height: 100,
                                      child: Container(
                                        width: 20,
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          TablerIcons.qrcode,
                                          color: Constants.colorDark,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                    Flexible(
                                      child: SizedBox(
                                        width: double.infinity,
                                        height: 70,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  mQres.items[index].mConcepto!,
                                                  style:
                                                      Constants
                                                          .textStyleBlackBold,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                SizedBox(width: 16),
                                                Text(
                                                  'Valor : ${f.format(mQres.items[index].mValor!)}',
                                                  style: const TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 40,
                                      height: 70,
                                      child: Container(
                                        width: 40,
                                        height: double.infinity,
                                        alignment: Alignment.center,
                                        child: Icon(
                                          TablerIcons.chevron_right,
                                          color: Constants.colorDark,
                                          size: 40,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      /*
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {},
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startDocked,*/
    );
  }
}
