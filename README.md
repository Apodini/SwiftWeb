<img align="left" alt="SwiftWeb logo" src="https://github.com/Apodini/SwiftWeb/raw/develop/Images/swiftweb.png" width=100>

### SwiftWeb
**Run Your SwiftUI App on a Swift Server. Serve Many Clients with Your SwiftUI Web App.**

---

<img align="right" alt="SwiftWeb logo" src="https://github.com/Apodini/SwiftWeb/raw/develop/Images/swiftweb-architecture.png" width=300>

With **SwiftWeb**, you can easily provide a web interface to your existing SwiftUI app. SwiftWeb renders SwiftUI code to HTML and CSS and keeps a WebSocket connection to connected Browsers. User input events are sent to your Swift server which runs your application logic. Screen updates are sent back to connected clients.

## Requirements

The SwiftWeb framework is intentionally kept independant of any HTTP / WebSocket server implementation. In order to provide a user interface over the web, you need to
1. provide the SwiftWeb HTML template (`HTMLTemplate.withContent("")`) under a URL of your desire,
2. provide the JavaScript client script (`JavaScriptClient.script`) under `/script.js` and
3. implement a WebSocket endpoint under `/websocket` on your server and connect it to a `SwiftWebServer` instance.

Have a look at the [example implementation](https://github.com/Apodini/SwiftWeb-Example) of an XCode project running an HTTP and WebSocket server together with SwiftWeb.

## Usage

Simply instantiate a server instance with a view instance: 

```let swiftWebServer = SwiftWebServer(contentView: Text("Hello World!")```

<p align="center">
<img alt="Hello World Screenshot" src="https://github.com/Apodini/SwiftWeb/raw/develop/Images/helloworld-screenshot.png" width=500>
</p>

The JavaScript client will connect to the server instance using a WebSocket connection and load the current state of the interface.

Check out the [example project](https://github.com/Apodini/SwiftWeb-Example) implementing various view components with SwiftWeb. 

## Contributing
Contributions to this projects are welcome. Please make sure to read the [contribution guidelines](https://github.com/Apodini/.github/blob/master/CONTRIBUTING.md) first.

## License
This project is licensed under the MIT License. See [License](https://github.com/Apodini/Template-Repository/blob/master/LICENSE) for more information.
