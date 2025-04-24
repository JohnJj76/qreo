import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_tabler_icons/flutter_tabler_icons.dart';
import 'package:provider/provider.dart';
import 'package:qreo/custom/constants.dart';
import 'package:qreo/custom/library.dart';
import 'package:qreo/custom/validation.dart';
import 'package:qreo/providers/notas_provider.dart';
import 'package:qreo/widgets/bottomnav.dart';
import 'package:qreo/widgets/custom_button.dart';
import 'package:qreo/widgets/custom_input.dart';
import 'package:qreo/widgets/navbar_back.dart';
import 'package:supabase_flutter/supabase_flutter.dart.';

class FormNotasPage extends StatefulWidget {
  const FormNotasPage({super.key});

  @override
  State<FormNotasPage> createState() => _FormNotasPageState();
}

class _FormNotasPageState extends State<FormNotasPage> {
  //
  // Get a reference to your Supabase client
  final supabase = Supabase.instance.client;

  final _formKey = GlobalKey<FormState>();

  Validation mValidation = Validation();

  late TextEditingController mContenidoController;

  @override
  void initState() {
    super.initState();

    mContenidoController = TextEditingController();

    mContenidoController.text =
        Provider.of<NotasProvider>(context, listen: false).mNota.mContenido ??
        '';
  }

  @override
  void dispose() {
    mContenidoController.dispose();
    super.dispose();
  }

  _formValidation() async {
    String mMessage = "";
    if (!_formKey.currentState!.validate()) {
      _clear();
    } else {
      // Validate inputs
      if (mContenidoController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, complete todos los campos')),
        );
        return;
      }

      // set global context
      globalContext = context;

      try {
        if (Provider.of<NotasProvider>(context, listen: false).mNota.mIdx ==
            null) {
          // insert country into the 'countries' table
          progressDialogShow(globalContext!);
          await supabase.from('notas').insert({
            'contenido': mContenidoController.text,
          });
          dialogDismiss();

          // alert
          customShowToast(globalContext!, 'Nota creada exitosamente');
        } else {
          // update country into the 'countries' table
          progressDialogShow(globalContext!);
          await supabase
              .from('notas')
              .update({'contenido': mContenidoController.text})
              .eq(
                'idx',
                Provider.of<NotasProvider>(context, listen: false).mNota.mIdx!,
              );
          dialogDismiss();

          customShowToast(
            globalContext!,
            'Nota actualizada satisfactoriamente',
          );
        }

        //Navigator.of(globalContext!).pop();
        Navigator.pushAndRemoveUntil(
          context,
          //MaterialPageRoute(builder: (context) => HomeNotame()),
          MaterialPageRoute(builder: (context) => BottomNav()),
          (Route<dynamic> route) => false,
        );

        // Clear the input fields
        mContenidoController.clear();
      } catch (e) {
        // Show error message if the insertion fails
        customShowToast(globalContext!, 'Error al guardar la nota: $e');
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

  deleteConfirmation({required BuildContext context, required String mNota}) {
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
                  'Eliminar nota',
                  style: Constants.textStyleAccentTitle,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                child: Text(
                  '¿Confirmas eliminar a $mNota de la lista? ',
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
                        "Atrás",
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
                        //Navigator.pop(globalContext!);
                        //Navigator.pop(globalContext!);
                        /*
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => HomeNotame()),
                          (Route<dynamic> route) => false,
                        );
                        */
                      },
                      child: Text(
                        "Eliminar",
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
      if (Provider.of<NotasProvider>(context, listen: false).mNota.mIdx ==
          null) {
        // alert
        customShowToast(globalContext!, 'No fue posible eliminar el registro');
      } else {
        // update country into the 'countries' table
        progressDialogShow(globalContext!);
        await supabase
            .from('notas')
            .delete()
            .eq(
              'idx',
              Provider.of<NotasProvider>(context, listen: false).mNota.mIdx!,
            );
        Timer(const Duration(seconds: 3), () {});
        dialogDismiss();

        customShowToast(globalContext!, 'Nota eliminada satisfactoriamente');
      }
    } catch (e) {
      // Show error message if the insertion fails
      customShowToast(globalContext!, 'Error al guardar la nota: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: NavbarBack(
        backgroundColor: Constants.colorLight,
        backgroundButtonColor: Constants.colorLight,
        tinte: Tinte.light,
        title:
            Provider.of<NotasProvider>(context, listen: false).mNota.mIdx ==
                    null
                ? "Nueva Nota"
                : "Editar Nota",
        showBack: true,
        mListActions: [
          Provider.of<NotasProvider>(context, listen: false).mNota.mIdx == null
              ? const SizedBox()
              : CustomButton(
                color: Colors.transparent,
                width: 50,
                callback: () async {
                  globalContext = context;
                  deleteConfirmation(
                    context: globalContext!,
                    mNota:
                        Provider.of<NotasProvider>(
                          context,
                          listen: false,
                        ).mNota.mContenido!,
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
          backgroundColor: Constants.colorAccent,
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
                          CustomInput(
                            title: 'Contenido',
                            hint: 'Ej: Argentina',
                            controller: mContenidoController,
                            textInputType: TextInputType.text,
                            validator: (value) {
                              return mValidation.validate(
                                type: TypeValidation.varchar,
                                name: 'Contenido',
                                value: mContenidoController.text,
                                isRequired: true,
                                min: 3,
                                max: 80,
                              );
                            },
                          ),
                          const SizedBox(height: 10),
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
}
