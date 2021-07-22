part of registration_view;

class _HeaderText extends StatelessWidget {
  const _HeaderText({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Registo", style: Theme.of(context).textTheme.headline5),
        SizedBox(height: 5),
        Text(
          "O futuro da logística está nas suas mãos.",
          textAlign: TextAlign.center,
        )
      ],
    );
  }
}
