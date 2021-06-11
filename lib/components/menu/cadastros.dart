import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/constants.dart';




class Cadastros extends StatefulWidget {

  @override
  _CadastrosState createState() => _CadastrosState();
}

class _CadastrosState extends State<Cadastros> {
  //define a pagina a ser exibida
  final BlocController bloc_bloc = BlocProvider.getBloc<BlocController>();
   bool ativo = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Icon(Icons.ac_unit_rounded,size: 16,),
            SizedBox(width: kDefaultPadding / 4),
           Icon(Icons.more,size: 16,),
            SizedBox(width: kDefaultPadding / 2),
            Text(
              "Cadastros",
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: AppColors.kGrayColor),
            ),
            Spacer(),
            MaterialButton(
              padding: EdgeInsets.all(10),
              minWidth: 40,
              onPressed: () {
                setState(() {
                  ativo= !ativo;

                });
              },
              child: Icon(
                ativo? Icons.add:Icons.remove,
                color: AppColors.kGrayColor,
                size: 20,
              ),
            )
          ],
        ),
        SizedBox(height: kDefaultPadding / 2),
        ativo ? Container():Container(
          child: Column(
            children:[

              buildTag(context, color: Color(0xFF23CF91), title: "Nivel Escolar",page: AppPages.nivelEscolar),
              buildTag(context, color: Color(0xFF3A6FF7), title: "Escolas",page: AppPages.unidadeEscolar ),
              buildTag(context, color: Color(0xFFF3CF50), title: "Categorias",page: AppPages.categoria),
              buildTag(context, color: Color(0xFF70D9E4 ), title: "Fornecedores",page: AppPages.fornecedor),
              buildTag(context, color: Color(0xFF8338E1), title: "Produtos",page: AppPages.produto),
              buildTag(context, color: Color(0xFF258A4D ), title: "Pnae",page: AppPages.pnae),
              buildTag(context, color: Color(0xFFDC6123 ), title: "Usuarios",page: AppPages.usuario),
              buildTag(context, color: Color(0xFF625955 ), title: "Cardápio",page: AppPages.cardapio),
               buildTag(context,
                      color: Color(0xFF625955),
                      title: "Teste",
                      page: AppPages.teste),
    ]


          ),
        )

      ],
    );
  }

  InkWell buildTag(BuildContext context,
      {@required Color color, @required String title,@required page}) {
    return InkWell(
      onTap: () {
          bloc_bloc.inPage.add(page);
          bloc_bloc.inTextAppBar.add(title);
          if(!mounted){
            Navigator.of(context).pop();
          }

      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(kDefaultPadding * 1.5, 10, 0, 10),
        child: Row(
          children: [
            Icon(Icons.storage,size: 15,
              color: color,
            ),
            SizedBox(width: kDefaultPadding / 2),
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(color: AppColors.kGrayColor),
            ),
          ],
        ),
      ),
    );
  }
}


