# VoIP Calling App

A prototype iOS VoIP application built with Swift and Acrobits LibSoftphone SDK as part of the Acrobits technical assignment.

## Features

- SIP registration using LibSoftphone SDK

- SIP registration status

- Outgoing calls

- Phone number validation

- Call information and duration

- Hang up

- Local user display name configuration

## Requirements

- macOS

- Xcode

- iOS device or simulator

- Acrobits LibSoftphone SDK

## Running the application

1. Clone the repository.

2. Open the Xcode project/workspace.

3. Select an iOS device or simulator.

4. Build and run the application.

For testing outgoing calls, the assignment provides the following test extensions:

- `5000` – IVR

- `9196` – echo test

## Architecture

The application uses a simple separation between the UI and the LibSoftphone SDK.

The main responsibilities are separated into:

- SwiftUI views – presentation and user interaction

- Application logic – handling UI state and user actions

- SIP service – communication with the LibSoftphone SDK

- Configuration – SIP and application configuration

The architecture was intentionally kept relatively lightweight due to the time constraints of the assignment. A more extensive Clean Architecture setup would be reasonable for a production application.

## Testing

With additional development time, the views would be backed by dedicated ViewModels and the SIP service would be abstracted behind a protocol. This would allow the LibSoftphone implementation to be replaced by mock implementations and enable more comprehensive unit testing.

## Trade-offs and possible improvements

The recommended time for the assignment was five hours. During this time I focused primarily on implementing the core requirements and getting the complete outgoing call flow working.

Possible areas for further improvement include:

- Dedicated ViewModels for the individual screens

- Further separation and abstraction of the SDK integration

- Unit test coverage

- Additional error handling

- Improved UI adaptation for iPhone landscape orientation

- Further UI and code refinements

- Optional mute, hold and audio route controls

## Notes

The application uses the LibSoftphone SDK and configuration provided specifically for this assignment.
