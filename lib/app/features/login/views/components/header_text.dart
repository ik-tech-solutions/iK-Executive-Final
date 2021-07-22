part of login_view;

class _HeaderText extends StatelessWidget {
  const _HeaderText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Login", style: Theme.of(context).textTheme.headline5),
        SizedBox(height: 5),
        Text("Por favor insira o número registado")
      ],
    );
  }
}
