import 'package:xml/xml.dart';

class KMLBuilder {
  final XmlDocument _document = XmlDocument([
    XmlProcessing('xml', 'version="1.0" encoding="UTF-8"'),
    XmlElement(XmlName('kml'), [], [
      XmlElement(XmlName('Document'), [], []),
    ])
  ]);

  void addPlacemark(String name, double latitude, double longitude) {
    final documentElement = _document.rootElement.getElement('Document');
    documentElement?.children.add(
      XmlElement(
        XmlName('Placemark'),
        [],
        [
          XmlElement(XmlName('name'), [], [XmlText(name)]),
          XmlElement(
            XmlName('Point'),
            [],
            [
              XmlElement(
                XmlName('coordinates'),
                [],
                [XmlText('$longitude,$latitude')],
              ),
            ],
          ),
        ],
      ),
    );
  }

  XmlDocument build() {
    return _document;
  }
}
