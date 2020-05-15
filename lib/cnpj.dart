class Cnpj {
  String numero;
  String situacao;
  String fantasia;
  String razao;
  String complemento;
  String bairro;
  String situacaoCadastral;
  String nome;
  String logradouro;
  String naturezaJuridica;
  String cnae;
  String cnae2;
  String capitalSocial;
  double value;
  String telefone;

  String fixCNPJ(String cnpj) {
    cnpj = cnpj
        .replaceAll('.', '')
        .replaceAll('/', '')
        .replaceAll('-', '')
        .replaceAll(',', '');
    return cnpj;
  }

  String fixSocios(String socios) {
    socios = socios
        .replaceAll("[", "")
        .replaceAll("]", "")
        .replaceAll("-", " ")
        .replaceAll(",", "");
    return socios;
  }
}
