<h1>📂 iOS part structure</h1>

```
gemergency_app_code/
├── Core/
    ├── Views/
        ├── Components/
            ├── ChatView components/
                ├── ChatAudioRecognitionErrorSubview.swift
                ├── ChatBackgroundView.swift
                ├── ChatBubbleSubview.swift
                ├── ChatHeaderSubview.swift
                └── ChatInputFieldSubview.swift
            ├── DirectionsView components/
                ├── CustomGetWayButtonSubview.swift
                ├── CustomMapControlsButtonSubview.swift
                ├── MapHeaderSubview.swift
                ├── MapItemInfoSubview.swift
                ├── MenuControlSubview.swift
                ├── MenuStyleSubview.swift
                ├── NoPermissionGrantedSubview.swift
                ├── PathCreationRuntimeErrorSubview.swift
                ├── PermissionRuntimeErrorSubview.swift
                └── SquishyButtonStyle.swift
            └── RootView components/
                ├── CustomNavigationTabBarSubview.swift
                ├── CustomNotificationSubview.swift
                └── CustomOnBoardingSubview.swift
        └── Pages/
            ├── ChatView.swift
            ├── DirectionsView.swift
            └── RootView.swift
    ├── Models/
        ├── CustomNotification.swift
        ├── DestinationPlaces.swift
        ├── Message.swift
        ├── NavigationTabs.swift
        ├── PathType.swift
        └── UserAnnotationColors.swift
    ├── ViewModels/
        └── DirectionsViewModel.swift
    └── Controllers/
        ├── HapticsController.swift
        ├── LibLlama.swift
        ├── LlamaState.swift
        ├── LocationController.swift
        └── SpeechRecognitionController.swift
└── Resources/
    ├── a.mp4
    ├── Assets.xcassets
    ├── default.metallib
    ├── libllama.a
    ├── gemergency_app_codeApp.swift
    └── Extensions/
        ├── String+Extensions.swift
        ├── UIApplication+Extensions.swift
        └── View+Extensions.swift
```
