//
//  ProductViewVC.swift
//  MedHacks
//
//  Created by Neil Johnson on 9/9/17.
//  Copyright © 2017 Neil Johnson. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ProductViewVC: UIViewController {

    @IBOutlet weak var qtyLabel: UILabel!
    @IBOutlet weak var subButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    
    var json : JSON = []
    var newAmt = ""
    var resolvedQR = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(json)
        
        guard let innerArray = json.array?.first else { return }
        
        let title = innerArray["name"].string!
        titleLabel.text = title
        
        let quantity = innerArray["qty"].string!
        qtyLabel.text = quantity
        
        resolvedQR = innerArray["qrcode"].string!
        
     //   json["price"].double

        // Do any additional setup after loading the view.
    }

    func URLRequest(with URL:String, query:String, completion: @escaping (JSON?) -> Void) {
        
        Alamofire.request("http://theblakebeat.com/chgItem.php?qr=" + query).responseJSON { snapshot in
            
            guard let value = snapshot.result.value else { completion(nil); return }
            
            let json = JSON(value)
            
            completion(json)
            
        }
        
    }
    
    @IBAction func subPressed(_ sender: Any) {
        let currentVal = Int(qtyLabel.text!)
        qtyLabel.text  = String(currentVal! - 1)
    }

    @IBAction func addPressed(_ sender: Any) {
        let currentVal = Int(qtyLabel.text!)
        qtyLabel.text  = String(currentVal! + 1)
    }
    @IBAction func submitQuery(_ sender: Any) {
        newAmt = "&qty=" + qtyLabel.text!
        
        let queryToUse = resolvedQR + "&qty=" + newAmt
        
        URLRequest(with: "http://theblakebeat.com/getItem.php?qr=", query: queryToUse, completion: { json in
            guard json != nil else { return }
            
        })
        performSegue(withIdentifier: "unwindSegueToVC1", sender: self)

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
