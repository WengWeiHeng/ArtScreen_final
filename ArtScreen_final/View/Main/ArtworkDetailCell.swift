//
//  ArtworkDetailCell.swift
//  ArtScreen_final
//
//  Created by Heng on 2020/11/12.
//

import UIKit

class ArtworkDetailCell: UITableViewCell {
    
    //MARK: - Properties
    var artworkNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .mainBackground
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris fermentum nulla sit amet iaculis. "
        
        return label
    }()
    
    var introductionLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .mainBackground
        label.numberOfLines = 0
        label.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris fermentum nulla sit amet elementum iaculis. Donec ac nisi dictum, hendrerit quam ut, consequat neque. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Donec hendrerit facilisis tortor nec pretium. Mauris eu fringilla orci. Cras in enim lorem. Sed nec libero rhoncus, lacinia erat nec, ultricies risus. Mauris a faucibus neque. Suspendisse urna purus, maximus sit amet urna ac, laoreet varius orci. Vestibulum ornare ex ut enim gravida, ut finibus odio lobortis. Nulla sagittis ac leo ut feugiat. In eu magna mi. Duis ultrices pulvinar sodales. Donec imperdiet fermentum tortor quis ornare. Donec vel libero in odio sollicitudin pretium."
        
        return label
    }()
    
    //MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .mainDarkGray
        selectionStyle = .none
        
        addSubview(artworkNameLabel)
        artworkNameLabel.anchor(top: topAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 12, paddingLeft: 12, paddingRight: 12)
        
        addSubview(introductionLabel)
        introductionLabel.anchor(top: artworkNameLabel.bottomAnchor, left: artworkNameLabel.leftAnchor, bottom: bottomAnchor, right: artworkNameLabel.rightAnchor, paddingTop: 20, paddingBottom: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

