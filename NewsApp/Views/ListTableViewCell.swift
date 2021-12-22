//
//  ListTableViewCell.swift
//  NewsApp
//
//  Created by Wahid Hidayat on 18/12/21.
//

import UIKit
import Kingfisher

class ListTableViewCell: UITableViewCell {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var publishedDateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    
    static let identifier = "ListTableViewCell"
    static let nib = UINib(nibName: identifier, bundle: nil)

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImage.layer.cornerRadius = 10
        thumbnailImage.layer.masksToBounds = true
    }
    
    func configure(with news: News) {
        thumbnailImage.kf.setImage(with: URL(string: news.imageUrl), options: [.transition(.fade(0.2))])
        publishedDateLabel.text = news.publishedAt.toDate()?.timeAgoDisplay()
        titleLabel.text = news.title
        sourceLabel.text = news.source.name
    }
}
