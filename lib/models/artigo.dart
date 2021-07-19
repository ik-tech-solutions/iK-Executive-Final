 class Artigo{
    String artigo;
    String altura;
    String comprimento;
    String qtd;

    Artigo({this.artigo,this.altura,this.comprimento,this.qtd});


    Artigo copy({
      String artigo,
      String altura,
      String comprimento,
      String qtd,
    })=>Artigo(
      artigo: artigo ?? this.artigo,
      altura: altura ?? this.altura,
      comprimento: comprimento ?? this.comprimento,
      qtd: qtd??this.qtd,
    );


    @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Artigo &&
          runtimeType == other.runtimeType &&
          artigo == other.artigo &&
          altura == other.altura &&
          qtd == other.qtd &&
          comprimento == other.comprimento;

  @override
  int get hashCode => artigo.hashCode ^ altura.hashCode ^ qtd.hashCode^ comprimento.hashCode;
  }