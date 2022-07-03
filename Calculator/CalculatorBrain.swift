
import Foundation

struct CalculatorBrain{
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var accumulator: Double?
    private var description = ""
    private var numarr = [Double]()
    private var oparr = [String]()
    private var countera = 0
    private var allop = [String]()
    private var countop = 0
    
    private enum Precedence: Int {
         case Min = 0
         case Max = 1
     }
  
    private enum Operation{
        case constant(Double)
        case UnaryOperation((Double)->Double)
        case binaryOperation((Double, Double)->Double, Precedence)
        case equals
        
    }
    private var operations: Dictionary<String, Operation> = [
        "π": Operation.constant(Double.pi),
        "e": Operation.constant(M_E),
        "SIN":Operation.UnaryOperation(sin),
        "COS":Operation.UnaryOperation(cos),
        "+": Operation.binaryOperation({$0 + $1}, Precedence.Min),
        "-": Operation.binaryOperation({$0 - $1}, Precedence.Min),
        "*": Operation.binaryOperation({$0 * $1}, Precedence.Max),
        "/": Operation.binaryOperation({$0 / $1}, Precedence.Max),
        "=": Operation.equals
]
    private mutating func performPendingOperation(){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    private mutating func performPendingOperation2(i: Int){
        if pendingBinaryOperation != nil && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: numarr[i])
            pendingBinaryOperation = nil
        }
    }
    
        private mutating func finalCalculation(){
            var i = 0
            
            while i < countera{
                if let operation = operations[oparr[i]]{
                switch operation{
                case .binaryOperation(let function, _):
                    if(allop[0] == "-" && i == 0){
                pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: numarr[i])
                performPendingOperation()
                    }
                    else{
                        pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                        performPendingOperation2(i: i)
                    }
                default: break
                }
                i += 1
        }
                
    }
           oparr.removeAll()
            numarr.removeAll()
            allop.removeAll()
            countop = 0
            countera = 0
    }
        
        

       
    
    mutating func performOperation(_ symbol: String){
        description = description + String(accumulator!) + symbol
        if let operation = operations[symbol] {
           
            switch operation {
            case .constant(let value):
            accumulator = value
            
            case .UnaryOperation(let function):
                if accumulator != nil{
                    accumulator = function(accumulator!)
                }
            case .binaryOperation(let function, let precedence):
                if precedence.rawValue == 0 {
                    numarr.append(accumulator!)
                    oparr.append(symbol)
                    countera += 1
            
                }
                else if accumulator != nil {
                performPendingOperation()
                    pendingBinaryOperation =
                PendingBinaryOperation(function: function, firstOperand: accumulator!)
        
                }
                
                accumulator = nil
        allop.append(symbol)
                countop += 1
            case .equals:

        if (countop > 1) && (allop[allop.count-2] == "*" || allop[allop.count-2] == "/") && (allop[allop.count-1] == "+" || allop[allop.count-1] == "-"){
                    print(accumulator!)
                    var temp = 0.0
                    temp = accumulator!
                    accumulator! = numarr[numarr.count-1]
                    numarr[numarr.count-1] = temp
                }
                    performPendingOperation()
                    finalCalculation()
                   
            }
                
        }
    }
    
    mutating func clear(){
          description = ""
      }
    
    mutating func setOperand(_ operand: Double){
        accumulator = operand
    }
    
    var result: Double?{
        get {
            return accumulator
        }
    }
    var des: String?{
        get{
         return description
        }
}



private struct PendingBinaryOperation{
    let function: (Double, Double) -> Double
    let firstOperand: Double
   
    func perform(with secondOperand: Double) -> Double {
        return function(firstOperand, secondOperand)
    }
    
}


}

