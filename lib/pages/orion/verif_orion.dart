import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:qreo/auth/auth_service.dart';
import 'package:qreo/custom/constants.dart';
import 'package:qreo/custom/library.dart';
import 'package:qreo/models/qre_models.dart';
import 'package:qreo/widgets/bottomnav.dart';
import 'package:qreo/widgets/custom_button.dart';
import 'package:supabase_flutter/supabase_flutter.dart.';

class VerifOrion extends StatefulWidget {
  const VerifOrion({super.key});

  @override
  State<VerifOrion> createState() => _VerifOrionState();
}

class _VerifOrionState extends State<VerifOrion> {
  final authService = AuthService();
  Qress mQres = Qress();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FocusScope.of(context).requestFocus(FocusNode());
      getQrOrion();
    });
  }

  void loggout() async {
    await authService.signOut();
  }

  getQrOrion() async {
    final mSupabase = Supabase.instance.client;
    final mResult = await mSupabase
        .from('orionqr')
        .select()
        .eq('revisado', true)
        .order('fecha', ascending: true);
    mQres = Qress.fromJsonList(mResult);
    setState(() {});
  }

  //
  confirmarBorrar() {
    return showModalBottomSheet(
      context: context,
      enableDrag: true,
      backgroundColor: Constants.colorBackgroundPanel,
      builder: (BuildContext context) {
        return Container(
          color: Constants.colorBackgroundPanel,
          margin: const EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: 40,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                child: Text(
                  'Borrar todos los Qrs',
                  style: Constants.textStyleAccentTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: Text(
                  '¿Confirmas borrar todos los qrs de la lista?',
                  style: Constants.textStyleLight,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                      width: double.infinity,
                      color: Constants.colorBlack,
                      callback: () => Navigator.pop(context),
                      child: Text(
                        "Cancelar",
                        style: Constants.textStyleAccentSemiBold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 20),
                  Flexible(
                    flex: 1,
                    child: CustomButton(
                      width: double.infinity,
                      color: Constants.colorAccent,
                      callback: () {
                        llenarListaBorrar();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => BottomNav()),
                          (Route<dynamic> route) => false,
                        );
                      },
                      child: Text(
                        "Aceptar",
                        style: Constants.textStyleBlackBold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  //
  llenarListaBorrar() async {
    final mSupabase = Supabase.instance.client;
    int contar = 0;
    final mResult = await mSupabase
        .from('orionqr')
        .select()
        .eq('revisado', true)
        .order('fecha', ascending: true);
    mQres = Qress.fromJsonList(mResult);

    mQres.items.forEach((doc) async {
      contar = contar + 1;
      deleteTask(doc.mIdx.toString());
    });
  }

  //
  Future<void> deleteTask(String taskId) async {
    final supabase = Supabase.instance.client;
    await supabase.from('orionqr').delete().eq('idx', taskId);
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
                'assets/imagenes/logo2.png',
                width: 90,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
        title: Column(
          children: [
            Container(
              padding: EdgeInsets.only(),
              child: Text(
                "Revisados",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.only(),
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
        leadingWidth: 120,
        toolbarHeight: 80,
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton(
                color: Colors.transparent,
                width: 40,
                callback: () async {
                  globalContext = context;
                  confirmarBorrar();
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
              getQrOrion();
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
    );
  }
}
