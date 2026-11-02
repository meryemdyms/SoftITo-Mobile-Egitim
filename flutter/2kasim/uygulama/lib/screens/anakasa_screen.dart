import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:uygulama/sepet_kontrol.dart';
import 'vitrin_screen.dart';
import 'profil_screen.dart';


final GoRouter uygulamaRotalari = GoRouter(
  initialLocation: '/anasayfa',
  routes: [
    ShellRoute(
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return AnakasaEkrani(
          ekranGovdesi: child,
        );
      },
      routes: [
        GoRoute(
          path: '/anasayfa',
          builder: (context, state) => const VitrinEkrani(),
        ),
        GoRoute(
          path: '/vitrin',
          builder: (context, state) => const VitrinEkrani(),
        ),
        GoRoute(
          path: '/profil',
          builder: (context, state) => const ProfilEkrani(),
        ),
      ],
    ),
  ],
);
class AnakasaEkrani extends StatelessWidget{
  final Widget ekranGovdesi;
  const AnakasaEkrani({super.key, required this.ekranGovdesi});

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body:ekranGovdesi,
      bottomNavigationBar:NavigationBar(
        selectedIndex:_aktifIndexiBul(context),
        onDestinationSelected:(yeniIndex){
          if(yeniIndex == 0) context.go('/vitrin');
          else if(yeniIndex == 1) context.go('/profil');
        },
        destinations:[
          const NavigationDestination(icon:Icon(Icons.store),label:'vitrin'),
               NavigationDestination(
                icon:ValueListenableBuilder<int>(
                  valueListenable:SepetKontrol.ornek.urunSayisi,
                  builder:(context,sayi,child){
                    return Badge(
                      label:Text('$sayi'),
                      isLabelVisible:sayi>0,
                      child:const Icon(Icons.person),
                    );
                  },
                ),

                label:'Profil',
              ),
        ],
      ),
    );
  }


  int _aktifIndexiBul(BuildContext context){
    final String konum = GoRouterState.of(context).uri.toString();
    if(konum.startsWith('profil')) return 1;
    return 0;
  }
}

