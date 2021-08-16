class Cnpj {
  String cnpj = '';
  String numero = '';
  String situacao = '';
  String fantasia = '';
  String razao = '';
  String complemento = '';
  String bairro = '';
  String situacaoCadastral = '';
  String nome = '';
  String logradouro = '';
  String naturezaJuridica = '';
  String cnae = '';
  String cnae2 = '';
  String capitalSocial = '';
  double value = 0;
  String telefone = '';

  String fixSocios(String socios) {
    socios = socios
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll('-', ' ')
        .replaceAll(',', '');
    return socios;
  }

  Cnpj.fromJson(Map<String, dynamic> json) {
    //dataSituacao = json['data_situacao'];
    //motivoSituacao = json['motivo_situacao'];
    //tipo = json['tipo'];
    nome = json['nome'];
    telefone = json['telefone'];
    // if (json['qsa'] != null) {
    // 	qsa = new List<Null>();
    // 	json['qsa'].forEach((v) { qsa.add(new Null.fromJson(v)); });
    // }
    situacao = json['situacao'];
    //	porte = json['porte'];
    //	abertura = json['abertura'];
    naturezaJuridica = json['natureza_juridica'];
    fantasia = json['fantasia'];
    cnpj = json['cnpj'];
    //	ultimaAtualizacao = json['ultima_atualizacao'];
    //	status = json['status'];
    logradouro = json['logradouro'];
    numero = json['numero'];
    complemento = json['complemento'];
    //	cep = json['cep'];
    bairro = json['bairro'];
    //	municipio = json['municipio'];
    //	uf = json['uf'];
    //	email = json['email'];
    //	efr = json['efr'];
    //	situacaoEspecial = json['situacao_especial'];
    //	dataSituacaoEspecial = json['data_situacao_especial'];
    // if (json['atividade_principal'] != null) {
    // 	atividadePrincipal = new List<AtividadePrincipal>();
    // 	json['atividade_principal'].forEach((v) { atividadePrincipal.add(new AtividadePrincipal.fromJson(v)); });
    // }
    // if (json['atividades_secundarias'] != null) {
    // 	atividadesSecundarias = new List<AtividadesSecundarias>();
    // 	json['atividades_secundarias'].forEach((v) { atividadesSecundarias.add(new AtividadesSecundarias.fromJson(v)); });
    // }
    capitalSocial = json['capital_social'];
    //	extra = json['extra'] != null ? new Extra.fromJson(json['extra']) : null;
    //	billing = json['billing'] != null ? new Billing.fromJson(json['billing']) : null;
  }

 
}
