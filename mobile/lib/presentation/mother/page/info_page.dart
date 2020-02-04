import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:simpati/core/utils/date_utils.dart';
import 'package:simpati/core/resources/app_color.dart';
import 'package:simpati/core/resources/app_text_style.dart';
import 'package:simpati/core/utils/form_utils.dart';
import 'package:simpati/domain/entity/mother.dart';
import 'package:simpati/domain/entity/pregnancy.dart';
import 'package:simpati/presentation/kid/page/add_page.dart';
import 'package:simpati/presentation/mother/dialog/add_pregnancy_dialog.dart';
import 'package:simpati/presentation/mother/page/pregancy_info_page.dart';

class MotherInfoPage extends StatelessWidget {
  final Mother initialData;

  const MotherInfoPage(this.initialData, {Key key}) : super(key: key);

  Widget createAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      iconTheme: IconThemeData(color: AppColor.primaryColor),
      titleSpacing: 0,
      backgroundColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context),
      backgroundColor: AppColor.appBackground,
      body: ListView(
        shrinkWrap: true,
        children: [
          createNameSection(),
          Container(height: 8),
          createPhotoSection(),
          Container(height: 8),
          createPersonalInfo(),
          Container(height: 8),
          createContactInfo(),
          Container(height: 8),
          createHealthCheckInfo(),
          Container(height: 8),
          createChildInfo(),
          Container(height: 8),
          createPregnancyInfo(),
        ],
      ),
    );
  }

  Widget createNameSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 21, right: 21, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(initialData.fullName, style: AppTextStyle.registerTitle),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Icon(LineIcons.map_marker, size: 16, color: Colors.black38),
              Container(width: 4),
              Text(
                initialData.address,
                style: AppTextStyle.titleName.copyWith(fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget createPhotoSection() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
      child: Row(
        children: <Widget>[
          CircleAvatar(
            radius: 36,
            backgroundColor: AppColor.profileBgColor,
            child: Icon(LineIcons.female, color: Colors.white, size: 36),
          ),
          Container(width: 16),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Foto Profil', style: AppTextStyle.sectionTitle),
              Row(
                children: <Widget>[
                  createProfileButton('Galeri', LineIcons.image),
                  Container(width: 8),
                  createProfileButton('Kamera', LineIcons.camera_retro),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  FlatButton createProfileButton(String source, IconData iconData) {
    return FlatButton(
      child: Row(
        children: <Widget>[
          Icon(iconData, color: Colors.black38, size: 18),
          Container(width: 4),
          Text(source, style: AppTextStyle.titleName),
        ],
      ),
      padding: const EdgeInsets.all(0),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(4),
          side: BorderSide(color: Colors.black38)),
      onPressed: () {},
    );
  }

  Widget createPersonalInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Data Pribadi', style: AppTextStyle.sectionTitle),
          Container(height: 21),
          FormUtils.buildField(
            'Tanggal Lahir',
            value: initialData.dateOfBirth.standardFormat(),
            isEnabled: false,
          ),
          Container(height: 8),
          Row(
            children: <Widget>[
              Expanded(
                child: FormUtils.buildField(
                  'Tinggi Badan',
                  value: initialData.height.toString(),
                  suffix: 'cm',
                  isEnabled: false,
                ),
              ),
              Container(width: 8),
              Expanded(
                child: FormUtils.buildField(
                  'Golongan Darah',
                  value: initialData.bloodType,
                  isEnabled: false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget createContactInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Informasi Kontak', style: AppTextStyle.sectionTitle),
          Container(height: 21),
          FormUtils.buildField(
            'Nomor Telpon',
            value: initialData.phoneNumber,
            isEnabled: false,
          ),
          Container(height: 8),
          FormUtils.buildField(
            'Nama Suami',
            value: initialData.husbandName,
            isEnabled: false,
          ),
        ],
      ),
    );
  }

  Widget createChildInfo() {
    return Builder(builder: (context) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Daftar Anak', style: AppTextStyle.sectionTitle),
            Container(height: 21),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                ...List.generate(
                  initialData.childCount,
                  (i) => createChildCircle('Alif'),
                ),
                SizedBox(
                  height: 59,
                  width: 59,
                  child: FlatButton(
                    padding: const EdgeInsets.all(0),
                    shape: CircleBorder(),
                    color: AppColor.primaryColor,
                    child: Icon(LineIcons.plus, color: Colors.white),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => KidAddPage(),
                      ));
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget createChildCircle(String name) {
    return Column(
      children: <Widget>[
        Stack(
          alignment: Alignment.center,
          children: <Widget>[
            CircleAvatar(
              radius: 29.5,
              backgroundColor: AppColor.accentColor,
            ),
            CircleAvatar(
              radius: 27,
              backgroundColor: Colors.white,
            ),
            CircleAvatar(
              radius: 26,
              backgroundColor: AppColor.profileBgColor,
              child: Icon(LineIcons.child, color: Colors.white, size: 36),
            ),
          ],
        ),
        Container(height: 8, width: 1),
        Text(name, style: AppTextStyle.caption.copyWith(color: Colors.black))
      ],
    );
  }

  Widget createHealthCheckInfo() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('Informasi Kesehatan', style: AppTextStyle.sectionTitle),
          Container(height: 21),
          Row(
            children: <Widget>[
              Flexible(
                child: FormUtils.buildField('Berat Badan',
                    value: initialData.weight.toString(),
                    isEnabled: false,
                    suffix: 'Kg'),
                flex: 3,
              ),
              Container(width: 8),
              Flexible(
                child: FormUtils.buildField('Tekanan Darah',
                    value: '120/80', isEnabled: false, suffix: 'mmHg'),
                flex: 4,
              ),
            ],
          ),
          Container(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              createChip('Berat Ideal'),
              createChip('Gizi Baik'),
            ],
          ),
        ],
      ),
    );
  }

  Container createChip(String title) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), color: AppColor.accentColor),
      child: Text(
        title,
        style: AppTextStyle.caption.copyWith(fontSize: 14),
      ),
    );
  }

  Widget createPregnancyInfo() {
    return Builder(builder: (context) {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 21, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Riwayat Kehamilan', style: AppTextStyle.sectionTitle),
            Container(height: 21),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <Widget>[
                ...List.generate(
                  // initialData.childCount,
                  4,
                  (i) => FlatButton(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                      side: BorderSide(color: Colors.black),
                    ),
                    child: Wrap(
                      direction: Axis.vertical,
                      spacing: 2,
                      children: <Widget>[
                        Text('Ke ${i + 1}',
                            style: AppTextStyle.itemTitle),
                        Text('2019',
                            style:
                                AppTextStyle.titleName.copyWith(fontSize: 10)),
                      ],
                    ),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (ctx) => PregnancyInfoPage(i, Pregnancy.mock),
                      ));
                    },
                  ),
                ),
                FlatButton(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  color: AppColor.primaryColor,
                  child: Icon(LineIcons.plus, color: Colors.white),
                  onPressed: () => showDialog(
                    context: context,
                    child: AddPregnancyDialog(1, initialData),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }
}
