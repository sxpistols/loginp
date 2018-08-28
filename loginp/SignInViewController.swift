//
//  SignInViewController.swift
//  loginp
//
//  Created by ariefdolants on 26/08/18.
//  Copyright © 2018 ariefdolants. All rights reserved.
//

import UIKit

class SignInViewController: UIViewController {
    
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInButton(_ sender: Any) {
        
        print("Sign In Button Tapped")
        
        let username = userNameTextField.text
        let password = userPasswordTextField.text
        
        if (username?.isEmpty)! || (password?.isEmpty)! {
            
            displayMessage(userMessage: "One of required fields is missing")
            print("username \(String(describing: username)) or password \(String(describing: password)) is empty" )
            return
        }
        
        let MyActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        MyActivityIndicator.center = view.center
        MyActivityIndicator.hidesWhenStopped = false
        MyActivityIndicator.startAnimating()
        view.addSubview(MyActivityIndicator)
        
        
        let myUrl = URL(string: "http://localhost:5000/api/token")
        var request = URLRequest(url: myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        //request.addValue("--user ariefdolants:password123", forHTTPHeaderField: "Authorization")
        let params:[String: Any] = [
            
            "ariefdolants:password123":""
        ]
        //request.addValue("ariefdolants:password123", forHTTPHeaderField: "--user")
        
        
        
        
//        let postString: [String: String] = [ "username" : username!, "password" : password!]
//
//        let loginString = NSString(format: "%@:%@", "ariefdolants", "password123")
//        print("login string: \(loginString)")
//        let loginData: NSData = loginString.data(using: String.Encoding.utf8.rawValue)! as NSData
//        let base64LoginString = loginData.base64EncodedString(options: NSData.Base64EncodingOptions())
//        request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
//
        
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)

        }catch let error{
            print(error.localizedDescription)
            displayMessage(userMessage: "Something wrong, please try again!")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in

            self.removeActivityIndicator(activityIndicator: MyActivityIndicator)

            if error != nil {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later! 1")
                print("error=\(String(describing: error))")
                return
            }


            let responseString = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
            print("responseString = \(String(describing: responseString))")

        
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary

                if let parseJson = json {

                    let duration = parseJson["duration"] as? String
                    let token = parseJson["token"] as? String
                    print("User Token:\(String(describing: token!))")

                    if (token?.isEmpty)! {
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later! 2")
                        return
                    }else{
                        self.displayMessage(userMessage: "Successfully User Registered Login")
                    }


                }else{
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later! 3")
                }
            } catch {
                self.removeActivityIndicator(activityIndicator: MyActivityIndicator)
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later! 4")
                print(error)
            }
            
        }
        task.resume()
        
        
    }
    
    func removeActivityIndicator(activityIndicator: UIActivityIndicatorView){
        
        DispatchQueue.main.async {
            activityIndicator.stopAnimating()
            activityIndicator.removeFromSuperview()
        }
    }
    
    @IBAction func registerNewAccountButton(_ sender: Any) {
        print("Register Account Button Tapped")
        
        let RegisterViewController = self.storyboard?.instantiateViewController(withIdentifier: "RegisterUserViewController") as! RegisterUserViewController
        
        self.present(RegisterViewController, animated: true)
        
    }
    func displayMessage(userMessage:String) -> Void {
        DispatchQueue.main.async {
            let alertController = UIAlertController(title: "Warning!", message: userMessage, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default ){
                (action:UIAlertAction!) in
                
                //Trigger when OK button click!
                print("OK Button Tapped")
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)
                }
            }
            alertController.addAction(OKAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

}
