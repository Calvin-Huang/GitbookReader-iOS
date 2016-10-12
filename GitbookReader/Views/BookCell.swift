//
//  BookCell.swift
//  GitbookReader
//
//  Created by Calvin on 10/13/16.
//  Copyright © 2016 CapsLock. All rights reserved.
//

import UIKit

import RxSwift
import RxCocoa

class BookCell: UITableViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    
    var disposeBag: DisposeBag?
    
    var viewModel: BookViewModel! {
        didSet {
            titleLabel.text = viewModel.book.title
            descriptionLabel.text = viewModel.book.summary
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func prepareForReuse() {
        disposeBag = nil
    }
}
