import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';
import 'package:qreo/auth/auth_service.dart';
import 'package:qreo/custom/constants.dart';
import 'package:qreo/custom/library.dart';
import 'package:qreo/models/qre_models.dart';
import 'package:qreo/providers/erosqr_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart.';
import 'package:intl/intl.dart';

class HomeqrEros extends StatefulWidget {
  const HomeqrEros({super.key});

  @override
  State<HomeqrEros> createState() => _HomeqrErosState();
}

class _HomeqrErosState extends State<HomeqrEros> {
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
        .eq('revisado', false)
        .order('fecha', ascending: true);

    mQres = Qress.fromJsonList(mResult);

    setState(() {});
  }

  //
  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();
    return Scaffold(
      backgroundColor: Constants.colorFondo1,
      appBar: AppBar(
        backgroundColor: Constants.colorFondo1,
        leading: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Image.asset(
                'assets/imagenes/logo1.png',
                width: 85,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Text(
                currentEmail.toString(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
        leadingWidth: 220,
        toolbarHeight: 80,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  onPressed: () async {
                    globalContext = context;
                    Provider.of<ErosQrProvider>(context, listen: false).mQre =
                        QrEros();
                    navigate(globalContext!, CustomPage.formEros);
                  },
                  icon: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Icon(
                      TablerIcons.plus,
                      color: Constants.colorBlack,
                      size: 30,
                    ),
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: GestureDetector(
                  onTap: loggout,
                  child: Icon(Icons.logout),
                ),
              ),
            ],
          ),
        ],
      ),
      //
      //
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
                            top: 10,
                            left: 10,
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
                            //
                            NumberFormat f = NumberFormat("#,##0", "es_CO");
                            f.format(mQres.items[index].mValor!);

                            NumberFormat n = NumberFormat("######");

                            return Card(
                              margin: const EdgeInsets.only(
                                left: 20,
                                right: 20,
                                bottom: 10,
                              ),
                              elevation: 1,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22),
                              ),
                              color: Constants.colorCards,
                              surfaceTintColor: Colors.white,
                              child: InkWell(
                                onTap: () {
                                  globalContext = context;
                                  Provider.of<ErosQrProvider>(
                                        context,
                                        listen: false,
                                      ).mQre =
                                      mQres.items[index];

                                  navigate(globalContext!, CustomPage.formEros);
                                },
                                borderRadius: BorderRadius.circular(15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 60,
                                      height: 100,
                                      child: Container(
                                        width: 40,
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
                                        height: 80,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            //
                                            Text(
                                              'Fecha : ${mQres.items[index].mFecha!}',
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                              ),
                                            ),
                                            //
                                            SizedBox(height: 4),
                                            //
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
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
                                                SizedBox(width: 18),
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
                                            //
                                            SizedBox(height: 6),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  mQres.items[index].mEmpleado!,
                                                  style: TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                  'Fra. # ${n.format(mQres.items[index].mFactura!)}',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),

                                            //
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 50,
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
    );
  }
}
