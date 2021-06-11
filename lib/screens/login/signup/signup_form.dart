import 'package:dbcrypt/dbcrypt.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/login/login_page.dart';
import 'package:unigran_tcc/screens/usuario/usuario.dart';
import 'package:unigran_tcc/screens/usuario/Usuario_api.dart';
import 'package:unigran_tcc/utils/alert.dart';
import 'package:unigran_tcc/utils/nav.dart';
import 'package:unigran_tcc/widgets/app_button.dart';

class SignupForm extends StatefulWidget {
  final Usuario usuario;

  SignupForm({this.usuario});

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  Size get size => MediaQuery.of(context).size;

  Color cor = Colors.white;

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final tNome = TextEditingController();
  final tSenha = TextEditingController();
  final tEmail = TextEditingController();


  var _showProgress = false;

  Usuario get usuario => widget.usuario;

  int idCidade;
  int idBairro;
  String logradouro;

  String _hash = '';



   gerarHash(String pass) async {
    var plainPwd = pass;
    DBCrypt dBCrypt = DBCrypt();
    String hashedPwd = await dBCrypt.hashpw(plainPwd, dBCrypt.gensalt());
    String salt = r'$2a$10$C6UzMDM/HUdfI/f7IKxGhu';
    hashedPwd = await dBCrypt.hashpw(plainPwd, salt);
    print(hashedPwd);

    setState(() {
      _hash = hashedPwd;
      print("_hash: ${_hash}");
    });

   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _layoutBackgroundImg(context));
  }

  _layoutBackgroundImg(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          "assets/images/background.jpg",
          fit: BoxFit.fill,
          width: double.infinity,
        ),
        Center(
          child: Container(
            width: 460,
            height: 500,
            decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                      color: AppColors.primaria,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10))),
                  height: 76,
                  child: Center(
                    child: Text("Cadastro de Usuário",
                        style: AppTextStyles.bodyWhite20),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16),
                  child: _form(context),
                ),
              ],
            ),
          ),
        )
      ],
    );
  }

  _form(BuildContext context) {
    return Form(
        key: this._formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            SizedBox(
              height: 30,
            ),
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.person,size: 20,), labelText: 'Nome'),
              controller: tNome,
              validator: (text) {
                if (text.isEmpty )
                  return "email inválido!";
              },
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height:10),
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email,size: 20,), labelText: 'Email'),
              controller: tEmail,
              validator: (text) {
                if (text.isEmpty || !text.contains('@'))
                  return "email inválido!";
              },
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(height:10),
            TextFormField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.remove_red_eye_sharp,size: 20,), labelText: 'Senha'),
              controller: tSenha,
              validator: (text) {
                if (text.isEmpty )
                  return "senha precisa ser preenchida!";
              },
              keyboardType: TextInputType.text,
              obscureText: true,
              textInputAction: TextInputAction.next,
            ),
            SizedBox(
              height: 20,
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              child: AppButton(
                "Cadastrar",
                onPressed: _onClickSalvar,
                showProgress: _showProgress,
              ),

            ),
            SizedBox(
              height: 10,
            ),
            new Container(
              width: MediaQuery.of(context).size.width,
              child: MaterialButton(
               child: Text('Voltar'),
                onPressed: _onClickVoltar,
                color: Colors.grey,

              ),

            ),
          ],
        ));
  }

  _onClickVoltar(){

    push(context, LoginPage(),replace: true);
  }

  _onClickSalvar() async {
    if (!_formKey.currentState.validate()) {
      return;
    } else {
      setState(() {
        _showProgress = true;
      });
      var hoje = DateTime.now().toIso8601String();

      await gerarHash(tSenha.text);

      // Cria o usuario
      var user = usuario ?? Usuario();
      user.login = tEmail.text;
      user.email = tEmail.text;
      user.nome = tNome.text;
      user.senha = _hash;
      user.nivel = '6';
      user.escola = 0;
      user.createdAt = hoje;
      user.modifiedAt = hoje;
      user.roles = [];
      var response = await UsuarioApi.save2(context, user);

      if (response.ok) {
        alert(context, "Usuário salvo com sucesso", callback: () {
          push(context, LoginPage(), replace: true);
        });
      } else {
        alert(context, response.msg);
      }

      setState(() {
        _showProgress = false;
      });
      print("Fim.");
    }
  }
}
