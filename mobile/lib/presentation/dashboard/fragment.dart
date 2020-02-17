import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:simpati/core/resources/app_color.dart';
import 'package:simpati/core/resources/app_text_style.dart';
import 'package:simpati/domain/entity/article.dart';
import 'package:simpati/domain/entity/recap.dart';
import 'package:simpati/presentation/app/app_bloc.dart';
import 'package:simpati/presentation/article/fragment/item/article_card.dart';
import 'package:simpati/presentation/auth/screen.dart';
import 'package:simpati/presentation/dashboard/bloc.dart';
import 'package:simpati/presentation/dashboard/item/dashboard_content_card.dart';
import 'package:simpati/presentation/dashboard/item/card_data.dart';
import 'package:simpati/presentation/home/bloc.dart';
import 'package:simpati/presentation/home/fragment.dart';
import 'package:simpati/core/utils/message_utils.dart';

class DashboardFragment implements BaseHomeFragment {
  DashboardFragment(this.position);

  @override
  void onTabSelected(BuildContext mContext) {
    BlocProvider.of<HomeScreenBloc>(mContext).add(this);
  }

  @override
  BottomNavyBarItem bottomNavyBarItem = BottomNavyBarItem(
    icon: Icon(LineIcons.home),
    title: Text('Beranda'),
    activeColor: AppColor.primaryColor,
    inactiveColor: Colors.grey,
  );

  @override
  Widget view = _HomeScreen();

  @override
  int position;
}

class _HomeScreen extends StatelessWidget {
  Widget createAppBar() {
    return BlocBuilder<AppBloc, AppState>(
      builder: (ctx, state) {
        final greeting = 'Selamat Datang!';

        return AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Wrap(
            direction: Axis.vertical,
            spacing: 2,
            children: <Widget>[
              if (state.nurse != null)
                Text('Hi ${state.nurse.fullName},',
                    style: AppTextStyle.titleName),
              Text(
                greeting,
                style: AppTextStyle.title.copyWith(
                  color: AppColor.primaryColor,
                  fontSize: state.nurse != null ? 14 : 18,
                ),
              ),
            ],
          ),
          backgroundColor: AppColor.appBackground,
          actions: <Widget>[
            IconButton(
              icon: Icon(LineIcons.info),
              color: AppColor.primaryColor,
              onPressed: () => ctx.showAppInfo(
                nurse: state?.nurse,
                posyandu: state?.posyandu,
                onLoginClick: () => onLoginClick(ctx),
                onLogoutClick: () {
                  Navigator.of(ctx).pop();
                  BlocProvider.of<AppBloc>(ctx).add(AppEvent.AppLogout);
                  Scaffold.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text('Logout Berhasil'),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
            )
          ],
        );
      },
    );
  }

  void onLoginClick(BuildContext context) async {
    final result = await Navigator.of(context).push(MaterialPageRoute(
      builder: (ctx) => AuthScreen(),
    ));
    if (result != null) {
      Navigator.of(context).pop();
      BlocProvider.of<AppBloc>(context).add(AppEvent.AppLogin);
      DashboardBloc()..add(DashboardEvent.Init);
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(result),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final safeHeight = MediaQuery.of(context).padding.top;
    return BlocProvider<DashboardBloc>(
      create: (ctx) => DashboardBloc()..add(DashboardEvent.Init),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              createAppBar(),
              Expanded(child: createContent()),
            ],
          ),
          Container(height: safeHeight, color: AppColor.primaryColor),
        ],
      ),
    );
  }

  Widget createContent() {
    return BlocBuilder<DashboardBloc, DashboardState>(
      builder: (ctx, state) {
        return ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            getSpace(),
            getSection(ctx, createSectionData(true, state.motherMeta)),
            getSpace(),
            getSection(ctx, createSectionData(false, state.childMeta)),
            getSpace(isSmall: true),
            ...getArticleSections(),
          ],
        );
      },
    );
  }

  SectionData createSectionData(bool isMother, PersonMeta meta) {
    return SectionData(
      LineIcons.child,
      'Rekap Kondisi ${isMother ? 'Ibu' : 'Anak'}',
      meta?.size ?? 0,
      'orang',
      isMother ? AppColor.redGradient : AppColor.yellowGradient,
      isMother ? 'assets/undraw_mom.svg' : 'assets/undraw_children.svg',
      meta?.list?.recaps?.map((e) {
            final isPercentage = e.type == 'percentage';
            final value = isPercentage ? (e.value / meta.size * 100) : e.value;
            final unit = isPercentage ? '%' : '';
            return CardData(e.title, '${value.toInt()}$unit');
          })?.toList() ??
          List(),
    );
  }

  Widget getSection(BuildContext context, SectionData data) {
    final horizontalItem = 3;
    final padding = 16 * 2 * 2;
    final space = 8 * (horizontalItem - 1);
    final contentWidth =
        (MediaQuery.of(context).size.width - padding - space) / horizontalItem;
    return Container(
      decoration: BoxDecoration(
        gradient: data.gradient,
        borderRadius: BorderRadius.circular(6),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      child: Stack(
        children: <Widget>[
          Align(
            child: SvgPicture.asset(data.assetPath, height: 120),
            alignment: Alignment.topRight,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(data.iconData, size: 28, color: Colors.white),
                  Container(width: 2),
                  Text(
                    data.name,
                    style: AppTextStyle.sectionTitle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Container(height: 16),
              Text(
                NumberFormat().format(data.value),
                style: AppTextStyle.sectionData,
                textAlign: TextAlign.end,
              ),
              Text(
                data.unit,
                style: AppTextStyle.sectionData.copyWith(
                  fontSize: 12,
                  color: Colors.white,
                ),
              ),
              Container(height: 16),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: data.items
                    .map((d) => DashboardContentCard(contentWidth, d))
                    .toList(),
              ),
              if (data.items.isEmpty)
                SpinKitWave(color: Colors.white, size: 18.0),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> getArticleSections() {
    return <Widget>[
      Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Text(
          'Artikel Terbaru',
          style: AppTextStyle.title.copyWith(
            color: AppColor.primaryColor,
            fontSize: 16,
          ),
        ),
      ),
      ArticleCard(Article.mock),
      ArticleCard(Article.mock),
      ArticleCard(Article.mock),
    ];
  }

  Container getSpace({bool isSmall = true}) {
    return isSmall ? Container(height: 8) : Container(height: 28);
  }
}
