//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Mohammad Kabajah on 8/29/15.
//  Copyright (c) 2015 Mohammad Kabajah. All rights reserved.
//

import Foundation

class CalculatorBrain {
    
    fileprivate enum Op: CustomStringConvertible{
        case operand (Double)
        case unaryOperation(String, (Double) -> Double)
        case binaryOperation(String, (Double , Double) -> Double)
        
        
        var description: String{
            get{
                switch self {
                case .operand(let operand):
                    return "\(operand)"
                case .unaryOperation(let symbol, _):
                    return symbol
                case .binaryOperation(let symbol, _):
                    return symbol
                }
            }
        }
        
    }
    
    
    //    var opStack: Array<Op>()
    fileprivate var opStack = [Op]()
    
    //    var knownOps = Dictionary<String,Op>()
    fileprivate var knownOps = [String:Op]()
    
    init(){
        func learnOp(_ op: Op){
            knownOps[op.description] = op
        }
        //knownOps["×"] = Op.BinaryOperation("×") {$0 * $1}
//        knownOps["×"] = Op.BinaryOperation("×",*)
        learnOp(Op.binaryOperation("×",*))
        knownOps["÷"] = Op.binaryOperation("÷") {$1 / $0}
        knownOps["+"] = Op.binaryOperation("+",+)
        knownOps["−"] = Op.binaryOperation("−") {$1 - $0}
        //knownOps["√"] = Op.UnaryOperation("√") { sqrt($0) }
        knownOps["√"] = Op.unaryOperation("√",sqrt)
    }
    
    typealias PropertyList = AnyObject
    
    var program: PropertyList {//guaranteed to be propertylist
        get{
            return opStack.map { $0.description }
//            var returnValue = Array<String>()
//            for op in opStack{
//                returnValue.append(op.description)
//            }
//            return returnValue
        }
        set{
            if let opSymbols = newValue as? Array<String>{
                var newOpStack = [Op]()
                for opSymbol in opSymbols{
                    if let op = knownOps[opSymbol]{
                        newOpStack.append(op)
                    }
                    else if let operand = NumberFormatter().number(from: opSymbol)?.doubleValue{
                        newOpStack.append(.operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    fileprivate func evaluate(_ ops: [Op]) -> (result: Double?, remainingOps: [Op]){
        
        if !ops.isEmpty {
            var remainingOps = ops
            let op = remainingOps.removeLast()
            switch op{
            case .operand(let operand):
                return (operand, remainingOps)
            case .unaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps)
                if let operand = operandEvaluation.result{
                    return (operation(operand), operandEvaluation.remainingOps)
                    
                }
            case .binaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1,operand2), op2Evaluation.remainingOps)
                    }
                }
            }
            
        }
        
        return (nil,ops)
    }
    
    func evaluate() -> Double? {
//        let (resutl, _) = evaluate(opStack) // THE SAME
        let (resutl, remainder) = evaluate(opStack)
        print("\(opStack) = \(resutl) with \(remainder) left over")
        return resutl;
    }
    
    func pushOperand(_ operand: Double) -> Double?{
        opStack.append(Op.operand(operand))
        return evaluate()
    }
    
    func performOperation(_ symbol: String) -> Double?{
        if let operation = knownOps[symbol] {
            opStack.append(operation)
        }
        return evaluate()
    }
    
}

/*
switch operation{
case "×": performOperation { $0 * $1 }//if there is no arguments before the function we can get rid of the ()

//case "×": performOperation(){ $0*$1 }//if there is other arguments before the function

//case "×": performOperation({ $0*$1 })

//case "×": performOperation({(op1, op2) in op1*op2 })

//case "×": performOperation({(op1, op2) in return op1*op2 })

//case "×": performOperation({(op1: Double, op2: Double) -> Double in
//return op1*op2
//})

//case "×": performOperation(multiply)

//if operandStack.count >= 2 {
//displayValue = operandStack.removeLast() * operandStack.removeLast()
//enter()
//}

case "÷": performOperation { $1 / $0 }
//                if operandStack.count >= 2 {
//                    displayValue = operandStack.removeLast() / operandStack.removeLast()
//                    enter()
//                }
case "+": performOperation { $0 + $1 }
//                if operandStack.count >= 2 {
//                    displayValue = operandStack.removeLast() + operandStack.removeLast()
//                    enter()
//                }
case "−": performOperation { $1 - $0 }
//                if operandStack.count >= 2 {
//                    displayValue = operandStack.removeLast() - operandStack.removeLast()
//                    enter()
//                }
case "√": performOperation1 { sqrt($0) }
default: break
}

//    func multiply (op1: Double, op2: Double) -> Double{
//        return op1*op2
//    }
//

//var operandStack: Array <Double> = Array<Double>()
var operandStack = Array<Double>()

func performOperation(operation: (Double,Double) -> Double ) {
if operandStack.count >= 2 {
displayValue = operation(operandStack.removeLast() , operandStack.removeLast())
enter()

}
}

func performOperation1(operation: Double -> Double ) {
if operandStack.count >= 1 {
displayValue = operation(operandStack.removeLast())
enter()

}
}
*/
