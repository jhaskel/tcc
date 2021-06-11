import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:unigran_tcc/core/app_colors.dart';
import 'package:unigran_tcc/core/app_pages.dart';
import 'package:unigran_tcc/utils/bloc/bloc.dart';
import 'package:unigran_tcc/utils/constants.dart';



class Consultas extends StatefulWidget {

  @override
  _ConsultasState createState() => _ConsultasState();
}

class _ConsultasState extends State<Consultas> {
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
              "Consultas",
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
             buildTag(context, color: AppColors.darkRed, title: "Gastos",page: AppPages.consulta,overflow: TextOverflow.ellipsis),
              buildTag(context, color: Color(0xFF23CF91), title: "Produto Mais Pedido",page: AppPages.produtoMais,overflow: TextOverflow.ellipsis),
              buildTag(context, color: Color(0xFF3A6FF7), title: "Produto não pedido",page: AppPages.produtoMenos,overflow: TextOverflow.ellipsis),

    ]


          ),
        )

      ],
    );
  }

  InkWell buildTag(BuildContext context,
      {@required Color color, @required String title,@required page,@required overflow}) {
    return InkWell(
      onTap: () {
          bloc_bloc.inPage.add(page);
          bloc_bloc.inTextAppBar.add(title);

      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(kDefaultPadding * 1.5, 10, 0, 10),
        child: Row(
          children: [
            Icon(Icons.all_out_outlined,size: 15,
              color: color,
            ),
            SizedBox(width: kDefaultPadding / 2),
            Text(
              title,
              overflow: overflow,
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


