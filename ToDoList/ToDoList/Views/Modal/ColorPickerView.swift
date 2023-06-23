import UIKit

class ColorPickerView: UIView {
    
    let colorPreview = UIView()
    let hexLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setup()
    }
    
    func setup() {
        setupColorPicker()
        setupColorPreview()
        setupHexLabel()
    }
    
    func setupColorPicker() {
        self.translatesAutoresizingMaskIntoConstraints = false

        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.red.cgColor,
            UIColor.yellow.cgColor,
            UIColor.green.cgColor,
            UIColor.cyan.cgColor,
            UIColor.blue.cgColor,
            UIColor.magenta.cgColor,
            UIColor.red.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 0)
        gradientLayer.type = .conic
        gradientLayer.frame = self.bounds
        self.layer.addSublayer(gradientLayer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        self.addGestureRecognizer(panGestureRecognizer)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleGesture(_:)))
        self.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func setupColorPreview() {
        colorPreview.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(colorPreview)
        
        NSLayoutConstraint.activate([
            colorPreview.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            colorPreview.topAnchor.constraint(equalTo: self.bottomAnchor, constant: 20),
            colorPreview.heightAnchor.constraint(equalToConstant: 50),
            colorPreview.widthAnchor.constraint(equalToConstant: 50)
        ])
        
        colorPreview.layer.cornerRadius = 25
    }
    
    func setupHexLabel() {
        hexLabel.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(hexLabel)
        
        NSLayoutConstraint.activate([
            hexLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            hexLabel.topAnchor.constraint(equalTo: colorPreview.bottomAnchor, constant: 20)
        ])
    }
    
    @objc func handleGesture(_ recognizer: UIGestureRecognizer) {
        let location = recognizer.location(in: self)
        
        guard self.bounds.contains(location) else { return }
        
        let color = self.getPixelColor(at: location)
        colorPreview.backgroundColor = color
        hexLabel.text = color.toHex()
    }
}

extension UIView {
    func getPixelColor(at location: CGPoint) -> UIColor {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        let context = CGContext(data: pixel, width: 1, height: 1, bitsPerComponent: 8, bytesPerRow: 4, space: colorSpace, bitmapInfo: bitmapInfo.rawValue)
        
        context?.translateBy(x: -location.x, y: -location.y)
        layer.render(in: context!)
        
        let color: UIColor = UIColor(red: CGFloat(pixel[0]) / 255.0, green: CGFloat(pixel[1]) / 255.0, blue: CGFloat(pixel[2]) / 255.0, alpha: CGFloat(pixel[3]) / 255.0)
        
        pixel.deallocate()
        
        return color
    }
}

extension UIColor {
    func toHex() -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        
        return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
    }
}
