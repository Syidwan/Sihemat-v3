import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapConfig {
  // Map Provider Selection
  static const String MAP_PROVIDER = 'google'; // 'openstreetmap' or 'google'
  
  // =========================================
  // GOOGLE MAPS CONFIGURATION
  // =========================================
  
  /// Google Maps API Key (set in AndroidManifest.xml & Info.plist)
  static const String GOOGLE_MAPS_API_KEY_ANDROID = 'YOUR_ANDROID_API_KEY';
  static const String GOOGLE_MAPS_API_KEY_IOS = 'YOUR_IOS_API_KEY';
  
  /// Google Maps Default Map Type
  static const MapType GOOGLE_MAP_TYPE = MapType.normal;
  
  /// Google Maps Style - Optimized: Hide POI, Keep Road Names
  /// This style removes points of interest, business names, and transit
  /// while keeping road labels for navigation
  static const String GOOGLE_MAP_STYLE = '''
  [
    {
      "featureType": "poi",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "poi.business",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "poi.park",
      "elementType": "labels.text",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "transit",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "transit.station",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "landscape.man_made",
      "elementType": "labels",
      "stylers": [{"visibility": "off"}]
    },
    {
      "featureType": "road",
      "elementType": "labels",
      "stylers": [{"visibility": "on"}]
    },
    {
      "featureType": "road.highway",
      "elementType": "labels",
      "stylers": [{"visibility": "on"}]
    },
    {
      "featureType": "road.arterial",
      "elementType": "labels",
      "stylers": [{"visibility": "on"}]
    }
  ]
  ''';
  
  /// Google Maps UI Settings - Optimized for Performance
  static const bool GOOGLE_MY_LOCATION_ENABLED = true;
  static const bool GOOGLE_MY_LOCATION_BUTTON_ENABLED = false;
  static const bool GOOGLE_ZOOM_CONTROLS_ENABLED = false;
  static const bool GOOGLE_ZOOM_GESTURES_ENABLED = true;
  static const bool GOOGLE_SCROLL_GESTURES_ENABLED = true;
  static const bool GOOGLE_TILT_GESTURES_ENABLED = false; // Disabled for performance
  static const bool GOOGLE_ROTATE_GESTURES_ENABLED = false; // Disabled for performance
  static const bool GOOGLE_COMPASS_ENABLED = false;
  static const bool GOOGLE_MAP_TOOLBAR_ENABLED = false;
  static const bool GOOGLE_BUILDINGS_ENABLED = false; // Disabled for performance
  static const bool GOOGLE_TRAFFIC_ENABLED = false;
  static const bool GOOGLE_INDOOR_ENABLED = false; // Disabled for performance
  
  /// Google Maps Camera Settings
  static const double GOOGLE_CAMERA_TILT = 0.0; // Flat view for better performance
  static const double GOOGLE_CAMERA_BEARING = 0.0;
  
  // =========================================
  // OPENSTREETMAP CONFIGURATION
  // =========================================
  
  /// Tile URL for OpenStreetMap
  static const String OSM_TILE_URL = 'https://tile.openstreetmap.org/{z}/{x}/{y}.png';
  
  /// User Agent for OSM requests
  static const String OSM_USER_AGENT = 'com.example.sihemat';
  
  // =========================================
  // COMMON MAP SETTINGS
  // =========================================
  
  /// Default zoom level when map loads
  static const double DEFAULT_ZOOM = 15.0;
  
  /// Minimum zoom level allowed
  static const double MIN_ZOOM = 10.0; // Increased for performance
  
  /// Maximum zoom level allowed
  static const double MAX_ZOOM = 18.0; // Reduced for performance
  
  /// Default center point (Bandung, Indonesia)
  static const double DEFAULT_CENTER_LAT = -6.9175;
  static const double DEFAULT_CENTER_LNG = 107.6191;
  
  // =========================================
  // MARKER CONFIGURATION
  // =========================================
  
  /// Size of selected marker
  static const double SELECTED_MARKER_SIZE = 90.0;
  
  /// Size of normal marker
  static const double NORMAL_MARKER_SIZE = 60.0;
  
  /// Icon size for selected marker
  static const double SELECTED_ICON_SIZE = 26.0;
  
  /// Icon size for normal marker
  static const double NORMAL_ICON_SIZE = 18.0;
  
  /// Marker anchor point
  static const double MARKER_ANCHOR_X = 0.5;
  static const double MARKER_ANCHOR_Y = 0.5;
  
  /// Google Maps marker settings
  static const double GOOGLE_MARKER_ALPHA = 1.0;
  static const bool GOOGLE_MARKER_DRAGGABLE = false;
  static const bool GOOGLE_MARKER_FLAT = true; // Flat for better performance
  static const double GOOGLE_MARKER_ROTATION = 0.0;
  static const bool GOOGLE_MARKER_VISIBLE = true;
  static const double GOOGLE_MARKER_Z_INDEX = 0.0;
  
  // =========================================
  // BOTTOM SHEET CONFIGURATION
  // =========================================
  
  static const double DEFAULT_SHEET_HEIGHT = 250.0;
  static const double MIN_SHEET_HEIGHT = 150.0;
  static const double MAX_SHEET_HEIGHT = 500.0;
  static const double EXPAND_THRESHOLD = 300.0;
  static const double SNAP_VELOCITY_THRESHOLD = 300.0;
  static const double SHEET_BORDER_RADIUS = 20.0;
  
  // =========================================
  // ANIMATION CONFIGURATION
  // =========================================
  
  /// Reduced animation durations for better performance
  static const Duration MARKER_ANIMATION_DURATION = Duration(milliseconds: 150);
  static const Duration SHEET_ANIMATION_DURATION = Duration(milliseconds: 200);
  static const Duration CAMERA_ANIMATION_DURATION = Duration(milliseconds: 400);
  
  // =========================================
  // PERFORMANCE CONFIGURATION
  // =========================================
  
  /// Enable lite mode for better performance (Google Maps only)
  static const bool GOOGLE_LITE_MODE = false; // Set true for very low-end devices
  
  /// Marker clustering
  static const bool ENABLE_MARKER_CLUSTERING = false;
  static const int CLUSTERING_THRESHOLD = 20;
  
  /// Tile caching
  static const bool ENABLE_TILE_CACHING = true;
  static const int MAX_CACHE_SIZE_MB = 50; // Reduced cache size
  
  /// Frame rate limit for animations
  static const int TARGET_FPS = 30; // Lower FPS for better performance
  
  /// Render pixel ratio (lower = better performance, less quality)
  static const double RENDER_PIXEL_RATIO = 2.0; // 3.0 = high quality, 1.0 = low quality
  
  // =========================================
  // FEATURE FLAGS
  // =========================================
  
  static const bool SHOW_VEHICLE_ROUTE = false;
  static const bool SHOW_TRAFFIC_LAYER = false;
  static const bool ENABLE_LIVE_TRACKING = true;
  static const int LIVE_TRACKING_INTERVAL = 10; // Increased interval to reduce load
  static const bool SHOW_GEOFENCES = false;
  
  /// Debounce map movements to reduce callbacks
  static const bool ENABLE_CAMERA_DEBOUNCE = true;
  static const Duration CAMERA_DEBOUNCE_DURATION = Duration(milliseconds: 300);
  
  // =========================================
  // HELPER METHODS
  // =========================================
  
  /// Get map provider name
  static String get mapProviderName {
    return MAP_PROVIDER == 'google' ? 'Google Maps' : 'OpenStreetMap';
  }
  
  /// Check if using Google Maps
  static bool get isUsingGoogleMaps {
    return MAP_PROVIDER == 'google';
  }
  
  /// Check if using OpenStreetMap
  static bool get isUsingOpenStreetMap {
    return MAP_PROVIDER == 'openstreetmap';
  }
  
  /// Get optimized map options for Google Maps
  static Map<String, dynamic> getOptimizedGoogleMapOptions() {
    return {
      'myLocationEnabled': GOOGLE_MY_LOCATION_ENABLED,
      'myLocationButtonEnabled': GOOGLE_MY_LOCATION_BUTTON_ENABLED,
      'zoomControlsEnabled': GOOGLE_ZOOM_CONTROLS_ENABLED,
      'zoomGesturesEnabled': GOOGLE_ZOOM_GESTURES_ENABLED,
      'scrollGesturesEnabled': GOOGLE_SCROLL_GESTURES_ENABLED,
      'tiltGesturesEnabled': GOOGLE_TILT_GESTURES_ENABLED,
      'rotateGesturesEnabled': GOOGLE_ROTATE_GESTURES_ENABLED,
      'compassEnabled': GOOGLE_COMPASS_ENABLED,
      'mapToolbarEnabled': GOOGLE_MAP_TOOLBAR_ENABLED,
      'buildingsEnabled': GOOGLE_BUILDINGS_ENABLED,
      'trafficEnabled': GOOGLE_TRAFFIC_ENABLED,
      'indoorViewEnabled': GOOGLE_INDOOR_ENABLED,
      'liteModeEnabled': GOOGLE_LITE_MODE,
    };
  }
}