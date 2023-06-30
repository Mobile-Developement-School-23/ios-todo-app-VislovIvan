import UIKit

// UI 'ColorPicker' доработаю, сделаю toggle как у календаря
class ColorPickerViewController: UIViewController {
    
    private let colorPicker = UIView()
    private let colorPreview = UIView()
    private let hexLabel = UILabel()
    private let alphaSlider = UISlider()
    
    var colorDidChange: ((UIColor) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupColorPicker()
        setupColorPreview()
        setupHexLabel()
        setupAlphaSlider()
    }
    
    private func setupColorPicker() {
        colorPicker.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorPicker)
        
        NSLayoutConstraint.activate([
            colorPicker.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorPicker.topAnchor.constraint(equalTo: view.topAnchor, constant: 16),
            colorPicker.heightAnchor.constraint(equalToConstant: 150),
            colorPicker.widthAnchor.constraint(equalToConstant: 150)
        ])
        
        colorPicker.layer.cornerRadius = 75
        colorPicker.clipsToBounds = true
        
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
        gradientLayer.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        colorPicker.layer.addSublayer(gradientLayer)
        
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        colorPicker.addGestureRecognizer(panGestureRecognizer)
    }
    
    private func setupColorPreview() {
        colorPreview.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(colorPreview)
        
        NSLayoutConstraint.activate([
            colorPreview.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            colorPreview.topAnchor.constraint(equalTo: colorPicker.bottomAnchor, constant: 20),
            colorPreview.heightAnchor.constraint(equalToConstant: 30),
            colorPreview.widthAnchor.constraint(equalToConstant: 30)
        ])
        
        colorPreview.layer.cornerRadius = 15
    }
    
    private func setupHexLabel() {
        hexLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(hexLabel)
        
        NSLayoutConstraint.activate([
            hexLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            hexLabel.topAnchor.constraint(equalTo: colorPreview.bottomAnchor, constant: 10)
        ])
    }
    
    @objc private func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let location = recognizer.location(in: colorPicker)
            
        guard colorPicker.bounds.contains(location),
            let color = colorPicker.getPixelColor(at: location) else { return }
            
        colorPreview.backgroundColor = color
        hexLabel.text = color.toHex()
            
        colorDidChange?(color)
    }
    
    private func setupAlphaSlider() {
        alphaSlider.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(alphaSlider)
        
        alphaSlider.minimumValue = 0
        alphaSlider.maximumValue = 1
        alphaSlider.value = 1
        
        NSLayoutConstraint.activate([
            alphaSlider.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alphaSlider.topAnchor.constraint(equalTo: hexLabel.bottomAnchor, constant: 20),
            alphaSlider.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8)
        ])
        
        alphaSlider.addTarget(self, action: #selector(handleAlphaChange), for: .valueChanged)
    }
    
    @objc private func handleAlphaChange() {
        colorPreview.backgroundColor = colorPreview.backgroundColor?.withAlphaComponent(CGFloat(alphaSlider.value))
        hexLabel.text = colorPreview.backgroundColor?.toHex(alpha: true)
        
        colorDidChange?(colorPreview.backgroundColor ?? .clear)
    }
    
    @objc private func handleGesture(_ recognizer: UIGestureRecognizer) {
        let location = recognizer.location(in: colorPicker)
        
        guard colorPicker.bounds.contains(location) else { return }
        
        guard let color = colorPicker.getPixelColor(at: location) else { return }
        colorPreview.backgroundColor = color
        hexLabel.text = color.toHex()
        alphaSlider.value = 1
    }
}

extension UIView {
    func getPixelColor(at location: CGPoint) -> UIColor? {
        let pixel = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: 4)
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedLast.rawValue)
        guard let context = CGContext(
            data: pixel,
            width: 1,
            height: 1,
            bitsPerComponent: 8,
            bytesPerRow: 4,
            space: colorSpace,
            bitmapInfo: bitmapInfo.rawValue
        ) else {
            return nil
        }
        
        context.translateBy(x: -location.x, y: -location.y)
        layer.render(in: context)
        
        let color: UIColor = UIColor(
            red: CGFloat(pixel[0]) / 255.0,
            green: CGFloat(pixel[1]) / 255.0,
            blue: CGFloat(pixel[2]) / 255.0,
            alpha: CGFloat(pixel[3]) / 255.0
        )
        
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

extension UIColor {
    func toHex(alpha: Bool = false) -> String? {
        guard let components = cgColor.components, components.count >= 3 else {
            return nil
        }
        
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        let a = Float(cgColor.alpha)
        
        if alpha {
            return String(format: "#%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "#%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
}
