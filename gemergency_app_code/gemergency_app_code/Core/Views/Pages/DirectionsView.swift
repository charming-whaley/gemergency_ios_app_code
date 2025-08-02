import SwiftUI
import MapKit
import Combine

public struct DirectionsView: View {
    
    @AppStorage("isShowingMapScaler") private var isShowingMapScaler: Bool = false
    @AppStorage("currentUserAnnotationTint") private var currentUserAnnotationTint: String = UserAnnotationColors.yellow.rawValue
    
    @Environment(\.openURL) private var openURL
    @EnvironmentObject var llamaState: LlamaState
    
    @Namespace private var mapScope
    
    @State private var locationController: LocationController = .init()
    @State private var directionsViewModel: DirectionsViewModel = .init()
    @State private var menuPosition: CGRect = .zero
    @State private var isSheetOpen: Bool = false
    
    private var coordinates: CLLocationCoordinate2D {
        if let currentCoordinates = locationController.currentCoordinates {
            return currentCoordinates
        }
        
        return CLLocationCoordinate2D(
            latitude: 40.716856,
            longitude: -74.004128
        )
    }
    
    public var body: some View {
        Map(position: $locationController.position, scope: mapScope) {
            Marker("You", systemImage: "figure.walk", coordinate: coordinates)
                .tint(UserAnnotationColors.getColor(currentUserAnnotationTint))
            
            
            if let destination = directionsViewModel.destination {
                Marker(destination.name ?? "Destination", coordinate: destination.placemark.coordinate)
                    .tint(UserAnnotationColors.getColor(currentUserAnnotationTint))
            }
            
            if let route = directionsViewModel.route {
                MapPolyline(route.polyline)
                    .stroke(UserAnnotationColors.getColor(currentUserAnnotationTint), lineWidth: 5)
            }
        }
        .mapControlVisibility(.hidden)
        .overlay {
            if let isPermissionDenied = locationController.isPermissionDenied {
                if isPermissionDenied {
                    NoPermissionGrantedSubview()
                }
            } else {
                PermissionRuntimeErrorSubview()
            }
            
            if directionsViewModel.wrongPathCreationError {
                PathCreationRuntimeErrorSubview(wrongPathCreationError: $directionsViewModel.wrongPathCreationError)
            }
        }
        .overlay(alignment: .top) {
            MapHeaderSubview(title: directionsViewModel.destination?.name ?? "You", isSheetOpen: $isSheetOpen)
        }
        .overlay(alignment: .topLeading) {
            if isShowingMapScaler {
                MapScaleView(scope: mapScope)
                    .padding()
            }
        }
        .overlay(alignment: .bottom) {
            if let isPermissionDenied = locationController.isPermissionDenied {
                if !isPermissionDenied {
                    HStack(spacing: 10) {
                        Spacer()
                        
                        CustomGetWayButtonSubview(
                            isDirectionsMenuExpanded: $directionsViewModel.isDirectionsMenuExpanded,
                            isSettingsMenuExpanded: $directionsViewModel.isSettingsMenuExpanded
                        )
                        
                        CustomMapControlsButtonSubview(
                            isSettingsMenuExpanded: $directionsViewModel.isSettingsMenuExpanded,
                            isDirectionsMenuExpanded: $directionsViewModel.isDirectionsMenuExpanded
                        )
                    }
                    .padding(.horizontal, 25)
                    .padding(.bottom, 15)
                }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            if directionsViewModel.isDirectionsMenuExpanded {
                MenuStyleSubview {
                    DirectionsMenuControlsSubview()
                        .frame(width: 220, height: 190)
                }
                .padding(.trailing, 25 + 60 + 10)
                .padding(.bottom, 100)
                .transition(.blurReplace)
            }
            
            if directionsViewModel.isSettingsMenuExpanded {
                MenuStyleSubview {
                    SettingsMenuControlsSubview()
                        .frame(width: 220, height: 200)
                }
                .padding(.trailing, 25)
                .padding(.bottom, 100)
                .transition(.blurReplace)
            }
        }
        .onAppear(perform: locationController.requestLocation)
        .mapScope(mapScope)
        .onReceive(llamaState.routeRequest) { destinationType in
            guard let userCoordinates = locationController.currentCoordinates else {
                return
            }
            
            directionsViewModel.getDirection(to: destinationType, from: userCoordinates)
        }
        .onChange(of: directionsViewModel.route) { oldValue, newValue in
            if let newRoute = newValue {
                let rect = newRoute.polyline.boundingMapRect.union(MKMapRect(
                    origin: MKMapPoint(coordinates),
                    size: MKMapSize(width: 0, height: 0)
                ))
                
                withAnimation {
                    locationController.position = .rect(rect)
                }
            }
        }
        .sheet(isPresented: $isSheetOpen) {
            MapItemInfoSubview(
                ofDestination: directionsViewModel.destination,
                with: coordinates,
                and: directionsViewModel.pathType
            )
            .presentationDetents([.height(250)])
        }
    }
    
    @ViewBuilder private func DirectionsMenuControlsSubview() -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 15) {
                ForEach(PathType.allCases, id: \.self) { pathType in
                    Image(systemName: pathType.symbol)
                        .font(.title3)
                        .foregroundStyle(directionsViewModel.pathType == pathType ? Color.blue : Color.primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .onTapGesture {
                            withAnimation(.smooth) {
                                directionsViewModel.pathType = pathType
                            }
                        }
                }
            }
            
            Rectangle()
                .fill(.black.opacity(0.1))
                .frame(height: 1)
            
            MenuControlSubview(title: "Hospitals", systemImage: "cross.case.fill") {
                directionsViewModel.getDirection(to: .hospital, from: coordinates)
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    directionsViewModel.isDirectionsMenuExpanded = false
                }
            }
            
            MenuControlSubview(title: "Police stations", systemImage: "shield.lefthalf.filled") {
                directionsViewModel.getDirection(to: .police, from: coordinates)
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    directionsViewModel.isDirectionsMenuExpanded = false
                }
            }
            
            MenuControlSubview(title: "Fire stations", systemImage: "flame.fill") {
                directionsViewModel.getDirection(to: .fireStation, from: coordinates)
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    directionsViewModel.isDirectionsMenuExpanded = false
                }
            }
        }
        .padding(20)
    }
    
    @ViewBuilder private func SettingsMenuControlsSubview() -> some View {
        VStack(spacing: 12) {
            HStack(spacing: 15) {
                ForEach(UserAnnotationColors.allCases, id: \.self) { item in
                    Circle()
                        .fill(item.color)
                        .frame(width: 18, height: 18)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 4)
                        .onTapGesture {
                            withAnimation(.smooth) {
                                currentUserAnnotationTint = item.rawValue
                            }
                        }
                }
            }
            
            Rectangle()
                .fill(.black.opacity(0.1))
                .frame(height: 1)
            
            MenuControlSubview(title: "Find you", systemImage: "figure.walk") {
                guard let coordinates = locationController.currentCoordinates else {
                    return
                }
                
                withAnimation(.smooth) {
                    locationController.position = .region(MKCoordinateRegion(
                        center: coordinates,
                        latitudinalMeters: 1000,
                        longitudinalMeters: 1000
                    ))
                }
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    directionsViewModel.isSettingsMenuExpanded = false
                }
            }
            
            MenuControlSubview(
                title: "Map scaler",
                systemImage: "ruler.fill"
            ) {
                isShowingMapScaler.toggle()
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    directionsViewModel.isSettingsMenuExpanded = false
                }
            }
            
            MenuControlSubview(
                title: "Clear paths",
                systemImage: "trash.fill"
            ) {
                directionsViewModel.clearRoute()
                
                withAnimation(.snappy(duration: 0.3, extraBounce: 0)) {
                    directionsViewModel.isSettingsMenuExpanded = false
                }
            }
        }
        .padding(20)
    }
}

#Preview {
    DirectionsView()
}
