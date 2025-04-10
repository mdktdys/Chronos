enum DepartmentForms {
  general(
    'Общеобразовательное',
    'https://docs.google.com/forms/d/e/1FAIpQLSdY65y9i7YZBIwD3oItOG57Sn0ZjA2DJ8yuk8TQXaVlKq8Xig/viewform?usp=sharing',
    'assets/icon/general.svg',
  ),
  informatics(
    'Информатика и программирование',
    'https://docs.google.com/forms/d/e/1FAIpQLSfD2CgQ8sAmnhiUoR8qOmKbXcYMyctUERSWy-uYOoZf1mfEAg/viewform?usp=sf_link',
    'assets/icon/informatics.svg',
  ),
  computer(
    'Вычислительная техника',
    'https://docs.google.com/forms/d/1IajFtj5A1YWWvvQ687P4UTKdmNfY3MRl--J7FSQA35w/edit#responses',
    'assets/icon/computer.svg',
  ),
  econom(
    'Экономика и землеустройство',
    'https://docs.google.com/forms/d/e/1FAIpQLScyWMvXES_WOcy20RT1Yu34SdrICbtqnlUzsstqFlF8RQqVWA/viewform?usp=sf_link',
    'assets/icon/econom.svg',
  // ),
  // law(
  //   'Права',
  //   'https://example.com/law-form',
  //   'assets/icon/trash.svg',
  );

  final String title;
  final String formUrl;
  final String iconPath;

  const DepartmentForms(
    this.title,
    this.formUrl,
    this.iconPath,
  );
}
