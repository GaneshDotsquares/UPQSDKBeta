
import UIKit
import CoreLocation
import MapKit
/*
 *  CustomLocationManager
 *
 *  Discussion:
 *      This class can be used to hand over work of tracing user location.
 *
 *    key for plist file ---->  (Privacy - Location When In Use Usage Description)
 *	 NSLocationAlwaysAndWhenInUseUsageDescription
 *   NSLocationWhenInUseUsageDescription
 *
 */


class CustomLocationManager: NSObject, CLLocationManagerDelegate
{
    
    //MARK:- Local property
   private var locationManager: CLLocationManager?
	
	var currentLocation:CLLocationCoordinate2D?
	
	var onlyCurrentLocation:Bool=true
   static var myLocation : CustomLocationManager!
    
    //MARK:- Singleton Object
	/*
	*	Below method is used to get singlton object of CustomLocationManager.
	*
	*/
    class func sharedInstance() -> CustomLocationManager {
        if myLocation == nil {
            myLocation = CustomLocationManager()
        }
        return myLocation
    }
    
    //MARK:- local variable for hold completion handler
    var locationHandler: (Double?, Double?, MKCoordinateRegion?, NSError?)-> Void = { lat,long,region,error  in }
 
    //MARK :- Request for location authorization
	/*
	*	Below method is used to get permission from user.
	*
	*/
    func requestLocationAuthorization()
    {
        locationManager = CLLocationManager()
		locationManager?.delegate = self
		locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.requestWhenInUseAuthorization()
		 
        
    }
    // MARK:- Initial function (work handover)
	/*
	*	Below method is used to start location updation.
	*
	*/
    func startLocationTracing( completionHandler: @escaping (_ latitude: Double?, _ longitude: Double?, _ region: MKCoordinateRegion?, _ error: NSError?) -> ())
    {
		checkPermissionStatus()
        //Hold completion which will be called from delegate method
		onlyCurrentLocation=true
        locationHandler = completionHandler
		
    }
	func startUpdatingLocation()
	{
		onlyCurrentLocation=true
		checkPermissionStatus()
	}
	func stopUpdatingLocation()
	{
		locationManager?.stopUpdatingLocation()
	}
    //MARk:- Utility function
	func checkPermissionStatus()
	{
		//verify location manager initialization
		if locationManager == nil
		{
			requestLocationAuthorization()
		}
		// checking location permission
		if CLLocationManager.locationServicesEnabled()
		{
			locationManager?.startUpdatingLocation()
		}
		else
		{
			DispatchQueue.main.async {
				self.permissionNotGiven()
			}
		}
	}
	/*
	*	Below method is used to show alert.
	*
	*/
    func permissionNotGiven()
    {
       /* guard  let application=(UIApplication.shared.delegate as? AppDelegate)?.window?.rootViewController else {
            return
        }
        if Utility.locationPermissionAttemp == false {
            Utility.locationPermissionAttemp =  true
             application.showPermissionAlert(message: PermissionMessage.location.rawValue)
        }
       */
    }
    
    //MARK:- CLLocation manager delegate
	/*
	*	Below method is delegate method of CLLocationManager.
	*   This method is called when device move from one place to another place.
	*/
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        
        //call back
		if onlyCurrentLocation{
		currentLocation=location.coordinate
        locationHandler(location.coordinate.latitude, location.coordinate.longitude, region, nil)
            stopUpdatingLocation()
  		}
		else{
        locationHandler(location.coordinate.latitude, location.coordinate.longitude, region, nil)
		}
    }
	/*
	*	Below method is delegate method of CLLocationManager.
	*   This method is called when user change authorization status from settings app of device.
	*/
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        
        switch(CLLocationManager.authorizationStatus())
        {
			case .notDetermined, .restricted:
				 print("************************** location status is either (not determined) or (restricted) ******* ")
			case .denied :
				//show alert for permission
				DispatchQueue.main.async {
					self.permissionNotGiven()
				}
			case .authorizedAlways, .authorizedWhenInUse:
				print("************************** location status is either (authorizedAlways) or (authorizedWhenInUse) ******* ")
        @unknown default:
            break;
        }
    }
    
    //MARK:- Vanish singleton object
	/*
	*	Below method is used to destroy siglton object of CustomLocationManager.
	*
	*/
    func distroySinglton() {
        if CustomLocationManager.myLocation != nil {
            CustomLocationManager.myLocation = nil
        }
    }
    
    
  
    
}
 
