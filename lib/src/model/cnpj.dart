class Cnpj {
  List<AtividadePrincipal> atividadePrincipal = [];
  dynamic cnpj;
  dynamic dataSituacao;
  dynamic motivoSituacao;
  dynamic tipo;
  dynamic porte;
  dynamic abertura;
  dynamic status;
  dynamic cep;
  dynamic municipio;
  dynamic uf;
  dynamic ultimaAtualizacao;
  dynamic numero;
  dynamic situacao;
  dynamic fantasia;
  dynamic email;
  dynamic complemento;
  dynamic bairro;
  dynamic situacaoCadastral;
  dynamic nome;
  dynamic logradouro;
  dynamic naturezaJuridica;
  dynamic efr;
  dynamic telefone;
  dynamic message;
  dynamic capitalSocial;
  Billing? billing;

  String fixSocios(String socios) {
    socios = socios
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('-', ' ')
        .replaceAll(',', '');
    return socios;
  }

  Cnpj.fromJson(Map<String, dynamic> json) {
    dataSituacao = json['data_situacao'];
    motivoSituacao = json['motivo_situacao'];
    tipo = json['tipo'];
    nome = json['nome'];
    telefone = json['telefone'] != '' ? json['telefone'] : '-';
    // if (json['qsa'] != null) {
    // 	qsa = new List<Null>();
    // 	json['qsa'].forEach((v) { qsa.add(new Null.fromJson(v)); });
    // }
    situacao = json['situacao'];
    porte = json['porte'];
    abertura = json['abertura'];
    naturezaJuridica = json['natureza_juridica'];
    fantasia = json['fantasia'] != '' ? json['fantasia'] : '-';
    cnpj = json['cnpj'];
    ultimaAtualizacao = json['ultima_atualizacao'];
    status = json['status'];
    logradouro = json['logradouro'] != '' ? json['logradouro'] : '-';
    numero = json['numero'] != '' ? json['numero'] : '-';
    complemento = json['complemento'] != '' ? json['complemento'] : '-';
    cep = json['cep'] != '' ? json['cep'] : '-';
    bairro = json['bairro'] != '' ? json['bairro'] : '-';
    municipio = json['municipio'] != '' ? json['municipio'] : '-';
    uf = json['uf'] != '' ? json['uf'] : '-';
    email = json['email'] != '' ? json['email'] : '-';
    efr = json['efr'];
    message = json['message'];
    //	situacaoEspecial = json['situacao_especial'];
    //	dataSituacaoEspecial = json['data_situacao_especial'];
    if (json['atividade_principal'] != null) {
      atividadePrincipal = <AtividadePrincipal>[];
      // ignore: lines_longer_than_80_chars
      json['atividade_principal'].forEach((v) {
        atividadePrincipal.add(AtividadePrincipal.fromJson(v));
      });
    }
    // if (json['atividades_secundarias'] != null) {
    // 	atividadesSecundarias = new List<AtividadesSecundarias>();
    // ignore: lines_longer_than_80_chars
    // 	json['atividades_secundarias'].forEach((v) { atividadesSecundarias.add(new AtividadesSecundarias.fromJson(v)); });
    // }
    if (json['capital_social'] != null) {
      capitalSocial = double.parse(json['capital_social']);
    } else {
      capitalSocial = json['capital_social'];
    }

    //	extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
    if (json['billing'] != null) {
      billing = Billing.fromJson(json['billing']);
    } else {
      billing = null;
    }
  }
}

class Billing {
  bool free = false;
  bool database = false;

  Billing({required this.free, required this.database});

  Billing.fromJson(Map<String, dynamic> json) {
    free = json['free'];
    database = json['database'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['free'] = free;
    data['database'] = database;
    return data;
  }
}

class AtividadePrincipal {
  String text = '';
  String code = '';

  AtividadePrincipal({required this.text, required this.code});

  AtividadePrincipal.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    code = json['code'];
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['text'] = text;
    data['code'] = code;
    return data;
  }
}
