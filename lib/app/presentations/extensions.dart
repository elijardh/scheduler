extension ASSETS on String {
  String toPNG() {
    return 'assets/images/png/$this.png';
  }

  String toSVG() {
    return 'assets/images/svg/$this.svg';
  }
}

const String pattern =
    r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
    r"{0,253}[a-zA-Z0-9])?)*$";
