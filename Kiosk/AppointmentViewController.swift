//
//  AppointmentViewController.swift
//  Kiosk
//
//  Created by Krishna teja Kalluri on 12/16/16.
//  Copyright © 2016 Cleveland Clinic. All rights reserved.
//

import UIKit

class AppointmentViewController: UIViewController {

    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    var userInfo: Details!

//MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.userInfo = Details()
        self.activityIndicatorView.hidesWhenStopped = true
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func submitTapped(_ sender: UIButton)
    {
        self.activityIndicatorView.startAnimating()
        
        //Form Http Body
        let json = [ "fname":self.userInfo.firstName ,
                     "lname": self.userInfo.lastName,
                     "dob": self.userInfo.dob]
        let jsonData = try! JSONSerialization.data(withJSONObject: json, options: .prettyPrinted)
        
        //Create Request & params
        let url = URL(string: "https://httpbin.org/post")
        let request = NSMutableURLRequest(url: url!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: request as URLRequest){ data,response,error in
            guard error == nil else {
                print(error ?? "sample error")
                return
            }
            guard let data = data else {
                print("Data is empty")
                return
            }
            
            OperationQueue.main.addOperation {
                self.activityIndicatorView.stopAnimating()
                let responseJSON = try! JSONSerialization.jsonObject(with: data, options: [])
                let alert = UIAlertController(title: "Appointment Confirmed", message:"Your appointment number is B6315", preferredStyle: .alert)
                let callActionHandler = { (action:UIAlertAction!) -> Void in
                    self.dismiss(animated: true, completion: nil)
                }
                let action = UIAlertAction(title: "Ok", style: .default, handler: callActionHandler)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                print(responseJSON)
                
            }
        }
        
        task.resume()
        
    }
    
}

//MARK: - Table View Delegate Methods

extension AppointmentViewController: UITableViewDelegate, UITableViewDataSource
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TextFieldCell", for: indexPath) as! TextFieldCell
        cell.textField.delegate = self
        cell.textField.tag = indexPath.row
        
        switch indexPath.row {
        case 0:
            cell.textField.placeholder = "Enter First Name"
        case 1:
            cell.textField.placeholder = "Enter Last Name"
        case 2:
            cell.textField.placeholder = "Enter DOB"
        default: break
            
        }
        
        return cell
    }
    
}

extension AppointmentViewController: UITextFieldDelegate
{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        switch textField.tag {
        case 0:
            if let firstName = textField.text
            {
              self.userInfo.firstName = firstName
            }
        case 1:
            if let lastName = textField.text
            {
                self.userInfo.lastName = lastName
            }

        case 2:
            if let dob = textField.text
            {
                self.userInfo.dob = dob
            }
        default:
            break
        }
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.becomeFirstResponder()
    }
    
}
