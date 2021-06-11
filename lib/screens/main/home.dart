import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_text_styles.dart';
import 'package:unigran_tcc/screens/main/webview/pnae_web.dart';
import 'package:unigran_tcc/splash_page.dart';
import 'package:unigran_tcc/utils/nav.dart';

class Home extends StatelessWidget {
  const Home({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    appBar: AppBar(
    leading: Image.asset("assets/images/brasao.png"),
    backgroundColor: AppColors.white,
    title: Text('Secretaria da Educação',style: AppTextStyles.bodyLightGrey20,),
    centerTitle: true,

    elevation: 0,),
        body: _body(context),
    );
        }

        _body(BuildContext context) {
        double largura = MediaQuery.of(context).size.width;
        double altura = MediaQuery.of(context).size.height;
        return Stack(
          children: [
            Container(

            decoration: new BoxDecoration(
                image: new DecorationImage(
        image: new AssetImage("assets/images/merenda.jpg"),
        fit: BoxFit.fill,
                ),
              ),
            ),
            Container(
            width: largura,
            height: altura,
            color: Colors.white70,

            ),
          Container(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                Center(
                  child: Column(
                  children: [
                  Text('Merenda escolar',style: AppTextStyles.heading70,),
                  Text('Direito do aluno, dever do Estado!',style: AppTextStyles.heading,),
                  SizedBox(height:100),
                  Text('Sistema da merenda Escolar do municipio de Braço do Trombudo',style: AppTextStyles.bodyBold,),
                  Text('Aqui você acompanha os gastos com alimentação escolar em cada escola!',style: AppTextStyles.bodyBold,),
                   SizedBox(height:50),
                  Row(
                   mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,

                  children: [

                  MaterialButton(
                  onPressed: (){
                  push(context, PnaeWeb());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('Ver mais',style: AppTextStyles.body11White,),
                  ),
                  color: Colors.orange[900],
                  ),
                  SizedBox(width: 10,),MaterialButton(
                  onPressed: (){
                  push(context, SplashPage());
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Text('Acompanhar',style: AppTextStyles.body11White,),
                  ),
                  color: Colors.blue,
                  )




                  ],)
                  ],


                  ),
                )

                ],
              ),
          ),


          ],

          );
        }
}