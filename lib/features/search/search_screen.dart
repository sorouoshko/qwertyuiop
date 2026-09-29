import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_theme.dart';
import '../../core/widgets/common.dart';
import '../../core/widgets/artwork.dart';
import '../../data/models/music_models.dart';
import '../../data/repositories/music_repository.dart';
import '../player/playback_controller.dart';

class SearchScreen extends StatefulWidget { const SearchScreen({super.key}); @override State<SearchScreen> createState()=>_SearchScreenState(); }
class _SearchScreenState extends State<SearchScreen>{
  final ctrl=TextEditingController(text:'bros before hoes neffex');
  int tab=0; List<Song> songs=[]; bool loading=true;
  @override void initState(){super.initState(); _load();}
  Future<void> _load() async { final repo=context.read<MusicRepository>(); final s=await repo.scanLocalSongs(); if(mounted)setState((){songs=s;loading=false;}); }
  @override Widget build(BuildContext c)=>SafeArea(child:CustomScrollView(slivers:[SliverToBoxAdapter(child:Text('Search',style:const TextStyle(fontSize:25,fontWeight:FontWeight.w700))),SliverToBoxAdapter(child:Container(height:48,margin:const EdgeInsets.only(top:14,bottom:12),decoration:BoxDecoration(color:AppColors.surface,borderRadius:BorderRadius.circular(17)),child:TextField(controller:ctrl,style:const TextStyle(fontSize:13),decoration:const InputDecoration(prefixIcon:Icon(Icons.search_rounded,color:AppColors.muted),suffixIcon:Icon(Icons.tune_rounded,color:AppColors.muted),border:InputBorder.none,hintText:'Search your music')))),SliverToBoxAdapter(child:SizedBox(height:39,child:ListView.separated(scrollDirection:Axis.horizontal,itemCount:5,separatorBuilder:(_,__)=>const SizedBox(width:7),itemBuilder:(_,i){final labels=['Songs','Albums','Artists','Playlists','Videos'];return GestureDetector(onTap:()=>setState(()=>tab=i),child:AnimatedContainer(duration:const Duration(milliseconds:220),padding:const EdgeInsets.symmetric(horizontal:16,vertical:10),decoration:BoxDecoration(color:tab==i?AppColors.accent:AppColors.surface,borderRadius:BorderRadius.circular(16)),child:Text(labels[i],style:TextStyle(color:tab==i?AppColors.bg:AppColors.muted,fontSize:12,fontWeight:FontWeight.w600))));}))),SliverToBoxAdapter(child:const SizedBox(height:12)),loading?SliverList.builder(itemCount:7,itemBuilder:(_,__)=>const Padding(padding:EdgeInsets.only(bottom:7),child:SizedBox(height:58,child:SkeletonRow()))):SliverList.builder(itemCount:songs.length>20?20:songs.length,itemBuilder:(_,i){final s=songs[i];return SongRow(title:s.title,artist:s.artistName,duration:s.duration,selected:context.watch<PlaybackController>().current?.id==s.id,artwork:Container(color:AppColors.surface2,child:const Icon(Icons.music_note_rounded,color:AppColors.muted)),onTap:()=>context.read<PlaybackController>().playSong(s,songs),onMenu:()=>_menu(s));})]));
  void _menu(Song s)=>showModalBottomSheet(context:context,backgroundColor:AppColors.surface2,shape:const RoundedRectangleBorder(borderRadius:BorderRadius.vertical(top:Radius.circular(26))),builder:(_)=>SafeArea(child:Column(mainAxisSize:MainAxisSize.min,children:[ListTile(title:Text('Play ${s.title}')),const ListTile(title:Text('Add to queue')),const ListTile(title:Text('Save as playlist')),const SizedBox(height:10)])));
}
class SkeletonRow extends StatelessWidget { const SkeletonRow({super.key}); @override Widget build(BuildContext c)=>Row(children:[const SkeletonBox(width:52,height:52,radius:14),const SizedBox(width:10),Expanded(child:Column(crossAxisAlignment:CrossAxisAlignment.start,mainAxisAlignment:MainAxisAlignment.center,children:[SkeletonBox(width:150,height:10,radius:5),const SizedBox(height:8),SkeletonBox(width:95,height:8,radius:5)]))]); }
