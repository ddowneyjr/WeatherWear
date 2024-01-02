# WeatherWear

WeatherWear is a Swift application designed to simplify your morning routine by providing weather updates, clothing recommendations based on the weather, and an alarm to help you start your day.

## Features

1. **Weather**: The app fetches the weather data for the user's current location.
2. **Clothes Recommender**: Based on the weather conditions, the app recommends appropriate clothing to the user.
3. **Alarm**: The app includes an alarm feature to wake you up in the morning.

## How to Use

1. Clone the repository to your local machine.
2. Open the project in Xcode.
3. Run the app in the simulator or on a physical device.

## Code Overview

The app is divided into three main parts:

1. **Weather**: This part utilizes the `LocationManager` class to get the user's current location. It then fetches the weather data for that location by making an API call. The fetched weather data is stored in a `Weather` struct.
2. **Clothes Recommender**: This part uses the weather data obtained from the `Weather` struct to recommend appropriate clothing to the user.
3. **Alarm**: This part includes an alarm feature that the user can set to wake up in the morning.

## Dependencies

The app uses the CoreLocation framework to get the user's current location and URLSession to make API calls.
