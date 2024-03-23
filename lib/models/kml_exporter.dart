import 'package:google_maps_flutter/google_maps_flutter.dart';
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

  void addPolygon(String name, List<LatLng> coordinates, String color) {
    final documentElement = _document.rootElement.getElement('Document');
    final List<String> coordinatesList = coordinates
        .map((coord) => '${coord.longitude},${coord.latitude}')
        .toList();

    documentElement?.children.add(
      XmlElement(
        XmlName('Placemark'),
        [],
        [
          XmlElement(XmlName('name'), [], [XmlText(name)]),
          XmlElement(
            XmlName('Style'),
            [],
            [
              XmlElement(
                XmlName('LineStyle'),
                [],
                [
                  XmlElement(XmlName('color'), [], [XmlText(color)]),
                ],
              ),
              XmlElement(
                XmlName('PolyStyle'),
                [],
                [
                  XmlElement(XmlName('color'), [], [XmlText(color)]),
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

  void addLine(String name, List<LatLng> coordinates, String color) {
    final documentElement = _document.rootElement.getElement('Document');
    final List<String> coordinatesList = coordinates
        .map((coord) => '${coord.longitude},${coord.latitude}')
        .toList();

    documentElement?.children.add(
      XmlElement(
        XmlName('Placemark'),
        [],
        [
          XmlElement(XmlName('name'), [], [XmlText(name)]),
          XmlElement(
            XmlName('Style'),
            [],
            [
              XmlElement(
                XmlName('LineStyle'),
                [],
                [
                  XmlElement(XmlName('color'), [], [XmlText(color)]),
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

  void addPlacemarkWithIcon(
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
