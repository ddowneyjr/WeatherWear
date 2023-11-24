//
//  CustomTableViewCell.swift
//  ImageTest
//
//  Created by Cassandra Davidson on 11/21/23.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    static let identifier = "CustomTableViewCell"
    
    
//    private let _switch : UISwitch = {
//        let _switch = UISwitch()
//        _switch.isOn = true
//
//        return _switch
//    }()
    
    private let titleArray: NSArray = ["Hats","Tops","Bottoms", "Footwear", "OuterWear"]
    
    private var categoryText : UILabel = {
        let categoryText = UILabel()
        categoryText.textColor = .white
        categoryText.backgroundColor = .clear
        categoryText.font = UIFont(name: "Verdana", size: 16)
        return categoryText
    }()
    
    func configure(category: String) {
        categoryText.text = category
    }
    
    var clothesScroll: UIScrollView!
    var images = [UIImageView]()


    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
                
        contentView.backgroundColor = UIColor(red: 180/255.0, green: 93/255.0, blue: 224/255.0, alpha: 1.0)
        contentView.addSubview(categoryText)
        
        //adding scroll view
        clothesScroll = UIScrollView(frame: CGRect(x: 5, y: 40, width: contentView.frame.width, height: 200))
        //clothesScroll.backgroundColor = .systemTeal
        //clothesScroll.showsHorizontalScrollIndicator = false
        contentView.addSubview(clothesScroll)
        
        
        // Uncomment the loop for adding multiple images
        for i in 0..<titleArray.count {
            let imageName = "jacket"
            let image = UIImageView(image: UIImage(named: imageName))
            let xPosition = CGFloat(i) * 110
            image.frame = CGRect(x: xPosition, y: 0, width: 100, height: 100)
            image.contentMode = .scaleToFill
            clothesScroll.addSubview(image)
        }

        // Set content size of the scroll view
        let totalWidth = contentView.frame.width * CGFloat(titleArray.count)
        clothesScroll.contentSize = CGSize(width: totalWidth, height: contentView.frame.height)

    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //called when view wants to know how to layout all subviews
    override func layoutSubviews() {
        super.layoutSubviews()
        
        //_switch.frame = CGRect(x: 5, y: 125, width: 100, height: contentView.frame.size.height )
        
        categoryText.frame = CGRect(x: 5, y: 5, width: contentView.frame.size.width - 50, height: 25)
        clothesScroll.frame = CGRect(x: 5, y: 40, width: contentView.frame.size.width - 10, height: 125)

    }
    
}

//extension UIScrollView{
//    func scrollToView(view:UIView, animated: Bool) {
//        if let origin = view.superview {
//            // Get the Y position of your child view
//            let childStartPoint = origin.convert(view.frame.origin, to: self)
//            // Scroll to a rectangle starting at the Y of your subview, with a height of the scrollview
//            self.scrollRectToVisible(CGRect(x:0, y:childStartPoint.y,width: 1,height: self.frame.height), animated: animated)
//        }
//    }
//}
