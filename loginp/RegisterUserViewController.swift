//
//  RegisterUserViewController.swift
//  loginp
//
//  Created by ariefdolants on 26/08/18.
//  Copyright © 2018 ariefdolants. All rights reserved.
//

import UIKit

class RegisterUserViewController: UIViewController {
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var emailAddressTextField: UITextField!
    @IBOutlet weak var PasswordTextField: UITextField!
    
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonTapped(_ sender: Any) {
        print("Cancel Button Tapped")
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        print("Sign Up Button Tapped")
        
        if (firstNameTextField.text?.isEmpty)! || (lastNameTextField.text?.isEmpty)! || (emailAddressTextField.text?.isEmpty)! || (PasswordTextField.text?.isEmpty)! || (repeatPasswordTextField.text?.isEmpty)! {

            //Display Message Error!
            displayMessage(userMessage: "Found Empty Field")
            return

        }

        if (PasswordTextField.text?.elementsEqual(repeatPasswordTextField.text!))! != true {
            //Display Message Password Field not Equal Repeat Password Field
            displayMessage(userMessage: "Password doesnt match!")
            return
        }
        
        let MyActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        MyActivityIndicator.center = view.center
        MyActivityIndicator.hidesWhenStopped = false
        MyActivityIndicator.startAnimating()
        view.addSubview(MyActivityIndicator)
        
        let myUrl = URL(string: "http://127.0.0.1:5000/api/users")
        var request = URLRequest(url: myUrl!)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let postString: [String: String] = [ "username": firstNameTextField.text!,
        "password": PasswordTextField.text! ]
        
//        let postString: [String: String] = [ "username": "johny",
//                                             "password": "pas" ]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: postString, options: .prettyPrinted)
            
        }catch let error{
            print(error.localizedDescription)
            displayMessage(userMessage: "Something wrong, please try again!")
            return
        }
        
        let task = URLSession.shared.dataTask(with: request) {
            (data: Data?, response: URLResponse?, error: Error?) in
            
            self.removeActivityIndicator(activityIndicator: MyActivityIndicator)
          
            if error != nil {
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later!")
                print("error=\(String(describing: error))")
                return
            }
            
            do {
                let json = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                if let parseJson = json {
                    
                    let userId = parseJson["username"] as? String
                    print("User Id:\(String(describing: userId!))")
                
                    if (userId?.isEmpty)! {
                        self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later!")
                        return
                    }else{
                        self.displayMessage(userMessage: "Successfully User Registered New Account")
                    }
                    
                
                }else{
                    self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later!")
                }
            } catch {
                self.removeActivityIndicator(activityIndicator: MyActivityIndicator)
                self.displayMessage(userMessage: "Could not successfully perform this request. Please try again later!")
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
