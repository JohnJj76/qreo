import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:qreo/auth/auth_service.dart';
import 'package:qreo/custom/constants.dart';
import 'package:qreo/custom/library.dart';
import 'package:qreo/custom/validation.dart';
import 'package:qreo/providers/erosqr_provider.dart';
import 'package:qreo/widgets/bottomnav.dart';
import 'package:qreo/widgets/custom_button.dart';
import 'package:qreo/widgets/custom_input.dart';
import 'package:qreo/widgets/custom_num.dart';
import 'package:qreo/widgets/navbar_back.dart';
import 'package:supabase_flutter/supabase_flutter.dart.';

class FormEros extends StatefulWidget {
  const FormEros({super.key});
  @override
  State<FormEros> createState() => _FormErosState();
}

class _FormErosState extends State<FormEros> {
  //
  final authService = AuthService();
  final supabase = Supabase.instance.client;
  final _formKey = GlobalKey<FormState>();

  Validation mValidation = Validation();
  //

  var miFecha;

  late TextEditingController mFechaController;
  late TextEditingController mConceptoController;
  late TextEditingController mFacturaController;
  late TextEditingController mValorController;
  late TextEditingController mRevisadoController;
  late TextEditingController mEmpleadoController;
  late DateTime cFecha = DateTime.now();
  late String myFechaData = "";
  late bool cRevisado = false;

  @override
  void initState() {
    super.initState();
    //

    convertirFechaTexto(cFecha);
    mFechaController = TextEditingController();
    Provider.of<ErosQrProvider>(context, listen: false).mQre.mIdx == null
        ? mFechaController.text = myFechaData
        : mFechaController.text =
            Provider.of<ErosQrProvider>(context, listen: false).mQre.mFecha!;
    //
    mConceptoController = TextEditingController();
    Provider.of<ErosQrProvider>(context, listen: false).mQre.mIdx == null
        ? mConceptoController.text = "Pago con QR"
        : mConceptoController.text =
            Provider.of<ErosQrProvider>(context, listen: false).mQre.mConcepto!;
    //
    mFacturaController = TextEditingController();
    Provider.of<ErosQrProvider>(context, listen: false).mQre.mIdx == null
        ? mFacturaController.text = "0"
        : mFacturaController.text =
            Provider.of<ErosQrProvider>(
              context,
              listen: false,
            ).mQre.mFactura.toString();
    //
    mValorController = TextEditingController();
    Provider.of<ErosQrProvider>(context, listen: false).mQre.mIdx == null
        ? mValorController.text = "0"
        : mValorController.text =
            Provider.of<ErosQrProvider>(
              context,
              listen: false,
            ).mQre.mValor.toString();
    //
    mRevisadoController = TextEditingController();
    Provider.of<ErosQrProvider>(context, listen: false).mQre.mIdx == null
        ? mRevisadoController.text = cRevisado.toString()
        : mRevisadoController.text =
            Provider.of<ErosQrProvider>(
              context,
              listen: false,
            ).mQre.mRevisado.toString();
    //
    final currentEmail = authService.getCurrentUserEmail();
    mEmpleadoController = TextEditingController();
    mEmpleadoController.text = currentEmail.toString();
  }

  @override
  void dispose() {
    mFechaController.dispose();
    mConceptoController.dispose();
    mFacturaController.dispose();
    mValorController.dispose();
    mRevisadoController.dispose();
    mEmpleadoController.dispose();
    super.dispose();
  }

  void loggout() async {
    await authService.signOut();
  }

  _formValidation() async {
    String mMessage = "";
    if (!_formKey.currentState!.validate()) {
      _clear();
    } else {
      // Validate inputs
      /*if (mFechaController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, complete todos los campos')),
        );
        return;
      }*/

      // set global context
      globalContext = context;

      try {
        if (Provider.of<ErosQrProvider>(context, listen: false).mQre.mIdx ==
            null) {
          // insertar el nuevo qr
          //progressDialogShow(globalContext!);
          await supabase.from('erosqr').insert({
            'fecha': myFechaData,
            'concepto': mConceptoController.text,
            'factura': mFacturaController.text,
            'valor': mValorController.text,
            'revisado': cRevisado,
            'empleado': mEmpleadoController.text,
          });
          dialogDismiss();

          // alert
          customShowToast(globalContext!, 'Qr creado exitosamente');
        } else {
          // modificar qr existente
          // progressDialogShow(globalContext!);
          await supabase
              .from('erosqr')
              .update({
                'fecha': mFechaController.text,
                'concepto': mConceptoController.text,
                'factura': mFacturaController.text,
                'valor': mValorController.text,
                'revisado': cRevisado,
                'empleado': mEmpleadoController.text,
              })
              .eq(
                'idx',
                Provider.of<ErosQrProvider>(context, listen: false).mQre.mIdx!,
              );
          dialogDismiss();

          customShowToast(globalContext!, 'Qr actualizado satisfactoriamente');
        }

        //Navigator.of(globalContext!).pop();
        Navigator.pushAndRemoveUntil(
          context,
          //MaterialPageRoute(builder: (context) => HomeNotame()),
          MaterialPageRoute(builder: (context) => BottomNav()),
          (Route<dynamic> route) => false,
        );

        // Clear the input fields
        mFechaController.clear();
        mConceptoController.clear();
        mFacturaController.clear();
        mValorController.clear();
        mRevisadoController.clear();
        mEmpleadoController.clear();
      } catch (e) {
        // Show error message if the insertion fails
        customShowToast(globalContext!, 'Error al guardar el qr: $e');
      }
    }

    if (mMessage.isNotEmpty) {
      customShowToast(globalContext!, mMessage);
      _clear();
    }
  }

  _clear() {
    setState(() {});
  }

  //
  validarUsuarioBorrar({
    required BuildContext context,
    required String mQr,
  }) async {
    final currentEmail = authService.getCurrentUserEmail();

    //if ( == 'german@gmail.com') {
    if (currentEmail.toString() != mEmpleadoController.text) {
      // mensaje
      customShowToast(
        globalContext!,
        'Este usuario no esta autorizado para borrar este QR.',
      );
    } else {
      globalContext = context;
      borrarConfirmacion(
        context: globalContext!,
        mQr: Provider.of<ErosQrProvider>(context, listen: false).mQre.mIdx!,
      );
    }
  }

  //
  borrarConfirmacion({required BuildContext context, required String mQr}) {
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
                  'Borrar Qr',
                  style: Constants.textStyleAccentTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: Text(
                  //'¿Confirmas borrar $mQr de la lista? ',
                  '¿Confirmas borrar el QR de la lista?',
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
                        deleteNota();
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

  deleteNota() async {
    try {
      if (Provider.of<ErosQrProvider>(context, listen: false).mQre.mIdx ==
          null) {
        // alert
        customShowToast(globalContext!, 'No fue posible eliminar el registro');
      } else {
        // update country into the 'countries' table
        //progressDialogShow(globalContext!);
        await supabase
            .from('erosqr')
            .delete()
            .eq(
              'idx',
              Provider.of<ErosQrProvider>(context, listen: false).mQre.mIdx!,
            );

        Timer(const Duration(seconds: 3), () {});
        //dialogDismiss();

        customShowToast(globalContext!, 'Nota eliminada satisfactoriamente');
      }
    } catch (e) {
      // Show error message if the insertion fails
      customShowToast(globalContext!, 'Error al guardar la nota: $e');
    }
  }

  //
  Future<void> _seleccionarFecha(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: cFecha,
      firstDate: DateTime(2015),
      lastDate: DateTime(2050),
    );
    if (pickedDate != null && pickedDate != cFecha) {
      setState(() {
        cFecha = pickedDate;
        convertirFechaTexto(cFecha);
        mFechaController.text = myFechaData;
      });
    }
  }

  //
  convertirFechaTexto(cFecha) {
    final parsearFecha = DateTime.parse(cFecha.toString());
    miFecha = DateFormat('dd/MM/yyyy').format(parsearFecha);
    myFechaData = miFecha;
  }

  //
  // ***********************************
  //
  //
  @override
  Widget build(BuildContext context) {
    final currentEmail = authService.getCurrentUserEmail();
    bool bandera = false;
    if (currentEmail.toString() == 'german@gmail.com') {
      bandera = true;
    }
    ;
    return Scaffold(
      backgroundColor: Constants.colorFondo2,
      appBar: NavbarBack(
        backgroundColor: Constants.colorFondo2,
        backgroundButtonColor: Constants.colorFondo2,
        tinte: Tinte.light,
        title:
            Provider.of<ErosQrProvider>(context, listen: false).mQre.mIdx ==
                    null
                ? "Agregar nuevo QR"
                : "Editar actual QR",
        showBack: true,
        mListActions: [
          Provider.of<ErosQrProvider>(context, listen: false).mQre.mIdx == null
              ? const SizedBox()
              : CustomButton(
                color: Colors.transparent,
                width: 50,
                callback: () async {
                  globalContext = context;
                  validarUsuarioBorrar(
                    context: globalContext!,
                    mQr:
                        Provider.of<ErosQrProvider>(
                          context,
                          listen: false,
                        ).mQre.mIdx!,
                  );
                },
                child: Icon(
                  TablerIcons.trash,
                  color: Constants.colorBlack,
                  size: 30,
                ),
              ),
        ],
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: RefreshIndicator(
          backgroundColor: Constants.colorFondo2,
          color: Constants.colorLight,
          strokeWidth: 3,
          displacement: 80,
          onRefresh: () async {
            if (mounted) {
              globalContext = context;
            }
          },
          child: SizedBox(
            height: double.infinity,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Container(
                padding: const EdgeInsets.only(left: 20, right: 20),
                child: Column(
                  children: [
                    Form(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      key: _formKey,
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          // *** FECHA ***
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Fecha:',
                                style: TextStyle(
                                  color: Colors.purple,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 10),

                              Provider.of<ErosQrProvider>(
                                        context,
                                        listen: false,
                                      ).mQre.mIdx ==
                                      null
                                  ? Text(
                                    myFechaData,
                                    style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                  : Text(
                                    mFechaController.text,
                                    style: TextStyle(
                                      color: Colors.purple,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),

                              SizedBox(width: 20),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                ),
                                onPressed: () => _seleccionarFecha(context),
                                child: const Text(
                                  'Seleccionar',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: CustomInput(
                              title: 'Concepto',
                              controller: mConceptoController,
                              textInputType: TextInputType.text,
                              validator: (value) {
                                return mValidation.validate(
                                  type: TypeValidation.varchar,
                                  name: 'Concepto',
                                  value: mConceptoController.text,
                                  isRequired: true,
                                  min: 3,
                                  max: 80,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            child: CustomNum(
                              title: 'Factura',
                              controller: mFacturaController,
                              //keyboardType: TextInputType.number,
                              textInputType: TextInputType.number,
                              validator: (value) {
                                return mValidation.validate(
                                  type: TypeValidation.varchar,
                                  name: 'Factura',
                                  value: mFacturaController.text,
                                  isRequired: true,
                                  max: 10,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 100),
                            child: CustomNum(
                              title: 'Valor',
                              controller: mValorController,
                              textInputType: TextInputType.number,
                              validator: (value) {
                                return mValidation.validate(
                                  type: TypeValidation.varchar,
                                  name: 'Valor',
                                  value: mValorController.text,
                                  isRequired: true,
                                  max: 10,
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
                          bandera
                              ? jhMySwitch(ancho: 90, estado: cRevisado)
                              : Text("--------------------------"),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 100,
                            ),
                            child: Text(
                              currentEmail.toString(),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    CustomButton(
                      color: Constants.colorAccent,
                      callback: () async {
                        _formValidation();
                      },
                      child: Text(
                        'Guardar',
                        style: Constants.textStyleBlackBold,
                      ),
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

  Widget jhMySwitch({required double ancho, required bool estado}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: ancho),
      child: Container(
        decoration: BoxDecoration(
          color: Constants.colorLight,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Row(
            children: [
              Text(
                'Revisado',
                style: TextStyle(
                  color: Color.fromARGB(255, 48, 102, 50),
                  fontSize: 16,
                ),
              ),
              Switch(
                // thumb color (round icon)
                activeColor: Colors.purple,
                activeTrackColor: Colors.cyan,
                inactiveThumbColor: Colors.blueGrey.shade600,
                inactiveTrackColor: Colors.grey.shade400,
                splashRadius: 30.0,
                value: cRevisado,
                onChanged: (value) => setState(() => cRevisado = value),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
