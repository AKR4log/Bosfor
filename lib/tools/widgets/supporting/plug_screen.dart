import 'package:flutter/material.dart';
import 'package:kz/tools/widgets/supporting/plug.dart';

class PlugScreen extends StatefulWidget {
  PlugScreen({Key key}) : super(key: key);

  @override
  _PlugScreenState createState() => _PlugScreenState();
}

class _PlugScreenState extends State<PlugScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        leading: BackButton(
          color: Colors.black,
        ),
        title: Text(
          'Разработка',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              plugWidget('Настройки', 'Требуется обговорить с заказчиком'),
              plugWidget('Помошь', 'Требуется обговорить с заказчиком'),
              plugWidget(
                  'Условия использования', 'Требуется обговорить с заказчиком'),
              plugWidget('Политика конфидециальности',
                  'Требуется обговорить с заказчиком'),
              plugWidget('Предложение и замечание',
                  'Требуется обговорить с заказчиком'),
              plugWidget('О приложении', 'Требуется обговорить с заказчиком'),
              plugWidget('Чат с пользователем',
                  'Требуется ли отправка фото в сообщениях?'),
              plugWidget('Покрасить объявление',
                  'Требуется логика (сколько брать за это)'),
              plugWidget(
                  'Продвигать', 'Требуется логика (сколько брать за это)')
            ],
          ),
        ),
      ),
    );
  }
}
