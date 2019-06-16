//
//  ReflectionTableViewCell.swift
//  Onigiri
//
//  Created by Vale-chan on 16.06.19.
//  Copyright © 2019 Vale-chan. All rights reserved.
//

import UIKit

class ReflectionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var shadowView: UIView!
   // @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var previewLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        
        shadowView.layer.shadowColor =  UIColor(red:0, green:0, blue:0, alpha: 1.0).cgColor
        shadowView.layer.shadowOffset = CGSize(width: 0.75, height: 0.75)
        shadowView.layer.shadowRadius = 1.5
        shadowView.layer.shadowOpacity = 0.2
        shadowView.layer.cornerRadius = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(reflection: Reflection) {
        self.previewLabel.text = reflection.answer1
    }

}
