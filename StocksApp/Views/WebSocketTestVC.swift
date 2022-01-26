//
//  WebSocketTestVC.swift
//  StocksApp
//
//  Created by Blaike Bradford on 1/26/22.
//

import UIKit

class WebSocketTestVC: UIViewController, URLSessionWebSocketDelegate
{
    private var websocket: URLSessionWebSocketTask?
    
    private let closeButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .white
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.black, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .blue
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let url = URL(string: "wss://demo.piesocket.com/v3/channel_1?api_key=oCdCMcMPQpbvNjUIzqtvF1d2X2okWpDQj4AwARJuAgtjhzKxVEjQU6IdCjwm&notify_self")!
        websocket = session.webSocketTask(with: url)
        websocket?.resume()
        
        closeButton.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        view.addSubview(closeButton)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        closeButton.center = view.center

        
    }
    
    @objc func close() {
        websocket?.cancel(with: .goingAway, reason: "Demo ended".data(using: .utf8))
    }
    
    
    // establish connection to see if connection still active
    func ping() {
        websocket?.sendPing(pongReceiveHandler: {error in
                if let error = error{
            print("Ping Error -> : \(error)")
            }
        })
    }

    func send() {
        DispatchQueue.global().asyncAfter(deadline: .now()+1)
        {
            self.send()
            self.websocket?.send(.string("Send new message: \(Int.random(in: 0...1000))"), completionHandler: { error in
                if let error = error {
                    print("Send error: \(error)")
                }
            })
        }

    }
    
    func receive() {
        websocket?.receive(completionHandler: { [weak self] result in
            switch result {
            case .success(let message):
                switch message {
                case .data(let data):
                    print("Got data: \(data)")
                case .string(let message):
                    print("Got string: \(message)")
                @unknown default:
                    break
                }
            case .failure(let error):
                print("Received error : \(error)")
            }
            self?.receive()
        })
        
        
    }


    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print("Connection was opened...")
        ping()
        receive()
        send()
    }
    
    func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("Closed connection to socket")
    }

}
