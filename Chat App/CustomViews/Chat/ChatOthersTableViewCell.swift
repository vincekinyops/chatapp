//
//  ChatOthersTableViewCell.swift
//  Chat App
//
//  Created by Lanex-Mark on 3/4/21.
//

import UIKit

class ChatOthersTableViewCell: UITableViewCell {
    @IBOutlet weak var bubblePoint: UIView!
    @IBOutlet weak var textLbl: CustomLabel!
    @IBOutlet weak var userLbl: UILabel!
    @IBOutlet weak var dateLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        bubblePoint.makeLeftTriangle()
        dateLbl.isHidden = true
        textLbl.isUserInteractionEnabled = true
        
        // NOTE: uncomment to enable
        onTapText()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func onTapText() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(showDate))
        tap.numberOfTapsRequired = 1
        
        // NOTE: important to set to false so gestures wont overlap
        tap.cancelsTouchesInView = false
        textLbl.addGestureRecognizer(tap)
    }
    
    @objc fileprivate func showDate() {
        dateLbl.isHidden = self.isSelected
    }
    
}
