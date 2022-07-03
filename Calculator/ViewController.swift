
import UIKit


class ViewController: UIViewController {
    
var userIsInTheMiddleOfTyping = false

   
    var displayValue: Double {
        get{
            return Double(display.text!)!
        }
        set{
            display.text = String(newValue)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBOutlet weak var Descript: UILabel!
    @IBOutlet weak var display: UILabel!
    
    
    private var brain = CalculatorBrain() 
    
    @IBAction func operationPressed(_ sender: UIButton) {
        Descript.text = ""
        
        if userIsInTheMiddleOfTyping{
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let operation = sender.currentTitle {
            brain.performOperation(operation)
        }
        if let result = brain.result {
            displayValue = result
        }
        
        if sender.currentTitle == "=" {
        if let des = brain.des{
            Descript.text = des
            brain.clear()
        }
    }
        
}
    @IBAction func digitPressed(_ sender: UIButton) {
        
        if userIsInTheMiddleOfTyping==false || display.text=="0"{
        display.text=""
        }
        userIsInTheMiddleOfTyping=true
        let digit = sender.currentTitle!
        let originalText=display.text!
        display.text=originalText+digit
        print("\(digit) Pressed")
        
    }
        
    @IBAction func CEPressed(_ sender: UIButton) {
        
        if display.text != "0"{
            let originalText = Double(display.text!)
            
            if (originalText!/10.0) > 0 {
                display.text = String(Int(originalText!/10.0))
            }
            else{
                display.text = "0"
            }
    }
}
}
