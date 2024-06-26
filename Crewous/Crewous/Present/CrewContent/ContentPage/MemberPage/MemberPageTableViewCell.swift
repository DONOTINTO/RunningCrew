//
//  MemberPageTableViewCell.swift
//  Crewous
//
//  Created by 이중엽 on 4/21/24.
//

import UIKit
import SnapKit

final class MemberPageTableViewCell: UITableViewCell {

    let profileImageView = UIImageView()
    let nickLabel = UILabel()
    let positionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        profileImageView.image = nil
        nickLabel.text = ""
        positionLabel.text = ""
    }
    
    func configureLayout() {
     
        [profileImageView, nickLabel, positionLabel].forEach {
            contentView.addSubview($0)
        }
        
        profileImageView.snp.makeConstraints {
            $0.verticalEdges.leading.equalTo(contentView).inset(7)
            $0.height.width.equalTo(30)
        }
        
        nickLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(5)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(20)
        }
        
        positionLabel.snp.makeConstraints {
            $0.verticalEdges.equalTo(contentView).inset(5)
            $0.leading.greaterThanOrEqualTo(nickLabel.snp.trailing).offset(5)
            $0.trailing.equalTo(contentView).inset(20)
        }
    }
    

    func configureView() {
        
        let image = UIImage.profile
        profileImageView.image = image
        profileImageView.layer.cornerRadius = 15
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.customGreen.cgColor
        profileImageView.layer.borderWidth = 2
        
        nickLabel.custom(title: "", color: .customBlack, fontScale: .regular, fontSize: .medium)
        positionLabel.custom(title: "", color: .customBlack, fontScale: .regular, fontSize: .medium)
    }
    
    func configure(nick: String, position: String) {
        
        nickLabel.text = nick.uppercased()
        positionLabel.text = position.uppercased()
    }

}
