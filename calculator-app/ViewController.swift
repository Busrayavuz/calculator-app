//
//  ViewController.swift
//  calculator-app
//
//  Created by Büşra Sağır on 23.06.2025.
//

import UIKit

class ViewController: UIViewController {
    
    let resultLabel = UILabel()
    var currentExpression: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        resultLabel.text = "0"
        resultLabel.textColor = .black
        resultLabel.font = .systemFont(ofSize: 70 ,weight: .bold)
        resultLabel.textAlignment = .right
        resultLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(resultLabel)
        
    let mainStack = UIStackView()
           mainStack.axis = .vertical
           mainStack.spacing = 10
           mainStack.alignment = .fill
           mainStack.distribution = .fillEqually
           mainStack.frame = CGRect(x: 17, y: 350, width: view.frame.width - 40, height: 450)
           view.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
                    resultLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
                    resultLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    resultLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    resultLabel.heightAnchor.constraint(equalToConstant: 100),
                    
                    mainStack.topAnchor.constraint(equalTo: resultLabel.bottomAnchor, constant: 20),
                    mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
                    mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
                    mainStack.heightAnchor.constraint(equalToConstant: 450)
                ])
        
        let allButtons = ["C" , "√" ,"±","%" ,"7", "8", "9", "/", "4", "5", "6", "*", "1", "2", "3", "-", "0", ".", "=", "+"].map { title -> UIButton in
            let orangeButtons = ["C", "√", "±", "%", "-", "+", "/", "*"]
            let button = UIButton(type: .system)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 30)
                        button.layer.cornerRadius = 20
                        button.backgroundColor = orangeButtons.contains(title) ? .orange : .gray
                        // Buton aksiyonlarını bağla
                        if title == "C" {
                            button.addTarget(self, action: #selector(clearTapped), for: .touchUpInside)
                        } else if title == "=" {
                            button.addTarget(self, action: #selector(calculateTapped), for: .touchUpInside)
                        } else if ["+", "-", "*", "/", "%", "√"].contains(title) {
                            button.addTarget(self, action: #selector(operationTapped), for: .touchUpInside)
                        } else {
                            button.addTarget(self, action: #selector(numberTapped), for: .touchUpInside)
                        }
                        return button
        }
    
                var currentRow: UIStackView?
                for (index, button) in allButtons.enumerated() {
                    if index % 4 == 0 {
                        currentRow = UIStackView()
                        currentRow?.axis = .horizontal
                        currentRow?.alignment = .fill
                        currentRow?.distribution = .fillEqually
                        currentRow?.spacing = 10
                        mainStack.addArrangedSubview(currentRow!)
                    }
                    currentRow?.addArrangedSubview(button)
                }
            }
            
            // Rakam tuşlarına basıldığında
            @objc func numberTapped(_ sender: UIButton) {
                let number = sender.currentTitle ?? ""
                if currentExpression == "0" {
                    currentExpression = number
                } else {
                    currentExpression += number
                }
                resultLabel.text = currentExpression
            }
            
            // Operatör tuşlarına basıldığında
            @objc func operationTapped(_ sender: UIButton) {
                let operation = sender.currentTitle ?? ""
                currentExpression += operation
                resultLabel.text = currentExpression
            }
            
            // Eşittir tuşuna basıldığında
            @objc func calculateTapped(_ sender: UIButton) {
                if let result = evaluateExpression(currentExpression) {
                    resultLabel.text = String(result)
                    currentExpression = String(result)
                } else {
                    resultLabel.text = "Hata"
                    currentExpression = "0"
                }
            }
            
            @objc func clearTapped(_ sender: UIButton) {
                currentExpression = "0"
                resultLabel.text = "0"
            }
            
            func evaluateExpression(_ expression: String) -> Double? {
                let modifiedExpression = expression.replacingOccurrences(of: "√", with: "sqrt")
                
                let exp = NSExpression(format: modifiedExpression)
                if let result = exp.expressionValue(with: nil, context: nil) as? Double {
                    return result
                }

                if expression.contains("%") {
                    let components = expression.split(separator: "%").map { String($0) }
                    if components.count == 2, let firstNum = Double(components[0]), let secondNum = Double(components[1]), secondNum != 0 {
                        return firstNum.truncatingRemainder(dividingBy: secondNum)
                    }
                }
                
                return nil
            }
        }
    


