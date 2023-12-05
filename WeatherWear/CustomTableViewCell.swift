import UIKit

class CustomTableViewCell: UITableViewCell {

    var weatherSingleton: WeatherSingleton? = nil
    
    static let identifier = "CustomTableViewCell"

    private let titleArray: NSArray = ["Hats", "Tops", "Bottoms", "Footwear", "OuterWear"]

    private var categoryText: UILabel = {
        let categoryText = UILabel()
        categoryText.textColor = .white
        categoryText.backgroundColor = .clear
        categoryText.font = UIFont(name: "Verdana", size: 16)
        return categoryText
    }()

    var clothesScroll: UIScrollView!

    var categoryImages: [String: [UIImageView]] = [
        "Hats": [
            UIImageView(image: UIImage(named: "cap")),
            UIImageView(image: UIImage(named: "beanie")),
            UIImageView(image: UIImage(named: "rainhat"))
        ],
        "Tops": [
            UIImageView(image: UIImage(named: "blouse")),
            UIImageView(image: UIImage(named: "longsleeve")),
            UIImageView(image: UIImage(named: "shortsleeve")),
            UIImageView(image: UIImage(named: "tanktop"))
        ],
        "Bottoms":[
            UIImageView(image: UIImage(named: "pants")),
            UIImageView(image: UIImage(named: "shorts")),
            UIImageView(image: UIImage(named: "skirt"))
        ],
        "Footwear":[
            UIImageView(image: UIImage(named: "flipflops")),
            UIImageView(image: UIImage(named: "rainboots")),
            UIImageView(image: UIImage(named: "sandals")),
            UIImageView(image: UIImage(named: "sneakers")),
            UIImageView(image: UIImage(named: "snowboots"))
        ],
        "Outerwear":[
            UIImageView(image: UIImage(named: "lightjacket")),
            UIImageView(image: UIImage(named: "raincoat")),
            UIImageView(image: UIImage(named: "sweater")),
            UIImageView(image: UIImage(named: "vest")),
            UIImageView(image: UIImage(named: "warm jacket"))
        ]
    ]
    
//    categoryImages.removeAll()
//    categoryImages = getWeather()

    func configure(category: String) {
        categoryText.text = category
        if let images = categoryImages[category] {
            var xOffset: CGFloat = 0

            for image in images {
                image.frame = CGRect(x: xOffset, y: 0, width: 100, height: 100)
                clothesScroll.addSubview(image)

                xOffset += image.frame.width + 10 // Adjust the spacing between images
            }

            // Set content size based on the total width of images
            clothesScroll.contentSize = CGSize(width: xOffset, height: 100)
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = UIColor(red: 180/255.0, green: 93/255.0, blue: 224/255.0, alpha: 1.0)
        contentView.addSubview(categoryText)

        // Adding scroll view
        clothesScroll = UIScrollView(frame: CGRect(x: 5, y: 40, width: contentView.frame.width, height: 100))
        contentView.addSubview(clothesScroll)

        // Set content size of the scroll view
        //let totalWidth = contentView.frame.width * CGFloat(titleArray.count)
        //clothesScroll.contentSize = CGSize(width: totalWidth, height: contentView.frame.height)
        
        categoryImages.removeAll()
        categoryImages = getWeather()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        //getWeather()
        categoryText.frame = CGRect(x: 5, y: 5, width: contentView.frame.size.width - 50, height: 25)
        clothesScroll.frame = CGRect(x: 5, y: 40, width: contentView.frame.size.width - 10, height: 100)
        
        //============= adding this line separates the cells but adds a white border i cant figure out how to change =============
        //contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10))
    }
    
    func getWeather() -> [String: [UIImageView]] {
        weatherSingleton = WeatherSingleton.getInstance()
        let temp = weatherSingleton?.currentWeather?.temp ?? -999
       
        if (temp == -999){
            print("Temperature not available")
        }else{
            print("Temperature: \(temp)")
        }
        
        let rain = weatherSingleton?.currentWeather?.precip ?? -999
        if (rain == -999){
            print("Rain not available")
        }else{
            print("Rain: \(rain)")
        }
        
        var imageDict: [String: [UIImageView]] = [:]
        var tempClothes:[UIImageView] = []

//***** might run into pointer issues *****
        
        //adding images for different temps
        if(temp <= 30){
            //hats
            tempClothes.append(UIImageView(image: UIImage(named: "beanie")))
            imageDict["Hats"] = tempClothes
            tempClothes.removeAll()

            //tops
            tempClothes.append( UIImageView(image: UIImage(named: "longsleeve")))
            imageDict["Tops"] = tempClothes
            tempClothes.removeAll()
            
            //bottoms
            tempClothes.append(UIImageView(image: UIImage(named: "pants")))
            imageDict["Bottoms"] = tempClothes
            tempClothes.removeAll()
            
            //footwear
            tempClothes.append(UIImageView(image: UIImage(named: "snowboots")))
            imageDict["Footwear"] = tempClothes
            tempClothes.removeAll()
            
            //outerwear
            tempClothes.append(UIImageView(image: UIImage(named: "sweater")))
            tempClothes.append(UIImageView(image: UIImage(named: "warm jacket")))
            imageDict["Outerwear"] = tempClothes
            
        }else if(temp > 30 && temp <= 65){
            //hats
            tempClothes.append(UIImageView(image: UIImage(named: "beanie")))
            tempClothes.append(UIImageView(image: UIImage(named: "cap")))
            imageDict["Hats"] = tempClothes
            tempClothes.removeAll()
            
            //tops
            tempClothes.append(UIImageView(image: UIImage(named: "longsleeve")))
            if(temp >= 60){
                tempClothes.append(UIImageView(image: UIImage(named: "shortsleeve")))
                tempClothes.append(UIImageView(image: UIImage(named: "blouse")))
            }
            imageDict["Tops"] = tempClothes
            tempClothes.removeAll()
            
            //bottoms
            tempClothes.append(UIImageView(image: UIImage(named: "pants")))
            if(temp >= 60){
                tempClothes.append(UIImageView(image: UIImage(named: "shorts")))
                tempClothes.append(UIImageView(image: UIImage(named: "skirt")))
            }
            imageDict["Bottoms"] = tempClothes
            tempClothes.removeAll()
            
            //footwear
            tempClothes.append(UIImageView(image: UIImage(named: "sneakers")))
            tempClothes.append(UIImageView(image: UIImage(named: "snowboots")))
            imageDict["Footwear"] = tempClothes
            tempClothes.removeAll()
            
            //outerwear
            tempClothes.append(UIImageView(image: UIImage(named: "sweater")))
            tempClothes.append(UIImageView(image: UIImage(named: "warmjacket")))
            tempClothes.append(UIImageView(image: UIImage(named: "lightjacket")))
            imageDict["Outerwear"] = tempClothes
            tempClothes.removeAll()
            
        }else{
            //hats
            tempClothes.append(UIImageView(image: UIImage(named: "cap")))
            imageDict["Hats"] = tempClothes
            tempClothes.removeAll()
            
            //tops
            tempClothes.append(UIImageView(image: UIImage(named: "shorts")))
            tempClothes.append(UIImageView(image: UIImage(named: "skirt")))
            tempClothes.append(UIImageView(image: UIImage(named: "tanktop")))
            imageDict["Tops"] = tempClothes
            tempClothes.removeAll()
            
            //bottoms
            tempClothes.append(UIImageView(image: UIImage(named: "shorts")))
            tempClothes.append(UIImageView(image: UIImage(named: "skirt")))
            imageDict["Bottoms"] = tempClothes
            tempClothes.removeAll()
            
            //footwear
            tempClothes.append(UIImageView(image: UIImage(named: "sandals")))
            tempClothes.append(UIImageView(image: UIImage(named: "flipflops")))
            tempClothes.append(UIImageView(image: UIImage(named: "sneakers")))
            imageDict["Footwear"] = tempClothes
            tempClothes.removeAll()
            
            //outerwear
            tempClothes.append(UIImageView(image: UIImage(named: "vest")))
            imageDict["Outerwear"] = tempClothes
            tempClothes.removeAll()
        }
        
        //adding images for different amount of rain
        if(rain >= 1.0){
            imageDict["Hats"]?.append(UIImageView(image: UIImage(named: "rainhat")))
            imageDict["Outerwear"]?.append(UIImageView(image: UIImage(named: "raincoat")))
        }
        
        //print(imageDict)
        return imageDict
    }
}
