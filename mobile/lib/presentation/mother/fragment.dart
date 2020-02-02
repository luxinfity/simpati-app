import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:simpati/core/bloc/scroll_fragment_bloc.dart';
import 'package:simpati/core/resources/app_color.dart';
import 'package:simpati/core/resources/app_text_style.dart';
import 'package:simpati/domain/entity/transaction.dart';
import 'package:simpati/presentation/mother/bloc.dart';
import 'package:simpati/presentation/home/bloc.dart';
import 'package:simpati/presentation/home/fragment.dart';
import 'package:simpati/core/utils/message_utils.dart';

class MotherFragment implements BaseHomeFragment {
  MotherFragment(this.position);

  @override
  void onTabSelected(BuildContext mContext) {
    BlocProvider.of<HomeScreenBloc>(mContext).add(this);
  }

  @override
  BottomNavyBarItem bottomNavyBarItem = BottomNavyBarItem(
    icon: Icon(LineIcons.female),
    title: Text('Ibu'),
    activeColor: AppColor.primaryColor,
    inactiveColor: Colors.grey,
  );

  @override
  Widget view = _HomeScreen();

  @override
  int position;
}

class _HomeScreen extends StatelessWidget {
  Widget createActionButton() {
    return Builder(
      builder: (ctx) {
        // ignore: close_sinks
        final bloc = BlocProvider.of<MotherBloc>(ctx);
        return Padding(
          padding: const EdgeInsets.all(16),
          child: MaterialButton(
            onPressed: () {
              bloc.add(Add(Transaction.mock));
            },
            onLongPress: () async {
              print('long press');
            },
            color: AppColor.primaryColor,
            shape: CircleBorder(),
            padding: const EdgeInsets.all(16),
            child: Icon(LineIcons.plus, color: Colors.white),
          ),
        );
      },
    );
  }

  Widget createAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Wrap(
        direction: Axis.vertical,
        spacing: 2,
        children: <Widget>[
          Text(
            'Daftar Ibu',
            style: AppTextStyle.title.copyWith(
              color: AppColor.primaryColor,
              fontSize: 16,
            ),
          ),
          Text(
            '300 Orang',
            style: AppTextStyle.titleName.copyWith(fontSize: 12),
          ),
        ],
      ),
      backgroundColor: AppColor.appBackground,
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          color: AppColor.primaryColor,
          onPressed: () => context.showComingSoonNotice(),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (ctx) => MotherBloc(),
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              createAppBar(context),
              Expanded(child: getContents())
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: createActionButton(),
          )
        ],
      ),
    );
  }

  Widget getContents() {
    return BlocBuilder<MotherBloc, ScrollFragmentState<Transaction>>(
      builder: (context, state) {
        final String assetName = 'assets/no_data.svg';
        final Widget svg = SvgPicture.asset(
          assetName,
          height: 120,
          semanticsLabel: 'Data Kosong',
        );
        return state.items.isNotEmpty
            ? ListView(
                padding: const EdgeInsets.all(0),
                children: state.items.map((d) => createCard()).toList(),
              )
            : Column(
                children: <Widget>[
                  Container(height: 64),
                  svg,
                  Container(height: 12),
                  Text('Data Kosong', style: AppTextStyle.titleName),
                ],
              );
      },
    );
  }

  Widget createCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CircleAvatar(
            child: Icon(LineIcons.female, color: Colors.white),
            backgroundColor: AppColor.gradientColor,
          ),
          Container(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Khusnaini Aghniya',
                      style: AppTextStyle.sectionData.copyWith(fontSize: 14),
                    ),
                    Text(
                      '24 thn',
                      style:
                          AppTextStyle.caption.copyWith(color: Colors.black87),
                    ),
                  ],
                ),
                Text(
                  'Jl Singosari No. 62',
                  style: AppTextStyle.caption.copyWith(color: Colors.black38),
                ),
                Container(height: 8),
                Wrap(
                  spacing: 4,
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColor.gradientColor),
                      child: Text(
                        '1 Anak',
                        style: AppTextStyle.caption.copyWith(fontSize: 10),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColor.gradientColor),
                      child: Text(
                        'Berat Ideal',
                        style: AppTextStyle.caption.copyWith(fontSize: 10),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: AppColor.gradientColor),
                      child: Text(
                        'Gizi Baik',
                        style: AppTextStyle.caption.copyWith(fontSize: 10),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Container getSpace({bool isSmall = true}) {
    return isSmall ? Container(height: 8) : Container(height: 28);
  }
}
