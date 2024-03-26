import 'package:testing_maps/models/marker.dart';
import 'package:xml/xml.dart';

class KMLBuilder {
  final XmlDocument _document = XmlDocument([
    XmlProcessing('xml', 'version="1.0" encoding="UTF-8"'),
    XmlElement(XmlName('kml'), [], [
      XmlElement(XmlName('Document'), [], []),
    ])
  ]);

  void addPolygon(PolygonModel polygon) {
    final documentElement = _document.rootElement.getElement('Document');
    final List<String> coordinatesList = polygon.coordinates
        .map((coord) => '${coord.longitude},${coord.latitude}')
        .toList();
    final String colorString =
        polygon.color.value.toRadixString(16).substring(2);
    final String lineOpacity =
        (polygon.lineOpacity * 255).toInt().toRadixString(16).padLeft(2, '0');
    final String areaOpacity =
        (polygon.areaOpacity * 255).toInt().toRadixString(16).padLeft(2, '0');

    documentElement?.children.add(
      XmlElement(
        XmlName('Placemark'),
        [],
        [
          XmlElement(XmlName('name'), [], [XmlText(polygon.name)]),
          XmlElement(
              XmlName('description'), [], [XmlText(polygon.description)]),
          XmlElement(
            XmlName('Style'),
            [],
            [
              XmlElement(
                XmlName('LineStyle'),
                [],
                [
                  XmlElement(XmlName('color'), [],
                      [XmlText('$lineOpacity$colorString')]),
                  XmlElement(XmlName('width'), [],
                      [XmlText(polygon.lineWidth.toString())]),
                ],
              ),
              XmlElement(
                XmlName('PolyStyle'),
                [],
                [
                  XmlElement(XmlName('color'), [],
                      [XmlText('$areaOpacity$colorString')]),
                ],
              ),
            ],
          ),
          XmlElement(
            XmlName('Polygon'),
            [],
            [
              XmlElement(
                XmlName('outerBoundaryIs'),
                [],
                [
                  XmlElement(
                    XmlName('LinearRing'),
                    [],
                    [
                      XmlElement(
                        XmlName('coordinates'),
                        [],
                        [XmlText(coordinatesList.join(' '))],
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void addLine(LineModel line) {
    final documentElement = _document.rootElement.getElement('Document');
    final List<String> coordinatesList = line.coordinates
        .map((coord) => '${coord.longitude},${coord.latitude}')
        .toList();
    final String colorString = line.color.value.toRadixString(16).substring(2);
    final String opacity =
        (line.opacity * 255).toInt().toRadixString(16).padLeft(2, '0');

    documentElement?.children.add(
      XmlElement(
        XmlName('Placemark'),
        [],
        [
          XmlElement(XmlName('name'), [], [XmlText(line.name)]),
          XmlElement(
            XmlName('Style'),
            [],
            [
              XmlElement(
                XmlName('LineStyle'),
                [],
                [
                  XmlElement(
                      XmlName('color'), [], [XmlText('$opacity$colorString')]),
                  XmlElement(
                      XmlName('width'), [], [XmlText(line.width.toString())]),
                ],
              ),
            ],
          ),
          XmlElement(
            XmlName('LineString'),
            [],
            [
              XmlElement(
                XmlName('coordinates'),
                [],
                [XmlText(coordinatesList.join(' '))],
              ),
            ],
          ),
        ],
      ),
    );
  }

  void addPlacemark(
    String name,
    double latitude,
    double longitude,
    String description,
    String iconUrl,
  ) {
    final documentElement = _document.rootElement.getElement('Document');
    documentElement?.children.add(
      XmlElement(
        XmlName('Placemark'),
        [],
        [
          XmlElement(XmlName('name'), [], [XmlText(name)]),
          XmlElement(
            XmlName('description'),
            [],
            [XmlText(description)],
          ),
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
          XmlElement(
            XmlName('Style'),
            [],
            [
              XmlElement(
                XmlName('IconStyle'),
                [],
                [
                  XmlElement(
                    XmlName('Icon'),
                    [],
                    [
                      XmlElement(
                        XmlName('href'),
                        [],
                        [XmlText(iconUrl)],
                      ),
                    ],
                  ),
                ],
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
