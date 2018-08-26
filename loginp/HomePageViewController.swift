//
//  HomePageViewController.swift
//  loginp
//
//  Created by ariefdolants on 26/08/18.
//  Copyright © 2018 ariefdolants. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
    
    @IBOutlet weak var userFullNameLabel: UILabel!
    
    @IBAction func signOutButtonTapped(_ sender: Any) {
        print("Sign Out Button Tapped")
    }
    
    @IBAction func loadMemberProfileButtonTapped(_ sender: Any) {
        print("Member Profile Button Tapped")
    }
   
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
