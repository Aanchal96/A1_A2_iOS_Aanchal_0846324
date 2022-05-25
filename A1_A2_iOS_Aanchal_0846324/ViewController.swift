//
//  ViewController.swift
//  A1_A2_iOS_Aanchal_0846324
//
//  Created by Aanchal Bansal on 2022-05-24.
//

import UIKit
import MapKit
import GLKit

extension Int{

    func getCorrespondingAlphabet() -> String {
        switch self {
        case 1:
            return "A"
        case 2:
            return "B"
        default:
            return "C"
        }
    }
}


class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var directionBtn: UIButton!

    var arrAddedLocations : [MKPointAnnotation] = []
    var lblAnotations : [MKPointAnnotation] = []

    var currentLocation : MKPointAnnotation?
    var locationMnager = CLLocationManager()
    var destination: CLLocationCoordinate2D!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        map.isZoomEnabled = true
        map.showsUserLocation = true
        directionBtn.isHidden = true
        locationMnager.delegate = self
        locationMnager.desiredAccuracy = kCLLocationAccuracyBest
        locationMnager.requestWhenInUseAuthorization()
        locationMnager.startUpdatingLocation()
        map.delegate = self
        let doubleTap = UITapGestureRecognizer(target: self, action: #selector(addLongAnnotattion))
        doubleTap.numberOfTapsRequired = 1
        map.addGestureRecognizer(doubleTap)
    }
    
    //MARK: - draw route between two places
    @IBAction func drawRoute(_ sender: UIButton) {
        map.removeOverlays(map.overlays)

        let sourcePlaceMark = MKPlacemark(coordinate: arrAddedLocations[0].coordinate)
        let destinationPlaceMark = MKPlacemark(coordinate: arrAddedLocations[1].coordinate)

        // request a direction
        let directionRequest = MKDirections.Request()

        // assign the source and destination properties of the request
        directionRequest.source = MKMapItem(placemark: sourcePlaceMark)
        directionRequest.destination = MKMapItem(placemark: destinationPlaceMark)

        // transportation type
        directionRequest.transportType = .automobile

        // calculate the direction
        let directions = MKDirections(request: directionRequest)
        directions.calculate { (response, error) in
            guard let directionResponse = response else {return}
            // create the route
            let route = directionResponse.routes[0]
            // drawing a polyline
            self.map.addOverlay(route.polyline, level: .aboveRoads)

            // define the bounding map rect
            let rect = route.polyline.boundingMapRect
            self.map.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)

            //            self.map.setRegion(MKCoordinateRegion(rect), animated: true)
        }

        // 2nd
        let sourcePlaceMark2 = destinationPlaceMark
        let destinationPlaceMark2 = MKPlacemark(coordinate: arrAddedLocations[2].coordinate)

        // request a direction
        let directionRequest2 = MKDirections.Request()

        // assign the source and destination properties of the request
        directionRequest2.source = MKMapItem(placemark: sourcePlaceMark2)
        directionRequest2.destination = MKMapItem(placemark: destinationPlaceMark2)

        // transportation type
        directionRequest2.transportType = .automobile

        // calculate the direction
        let directions2 = MKDirections(request: directionRequest2)
        directions2.calculate { (response, error) in
            guard let directionResponse2 = response else {return}
            // create the route
            let route = directionResponse2.routes[0]
            // drawing a polyline
            self.map.addOverlay(route.polyline, level: .aboveRoads)

            // define the bounding map rect
            let rect = route.polyline.boundingMapRect
            self.map.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)
        }

        // 3rd
        let sourcePlaceMark3 = destinationPlaceMark2
        let destinationPlaceMark3 = MKPlacemark(coordinate: arrAddedLocations[0].coordinate)

        // request a direction
        let directionRequest3 = MKDirections.Request()

        // assign the source and destination properties of the request
        directionRequest3.source = MKMapItem(placemark: sourcePlaceMark3)
        directionRequest3.destination = MKMapItem(placemark: destinationPlaceMark3)

        // transportation type
        directionRequest3.transportType = .automobile

        // calculate the direction
        let directions3 = MKDirections(request: directionRequest3)
        directions3.calculate { (response, error) in
            guard let directionResponse = response else {return}
            // create the route
            let route = directionResponse.routes[0]
            // drawing a polyline
            self.map.addOverlay(route.polyline, level: .aboveRoads)

            // define the bounding map rect
            let rect = route.polyline.boundingMapRect
            self.map.setVisibleMapRect(rect, edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100), animated: true)

            //            self.map.setRegion(MKCoordinateRegion(rect), animated: true)

        }

    }
    
    
    //MARK: - didupdatelocation method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        let latitude = userLocation.coordinate.latitude
        let longitude = userLocation.coordinate.longitude
        displayLocation(latitude: latitude, longitude: longitude, title: "My location", subtitle: "you are here")
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }

    //    //MARK: - polygon method
    func addPolygon() {
        map.removeAnnotations(lblAnotations)
        let coordinates = arrAddedLocations.map {$0.coordinate}
        let polygon = MKPolygon(coordinates: coordinates, count: coordinates.count)
        
        if coordinates.count == 3{
            var newC = coordinates
            newC.append(coordinates[0])
            let polylineFirst = MKPolyline.init(coordinates: [newC[0] , newC[1]], count: 2)
            let cent1 = getCenterCoord([newC[0] , newC[1]])
            let annotation1 = MKPointAnnotation()
            annotation1.title = getDistance(first: newC[0], second: newC[1])
            annotation1.coordinate = cent1
            map.addAnnotation(annotation1)

            let cent2 = getCenterCoord([newC[1] , newC[2]])
            let annotation2 = MKPointAnnotation()
            annotation2.title = getDistance(first: newC[1], second: newC[2])
            annotation2.coordinate = cent2
            map.addAnnotation(annotation2)

            let cent3 = getCenterCoord([newC[2] , newC[0]])
            let annotation3 = MKPointAnnotation()
            annotation3.title = getDistance(first: newC[2], second: newC[0])
            annotation3.coordinate = cent3

            map.addAnnotation(annotation3)
            lblAnotations = [annotation1,annotation2,annotation3]
            let polylineSecond = MKPolyline.init(coordinates: [newC[1] , newC[2]], count: 2)
            let polylineThird = MKPolyline.init(coordinates: [newC[2] , newC[0]], count: 2)

            map.addOverlays([polylineFirst,polylineSecond,polylineThird])
        }

        map.addOverlay(polygon)

    }
    
    @objc func addLongAnnotattion(gestureRecognizer: UIGestureRecognizer) {
        let touchPoint = gestureRecognizer.location(in: map)
        let coordinate = map.convert(touchPoint, toCoordinateFrom: map)
        // add annotation for the coordinatet
        if arrAddedLocations.count == 3 {
            map.removeAnnotations(arrAddedLocations)
            arrAddedLocations.removeAll()
            map.removeOverlays(map.overlays)
        }
        var selectedIndex = -1
        for (index,marker) in self.arrAddedLocations.enumerated() {
            let source = CLLocation.init(latitude: marker.coordinate.latitude, longitude: marker.coordinate.longitude)
            let destination = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
            let distance = Int(source.distance(from: destination))
            print(distance)
            if distance < 500 {
                map.removeOverlays(map.overlays)
                selectedIndex = index
                break
            }
        }
        if selectedIndex != -1 {
            map.removeAnnotation(arrAddedLocations[selectedIndex])
            arrAddedLocations.remove(at: selectedIndex)
            return
        }

        let annotation = MKPointAnnotation()
        annotation.title = (arrAddedLocations.count + 1).getCorrespondingAlphabet()
        let source = CLLocation.init(latitude: currentLocation?.coordinate.latitude ?? 0, longitude: currentLocation?.coordinate.longitude ?? 0)
        let destination = CLLocation.init(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let distance = Int(source.distance(from: destination)).description
        annotation.subtitle = "\(distance) m"
        annotation.coordinate = coordinate
        map.addAnnotation(annotation)
        arrAddedLocations.append(annotation)
        addPolygon()
        directionBtn.isHidden = arrAddedLocations.count < 3

    }

    //MARK: - display user location method
    func displayLocation(latitude: CLLocationDegrees,
                         longitude: CLLocationDegrees,
                         title: String,
                         subtitle: String) {
        // 2nd step - define span
        let latDelta: CLLocationDegrees = 0.05
        let lngDelta: CLLocationDegrees = 0.05
        
        let span = MKCoordinateSpan(latitudeDelta: latDelta, longitudeDelta: lngDelta)
        // 3rd step is to define the location
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        // 4th step is to define the region
        let region = MKCoordinateRegion(center: location, span: span)
        
        // 5th step is to set the region for the map
        map.setRegion(region, animated: true)
        
        // 6th step is to define annotation
        let annotation = MKPointAnnotation()
        annotation.title = title
        annotation.subtitle = subtitle
        annotation.coordinate = location
        currentLocation = annotation
        map.addAnnotation(annotation)
    }

}

extension ViewController: MKMapViewDelegate {
    
    //MARK: - viewFor annotation method


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }

        switch annotation.title {
        case "My location":
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "MyMarker")
            annotationView.markerTintColor = UIColor.blue
            return annotationView
        default:
            if annotation.subtitle ?? "" == nil{
                let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "DistanceMarker")
                annotationView.image = UIImage()
                annotationView.markerTintColor = UIColor.clear
                return annotationView
            }
            let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "CustomMarker")
            annotationView.markerTintColor = UIColor.red
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
    }
    
    //MARK: - callout accessory control tapped
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        let alertController = UIAlertController(title: "Distance from your location", message: view.annotation?.subtitle ?? "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
    
    //MARK: - rendrer for overlay func
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if overlay is MKCircle {
            let rendrer = MKCircleRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.black.withAlphaComponent(0.5)
            rendrer.strokeColor = UIColor.green
            rendrer.lineWidth = 3
            return rendrer
        } else if overlay is MKPolyline {
            let rendrer = MKPolylineRenderer(overlay: overlay)
            rendrer.strokeColor = UIColor.blue
            rendrer.lineWidth = 3
            return rendrer
        } else if overlay is MKPolygon {
            let rendrer = MKPolygonRenderer(overlay: overlay)
            rendrer.fillColor = UIColor.red.withAlphaComponent(0.5)
            rendrer.strokeColor = UIColor.green
            rendrer.lineWidth = 3
            return rendrer
        }
        return MKOverlayRenderer()
    }

    func getCenterCoord(_ LocationPoints: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D{
        var x:Float = 0.0;
        var y:Float = 0.0;
        var z:Float = 0.0;
        for points in LocationPoints {
            let lat = GLKMathDegreesToRadians(Float(points.latitude));
            let long = GLKMathDegreesToRadians(Float(points.longitude));

            x += cos(lat) * cos(long);

            y += cos(lat) * sin(long);

            z += sin(lat);
        }
        x = x / Float(LocationPoints.count);
        y = y / Float(LocationPoints.count);
        z = z / Float(LocationPoints.count);
        let resultLong = atan2(y, x);
        let resultHyp = sqrt(x * x + y * y);
        let resultLat = atan2(z, resultHyp);
        let result = CLLocationCoordinate2D(latitude: CLLocationDegrees(GLKMathRadiansToDegrees(Float(resultLat))), longitude: CLLocationDegrees(GLKMathRadiansToDegrees(Float(resultLong))));
        return result;
    }

    func getDistance(first : CLLocationCoordinate2D , second : CLLocationCoordinate2D) -> String{
        let source = CLLocation.init(latitude: first.latitude, longitude: first.longitude)
        let destination = CLLocation.init(latitude: second.latitude, longitude: second.longitude)
        let distance = Int(source.distance(from: destination))
        return "\(distance) m"
    }
}


