import 'package:flutter/material.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'data/repositories/music_repository.dart';
import 'data/services/local_store.dart';
import 'features/player/playback_controller.dart';
import 'features/home/home_screen.dart';
import 'features/search/search_screen.dart';
import 'features/library/library_screen.dart';
import 'features/player/now_playing_screen.dart';
import 'core/widgets/common.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await JustAudioBackground.init(androidNotificationChannelId: 'offline_player.audio', androidNotificationChannelName: 'Offline Player', androidNotificationOngoing: true);
  runApp(const PlayerApp());
}

class PlayerApp extends StatelessWidget {
  const PlayerApp({super.key});
  @override Widget build(BuildContext context) => MultiProvider(providers:[Provider(create:(_)=>MusicRepository()),Provider(create:(_)=>LocalStore()),ChangeNotifierProxyProvider<MusicRepository,PlaybackController>(create:(c)=>PlaybackController(c.read<MusicRepository>()),update:(_,repo,old)=>old ?? PlaybackController(repo))],child:MaterialApp(debugShowCheckedModeBanner:false,title:'Offline Player',theme:buildTheme(),home:const Shell()));
}

class Shell extends StatefulWidget { const Shell({super.key}); @override State<Shell> createState()=>_ShellState(); }
class _ShellState extends State<Shell> {
  int tab=0;
  final pages=const [HomeScreen(),SearchScreen(),LibraryScreen(),SettingsPlaceholder()];
  void select(int i){ if(i==4){Navigator.of(context).push(_slide(const NowPlayingScreen()));return;} if(i==tab)return; setState(()=>tab=i); }
  @override Widget build(BuildContext context)=>Scaffold(body:Stack(children:[IndexedStack(index:tab,children:pages),Align(alignment:Alignment.bottomCenter,child:Consumer<PlaybackController>(builder:(c,p,_){return Column(mainAxisSize:MainAxisSize.min,children:[if(p.current!=null && tab!=4) MiniPlayer(onTap:()=>Navigator.of(context).push(_slide(const NowPlayingScreen())),title:p.current!.title,artist:p.current!.artistName,playing:p.playing,onPlay:p.toggle,artwork:const ColoredBox(color:Color(0xFF232A2F),child:Icon(Icons.music_note_rounded,color:Colors.white54))); GlassNav(selected:tab,onChanged:select);]);}))]));
}

Route _slide(Widget child)=>PageRouteBuilder(pageBuilder:(_,a,b)=>child,transitionDuration:const Duration(milliseconds:300),reverseTransitionDuration:const Duration(milliseconds:280),transitionsBuilder:(_,a,b,child){final inAnim=Tween(begin:const Offset(1,0),end:Offset.zero).chain(CurveTween(curve:Curves.easeOutCubic)).animate(a);final fade=Tween(begin:.72,end:1.0).animate(a);return FadeTransition(opacity:fade,child:SlideTransition(position:inAnim,child:child));});

class SettingsPlaceholder extends StatelessWidget { const SettingsPlaceholder({super.key}); @override Widget build(BuildContext c)=>SafeArea(child:Center(child:Text('Settings',style:Theme.of(c).textTheme.headlineSmall))); }
